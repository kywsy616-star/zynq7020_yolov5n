# -*- coding: utf-8 -*-
"""
================================================================================
 refsim.py —— 纯 numpy 的算子表执行器（"纸面 PL"）
================================================================================

它按 layer_plan.json 里的算子顺序，一个一个算下去，用来在**不碰硬件**的前提下
把整条链路的数值算清楚。被三个脚本用：

    make_layer_plan.py  用 fp32 模式做摊平正确性自检（对比 PyTorch forward）
    calibrate.py        用 fp32 模式统计每层激活分布
    quantize.py         用 make_requant_vec 算 per-channel 的 mq/shift

【两种模式】

`mode="fp32"`
    用**未量化**的融合权重跑。唯一目的是证明"摊平"这一步没写错：
    和原版 PyTorch forward 逐元素比，误差应该只有 float32 舍入量级。

`mode="int8"`
    完整复现 PL 上的整数流水线：per-channel requant 乘数、整数偏置、
    LeakyReLU、饱和。**理论上是逐位一致的**（PL 的取数/计算顺序就是按
    这个契约实现的，见 01_hls/src/yolov5n_top.cpp）。

================================================================================
量化契约 —— 这是 PL 硬件实现的行为，本文件负责在 PC 上复现它
================================================================================

    activation  : int8，按张量对称量化          real = q * s
    weight      : int8，按输出通道对称量化      real = q * sw[oc]

    conv        : acc   = Σ wq*xq                     （int32 累加）
                  y_int = acc + bi[oc]                （bi = round(b/(sw*sx))）
                  y_real = y_int * sw[oc] * sx
                  y_q    = round(y_real / sy)
                  然后 LeakyReLU 在**整数域**做（*0.1 ≈ *3277>>15），再饱和到 int8

    requant      : M[oc] = sw[oc]*sx/sy，存成  acc * Mq >> shift
                   其中 |Mq| < 2^17，好让一个 DSP48（25x18）就能完成乘法

★ 这一节改一个字，PL 和 PC 就对不上了。要改必须两边同时改，并重跑上板验证。
================================================================================
"""

import numpy as np

from common import OP_CONV, OP_MAXPOOL, OP_COPY, ACT_LEAKY, CO, CI, rup


# ---------------------------------------------------------------------------
# 定点辅助函数（和 PL 里的运算一一对应）
# ---------------------------------------------------------------------------
M_FRAC_BITS = 16          # Mq 归一化后保留 16 位小数


def make_requant_vec(m):
    """把一个 float 乘数（可以是数组，按输出通道）变成 (mq:int32, shift:int32)

    要解决的问题：卷积累加完之后要乘上 M = sw[oc]*sx/sy 再除以 2^shift。
    硬件里这一步是一个 DSP48（25x18 乘法器）加一个移位器，所以：

      * 每个通道的 mq 都归一化到 [2^16, 2^17) —— 18 位操作数用满，
        精度最高；
      * 归一化剩下的那个指数塞进 per-channel 的 shift（每个输出 lane
        都有一个自己的移位器，所以 shift 可以是逐通道不同的）。

    这样 M 被拆成 (mq, shift) 两个整数，硬件做 acc*mq>>shift 即可。
    """
    m = np.asarray(m, np.float64)
    mq = np.zeros(m.shape, np.int64)
    sh = np.zeros(m.shape, np.int32)
    nz = m != 0
    if not nz.any():
        return mq.astype(np.int32), sh
    a = np.abs(m[nz])
    e = np.floor(np.log2(a)).astype(np.int64)
    mant = a / (2.0 ** e)
    mqv = np.round(mant * (1 << M_FRAC_BITS)).astype(np.int64)
    over = mqv >= (1 << 17)
    if over.any():
        mqv[over] = np.round((mant[over] / 2.0) * (1 << M_FRAC_BITS)).astype(np.int64)
        e[over] += 1
    mqv = np.sign(m[nz]).astype(np.int64) * mqv
    assert np.abs(mqv).max() < (1 << 17), mqv.max()
    mq[nz] = mqv
    sh[nz] = (M_FRAC_BITS - e).astype(np.int32)
    return mq.astype(np.int32), sh


def round_shift(x, shift):
    """除以 2**shift 并向"远离零"方向取整（round-half-away-from-zero）。

    和 C 里 `(v + (v>=0 ? h : -h)) >> shift` 是同一件事（PL 的
    `rshift_round_ap` 就是这个）。注意 shift 可以是负数（表示左移），
    也可以是一个按输出通道广播的数组。"""
    x = x.astype(np.int64)
    shift = np.asarray(shift)
    if shift.ndim == 0:
        s = int(shift)
        if s <= 0:
            return x << (-s)
        half = np.int64(1) << (s - 1)
        return (x + np.where(x >= 0, half, -half)) >> s
    # 把 1 维的 per-channel shift 广播到通道轴上，好和数据张量对齐
    if shift.ndim == 1 and x.ndim > 1:
        shift = shift.reshape(shift.shape + (1,) * (x.ndim - 1))
    pos = shift > 0
    sp = np.clip(np.where(pos, shift, 0), 0, 62)
    half = np.int64(1) << np.clip(np.where(pos, shift - 1, 0), 0, 62)
    rp = (x + np.where(x >= 0, half, -half)) >> sp
    sn = np.clip(np.where(pos, 0, -shift), 0, 62)
    rn = x << sn
    return np.where(pos, rp, rn)


def apply_requant(x, mq, shift):
    """int32 -> int32：round(x * mq / 2**shift)。

    这就是 PL 里那一个 DSP48 + 移位器做的事。每一步中间量都用 int64 装着，
    防止 numpy 在 int32 上悄悄溢出（PL 那边是靠 ap_int<44> 保证位宽足够）。
    """
    return round_shift(x.astype(np.int64) * mq.astype(np.int64), shift)


# ---------------------------------------------------------------------------
class RefSim:
    """按算子表逐条执行。

    `self.act` 是按张量 id 索引的激活缓存，形状 (cs, H, W)：**用补齐后的
    通道数 cs** 分配，这样 c4 打包的布局和 PL 里完全一致。
    """

    def __init__(self, plan, weights, mode="fp32", quant=None, verbose=False):
        self.p = plan
        self.w = weights
        self.mode = mode
        self.quant = quant or {}
        self.verbose = verbose
        self.act = {}

    # ------------------------------------------------------------- utilities
    def _padded_w(self, op, c_in):
        """真实权重 -> 补零到 [oc, ic, k, k]。补出来的部分权重是 0，
        所以对真实通道的结果没有影响（PL 也是这么做的）。"""
        w = self.w[op["wname"]]
        ocp, icp = op["oc"], c_in
        k = op["k"]
        out = np.zeros((ocp, icp, k, k), w.dtype)
        r = min(ocp, w.shape[0])
        ci = min(icp, w.shape[1])
        out[:r, :ci] = w[:r, :ci]
        return out

    def get(self, tid, ch_off, c):
        """从张量 tid 的第 ch_off 个通道起取 c 个通道。
        ★ 这就是"通道偏移"复用：C3 的 cv3 读 cat 张量时 ch_off=0、长度 2*c_。"""
        t = self.p["tensors"][tid]
        a = self.act.get(tid)
        if a is None:
            raise RuntimeError("tensor %d (%s) read before written" % (tid, t["name"]))
        return a[ch_off:ch_off + c]

    def put(self, tid, ch_off, c, val):
        """把 c 个通道写到张量 tid 的第 ch_off 个通道起。
        ★ 只写 oc_real 个通道：多出来的 c4 填充车道不动，保持原值。"""
        t = self.p["tensors"][tid]
        a = self.act.get(tid)
        if a is None:
            raise RuntimeError("tensor %d (%s) written before allocated" % (tid, t["name"]))
        a[ch_off:ch_off + c] = val

    def alloc_all(self):
        """给每个中间张量开一块 (cs, H, W) 的缓存 —— 复刻 PL 那边的 DDR arena 布局。"""
        for t in self.p["tensors"]:
            dt = np.int8 if self.mode == "int8" else np.float32
            self.act[t["id"]] = np.zeros((t["cs"], t["h"], t["w"]), dt)

    # --------------------------------------------------------------- kernels
    @staticmethod
    def conv2d_fp32(x, w, b, stride, pad, leaky):
        IC, H, W = x.shape
        OC, _, K, _ = w.shape
        xp = np.zeros((IC, H + 2 * pad, W + 2 * pad), np.float32)
        xp[:, pad:pad + H, pad:pad + W] = x
        OH = (H + 2 * pad - K) // stride + 1
        OW = (W + 2 * pad - K) // stride + 1
        out = np.zeros((OC, OH, OW), np.float32)
        for i in range(K):
            for j in range(K):
                patch = xp[:, i:i + OH * stride:stride, j:j + OW * stride:stride]
                out += np.tensordot(w[:, :, i, j], patch, axes=([1], [0]))
        out += b[:, None, None]
        if leaky:
            out = np.where(out < 0, out * 0.1, out)
        return out

    @staticmethod
    def conv2d_int8(xq, wq, bi, mq, shift, stride, pad, leaky):
        """整数卷积 —— 严格按上面那节"量化契约"来。

        xq/wq : int8 输入与权重
        bi    : int32，每个输出通道一个整数偏置（已经把输入零点折进去了）
        mq/shift : 每个输出通道的 requant 乘数和移位

        顺序很关键，和 PL 完全一致：
            累加(int32) -> +偏置 -> *mq>>shift -> LeakyReLU(整数域) -> 饱和int8
        """
        IC, H, W = xq.shape
        OC = wq.shape[0]
        K = wq.shape[2]
        xp = np.zeros((IC, H + 2 * pad, W + 2 * pad), np.int32)
        xp[:, pad:pad + H, pad:pad + W] = xq.astype(np.int32)
        OH = (H + 2 * pad - K) // stride + 1
        OW = (W + 2 * pad - K) // stride + 1
        acc = np.zeros((OC, OH, OW), np.int32)
        for i in range(K):
            for j in range(K):
                patch = xp[:, i:i + OH * stride:stride, j:j + OW * stride:stride]
                acc += np.tensordot(wq[:, :, i, j].astype(np.int32), patch, axes=([1], [0]))
        acc = acc + bi[:, None, None]
        if mq is None:                       # identity requant
            y = acc.astype(np.int64)
        else:
            y = apply_requant(acc, mq[:, None, None], shift)
        y = np.clip(y, -2**31, 2**31 - 1).astype(np.int32)
        if leaky:
            # LeakyReLU(0.1) 在整数域做：*0.1 用 Q15 的 3277/32768 近似，
            # 和 PL 里的 `(v * 3277) >> 15` 一模一样（不能换成 *0.1f，会差 1 LSB）
            y = np.where(y < 0, (y * 3277) >> 15, y)
        return np.clip(y, -128, 127).astype(np.int8)

    @staticmethod
    def maxpool_fp32(x, k, s, pad):
        C, H, W = x.shape
        xp = np.full((C, H + 2 * pad, W + 2 * pad), -np.inf, np.float32)
        xp[:, pad:pad + H, pad:pad + W] = x
        OH = (H + 2 * pad - k) // s + 1
        OW = (W + 2 * pad - k) // s + 1
        out = np.full((C, OH, OW), -np.inf, np.float32)
        for i in range(k):
            for j in range(k):
                out = np.maximum(out, xp[:, i:i + OH * s:s, j:j + OW * s:s])
        return out

    @staticmethod
    def maxpool_int8(x, k, s, pad):
        C, H, W = x.shape
        xp = np.full((C, H + 2 * pad, W + 2 * pad), -128, np.int8)
        xp[:, pad:pad + H, pad:pad + W] = x
        OH = (H + 2 * pad - k) // s + 1
        OW = (W + 2 * pad - k) // s + 1
        out = np.full((C, OH, OW), -128, np.int8)
        for i in range(k):
            for j in range(k):
                out = np.maximum(out, xp[:, i:i + OH * s:s, j:j + OW * s:s])
        return out

    # ------------------------------------------------------------------ run
    def run(self, x_in):
        """x_in: [3,H,W] float32（RGB，0..1 或 0..255）-> {P3/P4/P5: 输出张量}

        int8 模式下的输入量化用的就是"零点技巧"：
            q = clip(round(v/s - 128), -128, 127)，其中 s = 1/255
        等价于 round(v*255) - 128 —— PS 端 `app_preprocess` 里的 `v - 128`
        就是这条规则（前提：送进来的 v 已经是 0..255 的整数）。
        """
        self.alloc_all()
        t0 = self.p["input_tensor"]
        if self.mode == "int8":
            s = self.quant["input_scale"]
            z = self.quant.get("input_zero_point", 0.0)
            q = np.clip(np.round(x_in / s - z), -128, 127).astype(np.int8)
            self.put(t0, 0, 3, q)
        else:
            self.put(t0, 0, 3, x_in.astype(np.float32))

        for op in self.p["ops"]:
            self._exec(op)
        return {k: self.act[v] for k, v in self.p["outputs"].items()}

    def _exec(self, op):
        """执行一个算子。PL 的 `yolov5n_top()` 循环体做的就是同一件事 ——
        读描述符 -> 分派到 conv / maxpool / copy。"""
        ty = op["type"]
        if ty == OP_CONV:
            c_in = op["ic"]                    # 读的时候按**补齐后**的宽度读
            x = self.get(op["src"], op["src_ch_off"], c_in)
            if self.mode == "int8":
                q = self.quant["layers"][str(op["id"])]
                wq = q["wq"]                       # [OCp, ICp, K, K]
                wq = wq[:op["oc"], :c_in]
                y = self.conv2d_int8(x, wq, q["bi"], q["mq"], q["shift"],
                                     op["s"], op["pad"], op["act"] == ACT_LEAKY)
                if op["add_src"] >= 0:
                    # 残差相加在**激活之后**做，整数直接相加 —— 之所以能直接加，
                    # 是因为 quantize.py 保证了 dst 和 add_src 共用同一个 scale
                    a = self.get(op["add_src"], op["add_src_ch_off"], op["oc_real"])
                    y[:op["oc_real"]] = np.clip(
                        y[:op["oc_real"]].astype(np.int32) + a.astype(np.int32),
                        -128, 127).astype(np.int8)
            else:
                w = self._padded_w(op, c_in)
                b = np.zeros(op["oc"], np.float32)
                rb = self.w[op["bname"]]
                b[:min(op["oc"], rb.shape[0])] = rb[:min(op["oc"], rb.shape[0])]
                y = self.conv2d_fp32(x, w, b, op["s"], op["pad"], op["act"] == ACT_LEAKY)
                if op["add_src"] >= 0:
                    y[:op["oc_real"]] = y[:op["oc_real"]] + \
                        self.get(op["add_src"], op["add_src_ch_off"], op["oc_real"])
            self.put(op["dst"], op["dst_ch_off"], op["oc_real"], y[:op["oc_real"]])

        elif ty == OP_MAXPOOL:
            x = self.get(op["src"], op["src_ch_off"], op["ic"])
            f = self.maxpool_int8 if self.mode == "int8" else self.maxpool_fp32
            self.put(op["dst"], op["dst_ch_off"], op["oc"], f(x, op["k"], op["s"], op["pad"]))

        elif ty == OP_COPY:
            c = op["ic"]
            x = self.get(op["src"], op["src_ch_off"], c)
            if op["up"] == 2:
                x = np.repeat(np.repeat(x, 2, axis=1), 2, axis=2)
            self.put(op["dst"], op["dst_ch_off"], c, x)
        else:
            raise TypeError(ty)
