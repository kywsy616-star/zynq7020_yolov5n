# Ultralytics YOLO 🚀, AGPL-3.0 license
"""
结构化剪枝权重迁移脚本（teacher 通道选择 + 权重切片）

===== 为什么需要这个脚本 =====
把官方 yolov5n 训好的权重搬到「PL 部署版」剪枝结构上时，如果用 ultralytics 自带的
model.load(best.pt)，它的匹配规则只有「层名相同 + 张量形状完全相同」：
  · 只要某层的通道数或卷积核被改过（如 64→48、6×6→3×3），整层就**不匹配 → 保持随机初始化**
  · 本工程实测: 144/403 个条目“匹配”，但按**参数量**算只继承 17.7%(balance) / 11.0%(accuracy)，
    其余 82~89% 的权重是随机的 → 等价于从零训练 → 150 轮只到 mAP50 0.61~0.64
本脚本改用「结构化剪枝」的标准做法：**先按重要性挑出要保留的通道（原始索引），再按索引把 teacher
的权重切片**，把 teacher 的知识真正搬进窄模型（目标继承率 ~90%+）。

===== 核心概念 =====
  · 通道索引（sel）: 某层保留的 teacher 通道的**原始编号列表**（如 [12, 5, 77, ...]）
  · 挑通道        : 按 teacher 该层 BN 的 γ（缩放系数）绝对值从大到小取前 N 个（N = 目标结构该层通道数）
                    γ 小 = 该通道输出被 BN 压得很弱 = 贡献小 → 优先砍掉（Network Slimming 判据）
  · 切片权重      : W_new = W[sel_out][:, sel_in]，把 teacher 的 (C_out,C_in,kh,kw) 抠成目标形状

===== 通道联动的规则（脚本已实现，缺一条就会索引错位） =====
  1) 串接层（Conv/C3/SPPF）: 本层输入选择 = 上一层输出选择
  2) Upsample : 恒等，选择原样传递
  3) Concat   : 各路选择按 yaml 的 f 顺序拼接（f=[-1, 6] → cat(上一层选择, 第 6 层选择)）
  4) C3 内部  : cv1(1×1) 输出被切成两半 → 前半为旁路、后半进 Bottleneck；
                cv3 输入 = cat(旁路, 各 Bottleneck 输出)，顺序与 forward 一致
     Bottleneck: shortcut=True 时与恒等支路相加 → 其**输出选择必须等于输入选择**；
                 若 teacher 的 Bottleneck 个数多于目标结构，按各 Bottleneck 的平均 |γ| 挑保留哪几个
  5) SPPF     : cv2 输入 = cv1 输出的 4 份拼接（同一组选择重复 4 次）
  6) Detect   : cv2/cv3 的输入 = 对应尺度颈部输出的选择；末尾 1×1 卷积按通道维切片（类别数不变）

===== 无法切片的情况 =====
  stem 由 6×6 改成 3×3（PL 白名单只有 3×3）: 卷积核形状变了无法切片 →
  默认取 6×6 核的**中心 3×3** 近似（STEM_CENTER_CROP=True，仍比随机初始化好），报告里会标注

===== 使用方法 =====
  1. 修改下方「配置区」的 TEACHER（教师权重）与 PROFILE（目标档位）
  2. 在工程根目录运行: python scripts/prune_transfer.py
  3. 产物: weights\\v5n_to_<PROFILE>.pt（结构 = 目标 yaml，权重 = 切片迁移结果）
     控制台会打印: 逐层报告 / 继承参数量占比 / 前向自检结果
  4. 把 train_crack_4_3.py 的 WEIGHTS 指向该文件即可微调（建议同时 DISTILL=True）

===== 注意 =====
  · teacher 需是**未融合**（含 BN）的权重，脚本要读 BN 的 γ 做重要性判据；
    若检测不到 BN（已 fuse），会自动退化为「按卷积核 L1 范数挑通道 + 学生 BN 置为单位变换」并告警
  · teacher 与目标结构**拓扑必须一致**（层数/类型/连接相同），只有通道数或 kernel 不同 —— 本工程三档
    yaml 均由官方 v5 yaml 派生，满足该前提；脚本运行时会逐层校验，不匹配直接报错
  · 类别数 nc 必须一致（都来自 RDD_China 的 3 类）
"""

import datetime
import os
import sys

import cv2
import numpy as np
import torch
from torch import nn

from ultralytics import YOLO
from ultralytics.nn.modules import C3, SPPF, Bottleneck, Concat, Conv, Detect
from ultralytics.utils import LOGGER

# ============================================================
# 配置区（按需修改）
# ============================================================
# [2026-10-08 17:24:32] 新增: 补充「教师权重」与「训练脚本 WEIGHTS / DISTILL」的关系说明（避免用错）
#   Q1: 不开蒸馏模式（DISTILL = False）也可以吗？
#       → 可以，而且推荐先这样跑。本脚本只是**离线**用教师做一次「按通道挑 + 切权重」，产出一个新的权重文件；
#         train_crack_4_3.py 里的 DISTILL 是**训练过程中**每个 batch 额外的软标签监督，两者互不依赖：
#         只跑本脚本 + 训练时 DISTILL=False，就已经把 100% 参数换成了教师的子网络（远好于随机/load() 起点）；
#         蒸馏属于「锦上添花」（预期再 +0.5~1.5 点 mAP50），精度不够时再开也不迟。
#   Q2: train_crack_4_3.py 里的 WEIGHTS 那一行怎么改？
#       → 直接把 WEIGHTS 换成**本脚本产出的 .pt**（形如 ...\v5n_to_balance.pt）即可，其它参数不用动；
#         因为产物结构 = 目标档位 yaml，加载时会打印 Transferred 403/403 items（100%），不再有随机层。
#         例: WEIGHTS = r"D:\...\runs\detect\train_4_3\weights\v5n_to_balance.pt"
#         ⚠️ 档位必须一致: balance 产物 ↔ train_crack_4_3.py 的 PROFILE="balance"；
#            若 WEIGHTS 用 accuracy 产物而 PROFILE 设为 balance，会因通道数不同而大量不匹配。
#   教师要求: 与数据集同类数(nc=3)、官方 yolov5 系结构、**未融合（含 BN —— 脚本要读 γ 挑通道）**；
#            本工程 runs\detect\train_4_3\weights\best.pt 满足（v5n + RDD_China 3 类 + 含 BN + fp16）。
#            若想要 accuracy 档也 100% 迁移，需换官方 v5s 的 best.pt（各层通道是 v5n 的 2 倍，accuracy 才落在其窄子集内）。
TEACHER = r"D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\runs\detect\train_4_3\weights\best.pt"  # 教师权重（本脚本的输入，不上板、不参与训练）
PROFILE = "speed"                      # 目标档位: "speed" | "balance" | "accuracy"（与 train_crack_4_3.py 的档位表一致）
STEM_CENTER_CROP = True                   # stem 6×6 → 3×3 时取中心 3×3 近似（False = 保持随机初始化）
# [2026-10-08 17:24:32] 新增: SAVE_DIR / OUT_NAME —— 产物目录与文件名均可自定义
#   说明: 产物完整路径 = SAVE_DIR \ OUT_NAME；OUT_NAME 留空时自动命名为 v5n_to_<档位>.pt
SAVE_DIR = r"D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\runs\detect\train_4_3\weights"   # 产物保存目录（也可改成工程 weights 目录）
OUT_NAME = "crack_speed_init"                             # 产物文件名（不含目录）: 留空 = 自动命名 v5n_to_<档位>.pt；
                                          # 自定义示例: "crack_balance_init" 或 "crack_balance_init.pt"（不带扩展名会自动补 .pt）
VERBOSE_LAYERS = True                     # 是否逐层打印处理明细
DATA_YAML = r"D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\ultralytics\cfg\datasets\RDD_China.yaml"  # 用于 BN 重校准取图
BN_RECALIB_IMAGES = 200                   # BN 统计量重校准用的图片数（0 = 跳过；建议 100~300）
BN_RECALIB_BATCH = 8                      # 重校准的批大小
BN_RECALIB_IMGSZ = (384, 512)             # 重校准使用的输入尺寸（与部署一致）

_MODEL_BY_PROFILE = {                     # 档位 → 目标结构 yaml（与 train_crack_4_3.py 保持一致）
    "speed": r"D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\ultralytics\cfg\models\v5\yolov5_crack_speed.yaml",
    "balance": r"D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\ultralytics\cfg\models\v5\yolov5n_crack.yaml",
    "accuracy": r"D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\ultralytics\cfg\models\v5\yolov5_crack_accuracy.yaml",
}

# ============================================================
# 全局统计（供报告使用）
# ============================================================
_STAT = {"moved_params": 0, "written_keys": set(), "rows": []}


# ============================================================
# 基础工具（重要性判据 / 通道选择 / 权重切片）
# ============================================================
# [2026-10-08 16:58:25] 新增: 结构化剪枝权重迁移脚本（teacher 通道选择 + 权重切片）
# 原因: model.load() 只按「名字+形状」匹配，剪枝后通道/kernel 全部改变，实测按参数量只继承 11~18%，
#       其余 82~89% 随机初始化 → 等价从零训练 → mAP50 只到 0.61~0.64
# 解决方案: 按 teacher 的 BN-γ 重要性为每层挑出目标数量的通道（得到原始索引），再按索引切片权重与 BN，
#       并沿数据流处理 concat / C3 / Bottleneck / SPPF / Detect 的通道联动，组装成目标结构的完整权重
# 说明: 本脚本只写权重、不改 ultraalytics 库文件；产出的 ckpt 结构 = 目标 yaml，可直接作为训练脚本的 WEIGHTS
def _record(key):
    """记录一个被写入（成功迁移）的 state_dict 键，供最终统计继承参数量使用"""
    _STAT["written_keys"].add(key)


def _importance(src, path):
    """取某层输出通道的重要性向量。

    参数:
        src (dict): 教师 state_dict
        path (str): 层在 state_dict 中的前缀，如 "model.5"

    返回:
        (Tensor, str): (每输出通道一个分数, 判据名称)
        · 优先用 BN 的 γ（缩放系数）绝对值 —— Network Slimming 判据：γ 小表示该通道被 BN 压得很弱
        · 若教师已被 fuse（没有 BN），退化为卷积核的 L1 范数（每输出通道一个和）
    """
    g = src.get(f"{path}.bn.weight")
    if g is not None:
        return g.float().abs(), "BN-γ"
    w = src.get(f"{path}.conv.weight")
    if w is not None:
        return w.float().abs().sum(dim=(1, 2, 3)), "conv-L1"
    raise KeyError(f"{path} 既没有 BN 也没有卷积权重，无法评估通道重要性")


def _topk(imp, n, where):
    """按重要性从大到小挑出前 n 个通道，返回**原始通道索引**（重要性序）。

    参数:
        imp (Tensor): 每输出通道的重要性分数
        n (int): 目标结构该层需要的通道数
        where (str): 层标识，用于报错信息

    返回:
        Tensor: 形状 (n,) 的 dtype=long 索引
    """
    if imp.numel() < n:
        raise ValueError(
            f"{where}: 目标结构比教师宽 —— 该层目标需要 {n} 条通道，但教师只有 {imp.numel()} 条。\n"
            f"        这表示当前档位不是教师的「窄子集」，无法按通道切片迁移。两种解决办法：\n"
            f"        ① 换更宽的教师（推荐）: 把 TEACHER 指向官方 v5s 的 best.pt（各层通道都是 v5n 的 2 倍）；\n"
            f"        ② 或把目标 yaml 中该层通道数改到 ≤ {imp.numel()}（注意同步修改下游 concat 相关层）"
        )
    return torch.argsort(imp, descending=True)[:n]


def _has_bn(src, path):
    """判断教师该层是否带 BN（fuse 后就没有了）"""
    return f"{path}.bn.weight" in src


def _center_crop(w, kh, kw):
    """把卷积核中心裁剪到 (kh, kw)：用于 stem 6×6 → 3×3 这类 kernel 变小的层（近似，比随机初始化好）"""
    h, ww = w.shape[2], w.shape[3]
    top, left = (h - kh) // 2, (ww - kw) // 2
    return w[:, :, top:top + kh, left:left + kw]


def _unit_bn(dst, path):
    """把学生该层的 BN 置为单位变换（γ=1, β=0, mean=0, var=1）：教师已 fuse 时使用（其卷积已吸收 BN）"""
    pairs = (("weight", 1.0), ("bias", 0.0), ("running_mean", 0.0), ("running_var", 1.0))
    for k, v in pairs:
        kk = f"{path}.bn.{k}"
        if kk in dst:
            dst[kk] = torch.full_like(dst[kk], float(v))


def _fill_conv(dst, src, path, in_sel, out_sel, allow_crop=False, tag=""):
    """按 in_sel / out_sel 切片填充一个 Conv 模块（Conv2d + BN），返回迁移到的参数量。

    参数:
        dst (dict): 学生 state_dict（原地修改）
        src (dict): 教师 state_dict
        path (str): 层前缀，如 "model.5" 或 "model.13.cv1"
        in_sel (Tensor): 输入通道保留索引（来自上游层的输出选择）
        out_sel (Tensor): 输出通道保留索引（本层按重要性挑出）
        allow_crop (bool): kernel 形状不同时是否允许中心裁剪（仅 stem 用）
        tag (str): 报告用说明

    说明:
        W_new = W[out_sel][:, in_sel]，切片后形状必须与目标完全一致，否则直接报错（避免静默出错）
    """
    wk = f"{path}.conv.weight"
    w = src[wk].float()
    tgt_shape = tuple(dst[wk].shape)
    if allow_crop and tuple(w.shape[2:]) != tgt_shape[2:]:
        w = _center_crop(w, tgt_shape[2], tgt_shape[3])   # 6×6 → 3×3 中心裁剪
    sub = w[out_sel][:, in_sel]
    if tuple(sub.shape) != tgt_shape:
        raise ValueError(f"{path}: 切片后形状 {tuple(sub.shape)} ≠ 目标 {tgt_shape}（tag={tag}）")
    dst[wk] = sub.clone()
    _record(wk)

    if _has_bn(src, path):                                # 教师有 BN → 按输出通道切 γ/β/mean/var
        for k in ("weight", "bias", "running_mean", "running_var"):
            kk = f"{path}.bn.{k}"
            if kk in dst:
                dst[kk] = src[f"{path}.bn.{k}"].float()[out_sel].clone()
                _record(kk)
        kk = f"{path}.bn.num_batches_tracked"             # 标量，直接复制（不计入参数量统计）
        if kk in dst and kk in src:
            dst[kk] = src[kk].clone()
    else:                                                 # 教师已 fuse → 学生 BN 置单位变换
        _unit_bn(dst, path)
    return sub.numel()


def _fill_raw_conv(dst, src, path, in_sel):
    """填充没有 BN 的裸 nn.Conv2d（Detect 末尾的 1×1）：只按输入通道切片，输出通道不变"""
    wk = f"{path}.weight"
    w = src[wk].float()[:, in_sel]
    if tuple(w.shape) != tuple(dst[wk].shape):
        raise ValueError(f"{path}: 切片后形状 {tuple(w.shape)} ≠ 目标 {tuple(dst[wk].shape)}")
    dst[wk] = w.clone()
    _record(wk)
    bk = f"{path}.bias"
    if bk in dst and bk in src:
        dst[bk] = src[bk].float().clone()
        _record(bk)
    return w.numel()


# ============================================================
# 复合模块处理（C3 / Bottleneck / SPPF）
# ============================================================
# [2026-10-08 16:58:25] 新增: C3/Bottleneck/SPPF 的通道联动与切片
# 原因: 这三个模块内部有 split / concat / Add，通道选择不能各层独立挑，必须按前向顺序联动
# 解决方案: 按 C3.forward / SPPF.forward 的张量流向组织选择:
#       C3   : cv1 输出切成两半（前半旁路、后半进 Bottleneck）→ 各 Bottleneck 输出与旁路 concat 后进 cv3
#       Bottleneck: 有 Add（shortcut=True）时其输出选择必须等于输入选择（恒等支路决定通道对应关系）
#       SPPF : cv2 的输入 = cv1 输出的 (1 + 池化级数) 份拼接（同一组选择重复）
# 说明: 学生模块对象（dst_mod）也传进来，用于读取 Bottleneck 是否带 Add（该信息不在 state_dict 里）
def _sub_indices(src, path, sub):
    """列出某模块下连续编号的子模块序号（如 C3 下的 Bottleneck: m.0, m.1, ...）"""
    idx, i = [], 0
    while f"{path}.{sub}.{i}.cv1.conv.weight" in src:
        idx.append(i)
        i += 1
    return idx


def _fill_bottleneck(dst, src, dpath, spath, in_sel, force_out_sel=None):
    """填充一个 Bottleneck：cv1(1×1) → cv2(3×3) →（可选）与恒等支路相加。

    参数:
        dpath/spath (str): 学生/教师该 Bottleneck 的 state_dict 前缀
        in_sel (Tensor): 输入通道保留索引
        force_out_sel (Tensor|None): 强制输出选择；shortcut=True（有 Add）时**必须**等于 in_sel，
            因为 Add 要求逐通道对应 —— 教师那边同样如此（其输出通道与输入通道 1:1 对应）

    返回:
        (Tensor, int): (输出通道选择, 迁移参数量)
    """
    c1_out = dst[f"{dpath}.cv1.conv.weight"].shape[0]            # 学生 cv1 输出通道数
    imp1, _ = _importance(src, f"{spath}.cv1")
    sel_cv1 = _topk(imp1, c1_out, f"{spath}.cv1")
    n1 = _fill_conv(dst, src, f"{dpath}.cv1", in_sel, sel_cv1, tag="Bottleneck.cv1")

    c2_out = dst[f"{dpath}.cv2.conv.weight"].shape[0]
    if force_out_sel is not None:
        sel_cv2 = force_out_sel
    else:
        imp2, _ = _importance(src, f"{spath}.cv2")
        sel_cv2 = _topk(imp2, c2_out, f"{spath}.cv2")
    n2 = _fill_conv(dst, src, f"{dpath}.cv2", sel_cv1, sel_cv2, tag="Bottleneck.cv2")
    return sel_cv2, n1 + n2


def _fill_c3(dst, src, dpath, spath, in_sel, dst_mod):
    """填充一个 C3 模块（ultralytics 版 CSP Bottleneck），返回输出通道选择。

    前向（源码 block.py: C3.forward，本脚本已按此实现）:
        out = cv3( cat( ( m(cv1(x)), cv2(x) ), 1 ) )
      · cv1: Conv(c1 → c_, 1×1)  —— 主干入口（c_ = int(c2*e)，e=0.5）
      · cv2: Conv(c1 → c_, 1×1)  —— **独立旁路**（注意: 不是把 cv1 输出切两半！）
      · m  : n 个 Bottleneck(c_ → c_) 串联，输出 = 最后一个的输出
      · cv3: Conv(2*c_ → c2, 1×1)，输入 = cat([m 输出, cv2 输出])，**m 在前、cv2 在后**

    参数:
        dst_mod: 学生 C3 模块对象（用于读取每个 Bottleneck 是否带 Add）
    """
    # --- cv1（主干入口）---
    c_ = dst[f"{dpath}.cv1.conv.weight"].shape[0]
    sel_cv1 = _topk(_importance(src, f"{spath}.cv1")[0], c_, f"{spath}.cv1")
    _fill_conv(dst, src, f"{dpath}.cv1", in_sel, sel_cv1, tag="C3.cv1")

    # --- cv2（独立旁路）---
    c_v2 = dst[f"{dpath}.cv2.conv.weight"].shape[0]
    sel_cv2 = _topk(_importance(src, f"{spath}.cv2")[0], c_v2, f"{spath}.cv2")
    _fill_conv(dst, src, f"{dpath}.cv2", in_sel, sel_cv2, tag="C3.cv2")

    # --- Bottleneck 链（m）：目标个数可能少于教师（本工程 #4: 2→1、#6: 3→2）---
    t_bot = _sub_indices(src, spath, "m")
    s_bot = _sub_indices(dst, dpath, "m")
    if len(s_bot) > len(t_bot):
        raise ValueError(f"{spath}: 目标结构 Bottleneck 数({len(s_bot)}) 多于教师({len(t_bot)})，无法迁移")
    if len(s_bot) < len(t_bot):
        # 保留"教师的前 len(s_bot) 个"Bottleneck（而不是按 γ 挑）
        # 原因: m 是**链式**结构（b0 → b1 → …），每个 Bottleneck 的输入分布依赖前一个的输出；
        #       保留前 n 个可以保持"输入分布对齐"（学生 b0 的输入=教师 b0 的输入），
        #       而按重要性跳选会让被保留的 Bottleneck 收到它没见过的输入，误差更大
        keep = t_bot[: len(s_bot)]
        LOGGER.info(f"[prune] {spath}: 教师有 {len(t_bot)} 个 Bottleneck，目标保留 {len(s_bot)} 个 → 保留前 {keep}")
    else:
        keep = t_bot

    sel_m = sel_cv1                                   # 链式: 上一个的输出 = 下一个的输入
    for k, j in zip(s_bot, keep):
        has_add = bool(getattr(dst_mod.m[k], "add", False))   # 有 Add → 输出选择必须等于输入选择
        sel_m, _ = _fill_bottleneck(dst, src, f"{dpath}.m.{k}", f"{spath}.m.{j}", sel_m,
                                    force_out_sel=sel_m if has_add else None)

    # --- cv3: 输入 = cat([m 输出, cv2 输出])，顺序必须与 forward 一致 ---
    #     ⚠️ 关键: cv3 的权重列是**拼接后**的通道空间 → 第 2 段（cv2 输出）必须整体偏移 c_（教师侧）
    c_ten = src[f"{spath}.cv2.conv.weight"].shape[0]      # 教师侧 cv2 输出通道数（= 教师侧 c_）
    in_sel_cv3 = torch.cat([sel_m, c_ten + sel_cv2])      # 偏移后才是合法的列索引
    cv3_out = dst[f"{dpath}.cv3.conv.weight"].shape[0]
    sel_cv3 = _topk(_importance(src, f"{spath}.cv3")[0], cv3_out, f"{spath}.cv3")
    _fill_conv(dst, src, f"{dpath}.cv3", in_sel_cv3, sel_cv3, tag="C3.cv3")
    return sel_cv3


def _fill_sppf(dst, src, dpath, spath, in_sel, dst_mod):
    """填充 SPPF 模块，返回输出通道选择。

    前向顺序（与 ultralytics SPPF.forward 一致）:
        y = [cv1(x)]; y += [m(y[-1]) for m in self.m];  out = cv2(cat(y, 1))
        ⇒ cv2 的输入 = cv1 输出的 (1 + 池化级数) 份拼接（每份完全相同）
    """
    cv1_out = dst[f"{dpath}.cv1.conv.weight"].shape[0]
    imp1, _ = _importance(src, f"{spath}.cv1")
    sel_cv1 = _topk(imp1, cv1_out, f"{spath}.cv1")
    _fill_conv(dst, src, f"{dpath}.cv1", in_sel, sel_cv1, tag="SPPF.cv1")

    # cv2 的输入通道 = cv1 输出的整数倍（标准 SPPF 为 4 份： y, m(y), m(m(y)), m^3(y)）
    # 注意 1: ultralytics 里 self.m 是**单个** MaxPool2d，前向用 range(3) 重复，故不能用 len(self.m) 算份数，
    #         这里用「cv2 输入通道 ÷ cv1 输出通道」直接推导，最稳妥
    # 注意 2: cv2 权重列是**拼接后**的空间 → 第 k 份必须整体偏移 k × （教师侧 cv1 输出通道数）
    cv2_in = dst[f"{dpath}.cv2.conv.weight"].shape[1]
    c1_ten = src[f"{spath}.cv1.conv.weight"].shape[0]        # 教师侧 cv1 输出通道数
    repeats, rem = divmod(cv2_in, cv1_out)
    if rem != 0:
        raise ValueError(f"{dpath}.cv2 输入通道 {cv2_in} 不是 cv1 输出 {cv1_out} 的整数倍，无法推导 SPPF 份数")
    in_sel_cv2 = torch.cat([sel_cv1 + k * c1_ten for k in range(repeats)])
    cv2_out = dst[f"{dpath}.cv2.conv.weight"].shape[0]
    imp2, _ = _importance(src, f"{spath}.cv2")
    sel_cv2 = _topk(imp2, cv2_out, f"{spath}.cv2")
    _fill_conv(dst, src, f"{dpath}.cv2", in_sel_cv2, sel_cv2, tag="SPPF.cv2")
    return sel_cv2


# ============================================================
# 检测头处理（Detect: cv2 框分支 / cv3 分类分支 / DFL）
# ============================================================
# [2026-10-08 16:58:25] 新增: Detect 头的通道联动与切片
# 原因: cv2/cv3 第一层卷积的输入 = 对应尺度颈部输出（P3/P4/P5）→ 必须使用同一组通道选择；
#       末尾 1×1 卷积（无 BN）的输出通道数固定（框 4×reg_max=64、类别 nc=3）→ 只按输入维切片
# 解决方案: 逐尺度、逐分支: [0] Conv(输入按尺度选择) → [1] Conv(通道按 [0] 的输出选择) → [2] 裸 1×1 Conv(输入按 [1] 的选择)
# 说明: DFL 的 1×1（reg_max→1，无 BN、无 bias）与通道数无关，直接复制；reg_max/nc 必须与教师一致
def _fill_detect(dst, src, dpath, spath, sels):
    """填充 Detect 检测头。

    参数:
        sels (list[Tensor]): 三个尺度（P3/P4/P5）的颈部输出通道选择，顺序与 Detect.f 一致
    """
    for i, sel_in in enumerate(sels):                 # i = 尺度序号（0=P3, 1=P4, 2=P5）
        for br in ("cv2", "cv3"):                     # cv2 = 框回归分支，cv3 = 分类分支
            p0 = f"{dpath}.{br}.{i}.0"                # Conv(输入 → c2/c3, 3×3)
            c0 = dst[f"{p0}.conv.weight"].shape[0]
            imp0, _ = _importance(src, f"{spath}.{br}.{i}.0")
            sel0 = _topk(imp0, c0, f"{spath}.{br}.{i}.0")
            _fill_conv(dst, src, p0, sel_in, sel0, tag=f"Detect.{br}.{i}.0")

            p1 = f"{dpath}.{br}.{i}.1"                # Conv(c → c, 3×3)：输入与输出共用同一组选择
            _fill_conv(dst, src, p1, sel0, sel0, tag=f"Detect.{br}.{i}.1")

            p2 = f"{dpath}.{br}.{i}.2"                # nn.Conv2d(c → 4*reg_max 或 nc, 1)：只切输入维
            _fill_raw_conv(dst, src, p2, sel0)

    dfl = f"{dpath}.dfl.conv.weight"                  # DFL 固定 1×1（reg_max→1）：直接复制
    if dfl in dst and dfl in src:
        dst[dfl] = src[dfl].float().clone()
        _record(dfl)


# ============================================================
# 主流程（逐层挑通道 → 切片 → 组装 → 校验）
# ============================================================
# [2026-10-08 16:58:25] 新增: 主流程驱动器
# 原因: 需要「沿数据流顺序遍历 + 维护每层输出选择」的调度器，把各模块处理器串起来
# 解决方案: 按 stu.model 的层顺序遍历（顺序即数据流顺序，f 只指向已处理的层）:
#       ① 由 f 计算本层输入选择（-1 = 上一层；list = Concat 的多路拼接）
#       ② 按层类型分发到 Conv / C3 / SPPF / Concat / Upsample / Detect 处理器
#       ③ 记录本层输出选择供后续层使用
# 说明: 逐层校验学生与教师层类型一致；任何形状不匹配都带层号报错，避免"静默半迁移"造成假继承
def build_pruned_state_dict(teacher_path, yaml_path):
    """返回 (学生模型, 填充好的 state_dict, 报告行列表)。"""
    if not os.path.isfile(teacher_path):
        raise FileNotFoundError(f"教师权重不存在: {teacher_path}")
    if not os.path.isfile(yaml_path):
        raise FileNotFoundError(f"目标结构 yaml 不存在: {yaml_path}")

    tea = YOLO(teacher_path, task="detect").model
    ten = {k: v.float() for k, v in tea.state_dict().items()}      # 教师常以 fp16 保存 → 统一转 fp32
    stu = YOLO(yaml_path, task="detect").model
    dst = {k: v.clone() for k, v in stu.state_dict().items()}      # 以学生的随机初始化为底，逐层覆盖

    if len(tea.model) != len(stu.model):
        raise ValueError(f"层数不一致: 教师 {len(tea.model)} vs 目标 {len(stu.model)}（拓扑必须一致）")
    if not _has_bn(ten, "model.1"):
        LOGGER.warning("[prune] 教师权重看起来已融合（无 BN）→ 重要性判据退化为卷积核 L1 范数，学生 BN 置单位变换")

    rows, sel, out_ch_ten = [], {}, {}          # sel: 各层输出通道选择；out_ch_ten: 教师侧各层输出通道数
    for i, mod in enumerate(stu.model):
        dpath = spath = f"model.{i}"                                # 两侧层号一一对应（拓扑一致）
        tmod = tea.model[i]
        if type(mod).__name__ != type(tmod).__name__:
            raise ValueError(f"第 {i} 层类型不一致: 目标 {type(mod).__name__} vs 教师 {type(tmod).__name__}")

        f = getattr(mod, "f", -1)                                   # 该层的输入来源（-1=上一层，list=多路）
        if isinstance(f, (list, tuple)):
            # ⚠️ Concat: 其输出通道空间 = 各输入支路按 f 顺序**拼接**后的空间，
            #    因此第 k 段的索引必须整体偏移「教师侧前 k-1 段的通道数之和」，否则等于用错列去取权重
            parts, off = [], 0
            for j in f:
                jj = i - 1 if j == -1 else j
                parts.append(sel[jj] + off)
                off += out_ch_ten[jj]
            in_sel = torch.cat(parts)
            out_ch_ten[i] = off
        elif i == 0:
            in_sel = torch.arange(ten[f"{spath}.conv.weight"].shape[1])          # 图像输入的 3 通道
        else:
            in_sel = sel[i - 1]

        name = type(mod).__name__
        if isinstance(mod, Conv):
            out_n = dst[f"{dpath}.conv.weight"].shape[0]
            imp, judge = _importance(ten, spath)
            out_s = _topk(imp, out_n, spath)
            kernel_changed = tuple(ten[f"{spath}.conv.weight"].shape[2:]) != tuple(dst[f"{dpath}.conv.weight"].shape[2:])
            crop = (i == 0 and STEM_CENTER_CROP and kernel_changed)
            _fill_conv(dst, ten, dpath, in_sel, out_s, allow_crop=crop, tag=f"#{i} Conv")
            sel[i] = out_s
            out_ch_ten[i] = int(ten[f"{spath}.conv.weight"].shape[0])
            note = f"Conv: 输入 {in_sel.numel()} 保 {len(out_s)} / 输出 {out_ch_ten[i]}→{out_n}（{judge}）"
            if crop:
                note += "；stem 6×6→3×3 取中心近似"
        elif isinstance(mod, C3):
            sel[i] = _fill_c3(dst, ten, dpath, spath, in_sel, mod)
            out_ch_ten[i] = int(ten[f"{spath}.cv3.conv.weight"].shape[0])
            note = f"C3: 输入 {in_sel.numel()} 保 {sel[i].numel()} / 输出 {dst[f'{dpath}.cv3.conv.weight'].shape[0]}"
        elif isinstance(mod, SPPF):
            sel[i] = _fill_sppf(dst, ten, dpath, spath, in_sel, mod)
            out_ch_ten[i] = int(ten[f"{spath}.cv2.conv.weight"].shape[0])
            note = f"SPPF: 输出 {sel[i].numel()}"
        elif isinstance(mod, (Concat, nn.Upsample)):
            sel[i] = in_sel
            if isinstance(mod, nn.Upsample):
                out_ch_ten[i] = out_ch_ten[i - 1]                   # 上采样不改变通道数
            note = "无参数：仅传递/拼接通道选择（拼接项已按教师侧通道数做偏移）"
        elif isinstance(mod, Detect):
            sels = [sel[j] for j in f]
            _fill_detect(dst, ten, dpath, spath, sels)
            note = f"Detect: 头输入选择 {[int(s.numel()) for s in sels]}"
        else:
            raise TypeError(f"未支持的层类型 {name}（#{i}），请在主流程里补充处理逻辑")

        rows.append((i, name, int(sel[i].numel()) if i in sel else -1, note))
        if VERBOSE_LAYERS:
            LOGGER.info(f"[prune] #{i:>2} {name:<16} {note}")
    return stu, dst, rows, sel      # sel: {层号 → 该层输出通道选择}，可用于逐层校验


# ============================================================
# BN 统计量重校准（剪枝后**必需**的一步）
# ============================================================
# [2026-10-08 16:58:25] 新增: 切片后重估 BN 的 running_mean / running_var
# 原因: BN 的统计量是在**教师网络原始分布**下累计的；剪枝改变了每层的输入/输出分布，直接沿用会让
#       归一化错位 —— 实测"切片但不重校准"导出的权重零样本 mAP≈0（几乎无检测框），并非切片错误
# 解决方案: 先 reset_running_stats() 清零，再在 train 模式下做纯前向（no_grad、无标签、不更新任何权重），
#       让 BN 用当前 batch 的均值/方差按动量更新自己的 running stats（社区做法，Torch-Pruning 同理）
# 说明: 只改 BN 的 buffer、不改权重；建议 100~300 张、批 8；把 BN_RECALIB_IMAGES 置 0 可跳过
def _list_images(p):
    """列出路径下的图片文件，兼容多种数据集布局:
        · 直接是图片文件 / .txt 图片清单
        · 目录下直接放图片
        · 目录下是 <split>/images/*.jpg（本工程 RDD_China 的布局）
        · 以上都没有时，递归兜底搜索
    """
    exts = (".jpg", ".jpeg", ".png", ".bmp", ".webp")

    def _scan(d):
        return [os.path.join(d, f) for f in sorted(os.listdir(d)) if f.lower().endswith(exts)]

    if os.path.isfile(p):
        if p.lower().endswith(".txt"):
            return [line.strip() for line in open(p, encoding="utf-8") if line.strip()]
        return [p] if p.lower().endswith(exts) else []

    for sub in ("", "images", os.path.join("images", "train")):
        d = os.path.join(p, sub) if sub else p
        if os.path.isdir(d):
            files = _scan(d)
            if files:
                return files

    files = []                                     # 兜底: 递归搜索
    for root, _dirs, fs in os.walk(p):
        files += [os.path.join(root, f) for f in sorted(fs) if f.lower().endswith(exts)]
        if files:
            break
    return files


def _collect_images(data_yaml, limit):
    """从数据集 yaml 的 train 路径收集图片文件（同时支持「目录」与「txt 列表」两种写法）"""
    import yaml as _yaml

    d = _yaml.safe_load(open(data_yaml, encoding="utf-8"))
    tr = d.get("train")
    if isinstance(tr, (list, tuple)):
        tr = tr[0]
    p = tr if os.path.isabs(str(tr)) else os.path.join(str(d.get("path", "")), str(tr))
    return _list_images(p)[:limit]


def _letterbox_batch(files, h, w):
    """按 ultralytics 的 letterbox 规则把图片缩放进 (h, w)，堆成 (B,3,h,w) 的 float32 张量（BGR、/255）"""
    out = []
    for f in files:
        img = cv2.imread(f)
        h0, w0 = img.shape[:2]
        r = min(h / h0, w / w0)
        nh, nw = max(1, round(h0 * r)), max(1, round(w0 * r))
        canvas = np.full((h, w, 3), 114, np.uint8)
        top, left = (h - nh) // 2, (w - nw) // 2
        canvas[top:top + nh, left:left + nw] = cv2.resize(img, (nw, nh))
        out.append(canvas.transpose(2, 0, 1))
    return torch.from_numpy(np.ascontiguousarray(np.stack(out))).float() / 255.0


def recalibrate_bn(model, data_yaml, n_images=200, batch=8, imgsz=(384, 512), device="cpu"):
    """剪枝后重估 BN 的 running_mean/var（只动 buffer、不动权重），返回实际用到的图片数。"""
    files = _collect_images(data_yaml, n_images)
    if not files:
        LOGGER.warning("[prune] 没找到可用于 BN 重校准的图片，跳过")
        return 0
    for m in model.modules():                       # 先清零，避免残留教师的旧统计量
        if isinstance(m, nn.BatchNorm2d):
            m.reset_running_stats()
    model.to(device).train()                        # train 模式: BN 用当前 batch 统计并更新 running stats
    n = 0
    with torch.no_grad():
        for i in range(0, len(files), batch):
            chunk = files[i : i + batch]
            model(_letterbox_batch(chunk, imgsz[0], imgsz[1]).to(device))
            n += len(chunk)
    model.eval()
    return n


# ============================================================
# 入口: 执行迁移 → 打印报告 → BN 重校准 → 前向自检 → 保存产物
# ============================================================
if __name__ == "__main__":
    # 支持命令行覆盖档位: python scripts/prune_transfer.py balance（不传则用配置区的 PROFILE）
    profile = sys.argv[1] if len(sys.argv) > 1 else PROFILE
    yaml_path = _MODEL_BY_PROFILE.get(profile)
    if yaml_path is None:
        raise SystemExit(f"PROFILE 只能是 {list(_MODEL_BY_PROFILE)} 之一，当前为 {profile!r}")

    LOGGER.info(f"[prune] 教师权重: {TEACHER}")
    LOGGER.info(f"[prune] 目标结构: {yaml_path}（档位 {profile}）")

    stu, dst, rows, sel = build_pruned_state_dict(TEACHER, yaml_path)

    # ---- 统计: 迁移了多少**参数**（按参数量而非条目数，这才是"起点好不好"的真实指标）----
    total = sum(v.numel() for k, v in dst.items() if not k.endswith("num_batches_tracked"))
    moved = sum(dst[k].numel() for k in _STAT["written_keys"] if k in dst and not k.endswith("num_batches_tracked"))
    untouched = sorted(
        (k for k in dst if k not in _STAT["written_keys"] and not k.endswith("num_batches_tracked")),
        key=lambda k: -dst[k].numel(),
    )

    print("\n" + "=" * 100)
    print(f"逐层迁移报告（档位 {profile}）")
    print("=" * 100)
    for i, name, out_ch, note in rows:
        print(f"  #{i:>2} {name:<16} 输出选择 {out_ch:>4}  {note}")
    print("=" * 100)
    print(f"总参数（不含 num_batches_tracked） = {total:,}")
    print(f"已迁移参数                         = {moved:,}  ({moved / total * 100:.1f}%)")
    print(f"保持随机初始化的参数               = {total - moved:,}  ({(total - moved) / total * 100:.1f}%)")
    if untouched:
        print(f"未迁移的键（共 {len(untouched)} 个，按参数量排序取前 8）:")
        for k in untouched[:8]:
            print(f"    {k}  ({dst[k].numel():,})")
    print("=" * 100)

    # ---- 装回模型 + BN 统计量重校准（关键步骤，见上方说明）----
    stu.load_state_dict(dst)
    if BN_RECALIB_IMAGES > 0 and DATA_YAML and os.path.isfile(DATA_YAML):
        used = recalibrate_bn(stu, DATA_YAML, BN_RECALIB_IMAGES, BN_RECALIB_BATCH, BN_RECALIB_IMGSZ)
        print(f"BN 统计量重校准完成: 用 {used} 张训练图（reset + train 模式纯前向）重估，只更新 BN buffer、不动权重")
    else:
        print("⚠️ 已跳过 BN 统计量重校准（BN_RECALIB_IMAGES=0 或无数据集 yaml）"
              "—— 不重校准会因归一化失配导致零样本输出失效")

    # ---- 前向自检（能立即发现通道联动/形状类的错误）----
    stu.eval()
    nc = int(stu.yaml.get("nc") or stu.model[-1].nc)  # 类别数（3）
    reg_max = int(stu.model[-1].reg_max)              # DFL 分箱（16）
    h, w = 384, 512                                   # 部署输入 512×384（高,宽）
    with torch.no_grad():
        out = stu(torch.zeros(1, 3, h, w))
    y = out[0] if isinstance(out, tuple) else out      # eval 下 Detect 返回 (y, x)，y 为解码结果 (4+nc) 通道
    anchors = sum((h // s) * (w // s) for s in (8, 16, 32))
    if tuple(y.shape) != (1, 4 + nc, anchors):
        raise RuntimeError(f"前向自检失败: 输出 {tuple(y.shape)} ≠ 期望 (1, {4 + nc}, {anchors})")
    print(f"前向自检通过: 输入 (1,3,{h},{w}) → 解码输出 {tuple(y.shape)}  "
          f"[no={nc + 4 * reg_max}(原始) / 4+nc={4 + nc}(解码) / 锚点 {anchors}]")

    # ---- 保存产物（结构 yaml 与权重分离使用: MODEL=目标 yaml，WEIGHTS=本文件）----
    os.makedirs(SAVE_DIR, exist_ok=True)
    # [2026-10-08 17:24:32] 新增: 产物文件名支持自定义 —— 用配置区 OUT_NAME，留空则自动命名 v5n_to_<档位>.pt
    # 原因: 用户希望产物的文件名可自定义（便于按实验命名，如 crack_balance_init.pt）
    # 解决方案: OUT_NAME 非空则用它；未带 .pt 扩展名时自动补上；最终路径 = SAVE_DIR \ 文件名
    out_name = OUT_NAME.strip() or f"v5n_to_{profile}.pt"
    if not out_name.lower().endswith(".pt"):
        out_name += ".pt"
    out_path = os.path.join(SAVE_DIR, out_name)
    torch.save(
        {
            "model": stu,
            "train_args": {},
            "date": datetime.datetime.now().isoformat(),
            "note": f"channel-pruned transfer: {os.path.basename(TEACHER)} -> {os.path.basename(yaml_path)}",
        },
        out_path,
    )
    print(f"已保存: {out_path}  ({os.path.getsize(out_path) / 1e6:.2f} MB)")
    print("用法: 把 scripts/train_crack_4_3.py 的 WEIGHTS 指向该文件（建议同时 DISTILL=True）")
