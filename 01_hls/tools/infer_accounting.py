#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
infer_accounting.py —— 把 R2/R3 的逐算子表算成"账"

用途
    每次上板跑完 PROFILE_OPS 之后，把串口那张 84 行的表存成文本，
    用本脚本算出：MAC 理论时间 / staging 读 / 写回 / 权重 / COPY 各占多少，
    以及每个算子的"非 MAC 周期 ÷ DDR 访问次数"。
    这样能立刻看出：慢的那个算子是"算得多"还是"访存多"。

用法
    python infer_accounting.py                         # 只打印理论账（不需要串口数据）
    python infer_accounting.py profile.txt             # 再和实测对比
                                                        # profile.txt = 串口那张表（含 op/type/... 行即可）

输入
    03_vitis/yolov5n_speed/src/yolov5n_speed_layers.h   —— 描述符表（84 条，含 tile_r/tile_c）

判据（和 修复记录.md §H3 保持一致）
    MAC 理论时间 = Σ MACs ÷ 6400 MAC/µs        （64 MAC/cycle @ 100 MHz）
    纯搬运算子（COPY/POOL）的 cycles/源字 才是 DDR 的真实"单价"

Windows 控制台中文乱码时：
    先 `chcp 65001`，或直接 `python ... > out.txt` 再看文件（文件本身是 UTF-8）
"""
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
LAYERS = os.path.normpath(os.path.join(
    HERE, "..", "..", "03_vitis", "yolov5n_speed", "src", "yolov5n_speed_layers.h"))

CO, CI, NX = 16, 4, 16          # HW_CO / HW_CI / HW_NX（改 yolov5n_hls.h 就要同步改这里）
FREQ_MHZ = 100                  # clk_fpga_0
MAC_PER_US = CO * CI * FREQ_MHZ  # 6400

FIELDS = ("src dst wgt rq add addch res0 ih iw oh ow ic oc ocreal "
          "srcch dstch tile_r tile_c k s pad act up typ").split()


def parse_layers(path):
    txt = open(path, encoding="utf-8", errors="replace").read()
    out = []
    for m in re.finditer(r"/\*\s*(\d+)\s+(\S+)\s*\*/\s*\{([^}]*)\}", txt):
        vals = [int(x) for x in [y.strip() for y in m.group(3).split(",")][:28]]
        out.append((int(m.group(1)), m.group(2), dict(zip(FIELDS, vals))))
    return out


def ceil_div(a, b):
    return -(-a // b)


def account(op):
    """算出一条算子的理论工作量。返回 dict。"""
    d = op
    typ = d["typ"]
    a = dict(mac=0, stage=0, wb=0, res=0, wgt=0, blocks=0, src_words=0)
    if typ == 0:
        icb, ocb = d["ic"] // CI, d["oc"] // CO
        k, s = d["k"], d["s"]
        ntr, ntc = ceil_div(d["oh"], d["tile_r"]), ceil_div(d["ow"], d["tile_c"])
        a["mac"] = d["oh"] * d["ow"] * d["ic"] * d["oc"] * k * k
        for ob in range(ocb):
            base = ob * CO
            nwoc = 0 if d["ocreal"] <= base else min(ceil_div(d["ocreal"] - base, 4), CO // 4)
            a["wgt"] += icb * k * k * CO * CI // 4      # 代码里就是这个式子，单位=uint32 字
            for ti in range(ntr * ntc):
                nr = min(d["tile_r"], d["oh"] - (ti // ntc) * d["tile_r"])
                nc = min(d["tile_c"], d["ow"] - (ti % ntc) * d["tile_c"])
                rows = (nr - 1) * s + k
                cols = (nc - 1) * s + k
                a["stage"] += icb * rows * cols
                for _y in range(nr):
                    for x0 in range(0, nc, NX):
                        nxx = min(NX, nc - x0)
                        a["blocks"] += 1
                        a["wb"] += nxx * nwoc
                        if d["add"] >= 0:
                            a["res"] += nxx * nwoc
    elif typ == 2:
        nw = ceil_div(d["ic"], 4)
        a["src_words"] = nw * d["ih"] * d["iw"]
        a["stage"] = a["src_words"]                       # 源字（COPY 的循环迭代数）
        a["wb"] = a["src_words"] * (4 if d["up"] == 2 else 1)
    else:  # LT_MAXPOOL
        nw = ceil_div(d["ic"], 4)
        a["stage"] = nw * d["ih"] * d["iw"]
        a["wb"] = nw * d["oh"] * d["ow"]
    a["ddr"] = a["stage"] + a["wb"] + a["res"] + a["wgt"]
    return a


def parse_profile(path):
    """从串口日志里抓 ' op type out ic> oc k MACs real ideal r%' 这些行。"""
    obs = {}
    for line in open(path, encoding="utf-8", errors="replace"):
        m = re.match(r"\s*(\d+)\s+(\d)\s+(\d+)x\s*(\d+)\s+(\d+)>\s*(\d+)\s+(\d+)\s+"
                     r"([\d.]+)\s+(\d+)\s+(\d+)\s+(\d+)\s*$", line)
        if m:
            obs[int(m.group(1))] = int(m.group(9))
    return obs


def main():
    ops = parse_layers(LAYERS)
    obs = parse_profile(sys.argv[1]) if len(sys.argv) > 1 else {}
    print(f"# 描述符表 {LAYERS}")
    print(f"# 解析到 {len(ops)} 条算子；CO={CO} CI={CI} NX={NX}；"
          f"MAC 峰值 {MAC_PER_US} MAC/us @ {FREQ_MHZ} MHz\n")

    hdr = (f"{'op':>3} {'name':<16} {'ty':<4} {'MAC(M)':>8} {'MAC_us':>7} "
           f"{'stage':>8} {'wb':>7} {'wgt':>6} {'blk':>5} {'obs_us':>7} {'非MAC/词':>8}")
    print(hdr)
    print("-" * len(hdr))
    tot = dict(mac=0.0, stage=0, wb=0, res=0, wgt=0, ddr=0)
    # 按算子类型分开累计（COPY/POOL 是"纯搬运"，单价要和 conv 分开看）
    split = {0: dict(stage=0, wb=0), 1: dict(stage=0, wb=0), 2: dict(stage=0, wb=0)}
    per_op = []
    for idx, name, d in ops:
        a = account(d)
        for key in tot:
            tot[key] += a[key]
        split[d["typ"]]["stage"] += a["stage"]
        split[d["typ"]]["wb"] += a["wb"]
        mu = a["mac"] / MAC_PER_US
        row = (f"{idx:>3} {name:<16} {d['typ']:<4} {a['mac']/1e6:>8.2f} {mu:>7.1f} "
               f"{a['stage']:>8} {a['wb']:>7} {a['wgt']:>6} {a['blocks']:>5}")
        if obs and idx in obs:
            o = obs[idx]
            nonmac = o * FREQ_MHZ - a["mac"] / (MAC_PER_US / FREQ_MHZ)
            row += f" {o:>7} {nonmac/a['ddr'] if a['ddr'] else 0:>8.1f}"
            per_op.append((idx, name, o, mu, a))
        else:
            row += f" {'-':>7} {'-':>8}"
        print(row)

    print("-" * len(hdr))
    print(f"\n== 全网理论账 ==")
    print(f"  MAC 总量          {tot['mac']/1e6:>12.1f} M")
    print(f"  MAC 理论时间      {tot['mac']/MAC_PER_US/1000:>12.1f} ms   "
          f"({MAC_PER_US} MAC/us)")
    print(f"  读  conv staging  {split[0]['stage']:>12,} words = {split[0]['stage']*4/1e6:.2f} MB")
    print(f"  读  COPY 源       {split[2]['stage']:>12,} words = {split[2]['stage']*4/1e6:.2f} MB")
    print(f"  读  POOL 源       {split[1]['stage']:>12,} words = {split[1]['stage']*4/1e6:.2f} MB")
    print(f"  读  残差          {tot['res']:>12,} words = {tot['res']*4/1e6:.2f} MB")
    print(f"  读  权重          {tot['wgt']:>12,} words = {tot['wgt']*4/1e6:.2f} MB")
    print(f"  写  conv 写回     {split[0]['wb']:>12,} words = {split[0]['wb']*4/1e6:.2f} MB")
    print(f"  写  COPY/POOL     {split[1]['wb']+split[2]['wb']:>12,} words "
          f"= {(split[1]['wb']+split[2]['wb'])*4/1e6:.2f} MB")
    print(f"  ---- DDR 合计     {tot['ddr']:>12,} words = {tot['ddr']*4/1e6:.2f} MB")
    print(f"  DDR 理论下限      {tot['ddr']/FREQ_MHZ/1000:>12.1f} ms   "
          f"(1 字/周期 = {4*FREQ_MHZ} MB/s)")
    print(f"  ---- 结构下限     "
          f"{(tot['mac']/MAC_PER_US + tot['ddr']/FREQ_MHZ)/1000:>12.1f} ms   "
          f"(MAC + DDR 串行相加，不改算法的天花板)")
    print(f"  纯搬运算子(COPY+POOL) 读+写 = "
          f"{split[1]['stage']+split[2]['stage']+split[1]['wb']+split[2]['wb']:,} words")

    if per_op:
        print(f"\n== 实测 vs 理论 ==")
        so = sum(x[2] for x in per_op)
        sm = sum(x[4]['mac'] / MAC_PER_US for x in per_op)
        ddr = sum(x[4]['ddr'] for x in per_op)
        print(f"  实测合计 {so:>10,} us  = {so*FREQ_MHZ/1e6:.2f} M 周期")
        print(f"  MAC 理论 {sm:>10.1f} us   -> 实测是 MAC 理论的 {so/sm:.2f} 倍")
        print(f"  MAC 占比 {sm/so*100:.1f}%   -> 其余 {(so-sm)/1000:.0f} ms 是访存+循环开销")
        print(f"  DDR 访问 {ddr/1e6:.2f} M 次 / {so*FREQ_MHZ/1e6:.2f} M 周期 "
              f"= {so*FREQ_MHZ/ddr:.2f} 周期/次   (跑满应为 1.0)")
        print(f"  DDR 实测吞吐 {ddr*4/1e6/(so/1e6):.1f} MB/s  "
              f"(32bit@100MHz 上限 400 MB/s)")


if __name__ == "__main__":
    main()
