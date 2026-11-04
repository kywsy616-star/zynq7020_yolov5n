# -*- coding: utf-8 -*-
"""
================================================================================
 common.py —— 公共库：加载模型 / BN 融合 / 摊平成算子表 / 分配 DDR 地址
================================================================================

【这一整套脚本是给谁用的】

    产物**只给 Vitis 的 PS 端应用用**（`03_vitis/yolov5n_speed/src/`）：

        weights_speed_blob.c      权重字节
        rqt_speed_blob.c          每输出通道 {bias, mq, shift}
        yolov5n_speed_layers.h    84 条 64 字节描述符（层表）
        yolov5n_speed_desc.h      结构体 + 输出张量地址/尺度

    **HLS 工程一个字节都不读这些文件。** `01_hls/src/` 里是纯算法：
    `yolov5n_top.cpp`（数据通路）+ `yolov5n_hls.h`（接口与硬件常量的合并头，
    常量是手写死在里面的）。它的 testbench 也明说了
    "Algorithm-only smoke test: does NOT load golden bin files"。
    所以本目录不需要、也不应该往 HLS 工程里拷任何东西。

================================================================================
本文件提供四件事
================================================================================

1. `load_model()`   —— 用训练仓库里那份改过的 ultralytics 加载 best.pt
2. `fuse_conv_bn()` —— 把 Conv + BN 折成一个卷积（权重 + 偏置），精度无损
3. `PlanBuilder`    —— 把 C3 / SPPF / Detect / Concat 这些复合模块摊平成
                       "一次一个算子"的平表，PL 就是照这张表执行的
4. `Arena`          —— 给每个中间张量分配一个 64 字节对齐的 DDR 字节偏移

================================================================================
两条数据布局约定
================================================================================
这两条是 PL 侧的行为定死的（定义在 `01_hls/src/yolov5n_hls.h` 的注释里，
`yolov5n_top.cpp` 按它取数），本脚本负责**生产**符合约定的数据。

激活：int8，4 个通道打包进 1 个 32 位字 → [C/4][H][W][4]

    字下标 = ((c/4)*H + h)*W + w        字节下标 = 字下标 * 4
    C 通道的张量占 round_up(C,4)/4 * H * W * 4 字节
    ★ 所以 67 通道的检测头输出实际占 68 通道的位置，解码时只能取前 67 个。

权重：int8，每层一块，布局 [OC/CO][IC/CI][K][K][CO][CI]

    即 输出通道块 → 输入通道块 → 卷积核 → 输出 lane → 输入 lane，
    连续存放。这样 PL 暂存"一个输出通道块的权重"时读到的是一整段连续
    AXI 突发，不用跳来跳去。
================================================================================
"""

import os
import sys

import numpy as np
import torch
import torch.nn as nn

# ----------------------------------------------------------------------------
# PL 加速器的并行度常量 —— 这是**硬件已经定死**的，改这里必须重新综合 IP
#   （已综合的 IP 里，16x4 乘法器阵列和 CO=16 的 c4 打包方式是写死在 RTL 里的。
#    数值可在 01_hls/yolov5n_hls/solution1/impl/ip/hdl/verilog/ 下的
#    yolov5n_top_conv_kernel*.v 里核对。）
# ----------------------------------------------------------------------------
CO = 16   # 一次并行算多少个输出通道
CI = 4    # 一个 32 位字里打包多少个输入通道（正好一个 c4 字）

ACT_NONE = 0
ACT_LEAKY = 1

# PL 只认这三种算子（数值就是描述符里 desc.type 的取值）
OP_CONV = "conv"          # 0 卷积，K 是运行时参数（1x1 和 3x3 共用一条通路）
OP_MAXPOOL = "maxpool"    # 1 3x3 / stride1 / pad1 最大池化
OP_COPY = "copy"          # 2 通道拷贝（Concat）或 2 倍最近邻上采样（Upsample）

LEAKY_SLOPE = 0.1         # 模型用的激活；PL 在整数域做 *3277>>15 近似

# PL 一次要把"一个输出 tile 的输入窗口（含 halo）"整块搬进片上 BRAM，
# 所以 tile 大小要受 BRAM 容量约束。
IFM_TILE_BUDGET = 64 * 1024   # 输入窗口的最大像素数 × 输入通道数
MAX_TILE = 16                 # tile 边长上限（硬件 HW_NX / HW_MAX_PIX 都是 16）


def rup(x, m):
    """向上取整到 m 的倍数（round up）"""
    return ((x + m - 1) // m) * m


def repo_on_path(repo):
    """把训练仓库放到 sys.path 最前面，这样 `import ultralytics` 拿到的是
    那份改过的版本，而不是环境里装的官方版。"""
    repo = os.path.abspath(repo)
    if repo not in sys.path:
        sys.path.insert(0, repo)
    return repo


def load_model(weights, repo):
    """加载 best.pt 的**网络结构**（含 BN 和 SiLU/LeakyReLU 等模块）。
    注意：此时还没有融合 BN，也还没有量化；只是把模型对象拿到手。"""
    repo_on_path(repo)
    from ultralytics import YOLO
    yolo = YOLO(weights)
    net = yolo.model          # ultralytics.nn.tasks.DetectionModel
    net.eval()                # BN 必须用 running_mean/var，不能用 batch 统计值
    return net


def fuse_conv_bn(conv, bn):
    """把 BatchNorm 折进前面的 Conv2d -> (w, b) float32

    推理时 BN 就是一个仿射变换，所以可以精确地折进卷积，零精度损失：
        scale = gamma / sqrt(running_var + eps)
        w'    = w * scale                      （按输出通道广播）
        b'    = (0 - running_mean) * scale + beta
    折完 PL 就只需要"卷积 + 激活"两种操作，不用单独实现 BN。
    """
    w = conv.weight.detach().cpu().numpy().astype(np.float64)
    b = (conv.bias.detach().cpu().numpy().astype(np.float64)
         if conv.bias is not None else np.zeros(w.shape[0]))
    if bn is None:
        return w.astype(np.float32), b.astype(np.float32)
    g = bn.weight.detach().cpu().numpy().astype(np.float64)
    be = bn.bias.detach().cpu().numpy().astype(np.float64)
    mu = bn.running_mean.detach().cpu().numpy().astype(np.float64)
    va = bn.running_var.detach().cpu().numpy().astype(np.float64)
    s = g / np.sqrt(va + float(bn.eps))
    return (w * s[:, None, None, None]).astype(np.float32), \
           ((b - mu) * s + be).astype(np.float32)


def one_conv2d(mod):
    """从一个模块里抠出 (conv2d, bn, act) 三元组。

    ultralytics 的 `Conv` 模块把 Conv2d + BatchNorm2d + 激活打包在一起，
    这里把它拆开；`nn.Identity` 的激活当作"没有激活"。
    """
    if isinstance(mod, nn.Conv2d):
        return mod, None, None
    if hasattr(mod, "conv"):                      # ultralytics Conv
        bn = getattr(mod, "bn", None)
        act = getattr(mod, "act", None)
        if isinstance(act, nn.Identity):
            act = None
        return mod.conv, bn, act
    raise TypeError("unsupported conv module: %r" % type(mod))


class Arena:
    """DDR 激活区的分配器。

    每个中间张量都拿到一个 64 字节对齐的字节偏移 `off`，这个 `off` 会被
    原样写进层描述符（src_off / dst_off / add_off），PL 就是靠它去 DDR 取数的。
    所以这个偏移表一旦生成就不能再变——PS 端的解码、PL 端的读写都按它来。
    64 字节对齐是为了让 c4 打包的每行起点都落在 cache line / AXI 突发边界上。
    """

    def __init__(self, align=64):
        self.align = align
        self.off = 0

    def alloc(self, nbytes):
        """分配 nbytes 字节，返回对齐后的起始偏移；末尾也对齐，下一块才不会跨界"""
        self.off = rup(self.off, self.align)
        p = self.off
        self.off += rup(nbytes, self.align)
        return p


class PlanBuilder:
    def __init__(self, net, verbose=True):
        self.net = net
        self.verbose = verbose
        self.tensors = []
        self.ops = []
        self.weights = {}          # blob name -> np.ndarray (float32, un-quantised)
        self.arena = Arena(64)
        self._tid = 0
        self._oid = 0

    # ------------------------------------------------------------------ tensors
    def new_tensor(self, name, c, h, w, is_input=False):
        """登记一个中间张量：真实通道数 c，**存储**通道数 cs = round_up(c,4)。
        c != cs 时多出来的通道是 c4 打包的填充车道，PL 会算但 PS 无视它们。"""
        cs = rup(c, 4)
        nbytes = (cs // 4) * h * w * 4          # 每个 c4 字 4 字节
        t = dict(id=self._tid, name=name, c=int(c), cs=int(cs), h=int(h), w=int(w),
                 off=self.arena.alloc(nbytes), bytes=int(nbytes))
        if is_input:
            t["is_input"] = True
        self._tid += 1
        self.tensors.append(t)
        return t

    def T(self, tid):
        return self.tensors[tid]

    # ---------------------------------------------------------------------- ops
    def _tile_for(self, ic, oh, ow, k, s):
        """选一个输出 tile 尺寸 (tr, tc)，使得 PL 要搬的输入窗口装得下片上 BRAM。

        PL 算一个输出 tile 时，要把对应的输入窗口（**含 halo 和 stride 撑开的部分**）
        整块搬进片上：窗口大小 = ((tr-1)*s + k) × ((tc-1)*s + k) 个像素，
        每个像素 ic 个通道（c4 打包后是 ic/4 个字）。

        起步取 16×16（硬件 HW_NX/HW_MAX_PIX 的上限），超预算就一轮一轮往回缩，
        优先缩长边。缩到底还装不下就直接抛异常 —— 明确报错，绝不悄悄算错。
        """
        tr, tc = min(MAX_TILE, oh), min(MAX_TILE, ow)
        while True:
            ih_t = (tr - 1) * s + k
            iw_t = (tc - 1) * s + k
            if ih_t * iw_t * ic <= IFM_TILE_BUDGET:
                return tr, tc
            if tr == oh and tc == ow:
                # already the whole image and still too big -> caller must tile
                # with a strided schedule; reject loudly instead of silently
                raise RuntimeError("whole-image tile does not fit: ic=%d %dx%d" % (ic, oh, ow))
            if tr >= tc and tr > 2:
                tr = max(2, tr - 2)
            elif tc > 2:
                tc = max(2, tc - 2)
            else:
                raise RuntimeError("cannot fit tile: ic=%d oh=%d ow=%d" % (ic, oh, ow))

    def _emit(self, d):
        d["id"] = self._oid
        self._oid += 1
        self.ops.append(d)
        if self.verbose:
            print("  op%3d %-8s %-26s ic=%-4d oc=%-4d %dx%d k%d s%d p%d act%d add=%-5s macs=%.3fM"
                  % (d["id"], d["type"], d["name"], d["ic"], d["oc"], d["oh"], d["ow"],
                     d["k"], d["s"], d["pad"], d["act"],
                     ("-" if d["add_src"] < 0 else str(d["add_src"])), d["macs"] / 1e6))
        return d

    def conv(self, src, src_ch_off, c_in, c_out, k, s, act, wname, aname,
             add_src=None, add_src_ch_off=0, dst=None, dst_ch_off=0, h=None, w=None):
        """登记一个卷积算子。几个容易搞错的点：

        * `src_ch_off` / `dst_ch_off`：这个算子**从源张量的第几个通道开始读**、
          **写到目标张量的第几个通道**。C3/SPPF 内部的 Concat 就是靠它实现的
          —— 三个分支各自往同一块 cat 张量的不同通道段上写，不用真的搬数据。

        * `ic` / `oc` 是**补齐后**的值（4 / 16 的倍数），`ic_real` / `oc_real`
          是真实通道数。PL 会按补齐后的宽度算，多出来的车道结果是垃圾但会被丢弃。

        * `add_src`：残差相加的来源张量。PL 在激活**之后**做一次整数加
          （前提是两者共用同一个量化 scale —— 由 quantize.py 的并查集保证）。

        * `dst` + `dst_ch_off` 可以指向一个已存在的张量（比如 cat 张量的某一段），
          不传就自动新建一个。
        """
        src_t = self.T(src)
        h = src_t["h"] if h is None else h
        w = src_t["w"] if w is None else w
        pad = k // 2                        # 只支持 1x1(pad0) 和 3x3(pad1)，同尺寸输出
        oh = (h + 2 * pad - k) // s + 1
        ow = (w + 2 * pad - k) // s + 1
        if dst is None:
            dst = self.new_tensor(aname + "_out", c_out, oh, ow)
        icp, ocp = rup(c_in, CI), rup(c_out, CO)
        tr, tc = self._tile_for(icp, oh, ow, k, s)
        return self._emit(dict(
            type=OP_CONV, name=aname, src=int(src), src_ch_off=int(src_ch_off),
            ic=icp, ic_real=int(c_in), dst=dst["id"], dst_ch_off=int(dst_ch_off),
            oc=ocp, oc_real=int(c_out), oh=int(oh), ow=int(ow), k=int(k), s=int(s),
            pad=int(pad), act=int(act), wname=wname + "_w", bname=wname + "_b",
            add_src=(-1 if add_src is None else int(add_src)),
            add_src_ch_off=int(add_src_ch_off), tile=[int(tr), int(tc)],
            w_bytes=int(ocp * icp * k * k), macs=int(oh * ow * ocp * icp * k * k)))

    def maxpool(self, src, src_ch_off, c, k, s, act, aname,
                dst=None, dst_ch_off=0):
        """3x3 / stride1 / pad1 最大池化。PL 只实现了这一种规格（SPPF 用）。
        pad 区域填 int8 最小值 -128，所以永远不会赢（数学上等于 -inf）。"""
        src_t = self.T(src)
        h, w = src_t["h"], src_t["w"]
        pad = k // 2
        oh = (h + 2 * pad - k) // s + 1
        ow = (w + 2 * pad - k) // s + 1
        if dst is None:
            dst = self.new_tensor(aname + "_out", c, oh, ow)
        cp = rup(c, 4)
        tr, tc = self._tile_for(cp, oh, ow, k, s)
        return self._emit(dict(
            type=OP_MAXPOOL, name=aname, src=int(src), src_ch_off=int(src_ch_off),
            ic=cp, ic_real=int(c), dst=dst["id"], dst_ch_off=int(dst_ch_off),
            oc=cp, oc_real=int(c), oh=int(oh), ow=int(ow), k=int(k), s=int(s),
            pad=int(pad), act=ACT_NONE, wname="", bname="", add_src=-1,
            add_src_ch_off=0, tile=[int(tr), int(tc)], w_bytes=0, macs=0))

    def copy(self, srcs, src_ch_offs, cs, dst, dst_ch_offs, up=1, aname=""):
        """把若干段通道拷进 `dst`（Concat），或者 2 倍最近邻上采样（Upsample）。

        srcs / src_ch_offs / cs / dst_ch_offs 是四个平行列表：
        第 k 段从 `srcs[k]` 张量的第 `src_ch_offs[k]` 个通道起取 `cs[k]` 个通道，
        放到 `dst` 张量的第 `dst_ch_offs[k]` 个通道。

        up=2：H、W 各翻倍（最近邻，每个像素复制成 2x2）
        up=1：纯粹的通道拼接

        这两种模块级的拷贝是**显式的 DDR 搬运**（约 1 MB/帧），换来的是
        接线简单、模型改了也不容易出错。C3/SPPF 内部的 Concat 不走这里，
        它靠 conv 的 src_ch_off/dst_ch_off 零成本实现。
        """
        st = self.T(srcs[0])
        ih, iw = st["h"], st["w"]
        oh, ow = ih * up, iw * up
        for s_id, s_off, c, d_off in zip(srcs, src_ch_offs, cs, dst_ch_offs):
            cp = rup(c, 4)
            tr, tc = self._tile_for(cp, oh, ow, 1, up)
            self._emit(dict(
                type=OP_COPY, name="%s.c%d" % (aname, d_off), src=int(s_id),
                src_ch_off=int(s_off), ic=cp, ic_real=int(c), dst=dst["id"],
                dst_ch_off=int(d_off), oc=cp, oc_real=int(c),
                ih=int(ih), iw=int(iw), oh=int(oh), ow=int(ow),
                k=1, s=1, pad=0, up=int(up), act=ACT_NONE, wname="", bname="",
                add_src=-1, add_src_ch_off=0, tile=[int(tr), int(tc)],
                w_bytes=0, macs=0))

    # ------------------------------------------------------- composite helpers
    def emit_conv(self, mod, src, src_ch_off, aname, wname, add_src=None,
                  add_src_ch_off=0, dst=None, dst_ch_off=0):
        c2d, bn, act = one_conv2d(mod)
        k, s = c2d.kernel_size[0], c2d.stride[0]
        assert c2d.groups == 1, "%s: grouped conv not supported" % wname
        assert k in (1, 3), "%s: kernel %d not supported" % (wname, k)
        assert s in (1, 2), "%s: stride %d not supported" % (wname, s)
        w, b = fuse_conv_bn(c2d, bn)
        self.weights[wname + "_w"] = w
        self.weights[wname + "_b"] = b
        return self.conv(src, src_ch_off, c2d.in_channels, c2d.out_channels, k, s,
                         ACT_LEAKY if act is not None else ACT_NONE,
                         wname, aname, add_src=add_src, add_src_ch_off=add_src_ch_off,
                         dst=dst, dst_ch_off=dst_ch_off)

    def emit_c3(self, c3, src, src_ch_off, aname, dst=None, dst_ch_off=0):
        """把 C3 拆成 6 个（Bottleneck 多的话更多）卷积算子。

        C3 的结构是：
            cat = concat( 瓶颈链的输出 , cv2(src) )        # 各 c_ 通道，共 2*c_
            out = cv3(cat)                                  # 激活在 cv3 里

        拆法：
            cv1        : src -> cat[0 : c_]
            Bottleneck : 每个 m_i 是 cv1 -> cv2(+残差)。
                         cv1 写到临时张量，cv2 写回 —— 最后一个 m 直接落进 cat[0:c_]，
                         省一块临时张量。
            cv2        : src -> cat[c_ : 2*c_]              （旁路分支）
            cv3        : cat -> out

        ★ 关键：cat 是一个**已分配好 DDR 的张量**，各分支靠 dst_ch_off 往它的
          不同通道段写。所以 C3 内部这个 Concat 不需要任何拷贝算子。
        """
        c_ = c3.cv1.conv.out_channels
        c2 = c3.cv3.conv.out_channels
        shortcut = bool(c3.m[0].add) if len(c3.m) else False
        h, w = self.T(src)["h"], self.T(src)["w"]

        cat = self.new_tensor(aname + "_cat", 2 * c_, h, w)
        # top branch: cv1 -> bottlenecks, last one lands in cat[0:c_]
        self.emit_conv(c3.cv1, src, src_ch_off, aname + ".cv1", aname + ".cv1",
                       dst=cat, dst_ch_off=0)
        x_t, x_off = cat["id"], 0
        for i, bn in enumerate(c3.m):
            tmp = self.new_tensor("%s.m%d.cv1" % (aname, i), c_, h, w)
            self.emit_conv(bn.cv1, x_t, x_off, "%s.m%d.cv1" % (aname, i), "%s.m%d.cv1" % (aname, i),
                           dst=tmp)
            last = (i == len(c3.m) - 1)
            out_t = cat if last else self.new_tensor("%s.m%d.cv2" % (aname, i), c_, h, w)
            self.emit_conv(bn.cv2, tmp["id"], 0, "%s.m%d.cv2" % (aname, i), "%s.m%d.cv2" % (aname, i),
                           add_src=(x_t if bn.add else None), add_src_ch_off=x_off,
                           dst=out_t, dst_ch_off=0)
            x_t, x_off = out_t["id"], 0
        # bottom branch lands in cat[c_:2c_]
        self.emit_conv(c3.cv2, src, src_ch_off, aname + ".cv2", aname + ".cv2",
                       dst=cat, dst_ch_off=c_)
        # cv3 over the 2*c_ concatenation
        if dst is None:
            dst = self.new_tensor(aname + "_out", c2, h, w)
        self.emit_conv(c3.cv3, cat["id"], 0, aname + ".cv3", aname + ".cv3",
                       dst=dst, dst_ch_off=dst_ch_off)
        return dst

    def emit_sppf(self, sppf, src, src_ch_off, aname):
        """把 SPPF 拆成 cv1 + 3 次 maxpool + cv2。

        SPPF 的结构是 cat = concat( x, pool(x), pool(pool(x)), pool(pool(pool(x))) )，
        然后 cv2 收口。三段池化结果直接写进同一个 4*c_ 的 cat 张量的
        第 1/2/3 段（dst_ch_off = c_, 2c_, 3c_），所以同样不需要拷贝算子。

        注意池化是**串联**的：m1 读 m0 的输出、m2 读 m1 的输出 ——
        看第三个参数 `i * c_`（源通道偏移）就是逐级递增的。
        """
        c_ = sppf.cv1.conv.out_channels
        c2 = sppf.cv2.conv.out_channels
        k = sppf.m.kernel_size
        k = k[0] if isinstance(k, (tuple, list)) else int(k)
        h, w = self.T(src)["h"], self.T(src)["w"]
        cat = self.new_tensor(aname + "_cat", 4 * c_, h, w)
        self.emit_conv(sppf.cv1, src, src_ch_off, aname + ".cv1", aname + ".cv1",
                       dst=cat, dst_ch_off=0)
        for i in range(3):
            self.maxpool(cat["id"], i * c_, c_, k, 1, ACT_NONE, "%s.m%d" % (aname, i),
                         dst=cat, dst_ch_off=(i + 1) * c_)
        out = self.new_tensor(aname + "_out", c2, h, w)
        self.emit_conv(sppf.cv2, cat["id"], 0, aname + ".cv2", aname + ".cv2", dst=out)
        return out

    def emit_detect(self, det, feats, aname):
        """把检测头拆成 3 个尺度 × 6 个卷积，每个尺度的输出写进**同一块** obuf。

        Detect 有两条并行的分支，各自是 3 个 3x3 卷积（cv2 回归框、cv3 分类）：

            obuf = [ 64 个 DFL 分布通道 | 3 个类别通道 ]    共 67 通道

            cv2.0/1/2 : feats -> 中间 -> 中间 -> obuf[0 : 64]
            cv3.0/1/2 : feats -> 中间 -> 中间 -> obuf[64 : 67]

        ★ cv2.2 和 cv3.2 是**两个独立的卷积算子**，但写成同一块 obuf 的不同
          通道段（dst_ch_off = 0 和 n_reg）。PS 端解码时按 67 通道读，
          前面 64 个走 DFL softmax，后面 3 个走 sigmoid。这就是
          `yolov5n_speed_app.c::decode_level()` 里 `plane, 64 + s` 的来历。

        ★ 三个尺度的 obuf 就是 P3/P4/P5 三个输出张量，它们的 off 会被
          写进 yolov5n_speed_desc.h 的 YOLO_OUT_*_OFF / _CH / _H / _W / _SCALE。
        """
        outs = []
        for i, xf in enumerate(det.cv2):
            feat = self.T(feats[i])
            h, w = feat["h"], feat["w"]
            n_reg = xf[2].out_channels                    # 4*reg_max = 64
            n_cls = det.cv3[i][2].out_channels            # nc = 3
            c2_lane = xf[0].conv.out_channels
            c3_lane = det.cv3[i][0].conv.out_channels

            obuf = self.new_tensor("%s.L%d" % (aname, i), n_reg + n_cls, h, w)
            a = self.new_tensor("%s.L%d.cv2a" % (aname, i), c2_lane, h, w)
            self.emit_conv(xf[0], feats[i], 0, "%s.L%d.cv2.0" % (aname, i), "%s.L%d.cv2.0" % (aname, i), dst=a)
            b = self.new_tensor("%s.L%d.cv2b" % (aname, i), c2_lane, h, w)
            self.emit_conv(xf[1], a["id"], 0, "%s.L%d.cv2.1" % (aname, i), "%s.L%d.cv2.1" % (aname, i), dst=b)
            self.emit_conv(xf[2], b["id"], 0, "%s.L%d.cv2.2" % (aname, i), "%s.L%d.cv2.2" % (aname, i),
                           dst=obuf, dst_ch_off=0)
            c = self.new_tensor("%s.L%d.cv3a" % (aname, i), c3_lane, h, w)
            self.emit_conv(det.cv3[i][0], feats[i], 0, "%s.L%d.cv3.0" % (aname, i), "%s.L%d.cv3.0" % (aname, i), dst=c)
            d = self.new_tensor("%s.L%d.cv3b" % (aname, i), c3_lane, h, w)
            self.emit_conv(det.cv3[i][1], c["id"], 0, "%s.L%d.cv3.1" % (aname, i), "%s.L%d.cv3.1" % (aname, i), dst=d)
            self.emit_conv(det.cv3[i][2], d["id"], 0, "%s.L%d.cv3.2" % (aname, i), "%s.L%d.cv3.2" % (aname, i),
                           dst=obuf, dst_ch_off=n_reg)
            outs.append(obuf["id"])
        return outs


def build_plan(net, verbose=True, img_h=384, img_w=512):
    """把 DetectionModel.model（一串顶层模块）摊平成 ops + tensors 两张表。

    逐模块处理，`cur` 始终指向"上一个模块的输出张量"（模型里的 from=-1）：

        Conv     -> 一个卷积算子
        C3       -> emit_c3
        SPPF     -> emit_sppf
        Upsample -> 一个 up=2 的拷贝算子（H/W 翻倍）
        Concat   -> 每个输入段一个 up=1 的拷贝算子，写进新 cat 张量的不同通道段
        Detect   -> emit_detect（三尺度，然后结束）

    模块级的 Concat 和 Upsample 落成显式的 DDR 拷贝（约 1 MB/帧，占总量 7%
    左右），换来的是接线简单、模型改了也不容易错；C3/SPPF **内部**的 Concat
    不走拷贝，靠 conv 的 src_ch_off/dst_ch_off 零成本实现。
    """
    b = PlanBuilder(net, verbose=verbose)
    mods = net.model
    print("flattening %d top-level modules, input %dx%d (HxW)" % (len(mods), img_h, img_w))

    inp = b.new_tensor("input", 3, img_h, img_w, is_input=True)
    tf = {}                      # top-level index -> tensor id
    cur = None                   # output tensor id of the previous module
    outputs = None

    def resolve(f, i, cur_id):
        """resolve a `from` entry (list); -1 means 'previous module output'"""
        return [cur_id if j == -1 else tf[j] for j in f]

    for i, m in enumerate(mods):
        tn = type(m).__name__
        if tn == "Conv":
            src = inp["id"] if cur is None else cur
            cur = b.emit_conv(m, src, 0, "L%02d" % i, "L%02d" % i)["dst"]
        elif tn == "C3":
            cur = b.emit_c3(m, cur, 0, "L%02d" % i)["id"]
        elif tn == "SPPF":
            cur = b.emit_sppf(m, cur, 0, "L%02d" % i)["id"]
        elif tn == "Upsample":
            src_t = b.T(cur)
            dst = b.new_tensor("L%02d_up" % i, src_t["cs"], src_t["h"] * 2, src_t["w"] * 2)
            b.copy([cur], [0], [src_t["cs"]], dst, [0], up=2, aname="L%02d.up" % i)
            cur = dst["id"]
        elif tn == "Concat":
            srcs = resolve(m.f, i, cur)
            chs = [b.T(s)["cs"] for s in srcs]
            dst = b.new_tensor("L%02d_cat" % i, sum(chs), b.T(srcs[0])["h"], b.T(srcs[0])["w"])
            offs, acc = [], 0
            for c in chs:
                offs.append(acc)
                acc += c
            b.copy(srcs, [0] * len(srcs), chs, dst, offs, up=1, aname="L%02d.cat" % i)
            cur = dst["id"]
        elif tn == "Detect":
            feats = resolve(m.f, i, cur)
            outputs = b.emit_detect(m, feats, "Detect")
            cur = None
        else:
            raise TypeError("unhandled module %s at %d" % (tn, i))

        if cur is not None:
            tf[i] = cur
            t = b.T(cur)
            print("  [top %2d] %-9s -> tensor %3d  %4dch %3dx%-3d @0x%06X"
                  % (i, tn, cur, t["cs"], t["h"], t["w"], t["off"]))
        else:
            print("  [top %2d] %-9s -> outputs %s" % (i, tn, outputs))

    return b, inp, outputs
