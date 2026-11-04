# -*- coding: utf-8 -*-
"""
================================================================================
 verify_blobs.py —— 第 5 步：把成品文件按"硬件的读法"重新解一遍，证明三者自洽
================================================================================

【为什么要有这一步】

    这一节存在的理由：**产物之间对不上时，编译期看不出来**。
    layers / weights / rqt 三份文件只要有任意两份不是同一次导出，或者某个
    字段填错一位，PL 就会安静地算出一堆垃圾特征 —— 它不会报错，因为
    C 数组就是一堆 uint8_t，没有类型信息可查，上板只表现成
    "能跑、但结果是垃圾"。

    所以本脚本做的事情是：**完全按照 PL 的读法**，把已经生成的成品文件重新
    解析一遍，再独立重算一遍真值，逐字节对照：

        1. layers.bin  → 按 64 字节一条解出 84 个 descriptor，
                        检查所有偏移是否越界、形状是否和 layer_plan 一致
        2. 对每个 conv op：
             从 fused_weights.npz 的 fp32 权重**独立重算**量化 + 打包，
             再和 weights.bin 在 wgt_off 处的字节逐字节比
             （不是拿 quant.json 比，是真算一遍 —— 连量化公式写错也能抓出来）
             从 rqt.bin 的 rq_off 处读 oc 组 {bias, mq, shift} → 对比 quant.json
        3. 检查所有 wgt_off / rq_off / src_off / dst_off / add_off 是否越界，
           ic/oc 是否都是 4/16 的倍数（PL 的并行度要求）

    只要这一步过了，就说明"描述符 ↔ 权重 ↔ requant 表"三者是对齐的，
    上板再出问题就不是这三个文件的事，要往别处找（时钟、时序、缓存、IP 版本）。

【用法】

    cd /d "D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\scripts\VITIS_export"
    python verify_blobs.py

【退出码】

    0 = 全部自洽；非 0 = 有不一致，会明确指出是哪个 op、哪个字段
================================================================================
"""

import json
import os
import struct
import sys

import numpy as np

try:
    sys.stdout.reconfigure(encoding="utf-8")
except Exception:
    pass

HERE = os.path.dirname(os.path.abspath(__file__))
BUILD = os.path.join(HERE, "build_speed")

CO, CI = 16, 4          # PL 的并行度：一次 16 个输出通道 × 4 个输入通道

# layer_desc_t 的字段顺序 = **PL 解包描述符的顺序**（PL 侧的实现见
# 01_hls/src/yolov5n_top.cpp，读的是 d[0]..d[13]；PC 侧的打包见
# quantize.py::pack_desc）。两边任何一个动了，这个脚本就会报警。
DESC_FMT = "<6i i 7h 4h 8B h i"
DESC_FIELDS = ["src_off", "dst_off", "wgt_off", "rq_off", "add_off", "add_ch_off",
               "reserved0",
               "ih", "iw", "oh", "ow", "ic", "oc", "oc_real",
               "src_ch_off", "dst_ch_off", "tile_r", "tile_c",
               "k", "s", "pad", "act", "up", "type", "pad0", "pad1",
               "pad2", "pad3"]


def unpack_desc(buf, i):
    vals = struct.unpack_from(DESC_FMT, buf, i * 64)
    return dict(zip(DESC_FIELDS, vals))


def main():
    with open(os.path.join(BUILD, "layer_plan.json"), encoding="utf-8") as f:
        plan = json.load(f)
    with open(os.path.join(BUILD, "quant.json"), encoding="utf-8") as f:
        quant = json.load(f)

    weights = open(os.path.join(BUILD, "weights.bin"), "rb").read()
    rqt = open(os.path.join(BUILD, "rqt.bin"), "rb").read()
    layers = open(os.path.join(BUILD, "layers.bin"), "rb").read()

    arena = plan["arena_bytes"]
    n_desc = len(layers) // 64
    print("weights.bin %d B, rqt.bin %d B, layers.bin %d B (%d 条描述符)"
          % (len(weights), len(rqt), len(layers), n_desc))

    errs = []

    # op 数必须和 plan 一致 —— 这里就是"层表是别的模型导出的"第一个报警点
    if n_desc != len(plan["ops"]):
        errs.append("描述符条数 %d != layer_plan 的 op 数 %d" % (n_desc, len(plan["ops"])))

    # ---------------------------------------------------------------- 1. 描述符
    descs = [unpack_desc(layers, i) for i in range(n_desc)]
    for i, d in enumerate(descs):
        op = plan["ops"][i]
        # 张量偏移必须落在 arena 内
        for key in ("src_off", "dst_off"):
            if not (0 <= d[key] < arena):
                errs.append("op%2d %-16s %s=%d 超出 arena(%d)"
                            % (i, op["name"], key, d[key], arena))
        if d["add_off"] >= 0 and not (0 <= d["add_off"] < arena):
            errs.append("op%2d %-16s add_off=%d 超出 arena" % (i, op["name"], d["add_off"]))
        # conv 的权重/requant 区间必须在各自 blob 里
        if d["type"] == 0:
            wbytes = d["oc"] * d["ic"] * d["k"] * d["k"]
            if d["wgt_off"] + wbytes > len(weights):
                errs.append("op%2d %-16s 权重越界 %d+%d > %d"
                            % (i, op["name"], d["wgt_off"], wbytes, len(weights)))
            if d["rq_off"] + d["oc"] * 12 > len(rqt):
                errs.append("op%2d %-16s requant 越界 %d+%d > %d"
                            % (i, op["name"], d["rq_off"], d["oc"] * 12, len(rqt)))
        # 描述符里的张量形状必须和 plan 里记的完全一致
        t_src = plan["tensors"][op["src"]]
        if (d["ih"], d["iw"]) != (t_src["h"], t_src["w"]):
            errs.append("op%2d %-16s ih/iw %dx%d != plan %dx%d"
                        % (i, op["name"], d["ih"], d["iw"], t_src["h"], t_src["w"]))
        if (d["ic"], d["oc"], d["oc_real"]) != (op["ic"], op["oc"], op["oc_real"]):
            errs.append("op%2d %-16s ic/oc/oc_real %s != plan %s"
                        % (i, op["name"], (d["ic"], d["oc"], d["oc_real"]),
                           (op["ic"], op["oc"], op["oc_real"])))
        # 并行度约束：硬件要求 ic/oc 是 CI/CO 的整数倍，否则尾部空转/越界
        if d["ic"] % CI or d["oc"] % CO:
            errs.append("op%2d %-16s ic=%d oc=%d 不是 %d/%d 的倍数"
                        % (i, op["name"], d["ic"], d["oc"], CI, CO))

    print("描述符结构检查：%s" % ("通过" if not errs else "有 %d 个问题" % len(errs)))

    # ------------------------------------------------- 2. 权重/requant 逐 op 对照
    # 权重这一项是**独立重算**的：直接从 fused_weights.npz 的 fp32 权重出发，
    # 按 quantize.py 里同一套 per-output-channel 对称量化公式重算
    #     sw = max|W| / 127 ;  wq = clip(round(W / sw), -127, 127)
    # 再按 [ob][ib][ky][kx][co][ci] 打包，最后和成品 weights.bin 逐字节比。
    # 这样除了能验证打包顺序，还能验证量化本身没写错。
    fused = np.load(os.path.join(BUILD, "fused_weights.npz"))

    n_conv = 0
    n_w_checked = 0
    n_rq_checked = 0
    for i, d in enumerate(descs):
        if d["type"] != 0:
            continue
        op = plan["ops"][i]
        q = quant["layers"][str(i)]
        n_conv += 1

        ocp, icp, k = d["oc"], d["ic"], d["k"]
        assert (ocp, icp, k) == (q["ocp"], q["icp"], q["k"]), \
            "op%d 描述符形状和 quant.json 不一致" % i

        # ---- 重算量化权重（float32 全程，和 quantize.py 完全同路）
        W = fused[op["wname"]].astype(np.float32)
        Wp = np.zeros((ocp, icp, k, k), np.float32)
        r = min(ocp, W.shape[0])
        c = min(icp, W.shape[1])
        Wp[:r, :c] = W[:r, :c]
        amax = np.abs(Wp).reshape(ocp, -1).max(axis=1)
        sw = np.where(amax > 0, amax / 127.0, 1.0)
        wq = np.clip(np.round(Wp / sw[:, None, None, None]), -127, 127).astype(np.int8)

        # ---- 打包成 [oc_blk][ic_blk][ky][kx][co][ci]
        n_icb, n_ocb = icp // CI, ocp // CO
        ob, ib, ky, kx, co, ci = np.meshgrid(
            np.arange(n_ocb), np.arange(n_icb), np.arange(k), np.arange(k),
            np.arange(CO), np.arange(CI), indexing="ij")
        dst_idx = ((((ob * n_icb + ib) * k + ky) * k + kx) * CO + co) * CI + ci
        src_idx = ((ob * CO + co) * icp + (ib * CI + ci)) * k * k + (ky * k + kx)
        flat_expect = np.zeros(ocp * icp * k * k, np.int8)
        flat_expect[dst_idx.ravel()] = wq.reshape(-1)[src_idx.ravel()]

        # ---- 和成品字节比
        flat_got = np.frombuffer(weights, np.int8,
                                 count=ocp * icp * k * k, offset=d["wgt_off"])
        if not np.array_equal(flat_got, flat_expect):
            nbad = int((flat_got != flat_expect).sum())
            errs.append("op%2d %-16s 权重不符：%d/%d 个字节不一样"
                        % (i, op["name"], nbad, flat_expect.size))
        n_w_checked += flat_expect.size

        # 顺便核对 sw（量化刻度）有没有被换掉
        if not np.allclose(np.asarray(q["sw"], np.float32), sw, rtol=1e-6, atol=0):
            errs.append("op%2d %-16s 权重刻度 sw 不符" % (i, op["name"]))

        # ---- requant：{bias, mq, shift} × oc
        rq = np.frombuffer(rqt, np.int32, count=ocp * 3, offset=d["rq_off"])
        rq = rq.reshape(ocp, 3)
        for j, key in enumerate(("bi", "mq", "shift")):
            want = np.asarray(q[key], np.int32)
            if not np.array_equal(rq[:want.size, j], want):
                errs.append("op%2d %-16s requant.%s 不符" % (i, op["name"], key))
        n_rq_checked += ocp

    print("卷积 op：%d 个；独立重算并逐字节复核权重点数 %d；requant 逐通道复核 %d 条"
          % (n_conv, n_w_checked, n_rq_checked))

    # ------------------------------------------------------ 3. 输入/输出声明
    in_t = plan["tensors"][plan["input_tensor"]]
    print("输入张量：%d 通道（c4 补齐到 %d）= 3 通道 + 1 车道填充"
          % (in_t["c"], in_t["cs"]))
    if in_t["off"] != 0:
        errs.append("输入张量 off=%d，PS 端 app_preprocess 假设它是 0" % in_t["off"])

    outs = plan["outputs"]
    print("输出张量：%s" % ", ".join("%s(off=%d, %dch %dx%d)"
                                     % (k, plan["tensors"][v]["off"],
                                        plan["tensors"][v]["c"],
                                        plan["tensors"][v]["h"],
                                        plan["tensors"][v]["w"])
                                     for k, v in outs.items()))

    print("")
    if errs:
        print("!! 有 %d 个不一致：" % len(errs))
        for e in errs[:40]:
            print("   -", e)
        raise SystemExit(1)
    print("全部通过：描述符表、权重、requant 表互相自洽，且与 layer_plan 完全一致。")


if __name__ == "__main__":
    main()
