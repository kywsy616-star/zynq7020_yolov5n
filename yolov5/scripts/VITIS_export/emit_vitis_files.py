# -*- coding: utf-8 -*-
"""
================================================================================
 emit_vitis_files.py —— 最后一步：把量化产物改名，拷进 Vitis 工程的 src/
================================================================================

【这一步的产物给谁用】

    给 Vitis **PS 端应用**（`03_vitis/yolov5n_speed/src/`）。
    HLS 工程不参与，也不需要这些文件。

【为什么要单独有这么一步】

    quantize.py 生成的文件名是"通用名"（weights_blob.c / rqt_blob.c /
    yolov5n_desc.h / yolov5n_layers.h），而 Vitis 工程里用的是带 _speed_
    前缀的工程内命名。两边靠一个手工改名步骤衔接，很容易出现
    "文件名和内容对不上"—— 而这恰恰是 PL 最怕的：

        PL 是按描述符表逐条**盲执行**的。表里说骨干 P3 分支 32 通道、
        权重也按那个形状打包，它就照算；要是 layers / weights / rqt 里
        任意两份不是同一次导出（或者字段错一位），它不会报错，
        只是安静地算出一堆垃圾特征 —— PS 端再拿去做 DFL decode + NMS，
        就吐出一堆假框（虚检）、框位置乱跳。

    本脚本就是保证"名字和内容对得上"的那道闸门：它从 build_speed/gen/ 里
    读，按 Vitis 工程的命名规则写，并且打印内容指纹（长度 + CRC32），
    方便上板出问题时回查"板子上跑的到底是哪一版"。

【产物（写到 Vitis 工程 src/）】

    weights_speed_blob.c    ← gen/weights_blob.c      （符号 yolov5n_weights）
    rqt_speed_blob.c        ← gen/rqt_blob.c          （符号 yolov5n_rqt）
    yolov5n_speed_desc.h    ← gen/yolov5n_desc.h      （宏名前缀改成 SPEED）
    yolov5n_speed_layers.h  ← gen/yolov5n_layers.h    （宏名前缀 + include 改名）

    注意：只有这 4 个文件会被覆盖（覆盖前自动留 .bak），其它 Vitis 源码
    （main.c / yolov5n_speed_app.c/.h / display_ctrl / vdma_api / ov5640 /
    sccb / dynclk）一个字都不动 —— 它们本来就是通用的，参数全部来自
    yolov5n_speed_desc.h。

【用法】

    cd /d "D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\scripts\VITIS_export"
    python emit_vitis_files.py                    # 默认写到 speed 工程
    python emit_vitis_files.py --vitis-src <其它目录>   # 换目标
    python emit_vitis_files.py --dry-run          # 只看差异，不写
================================================================================
"""

import argparse
import os
import re
import shutil
import sys
import zlib

# Windows 控制台默认是 GBK(cp936)，本脚本的提示是中文，
# 不强制成 UTF-8 会打出乱码（虽然不影响写出来的文件内容）。
try:
    sys.stdout.reconfigure(encoding="utf-8")
except Exception:
    pass

HERE = os.path.dirname(os.path.abspath(__file__))
BUILD = os.path.join(HERE, "build_speed")
GEN = os.path.join(BUILD, "gen")

# Vitis 应用的 src/ 目录（speed 工程）
DEFAULT_VITIS_SRC = (r"D:/02_workspace/02_vitis_projects/yolov5n_speed_prj"
                     r"/03_vitis/yolov5n_speed/src")


def fingerprint(path):
    """给一个文件打指纹：长度 + CRC32。上板出问题时用来核对烧进去的到底是哪一版。"""
    with open(path, "rb") as f:
        data = f.read()
    return len(data), zlib.crc32(data) & 0xFFFFFFFF


def convert_desc_h(text):
    """gen/yolov5n_desc.h -> yolov5n_speed_desc.h

    只改 include guard：
        YOLOV5N_DESC_H  ->  YOLOV5N_SPEED_DESC_H
    其余内容（结构体、宏、数值）原样带过去。
    """
    return text.replace("YOLOV5N_DESC_H", "YOLOV5N_SPEED_DESC_H")


def convert_layers_h(text):
    """gen/yolov5n_layers.h -> yolov5n_speed_layers.h

    只改两个名字：
        include guard  YOLOV5N_LAYERS_H  ->  YOLOV5N_SPEED_LAYERS_H
        #include "yolov5n_desc.h"       ->  #include "yolov5n_speed_desc.h"
    层表本体（那 84 行数字）一个字节都不动。
    """
    text = text.replace("YOLOV5N_LAYERS_H", "YOLOV5N_SPEED_LAYERS_H")
    return re.sub(r'#include\s+"yolov5n_desc\.h"',
                  '#include "yolov5n_speed_desc.h"', text)


def convert_blob_c(text):
    """weights_blob.c / rqt_blob.c -> weights_speed_blob.c / rqt_speed_blob.c

    内容**一个字都不改**，原样拷过去。
    数组符号名 `yolov5n_weights` / `yolov5n_rqt` 保持不变 ——
    main.c 里 `extern const uint8_t yolov5n_weights[];` 就是按这名字声明的，
    换名字就得同时改 main.c，没必要。
    """
    return text


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--vitis-src", default=DEFAULT_VITIS_SRC,
                    help="Vitis 应用的 src/ 目录")
    ap.add_argument("--dry-run", action="store_true")
    args = ap.parse_args()

    src_dir = os.path.normpath(args.vitis_src)
    if not os.path.isdir(src_dir):
        raise SystemExit("Vitis src 目录不存在: %s" % src_dir)

    # 输入文件必须齐全，缺一个就说明前面的步骤没跑完
    need = ["weights_blob.c", "rqt_blob.c", "yolov5n_desc.h", "yolov5n_layers.h"]
    for n in need:
        p = os.path.join(GEN, n)
        if not os.path.exists(p):
            raise SystemExit("缺少 %s —— 先跑 python quantize.py" % p)

    # 二进制 blob 的指纹（这两个是"内容对不对"最直接的证据）
    wbin = os.path.join(BUILD, "weights.bin")
    rbin = os.path.join(BUILD, "rqt.bin")
    lbin = os.path.join(BUILD, "layers.bin")
    wlen, wcrc = fingerprint(wbin)
    rlen, rcrc = fingerprint(rbin)
    llen, lcrc = fingerprint(lbin)

    print("=" * 78)
    print(" speed 档 量化产物指纹（请和上板日志里的 arena/weights 长度核对）")
    print("=" * 78)
    print("  weights.bin  %8d B   crc32=0x%08x" % (wlen, wcrc))
    print("  rqt.bin      %8d B   crc32=0x%08x" % (rlen, rcrc))
    print("  layers.bin   %8d B   crc32=0x%08x  (%d ops x 64 B)"
          % (llen, lcrc, llen // 64))
    print("")

    jobs = [
        (os.path.join(GEN, "weights_blob.c"),
         os.path.join(src_dir, "weights_speed_blob.c"), convert_blob_c),
        (os.path.join(GEN, "rqt_blob.c"),
         os.path.join(src_dir, "rqt_speed_blob.c"), convert_blob_c),
        (os.path.join(GEN, "yolov5n_desc.h"),
         os.path.join(src_dir, "yolov5n_speed_desc.h"), convert_desc_h),
        (os.path.join(GEN, "yolov5n_layers.h"),
         os.path.join(src_dir, "yolov5n_speed_layers.h"), convert_layers_h),
    ]

    for src, dst, conv in jobs:
        with open(src, "r", encoding="ascii") as f:
            text = f.read()
        text = conv(text)

        old = None
        if os.path.exists(dst):
            with open(dst, "r", encoding="ascii", errors="replace") as f:
                old = f.read()
        same = (old == text)
        tag = "不变" if same else ("新增" if old is None else "已更新")

        print("  %-24s <- %-18s  %s  (%.1f KB)"
              % (os.path.basename(dst), os.path.basename(src), tag, len(text) / 1024.0))

        if args.dry_run or same:
            continue
        # 覆盖前留个 .bak，出问题能一键回滚
        if old is not None:
            shutil.copy(dst, dst + ".bak")
        with open(dst, "w", encoding="ascii", newline="\n") as f:
            f.write(text)

    if args.dry_run:
        print("\n[dry-run] 没有写任何文件")

    # ------------------------------------------------------------ 一致性自检
    # 层表里的 op 数、输出张量偏移必须和 desc 头文件对得上，否则 PS 会读错地方
    with open(os.path.join(GEN, "yolov5n_desc.h"), encoding="ascii") as f:
        desc = f.read()

    def macro(name):
        m = re.search(r"#define\s+%s\s+([0-9]+)" % name, desc)
        return int(m.group(1)) if m else None

    n_ops = macro("YOLO_N_OPS")
    arena = macro("YOLO_ARENA_BYTES")
    print("")
    print("---- 自检 ----")
    print("  YOLO_N_OPS      = %s  （layers.bin 里 %d 条）" % (n_ops, llen // 64))
    assert n_ops == llen // 64, "op 数和 layers.bin 对不上"
    print("  YOLO_ARENA_BYTES= %s" % arena)
    # 三个检测头的张量末端必须落在 arena 里面。通道是 c4 打包的，
    # 所以 67 通道实际占 round_up(67,4)=68 个通道的位置。
    for nm in ("P3", "P4", "P5"):
        off = macro("YOLO_OUT_%s_OFF" % nm)
        ch = macro("YOLO_OUT_%s_CH" % nm)
        h = macro("YOLO_OUT_%s_H" % nm)
        w = macro("YOLO_OUT_%s_W" % nm)
        chp = (ch + 3) // 4 * 4                  # c4 补齐
        end = off + (chp // 4) * h * w * 4
        ok = end <= arena
        print("  %s %2dch %2dx%-3d @%8d  末端 %8d <= arena %8d   %s"
              % (nm, ch, h, w, off, end, arena, "OK" if ok else "!! 越界"))
        assert ok, "%s 张量越出 arena" % nm
    print("  自检通过。")

    # ---- 最后一道：把刚写进工程的 C 源码文本解回来，和 layers.bin 逐字节比。
    #      verify_blobs.py 验的是 bin；这一步验的是"写进工程的 .h 是不是同一张表"。
    if not args.dry_run:
        import struct
        h = open(os.path.join(src_dir, "yolov5n_speed_layers.h"),
                 encoding="ascii").read()
        body = h.split("= {", 1)[1].rsplit("};", 1)[0]
        rows = re.findall(r"\{\s*([^}]*)\}", body)
        DESC_FMT = "<6i i 7h 4h 8B h i"
        lb = open(os.path.join(BUILD, "layers.bin"), "rb").read()
        bad = 0
        for i, r in enumerate(rows):
            v = [int(x) for x in r.split(",")]
            repack = struct.pack(DESC_FMT, *v[:24], 0, 0, 0, 0)
            if repack != lb[i * 64:(i + 1) * 64]:
                bad += 1
        print("  C 层表 %d 条 vs layers.bin：%s"
              % (len(rows), "一致" if bad == 0 else "!! %d 条不一致" % bad))
        assert bad == 0

    print("")
    print("  下一步：在 Vitis 里 Rebuild 应用工程（src 下的 4 个生成文件已就位）。")


if __name__ == "__main__":
    main()
