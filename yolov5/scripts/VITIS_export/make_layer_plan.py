# -*- coding: utf-8 -*-
"""
================================================================================
 make_layer_plan.py —— 第 1 步：把 PyTorch 模型"摊平"成 PL 能执行的算子表
================================================================================

【产物只给谁用】

    这一整套脚本的产物**只给 Vitis 的 PS 端应用用**
    （`03_vitis/yolov5n_speed/src/`）。HLS 工程是纯算法，一个字节都不读。

【在整个流水线里的位置】

    make_layer_plan.py   ← 你在这里（摊平 + BN 融合 + DDR 地址分配）
            ↓  build_speed/layer_plan.json + fused_weights.npz
    calibrate.py            跑验证集，统计每层激活的绝对值分布
            ↓  build_speed/calib.json
    quantize.py             int8 量化 + 打包，生成 weights.bin / rqt.bin /
                           layers.bin 和全部 C 源文件
            ↓  build_speed/gen/…
    verify_blobs.py         按 PL 的读法反解成品、逐字节复核
    emit_vitis_files.py     改名成 Vitis 工程 src/ 需要的文件名并拷过去

【为什么要"摊平"】

    PyTorch 的 forward 是一个张量程序：C3、SPPF、Detect 这些复合模块内部
    怎么算，是框架自己决定的。而 PL 上的 yolov5n_top 加速器是一个
    **指令驱动的固定数据通路**：它只认描述符表里的三种算子

        LT_CONV     = 0   卷积（K 是运行时参数，1x1 / 3x3 都走同一条通路）
        LT_MAXPOOL  = 1   3x3 / stride1 / pad1 最大池化
        LT_COPY     = 2   通道拷贝（Concat）或 2 倍最近邻上采样（Upsample）

    所以本脚本做的事就是：把 C3 拆成 cv1 + N 个 Bottleneck(cv1,cv2) + cv2 + cv3；
    把 SPPF 拆成 cv1 + 3 次 maxpool + cv2；把 Detect 拆成 3 个尺度 × 6 个卷积。
    拆完之后每一层都只用到上面三种算子之一。

【三个关键约定】（写错任何一个，PL 算出来的东西就是错的）

    1) 激活张量布局：int8，4 个通道打包进一个 32 位字 → [C/4][H][W][4]
       字节下标 = (((c>>2)*H + h)*W + w)*4 + (c&3)
       通道数一律向上取整到 4 的倍数（cs = round_up(c,4)），
       所以 P3/P4/P5 的 67 通道实际占 68 通道的位置。

    2) 张量之间靠"通道偏移"复用同一块 DDR（src_ch_off / dst_ch_off），
       这样 C3/SPPF 内部的 Concat 不用真的搬数据（省带宽），
       只有模块级的 Concat/Upsample 才用显式的 LT_COPY 算子。

    3) 每个中间张量由 Arena 分配一个 64 字节对齐的 DDR 字节偏移 off，
       这个 off 会原封不动写进 64 字节的 layer descriptor，
       PL 就是靠它去 DDR 里取数的。**PS 端的解码也按它找张量。**

【用法】

    cd /d "D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\scripts\VITIS_export"
    python make_layer_plan.py                 # 用下面的默认 speed 模型
    python make_layer_plan.py --weights <其它 .pt> --out <其它目录>/layer_plan.json

【产物】

    build_speed/layer_plan.json    op / tensor 总表（后面所有脚本的输入）
    build_speed/fused_weights.npz  卷积+BN 融合后的 float32 权重与偏置

【自检】

    脚本最后会跑一遍 fp32 numpy 模拟器（refsim），
    把摊平后的结果和原版 PyTorch forward 逐元素对比。
    相对误差 > 1e-4 就直接 SystemExit —— 说明摊平逻辑写错了，
    后面的量化、上板全都是错的，必须先修 common.py。
================================================================================
"""

import argparse
import json
import os
import sys

# Windows 下 stdout 被重定向/管道时默认用 GBK，中文提示会乱码，强制成 UTF-8
try:
    sys.stdout.reconfigure(encoding="utf-8")
except Exception:
    pass

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)

from common import build_plan, load_model, OP_CONV, OP_MAXPOOL, OP_COPY  # noqa: E402
from refsim import RefSim                                               # noqa: E402

# 产物目录：本目录下的 build_speed/。
#   每一步都只读写这里，不碰工程外的任何目录。
BUILD = os.path.normpath(os.path.join(HERE, "build_speed"))


def parse_args():
    ap = argparse.ArgumentParser()
    # 默认就是 speed（帧率优先、骨干 P3 收到 32 通道）这一档的权重
    ap.add_argument("--weights", default=r"D:/02_workspace/05_ascend_projects/yolo_pavement/"
                                         r"yolov5/runs/detect/train_crack_4_35/weights/best.pt")
    ap.add_argument("--repo", default=r"D:/02_workspace/05_ascend_projects/yolo_pavement/yolov5")
    ap.add_argument("--img", default=None, help="test image for the fp32 self-check")
    ap.add_argument("--out", default=os.path.join(BUILD, "layer_plan.json"))
    ap.add_argument("--no-check", action="store_true")
    return ap.parse_args()


def main():
    args = parse_args()
    net = load_model(args.weights, args.repo)
    img_h, img_w = 384, 512

    b, inp, outputs = build_plan(net, verbose=True, img_h=img_h, img_w=img_w)

    # ---------------------------------------------------------------- pack
    plan = dict(
        model_name="yolov5n_crack_speed",
        input_h=img_h, input_w=img_w, input_c=3,
        input_tensor=inp["id"],
        arena_bytes=b.arena.off,
        tensors=b.tensors,
        ops=b.ops,
        outputs=dict(P3=outputs[0], P4=outputs[1], P5=outputs[2]),
        n_ops=len(b.ops),
        total_macs=sum(o["macs"] for o in b.ops),
    )

    print("")
    print("tensors : %d   ops : %d   arena : %.3f MB"
          % (len(b.tensors), len(b.ops), plan["arena_bytes"] / 1048576.0))
    print("MACs/frame = %.4f G  (%.1f%% in conv ops)"
          % (plan["total_macs"] / 1e9,
             100.0 * plan["total_macs"] / max(1, plan["total_macs"])))

    # ------------------------------------------------------- fp32 self-check
    if not args.no_check:
        x = make_test_input(args)
        import torch
        with torch.no_grad():
            pt_out = net(torch.from_numpy(x)[None])
        raw = pt_out[1]                      # list of 3 tensors, channels 67
        sim = RefSim(plan, b.weights, mode="fp32")
        got = sim.run(x)
        print("")
        print("---- fp32 flattening self-check (vs PyTorch forward) ----")
        ok = True
        for name, tid in plan["outputs"].items():
            ref = raw[list(plan["outputs"].keys()).index(name)][0].numpy()
            mine = got[name]
            # our tensor is channel-padded; compare only the real 67 channels
            mine = mine[:ref.shape[0]]
            d = np.abs(ref - mine)
            rel = d.max() / max(1e-9, np.abs(ref).max())
            print("  %s  shape=%s  max|d|=%.3e  rel=%.3e" % (name, ref.shape, d.max(), rel))
            if rel > 1e-4:
                ok = False
        print("  RESULT:", "PASS" if ok else "FAIL")
        if not ok:
            raise SystemExit("flattening mismatch - fix common.py before continuing")

    # ---------------------------------------------------------------- save
    os.makedirs(os.path.dirname(args.out), exist_ok=True)
    with open(args.out, "w", encoding="utf-8") as f:
        json.dump(plan, f, indent=1)
    print("")
    print("[written] %s" % args.out)

    npz = os.path.join(os.path.dirname(args.out), "fused_weights.npz")
    np.savez_compressed(npz, **b.weights)
    print("[written] %s  (%d blobs)" % (npz, len(b.weights)))

    # per-op MAC summary
    tot = plan["total_macs"]
    print("")
    print("---- top-15 MAC consumers ----")
    for o in sorted(plan["ops"], key=lambda o: -o["macs"])[:15]:
        print("  op%3d %-24s %10.3f M  %5.1f%%" % (o["id"], o["name"], o["macs"] / 1e6,
                                                   100.0 * o["macs"] / tot))


def make_test_input(args):
    """a real val image if we can find one, else deterministic noise"""
    if args.img and os.path.exists(args.img):
        from PIL import Image
        im = Image.open(args.img).convert("RGB")
        im = im.resize((512, 384), Image.BILINEAR)
        return (np.asarray(im, np.float32) / 255.0).transpose(2, 0, 1).copy()
    cand = os.path.join(args.repo, "..", "dataset", "RDD_China", "val", "images")
    if os.path.isdir(cand):
        for fn in sorted(os.listdir(cand)):
            if fn.lower().endswith((".jpg", ".png", ".jpeg")):
                from PIL import Image
                im = Image.open(os.path.join(cand, fn)).convert("RGB")
                if im.size != (512, 384):
                    im = im.resize((512, 384), Image.BILINEAR)
                print("[check] using val image %s" % fn)
                return (np.asarray(im, np.float32) / 255.0).transpose(2, 0, 1).copy()
    rng = np.random.RandomState(0)
    print("[check] no image found - using deterministic noise")
    return rng.rand(3, 384, 512).astype(np.float32) * 0.9 + 0.05


if __name__ == "__main__":
    main()
