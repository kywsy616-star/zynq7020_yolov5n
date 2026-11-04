# -*- coding: utf-8 -*-
"""
================================================================================
 calibrate.py —— 第 2 步：用真图统计每层激活的分布，给量化器定"裁剪门限"
================================================================================

【它在流水线里的位置】

    make_layer_plan.py   →   build_speed/layer_plan.json + fused_weights.npz
    calibrate.py         ←   你在这里
            ↓  build_speed/calib.json
    quantize.py          →   weights.bin / rqt.bin / layers.bin

【为什么要标定】

    int8 只有 256 个格子。把一个浮点张量压到 int8，就是要选一个
    "代表范围" c（对称量化：real = q * c/127）。c 选大了 → 步长粗、精度差；
    c 选小了 → 大值被饱和截断、信息丢失。

    所以必须先看看这个张量真实跑起来到底有多大。这里跑的是 **fp32**
    的 numpy 参考模拟器（refsim），不是 PyTorch —— 因为只有 refsim
    才能逐层、按 PL 的算子顺序拿到每一个中间张量。

【两趟扫描】

    第 1 趟：只记录每个张量 |value| 的历史最大值 max
    第 2 趟：以 max 为上限划 8192 个 bin 做直方图

    拿到直方图之后，quantize.py 才能算出：
      * p99.9 / p99.99 分位数      （比 max 抗单帧离群值）
      * MSE 最优裁剪点              （默认用的就是它，见 quantize.py 的 mse_optimal_clip）
    直方图最后降采样成 512 bin 存进 calib.json（8192 bin 太大）。

【为什么用验证集而不是训练集】

    训练集里有模型"背下来"的样本，激活分布偏乐观；
    验证集才能反映上板时真实看到的分布。默认用 RDD_China/val/images。

【用法】

    cd /d "D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\scripts\VITIS_export"
    python calibrate.py                 # 默认 128 张验证图（实测约 70 秒）
    python calibrate.py --n 64          # 想快一点就把张数减半

【产物】

    build_speed/calib.json
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

from common import load_model, build_plan          # noqa: E402
from refsim import RefSim                          # noqa: E402

# 产物目录：必须和 make_layer_plan.py 的 BUILD 一致，否则会读错 plan / 权重
BUILD = os.path.normpath(os.path.join(HERE, "build_speed"))
NBINS = 8192


def list_images(root, n):
    files = []
    for dirpath, _, names in os.walk(root):
        for fn in sorted(names):
            if fn.lower().endswith((".jpg", ".jpeg", ".png", ".bmp")):
                files.append(os.path.join(dirpath, fn))
    files.sort()
    if n and len(files) > n:
        step = len(files) / float(n)
        files = [files[int(i * step)] for i in range(n)]
    return files


def load_img(path, h=384, w=512):
    from PIL import Image
    im = Image.open(path).convert("RGB")
    if im.size != (w, h):
        im = im.resize((w, h), Image.BILINEAR)
    return (np.asarray(im, np.float32) / 255.0).transpose(2, 0, 1).copy()


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--weights", default=r"D:/02_workspace/05_ascend_projects/yolo_pavement/"
                                         r"yolov5/runs/detect/train_crack_4_35/weights/best.pt")
    ap.add_argument("--repo", default=r"D:/02_workspace/05_ascend_projects/yolo_pavement/yolov5")
    ap.add_argument("--images", default=r"D:/02_workspace/05_ascend_projects/yolo_pavement/"
                                        r"dataset/RDD_China/val/images")
    ap.add_argument("--n", type=int, default=128)
    ap.add_argument("--plan", default=os.path.join(BUILD, "layer_plan.json"))
    ap.add_argument("--out", default=os.path.join(BUILD, "calib.json"))
    args = ap.parse_args()

    with open(args.plan, encoding="utf-8") as f:
        plan = json.load(f)
    net = load_model(args.weights, args.repo)
    # rebuild the fused weights exactly as make_layer_plan did
    from make_layer_plan import BUILD as _b                            # noqa: F401
    fused = np.load(os.path.join(BUILD, "fused_weights.npz"))

    files = list_images(args.images, args.n)
    print("calibration images: %d" % len(files))
    if not files:
        raise SystemExit("no calibration images under %s" % args.images)

    ntensor = len(plan["tensors"])
    tmax = np.zeros(ntensor, np.float64)

    # ---------------------------------------------------------------- pass 1
    sim = RefSim(plan, fused, mode="fp32")
    for k, fp in enumerate(files):
        sim.run(load_img(fp))
        for t in plan["tensors"]:
            a = sim.act[t["id"]]
            if a is None or a.size == 0:
                continue
            m = float(np.abs(a[:t["c"]]).max()) if t["c"] > 0 else 0.0
            if m > tmax[t["id"]]:
                tmax[t["id"]] = m
        if (k + 1) % 16 == 0:
            print("  pass1 %3d/%d" % (k + 1, len(files)))

    # ---------------------------------------------------------------- pass 2
    edges = {}
    hist = {}
    for t in plan["tensors"]:
        hi = tmax[t["id"]]
        if hi <= 0:
            continue
        edges[t["id"]] = np.linspace(0.0, hi, NBINS + 1)
        hist[t["id"]] = np.zeros(NBINS, np.int64)

    sim = RefSim(plan, fused, mode="fp32")
    for k, fp in enumerate(files):
        sim.run(load_img(fp))
        for t in plan["tensors"]:
            if t["id"] not in hist:
                continue
            a = np.abs(sim.act[t["id"]][:t["c"]]).ravel()
            h, _ = np.histogram(a, bins=edges[t["id"]])
            hist[t["id"]] += h
        if (k + 1) % 16 == 0:
            print("  pass2 %3d/%d" % (k + 1, len(files)))

    # ------------------------------------------------------------- percentiles
    # the 512-bin histogram is kept so the quantiser can pick an *MSE-optimal*
    # clipping level instead of a percentile (percentiles starve the range;
    # the raw max lets one outlier coarsen every step)
    NH = 512
    out = dict(tensors={}, ops={}, n_images=len(files))
    for t in plan["tensors"]:
        tid = str(t["id"])
        hi = float(tmax[t["id"]])
        if hi <= 0:
            out["tensors"][tid] = dict(max=0.0, p999=0.0, p9999=0.0,
                                       hist=[0] * NH, hist_max=0.0)
            continue
        c = np.cumsum(hist[t["id"]]).astype(np.float64)
        tot = c[-1] if c[-1] > 0 else 1.0
        e = edges[t["id"]]
        p999 = float(e[int(np.searchsorted(c, 0.999 * tot))])
        p9999 = float(e[int(np.searchsorted(c, 0.9999 * tot))])
        out["tensors"][tid] = dict(max=hi, p999=p999, p9999=p9999,
                                   hist=None, hist_max=hi)
    # (the full histograms are large; recompute the 512-bin ones cheaply from
    #  the existing 8192-bin histograms by summing groups)
    for t in plan["tensors"]:
        tid = str(t["id"])
        st = out["tensors"][tid]
        if st["max"] <= 0:
            continue
        h8 = hist[t["id"]]
        g = NBINS // NH
        st["hist"] = h8.reshape(NH, g).sum(1).tolist()

    # per-op natural output scale (max over the op's real output rows)
    for op in plan["ops"]:
        if op["type"] != "conv":
            continue
        t = plan["tensors"][op["dst"]]
        st = out["tensors"][str(t["id"])]
        out["ops"][str(op["id"])] = dict(tensor=t["id"],
                                         max_out=st["max"], p999=st["p999"])

    os.makedirs(os.path.dirname(args.out), exist_ok=True)
    with open(args.out, "w", encoding="utf-8") as f:
        json.dump(out, f, indent=1)
    print("[written] %s" % args.out)

    print("")
    print("---- tensor |activ| statistics (non-trivial ones) ----")
    print("%-4s %-26s %10s %10s %10s" % ("id", "name", "max", "p99.9", "p99.99"))
    for t in plan["tensors"]:
        st = out["tensors"][str(t["id"])]
        if st["max"] <= 0:
            continue
        tag = ""
        if t.get("is_input"):
            tag = " (INPUT)"
        print("%-4d %-26s %10.4f %10.4f %10.4f%s"
              % (t["id"], t["name"][:26], st["max"], st["p999"], st["p9999"], tag))


if __name__ == "__main__":
    main()
