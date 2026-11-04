# -*- coding: utf-8 -*-
"""
================================================================================
 quantize.py —— 第 3 步（核心）：int8 量化 + 数据打包，产出 PS 端要的全部文件
================================================================================

【产物只给谁用】

    全部给 Vitis 的 PS 端应用（`03_vitis/yolov5n_speed/src/`）。
    **HLS 工程不读这里的任何文件** —— 那边是纯算法，硬件常量写死在
    `01_hls/src/yolov5n_hls.h` 里。所以本脚本不再往 HLS 工程拷东西。

【在流水线里的位置】

    make_layer_plan.py   →   layer_plan.json + fused_weights.npz
    calibrate.py         →   calib.json
    quantize.py          ←   你在这里
            ↓  build_speed/{weights.bin, rqt.bin, layers.bin, gen/*}
    verify_blobs.py      →   按 PL 的读法反解成品，逐字节复核
    emit_vitis_files.py  →   改名拷贝进 Vitis 工程的 src/

【量化契约 —— PL 硬件实际执行的就是这一套，错一条上板就是垃圾】

    激活  : int8，按**张量**对称量化      real = q * s
    权重  : int8，按**输出通道**对称量化  real = q * sw[oc]
    卷积  : acc   = Σ wq*xq               （int32 累加）
            y_int = acc + bi[oc]          （bi = round(b/(sw*sx))，整数偏置）
            y_q   = round(acc * mq[oc] >> shift[oc])   （融合后的 requant）
            然后 LeakyReLU（在整数域做 *3277>>15）、再饱和到 int8

    mq/shift 由 make_requant_vec 算出来，把 m 归一化到 [2^16, 2^17)，
    这样 DSP48 的 25x18 乘法器刚好吃得下，剩下的指数放进 per-channel shift。

【四条缩放规则（为什么必须这样）】

  1) 一个张量一个 scale（张量 = 存激活的那块数组）
  2) 有"残差 Add"关系、或者"拷贝（concat / upsample）"关系的张量，
     **必须共用同一个 scale**。否则：
       - 拷贝就得插一个 requant（PL 没有这个通路）
       - 残差就得做两次 requant 再对齐（PL 也没有）
     这些关系构成并查集(union-find)分组，每组取组内最大的自然 scale。
  3) 三个 Detect 输出张量的裁剪门限要**故意调小**（--outclip）：
     DFL 的 16-bin softmax 全靠相邻 bin 的 logit 差值（只有 0.2~0.5），
     MSE 最优裁剪点会贴到最大值，步长 ~0.3 就把差值抹平了，
     softmax 退化成均匀分布 → 期望值恒等于 7.5 → 所有框都回归成固定大小。
     裁狠一点反而让饱和的离群值把 softmax 锐化，方向是对的。
     （实测 --outclip 1.0 就够；如果发现框大小都差不多，先怀疑这里。）
  4) 输入张量用零点技巧：v∈[0,1] 存成 q = round(v*255) - 128，
     sx = 1/255（比朴素对称的 1/127 精度高一倍），
     这个 +128 的偏移被折进第一层卷积的 bias 里。
     ★ PS 端 app_preprocess() 里 `p[c] = v - 128` 就是这条规则的实现。

【产物（全部在 build_speed/）】

    weights.bin          int8 权重，每个 op 一块，布局 [OC/CO][IC/CI][K][K][CO][CI]
    rqt.bin              每个 op 每通道 {int32 bias, int32 mq, int32 shift}
    layers.bin           64 字节 × N 的 layer descriptor 表（二进制）
    quant.json           全部 scale / 乘数（给 refsim 的 int8 模式用）
    gen/yolov5n_desc.h   描述符结构体 + 输出张量地址/尺度   ┐
    gen/yolov5n_layers.h 层表 C 源码                       │ 这 5 个是
    gen/weights_blob.c   权重字节的 C 数组                 │ 中间产物，
    gen/rqt_blob.c       requant 字节的 C 数组             │ 由下一个脚本
    gen/hw_config.h      硬件常量（**只作对账用**，见下）   ┘ 改名后送进 Vitis

    ★ gen/hw_config.h 的定位：它是"这个模型需要多大的片上缓冲"的一份账，
      用来核对**已经综合好的 IP** 是否够用，比如
          HW_IFM_WORDS 13248  ←→ RTL 里 yolov5n_top_ifm_buf_ram 的 MEM_SIZE
      它不是 HLS 的构建输入。本模型（speed）的每一项都 ≤ 已综合的 IP，
      所以换档不用重新综合。

【权重布局为什么长这样】

    [OC/CO][IC/CI][K][K][CO][CI] —— 输出通道块 → 输入通道块 → 卷积核 → 输出 lane → 输入 lane。
    这样 PL "暂存一个输出通道块的权重"时，读到的就是一段连续的 AXI 突发，
    不用跳来跳去。脚本里 packing 之后还会 round-trip 反解校验一遍（assert）。
================================================================================
"""

import argparse
import json
import os
import struct
import sys

# Windows 下 stdout 被重定向/管道时默认用 GBK，中文提示会乱码，强制成 UTF-8
try:
    sys.stdout.reconfigure(encoding="utf-8")
except Exception:
    pass

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)

from common import CO, CI, OP_CONV, OP_MAXPOOL, OP_COPY, rup     # noqa: E402
from refsim import make_requant_vec                              # noqa: E402

# 产物目录：与 make_layer_plan.py / calibrate.py 保持一致
BUILD = os.path.normpath(os.path.join(HERE, "build_speed"))
GEN = os.path.join(BUILD, "gen")

DESC_SIZE = 64
INPUT_ZERO_POINT = 128.0     # q = v*255 - 128


# ---------------------------------------------------------------------------
def mse_optimal_clip(hist, hist_max, n_step=8):
    """pick the symmetric clipping level that minimises the quantisation MSE.

    For a level c the step is 2c/255, so bins inside [-c,c] contribute
    n*step^2/12 (uniform rounding error) and bins outside contribute
    n*(|x|-c)^2 (saturation error).  Searching c over the histogram is the
    standard MSE calibration and beats both 'max' (one outlier ruins the step)
    and a fixed percentile (saturates a large tail)."""
    if hist_max <= 0 or hist.sum() == 0:
        return hist_max
    n = len(hist)
    edges = np.linspace(0, hist_max, n + 1)
    ctr = 0.5 * (edges[:-1] + edges[1:])
    tot = hist.sum()
    best_c, best_mse = hist_max, None
    for c in np.linspace(ctr[n // 20], hist_max, n_step * 16):
        step = 2.0 * c / 255.0
        inside = ctr <= c
        mse = (hist[inside].sum() * step * step / 12.0
               + (hist[~inside] * (ctr[~inside] - c) ** 2).sum())
        mse /= tot
        if best_mse is None or mse < best_mse:
            best_mse, best_c = mse, c
    return float(best_c)


def union_find_groups(nt, links):
    parent = list(range(nt))

    def find(x):
        while parent[x] != x:
            parent[x] = parent[parent[x]]
            x = parent[x]
        return x

    for a, b in links:
        ra, rb = find(a), find(b)
        if ra != rb:
            parent[ra] = rb
    return [find(i) for i in range(nt)]


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--plan", default=os.path.join(BUILD, "layer_plan.json"))
    ap.add_argument("--calib", default=os.path.join(BUILD, "calib.json"))
    ap.add_argument("--weights", default=os.path.join(BUILD, "fused_weights.npz"))
    ap.add_argument("--clip", choices=["max", "p999", "p9999", "mse"], default="mse")
    ap.add_argument("--outclip", type=float, default=1.0,
                    help="extra clipping factor applied to the 3 Detect output tensors")
    args = ap.parse_args()

    with open(args.plan, encoding="utf-8") as f:
        plan = json.load(f)
    with open(args.calib, encoding="utf-8") as f:
        calib = json.load(f)
    fused = np.load(args.weights)

    tensors = plan["tensors"]
    nt = len(tensors)
    print("quantising %d ops / %d tensors  (clip=%s, %d calib images)"
          % (len(plan["ops"]), nt, args.clip, calib["n_images"]))

    # ---------------------------------------------------------- natural scales
    # The three Detect output tensors need a *deliberately smaller* clipping
    # level than MSE would pick: the DFL does a 16-bin softmax whose whole
    # information content is the logit difference between neighbouring bins
    # (~0.2..0.5).  An MSE-optimal clip sits near the max, giving a step of
    # ~0.3 which flattens that difference and collapses the softmax towards
    # uniform -- the expected bin then snaps to 7.5 and every box regresses to
    # a fixed size.  Clipping harder restores the resolution; the saturated
    # outliers only sharpen the softmax, which is the right direction anyway.
    out_ids = set(plan["outputs"].values())
    nat = np.zeros(nt, np.float64)
    for t in tensors:
        st = calib["tensors"][str(t["id"])]
        if args.clip == "mse" and st.get("hist"):
            v = mse_optimal_clip(np.asarray(st["hist"], np.float64), st["hist_max"])
        else:
            v = st[args.clip]
        if v <= 0:
            v = st["max"]
        if t["id"] in out_ids:
            v *= args.outclip
        nat[t["id"]] = v / 127.0 if v > 0 else 0.0

    # input tensor: fixed zero-point scale (see module docstring)
    in_t = plan["input_tensor"]
    nat[in_t] = 1.0 / 255.0

    # ------------------------------------------------------ constraint groups
    links = []
    for op in plan["ops"]:
        if op["type"] == OP_COPY:
            links.append((op["src"], op["dst"]))
        if op["add_src"] >= 0:
            links.append((op["dst"], op["add_src"]))
    root = union_find_groups(nt, links)

    group_scale = {}
    for t in tensors:
        r = root[t["id"]]
        group_scale[r] = max(group_scale.get(r, 0.0), nat[t["id"]])
    sx = np.array([group_scale[root[t]] for t in range(nt)], np.float64)
    # a tensor that is *only* an add_src of a later op still got a scale above

    nfix = sum(1 for t in tensors if abs(sx[t["id"]] - nat[t["id"]]) > 1e-12
               and nat[t["id"]] > 0)
    print("scale groups: %d ; tensors whose scale was raised by a constraint: %d"
          % (len(set(root)), nfix))

    # ------------------------------------------------------------- quantise
    weights_blob = bytearray()
    rq_blob = bytearray()
    quant_layers = {}
    descs = []
    wgt_off = 0
    rq_off = 0

    n_clamped_bias = 0
    for op in plan["ops"]:
        ty = op["type"]
        if ty == OP_CONV:
            ocp, icp, k = op["oc"], op["ic"], op["k"]
            W = fused[op["wname"]]                      # [oc_real, ic_real, k, k]
            Wp = np.zeros((ocp, icp, k, k), np.float32)
            r = min(ocp, W.shape[0])
            c = min(icp, W.shape[1])
            Wp[:r, :c] = W[:r, :c]
            amax = np.abs(Wp).reshape(ocp, -1).max(axis=1)
            sw = np.where(amax > 0, amax / 127.0, 1.0)
            wq = np.clip(np.round(Wp / sw[:, None, None, None]), -127, 127).astype(np.int8)

            b = np.zeros(ocp, np.float64)
            rb = fused[op["bname"]]
            b[:min(ocp, rb.shape[0])] = rb[:min(ocp, rb.shape[0])]
            # fold the input zero-point into the FIRST conv's bias:
            #    v = q*sx + z   ->   extra bias = z * sum(w)
            if op["src"] == in_t:
                z = INPUT_ZERO_POINT / 255.0
                b += z * Wp.reshape(ocp, -1).astype(np.float64).sum(axis=1)

            s_x = sx[op["src"] + 0]                     # per-tensor input scale
            s_y = sx[op["dst"] + 0]
            bi = np.round(b / (sw * s_x)).astype(np.int64)
            big = np.abs(bi) > (2 ** 24)
            if big.any():
                n_clamped_bias += int(big.sum())
                bi = np.clip(bi, -(2 ** 24), 2 ** 24)

            mq, shift = make_requant_vec(sw * s_x / s_y)   # per output channel

            # pack weights: [oc_blk][ic_blk][ky][kx][co][ci]
            n_icb = icp // CI
            n_ocb = ocp // CO
            idx = np.arange(ocp * icp * k * k).reshape(ocp, icp, k, k)
            # build the destination index for every (ob,blk,i,j,co,ci)
            ob, blk, i, j, co, ci = np.meshgrid(
                np.arange(n_ocb), np.arange(n_icb), np.arange(k), np.arange(k),
                np.arange(CO), np.arange(CI), indexing="ij")
            dst_idx = ((((ob * n_icb + blk) * k + i) * k + j) * CO + co) * CI + ci
            src_idx = ((ob * CO + co) * icp + (blk * CI + ci)) * k * k + (i * k + j)
            flat = np.zeros(ocp * icp * k * k, np.int8)
            flat[dst_idx.ravel()] = wq.reshape(-1)[src_idx.ravel()]
            # ---- 反解校验：PL 是按 [ob][blk][ky][kx][co][ci] 六重循环顺序
            #      连着读这段字节的，所以这里也用同样的顺序反解回来，
            #      必须和量化后的 wq 完全相等。打包顺序写反了这一步就会炸。 ----
            chk = np.zeros((ocp, icp, k, k), np.int8)
            _n = 0
            for _ob in range(n_ocb):
                for _blk in range(n_icb):
                    for _ky in range(k):
                        for _kx in range(k):
                            for _co in range(CO):
                                for _ci in range(CI):
                                    chk[_ob * CO + _co, _blk * CI + _ci, _ky, _kx] = flat[_n]
                                    _n += 1
            assert _n == flat.size, (op["name"], _n, flat.size)
            assert np.array_equal(chk, wq), "weight packing mismatch in %s" % op["name"]
            weights_blob += flat.tobytes()

            for i in range(ocp):
                rq_blob += struct.pack("<iii", int(bi[i]), int(mq[i]), int(shift[i]))

            quant_layers[str(op["id"])] = dict(
                wq=wq, bi=bi.astype(np.int32), mq=mq, shift=shift.astype(np.int32),
                sw=sw, sx=float(s_x), sy=float(s_y), sx_in=float(s_x), sy_out=float(s_y),
                wgt_off=wgt_off, rq_off=rq_off, ocp=ocp, icp=icp, k=k)
            op["_wgt_off"] = wgt_off
            op["_rq_off"] = rq_off
            wgt_off += ocp * icp * k * k
            rq_off += ocp * 12
        else:
            op["_wgt_off"] = 0
            op["_rq_off"] = 0

        # ---- descriptor (64 bytes, explicit offsets -- see pack_desc)
        descs.append(dict(
            src_off=tensors[op["src"]]["off"], dst_off=tensors[op["dst"]]["off"],
            wgt_off=op["_wgt_off"], rq_off=op["_rq_off"],
            add_off=(-1 if op["add_src"] < 0 else tensors[op["add_src"]]["off"]),
            add_ch_off=op.get("add_src_ch_off", 0),
            ih=tensors[op["src"]]["h"], iw=tensors[op["src"]]["w"],
            oh=op["oh"], ow=op["ow"], ic=op["ic"], oc=op["oc"],
            oc_real=op["oc_real"],
            k=op.get("k", 1), s=op.get("s", 1), pad=op.get("pad", 0),
            act=op.get("act", 0), up=op.get("up", 1),
            type={"conv": 0, "maxpool": 1, "copy": 2}[ty],
            src_ch_off=op["src_ch_off"], dst_ch_off=op["dst_ch_off"],
            tile_r=op["tile"][0], tile_c=op["tile"][1]))

    # ------------------------------------------------------------- file dumps
    os.makedirs(GEN, exist_ok=True)
    with open(os.path.join(BUILD, "weights.bin"), "wb") as f:
        f.write(weights_blob)
    with open(os.path.join(BUILD, "rqt.bin"), "wb") as f:
        f.write(rq_blob)
    with open(os.path.join(BUILD, "layers.bin"), "wb") as f:
        for d in descs:
            f.write(pack_desc(d))
    print("[written] weights.bin %.1f KB   rqt.bin %.1f KB   layers.bin %.1f KB"
          % (len(weights_blob) / 1024.0, len(rq_blob) / 1024.0, len(descs) * DESC_SIZE / 1024.0))

    with open(os.path.join(BUILD, "quant.json"), "w", encoding="utf-8") as f:
        json.dump(dict(layers={k: dict(shift=v["shift"].tolist(), ocp=v["ocp"], icp=v["icp"],
                                       k=v["k"], wgt_off=v["wgt_off"], rq_off=v["rq_off"],
                                       sx=v["sx"], sy=v["sy"], sw=v["sw"].tolist(),
                                       bi=v["bi"].tolist(), mq=v["mq"].tolist())
                             for k, v in quant_layers.items()},
                       tensor_scales=[float(x) for x in sx],
                       input_tensor=in_t, input_scale=float(sx[in_t]),
                       input_zero_point=INPUT_ZERO_POINT,
                       clip=args.clip, n_clamped_bias=n_clamped_bias),
                  f, indent=1)
    print("[written] %s" % os.path.join(BUILD, "quant.json"))
    if n_clamped_bias:
        print("WARNING: %d biases were clamped to +/-2^24" % n_clamped_bias)

    # --------------------------------------------------------- C source dumps
    emit_hw_config(plan, quant_layers)
    emit_layers_h(plan, descs, sx)
    emit_weights_c(os.path.join(BUILD, "weights.bin"))
    emit_blob_c(os.path.join(BUILD, "rqt.bin"), "rqt_blob.c", "yolov5n_rqt")
    print("[written] %s/{hw_config.h,yolov5n_desc.h,yolov5n_layers.h,weights_blob.c}" % GEN)

    # ------------------------------------------------------- hw_config.h 的对账
    # 这里刻意**不往任何 HLS 目录拷东西**：
    #   * HLS 工程是纯算法，它的硬件常量写死在 01_hls/src/yolov5n_hls.h，
    #     不读本目录的产物；
    #   * hw_config.h 里的 HW_IFM_WORDS / HW_WGT_BYTES 决定 IP 里 BRAM 的深度，
    #     偷偷覆盖会让"已综合的 bitstream"和"头文件"对不上。
    # 它的用途只是让你**核对**现有 IP 够不够用，核对方法见本文件顶部说明。
    hw = open(os.path.join(GEN, "hw_config.h"), encoding="ascii").read()

    def _m(name):
        import re as _re
        m = _re.search(r"#define\s+%s\s+(\d+)" % name, hw)
        return int(m.group(1)) if m else -1

    print("")
    print("---- 和已综合 IP 的对账（只读，不改任何东西）----")
    for name, ip_val in (("HW_IFM_WORDS", 13248), ("HW_WGT_BYTES", 18432),
                         ("HW_TROWS", 33), ("HW_TCOLS", 33), ("HW_N_OPS", 84)):
        need = _m(name)
        ok = "够用" if need <= ip_val else "!!! 不够，必须重新综合 IP"
        print("  %-14s 本模型需要 %-6d  已综合 IP 提供 %-6d  %s" % (name, need, ip_val, ok))


# ---------------------------------------------------------------------------
MAX_TILE = 16          # must match common.py MAX_TILE
ICG = 16               # input channels held on chip per accumulation pass


def emit_hw_config(plan, quant_layers):
    """算出"这个模型需要多大的片上缓冲"，写成 hw_config.h。

    ★ 这不是 HLS 的构建输入，是一份**对账用的账本**：
      它把你手上这个模型对硬件资源的需求列出来，好和第 IP 里实际的
      BRAM 深度比一比。核对的三个数：

        HW_IFM_WORDS ←→ yolov5n_top_ifm_buf_ram  的 MEM_SIZE（现在 13248）
        HW_WGT_BYTES ←→ yolov5n_top_conv_kernel_wgt_buf_ram 的 MEM_SIZE×4（18432）
        HW_TROWS/TCOLS ←→ 上面两个 RAM 单个窗口的形状

      RTL 路径：01_hls/yolov5n_hls/solution1/impl/ip/hdl/verilog/
      三项都 ≤ 现有 IP，就说明换档不用重新综合。

    各量的算法（都能在本函数里对上）：
        HW_IFM_WORDS = max over 算子 ( ic/4 × 该 tile 的输入窗口像素数 )
        HW_WGT_BYTES = max over 卷积 ( ic × K × K × 16 )   ← 一个输出通道块
        HW_MAX_IC    = max ic
        HW_TROWS     = (MAX_TILE-1)*2 + 3 = 33  ← s=2,k=3 时最宽的一次 halo
    """
    max_wbuf = 0
    max_pix = 0
    max_ic = 0
    max_ifm = 0
    tro = (MAX_TILE - 1) * 2 + 3          # 33: widest halo for MAX_TILE at s=2,k=3
    for op in plan["ops"]:
        tr, tc = op["tile"]
        if op["type"] == "conv":
            max_wbuf = max(max_wbuf, op["ic"] * op["k"] * op["k"] * CO)   # one OB block
            max_ic = max(max_ic, op["ic"])
            rows = (tr - 1) * op["s"] + op["k"]
            cols = (tc - 1) * op["s"] + op["k"]
            max_ifm = max(max_ifm, (op["ic"] // CI) * rows * cols)
        elif op["type"] == "maxpool":
            max_ifm = max(max_ifm, ((op["ic"] + 3) // 4) * (tr + 2) * (tc + 2))
        max_pix = max(max_pix, tr * tc)
    icw = ICG // CI                       # 4 c4-words per pixel
    lines = [
        "/* AUTO-GENERATED by scripts/VITIS_export/quantize.py -- do not edit */",
        "#ifndef YOLOV5N_HW_CONFIG_H",
        "#define YOLOV5N_HW_CONFIG_H",
        "",
        "/* ---- parallelism ---- */",
        "#define HW_CO       %d     /* output channels computed in parallel */" % CO,
        "#define HW_CI       %d     /* input channels per packed word (c4) */" % CI,
        "#define HW_KMAX     3",
        "#define HW_NX       %d     /* output pixels per pipelined block */" % MAX_TILE,
        "#define HW_ICG      %d     /* input channels resident on chip per pass */" % ICG,
        "#define HW_ICW      %d     /* c4 words per pixel (HW_ICG/HW_CI) */" % icw,
        "",
        "/* ---- on-chip buffers ---- */",
        "#define HW_TROWS    %d     /* input tile rows  = (MAX_TILE-1)*2+3 */" % tro,
        "#define HW_TCOLS    %d" % tro,
        "#define HW_IFM_WORDS %d    /* max(icb * halo_pixels), 32-bit words */"
        % rup(max_ifm, 64),
        "#define HW_WGT_BYTES %d    /* biggest (oc * ic * K * K) weight set */" % rup(max_wbuf, 8),
        "#define HW_ACC_N    %d     /* HW_NX * HW_CO int32 accumulators */" % (MAX_TILE * CO),
        "#define HW_MAX_PIX  %d     /* biggest tile_r*tile_c */" % max_pix,
        "#define HW_MAX_IC   %d" % max_ic,
        "",
        "/* ---- system ---- */",
        "#define HW_ARENA_BYTES %d" % plan["arena_bytes"],
        "#define HW_N_OPS %d" % len(plan["ops"]),
        "#define HW_DESC_WORDS 16   /* 64-byte descriptor / 4 */",
        "",
        "#endif",
        ""]
    # newline="\n"：Windows 下默认会写成 CRLF，那样 gen/ 和拷进 Vitis 的
    # 文件会差一个字节数（内容一样，只是行尾）。统一成 LF，两边就逐字节一致，
    # emit_vitis_files.py 的"有没有变化"判断也才是字节级的。
    with open(os.path.join(GEN, "hw_config.h"), "w", encoding="ascii", newline="\n") as f:
        f.write("\n".join(lines))


def pack_desc(d):
    """64-byte record, explicit offsets so it cannot drift from the C struct"""
    b = bytearray(DESC_SIZE)
    struct.pack_into("<6i", b, 0, d["src_off"], d["dst_off"], d["wgt_off"],
                     d["rq_off"], d["add_off"], d["add_ch_off"])
    struct.pack_into("<i", b, 24, 0)
    struct.pack_into("<7h", b, 28, d["ih"], d["iw"], d["oh"], d["ow"],
                     d["ic"], d["oc"], d["oc_real"])
    struct.pack_into("<4h", b, 42, d["src_ch_off"], d["dst_ch_off"],
                     d["tile_r"], d["tile_c"])
    struct.pack_into("<8B", b, 50, d["k"], d["s"], d["pad"], d["act"],
                     d["up"], d["type"], 0, 0)
    struct.pack_into("<h", b, 58, 0)
    struct.pack_into("<i", b, 60, 0)
    return bytes(b)


DESC_FIELDS = [
    ("int32_t", "src_off"), ("int32_t", "dst_off"), ("int32_t", "wgt_off"),
    ("int32_t", "rq_off"), ("int32_t", "add_off"), ("int32_t", "add_ch_off"),
    ("int32_t", "reserved0"),
    ("int16_t", "ih"), ("int16_t", "iw"), ("int16_t", "oh"), ("int16_t", "ow"),
    ("int16_t", "ic"), ("int16_t", "oc"), ("int16_t", "oc_real"),
    ("int16_t", "src_ch_off"), ("int16_t", "dst_ch_off"),
    ("int16_t", "tile_r"), ("int16_t", "tile_c"),
    ("uint8_t", "k"), ("uint8_t", "s"), ("uint8_t", "pad"), ("uint8_t", "act"),
    ("uint8_t", "up"), ("uint8_t", "type"), ("uint8_t", "pad0"), ("uint8_t", "pad1"),
    ("int16_t", "pad2"), ("int32_t", "pad3"),
]


def emit_desc_h(plan, _sc):
    """只出结构体 + 常量。这份头文件给 **PS 端固件**用，
    描述符的二进制布局必须和 PL 解包时用的顺序一致（由 pack_desc 钉死）。"""
    L = []
    L.append("/* AUTO-GENERATED by scripts/VITIS_export/quantize.py -- do not edit */")
    L.append("/* layer descriptor layout, shared by the PS firmware / PC tools */")
    L.append("#ifndef YOLOV5N_DESC_H")
    L.append("#define YOLOV5N_DESC_H")
    L.append("")
    L.append("#include <stdint.h>")
    L.append("")
    L.append("/* 64-byte record; layout is pinned by quantize.py::pack_desc */")
    L.append("typedef struct {")
    for ty, name in DESC_FIELDS:
        L.append("    %-8s %s;" % (ty, name))
    L.append("} layer_desc_t;")
    L.append("")
    L.append("/* per output channel requant record (12 bytes) */")
    L.append("typedef struct { int32_t bias, mq, shift; } requant_t;")
    L.append("")
    L.append("/* op types */")
    L.append("#define LT_CONV     0")
    L.append("#define LT_MAXPOOL  1")
    L.append("#define LT_COPY     2")
    L.append("")
    L.append("/* op flags (desc.act / desc.up) */")
    L.append("#define ACT_NONE    0")
    L.append("#define ACT_LEAKY   1")
    L.append("")
    L.append("#define YOLO_N_OPS %d" % len(plan["ops"]))
    L.append("#define YOLO_INPUT_OFF     %d" % plan["tensors"][plan["input_tensor"]]["off"])
    L.append("#define YOLO_INPUT_CH      3")
    L.append("#define YOLO_INPUT_H       %d" % plan["input_h"])
    L.append("#define YOLO_INPUT_W       %d" % plan["input_w"])
    for name, tid in plan["outputs"].items():
        t = plan["tensors"][tid]
        L.append("#define YOLO_OUT_%s_OFF     %d" % (name, t["off"]))
        L.append("#define YOLO_OUT_%s_CH      %d" % (name, t["c"]))
        L.append("#define YOLO_OUT_%s_H       %d" % (name, t["h"]))
        L.append("#define YOLO_OUT_%s_W       %d" % (name, t["w"]))
    L.append("")
    L.append("/* output dequantisation scales: the DFL softmax and the")
    L.append("   class sigmoid are scale sensitive, the PS MUST apply them */")
    for name, tid in plan["outputs"].items():
        L.append("#define YOLO_OUT_%s_SCALE   %.9gf" % (name, _sc[tid]))
    L.append("#define YOLO_ARENA_BYTES   %d" % plan["arena_bytes"])
    L.append("")
    L.append("#endif")
    with open(os.path.join(GEN, "yolov5n_desc.h"), "w", encoding="ascii", newline="\n") as f:
        f.write("\n".join(L))


def emit_layers_h(plan, descs, sx):
    """出两张东西：yolov5n_desc.h（结构体+常量）和 yolov5n_layers.h（层表本体）。

    层表就是 84 条 64 字节记录的 C 写法，`main.c` 把它整个 flush 到 DDR 再
    把地址交给 PL。**文本里的数字顺序必须和 pack_desc 的字节顺序完全一致**，
    否则 PS 一份、PL 一份就错位了。emit_vitis_files.py 最后会反解这段文本
    和 layers.bin 逐字节比一遍。
    """
    emit_desc_h(plan, sx)
    L = []
    L.append("/* AUTO-GENERATED by scripts/VITIS_export/quantize.py -- do not edit */")
    L.append("/* the concrete layer table (PS firmware side) */")
    L.append("#ifndef YOLOV5N_LAYERS_H")
    L.append("#define YOLOV5N_LAYERS_H")
    L.append("")
    L.append('#include "yolov5n_desc.h"')
    L.append("")
    L.append("/* op types */")
    L.append("#define LT_CONV     0")
    L.append("#define LT_MAXPOOL  1")
    L.append("#define LT_COPY     2")
    L.append("")
    L.append("#define YOLO_N_OPS %d" % len(descs))
    L.append("")
    L.append("/* layer table for the Vitis application (64B aligned to match hardware) */")
    L.append("static const layer_desc_t yolo_layers[YOLO_N_OPS] __attribute__((aligned(64))) = {")
    for i, d in enumerate(descs):
        L.append("  /*%2d %-24s*/" % (i, plan["ops"][i]["name"][:24]))
        L.append("  { %9d,%9d,%9d,%9d,%9d,%9d, 0,  %5d,%5d,%5d,%5d,%5d,%5d,%5d,"
                 " %5d,%5d,%5d,%5d, %d,%d,%d,%d,%d,%d,0,0, 0,0 },"
                 % (d["src_off"], d["dst_off"], d["wgt_off"], d["rq_off"], d["add_off"],
                    d["add_ch_off"], d["ih"], d["iw"], d["oh"], d["ow"], d["ic"], d["oc"],
                    d["oc_real"], d["src_ch_off"], d["dst_ch_off"], d["tile_r"], d["tile_c"],
                    d["k"], d["s"], d["pad"], d["act"], d["up"], d["type"]))
    L.append("};")
    L.append("")
    L.append("#endif")
    with open(os.path.join(GEN, "yolov5n_layers.h"), "w", encoding="ascii", newline="\n") as f:
        f.write("\n".join(L))


def emit_blob_c(binpath, outname, sym, ctype="uint8_t", per_line=24):
    """turn a .bin into a C array so the firmware can link it in directly"""
    data = open(binpath, "rb").read()
    L = ["/* AUTO-GENERATED from %s -- do not edit */" % os.path.basename(binpath),
         "#include <stdint.h>",
         "const %s %s[%d] __attribute__((aligned(64))) = {" % (ctype, sym, len(data))]
    for i in range(0, len(data), per_line):
        L.append("  " + ",".join("0x%02x" % b for b in data[i:i + per_line]) + ",")
    L.append("};")
    L.append("const uint32_t %s_len = %d;" % (sym, len(data)))
    with open(os.path.join(GEN, outname), "w", encoding="ascii", newline="\n") as f:
        f.write("\n".join(L))
    print("[%s] %.2f MB of C source" % (outname, os.path.getsize(os.path.join(GEN, outname)) / 1e6))


def emit_weights_c(binpath, per_line=24):
    data = open(binpath, "rb").read()
    L = ["/* AUTO-GENERATED from weights.bin -- do not edit */",
         "#include <stdint.h>",
         "const uint8_t yolov5n_weights[%d] __attribute__((aligned(64))) = {" % len(data)]
    for i in range(0, len(data), per_line):
        L.append("  " + ",".join("0x%02x" % b for b in data[i:i + per_line]) + ",")
    L.append("};")
    L.append("const uint32_t yolov5n_weights_len = %d;" % len(data))
    with open(os.path.join(GEN, "weights_blob.c"), "w", encoding="ascii", newline="\n") as f:
        f.write("\n".join(L))
    print("[weights_blob.c] %.2f MB of C source" % (os.path.getsize(os.path.join(GEN, "weights_blob.c")) / 1e6))


if __name__ == "__main__":
    main()
