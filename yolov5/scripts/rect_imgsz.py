# Ultralytics YOLO 🚀, AGPL-3.0 license
"""
非正方形分辨率（如 640×480）训练 / 验证支持模块（运行时补丁）

功能说明:
  让 ultralytics 8.2.103 的训练与验证流程支持「非正方形」输入尺寸，例如 imgsz=(480, 640)
  （高 H=480、宽 W=640），从而可以按 640×480 这类非正方形分辨率训练目标检测模型。

背景说明:
  ultralytics 8.2.103 官方只允许 train/val 模式的 imgsz 为单个整数（即正方形输入）：
    - engine/trainer.py   : check_imgsz(..., max_dim=1) 会把 [480, 640] 折叠成 640（变回 640×640）
    - engine/validator.py : check_imgsz(..., max_dim=1) 同样折叠，导致验证分辨率与训练不一致
    - data/base.py        : load_image() 用 self.imgsz 做标量运算（self.imgsz / max(h, w)）
    - data/augment.py     : Mosaic 以 2*imgsz × 2*imgsz 的正方形画布拼接，LetterBox 传入 (imgsz, imgsz)
  因此仅靠脚本传参无法得到真正的 640×480 训练，必须在训练前做运行时补丁。

实现方式:
  本模块只做「运行时补丁」（monkey patch），不修改 ultralytics 库文件（该库由 pip 以可编辑模式
  安装在其它工程目录下，直接改库会影响其它工程）。所有补丁函数都会先判断 imgsz 是否为两元素
  尺寸：不是（如 640 这种整数）则原样调用库函数，行为与原生完全一致。

使用方法:
    import rect_imgsz
    rect_imgsz.enable_rect_imgsz()      # 必须放在「模块顶层」（import 之后），不要放进 if __name__ == "__main__"

注意事项:
  1. imgsz 写作 (高 H, 宽 W)，例如 (480, 640) 表示网络输入张量形状 (N, 3, 480, 640)
  2. 非正方形分辨率暂不支持 batch=-1（autobatch 自动批大小），请显式指定 batch 为正整数
  3. 正方形分辨率（imgsz=640）走原生逻辑，本模块对其无任何影响
  4. 数据集类别编号不连续时（如 RDD_2026 使用原始编号 0/1/2/4），本模块会按 yaml 中 names 的键顺序把
     标签编号映射为连续的「训练编号」0..N-1（只在内存中转换，磁盘标签文件与 yaml 均不改动），
     类别数 nc = yaml 中 names 的数量（RDD_2026 → 映射 {0:0, 1:1, 2:2, 4:3}，nc=4，
     即 0=纵向裂缝 1=横向裂缝 2=龟裂 3=坑洞；坑洞编号由 4 变为 3，使用模型时按 4 类解析）；
     编号本身连续的数据集（如本工程 4:3 实验所用 RDD_China，0=crack / 1=alligator crack / 2=pothole）
     映射为恒等映射（0→0、1→1、2→2，nc=3），与原版行为完全一致
  5. 马赛克只适配了 n=4（默认）与 n=9 两种网格；本版本 Mosaic.__init__ 本身就断言 n ∈ {4, 9}，
     n=3（库内自定义 _mosaic3 分支）不会被使用，故未做非正方形适配
  6. enable_rect_imgsz() 必须在「模块顶层」调用（不能只放在 if __name__ == "__main__" 里）：
     WORKERS>0 时 PyTorch 用 spawn 派生子进程，子进程会重新 import 脚本的模块级代码但不会执行 __main__ 分支，
     若补丁只在 __main__ 里启用，子进程会使用未打补丁的原版 load_image 而报
     "TypeError: unsupported operand type(s) for /: 'list' and 'int'"
"""

# [2026-10-08 10:15:07] 新增: 从 yolov8_640×480 工程移植非正方形分辨率支持模块到本工程（yolov5）
# 原因: 本工程新增的 scripts/train_4_3.py 需要按 4:3（imgsz=(480, 640)）训练，而 ultralytics 8.2.103
#       train/val 只接受整数 imgsz，(480, 640) 会被折叠成 640×640；该支持已在 yolov8_640×480 工程
#       用运行时补丁实现并通过训练验证，无需重写
# 解决方案: 原样复制该工程的 rect_imgsz.py（补丁逻辑一字未改，仅把文档与两处说明由 RDD_2026 补充为
#       同时覆盖本工程 4:3 实验数据集 RDD_China），在训练脚本模块顶层调用 enable_rect_imgsz() 启用
# 说明: 本工程 python 环境 import 到的是工程内自带的 ultralytics 8.2.103（yolov5\ultralytics），
#       与被移植工程使用的版本一致，补丁函数签名匹配；RDD_China 类别编号连续（0/1/2，nc=3），
#       类别归一化补丁对其为恒等映射，不会改动任何编号
import multiprocessing
import math
import random
from pathlib import Path

import cv2
import numpy as np

from ultralytics.utils import LOGGER

_PATCHED = False  # 是否已打过补丁（避免重复打补丁）
_PATCHES = (  # 补丁清单（用于日志输出，与下文各补丁一一对应）
    "check_imgsz 放行两元素尺寸",
    "BaseDataset.load_image / check_cache_ram 支持 (高, 宽)",
    "Mosaic 马赛克按 (2*高, 2*宽) 画布拼接",
    "v8_transforms / YOLODataset.build_transforms 按 (高, 宽) 定尺",
    "AutoBackend.warmup 兼容嵌套尺寸",
    "autobatch 非正方形回退提示",
    "数据集类别编号归一化（非连续编号按 names 顺序映射为 0..N-1；连续编号如 RDD_China 为恒等映射）",
)


def _hw_pair(imgsz):
    """
    把两元素尺寸规整为 (高, 宽) 整数元组。

    参数:
        imgsz (int | list | tuple | str): 传入的输入尺寸

    返回:
        tuple[int, int] | None: 形如 [480, 640] / (480, 640) 时返回 (480, 640)；其它情况返回 None
    """
    if isinstance(imgsz, (list, tuple)) and len(imgsz) == 2:
        try:
            return int(imgsz[0]), int(imgsz[1])
        except (TypeError, ValueError):
            return None
    return None


def _rebind_module_attr(attr, old_obj, new_obj):
    """
    把已加载的 ultralytics 子模块中「按名导入」的 attr 统一替换为补丁版本。

    参数:
        attr (str): 属性名，例如 "check_imgsz"
        old_obj: 原函数对象（用于判断某模块是否持有的正是原函数）
        new_obj: 补丁函数对象

    返回:
        int: 实际替换的模块数量
    """
    import sys

    count = 0
    for name, module in list(sys.modules.items()):
        if module is None or name.split(".")[0] != "ultralytics":
            continue
        try:
            if getattr(module, attr, None) is old_obj:
                setattr(module, attr, new_obj)
                count += 1
        except Exception:
            continue
    return count


# [2026-09-26 17:12:00] 新增: 新增非正方形分辨率(640×480)运行时补丁模块
# 原因: ultralytics 8.2.103 的 train/val 只接受整数 imgsz，传入 [480, 640] 会被 check_imgsz(max_dim=1)
#       折叠成 640，训练分辨率仍是 640×640，无法满足 640×480 训练需求；且库文件是其它工程的可编辑安装，
#       直接改库会影响其它工程
# 解决方案: 在脚本侧新增本模块，用运行时补丁的方式（monkey patch）让训练/验证支持 (高, 宽) 两元素尺寸，
#       补丁仅在两元素尺寸时生效，整数/正方形尺寸完全走原生逻辑
# 说明: 使用方式为 import rect_imgsz 后调用 rect_imgsz.enable_rect_imgsz()，训练与测试脚本均已接入
# [2026-09-26 18:40:00] 修复: 补丁必须在模块顶层启用，否则多进程 DataLoader 的子进程未打补丁
# 原因: WORKERS>0 时 PyTorch 用 spawn 派生子进程，子进程会重新 import 本脚本的模块级代码，
#       但不会执行 if __name__ == "__main__" 里的代码 → 子进程中的 ultralytics 是未打补丁的原版，
#       读图时执行原版 load_image 的 self.imgsz / max(h0, w0)，抛
#       "TypeError: unsupported operand type(s) for /: 'list' and 'int'"
# 解决方案: 把 enable_rect_imgsz() 提到模块顶层（import 之后立即调用），子进程 import 本脚本时同样生效；
#       子进程中的启用日志由 rect_imgsz 模块自动静默，只在主进程打印
# 说明: 该调用必须保留在模块顶层，不要移回 __main__ 分支；重复调用只生效一次
def enable_rect_imgsz(verbose=True):
    """启用非正方形分辨率（如 640×480）训练/验证支持，重复调用只生效一次。

    参数:
        verbose (bool): 是否打印补丁启用信息（DataLoader 子进程中会自动静默，避免刷屏）
    """
    global _PATCHED
    if _PATCHED:
        return
    _PATCHED = True

    # 多进程 DataLoader 的 worker 子进程也会调用本函数，只在主进程打印启用信息
    if multiprocessing.current_process().name != "MainProcess":
        verbose = False

    import ultralytics
    from ultralytics.data import augment as _augment
    from ultralytics.data import base as _base
    from ultralytics.data import dataset as _dataset
    from ultralytics.engine import trainer as _trainer
    from ultralytics.engine import validator as _validator
    from ultralytics.nn import autobackend as _autobackend
    from ultralytics.utils import autobatch as _autobatch
    from ultralytics.utils import checks as _checks
    from ultralytics.utils.instance import Instances

    # ============================================================
    # 补丁1: check_imgsz 放行两元素尺寸（训练/验证入口）
    # ============================================================
    # [2026-09-26 17:12:00] 修复: check_imgsz 将 (480, 640) 折叠为 640，导致仍是 640×640 训练
    # 原因: engine/trainer.py 与 engine/validator.py 均以 check_imgsz(..., max_dim=1) 校验 imgsz，
    #       max_dim=1 表示只允许一维（正方形）尺寸，传入两元素尺寸时会取最大值 640 并发出警告
    # 解决方案: 包装 check_imgsz，遇到 max_dim=1 且 imgsz 为两元素尺寸时改以 max_dim=2 调用原函数，
    #       使 (480, 640) 被完整保留；其它情况直接调用原函数
    # 说明: trainer.py / validator.py 在模块内是以 from ... import check_imgsz 引入的，需同时替换其模块属性
    _orig_check_imgsz = _checks.check_imgsz

    def _check_imgsz_rect(imgsz, stride=32, min_dim=1, max_dim=2, floor=0):
        """check_imgsz 包装：允许 train/val 使用 (高, 宽) 两元素尺寸"""
        if max_dim == 1 and _hw_pair(imgsz) is not None:
            return _orig_check_imgsz(imgsz, stride=stride, min_dim=1, max_dim=2, floor=floor)
        return _orig_check_imgsz(imgsz, stride=stride, min_dim=min_dim, max_dim=max_dim, floor=floor)

    _checks.check_imgsz = _check_imgsz_rect
    for _m in (_trainer, _validator):
        if hasattr(_m, "check_imgsz"):
            _m.check_imgsz = _check_imgsz_rect

    # ============================================================
    # 补丁2: 数据集读图按 (高, 宽) 等比缩放
    # ============================================================
    # [2026-09-26 17:12:00] 修复: load_image 用 imgsz 做标量运算，两元素尺寸时会报 TypeError
    # 原因: BaseDataset.load_image() 中 r = self.imgsz / max(h0, w0)、min(..., self.imgsz) 均按标量处理，
    #       传入 [480, 640] 会抛 "unsupported operand type(s) for /: 'list' and 'int'"
    # 解决方案: 包装 load_image，两元素尺寸时按 r = min(H/h0, W/w0) 等比缩放（只缩小不裁剪，把图像装进 高480×宽640），
    #       整数尺寸时调用原函数；缓存显存/内存估算 check_cache_ram 同步支持两元素尺寸
    # 说明: 缩放到目标框内后由 LetterBox 补边到精确的 (H, W)，因此不损失有效像素，只补灰色边
    _orig_load_image = _base.BaseDataset.load_image
    _orig_check_cache_ram = _base.BaseDataset.check_cache_ram

    def _load_image_rect(self, i, rect_mode=True):
        """load_image 包装：支持 (高, 宽) 两元素 imgsz"""
        hw = _hw_pair(self.imgsz)
        if hw is None:
            return _orig_load_image(self, i, rect_mode)

        im, f, fn = self.ims[i], self.im_files[i], self.npy_files[i]
        if im is None:  # not cached in RAM
            if fn.exists():  # load npy
                try:
                    im = np.load(fn)
                except Exception as e:
                    LOGGER.warning(f"{self.prefix}WARNING ⚠️ Removing corrupt *.npy image file {fn} due to: {e}")
                    Path(fn).unlink(missing_ok=True)
                    im = cv2.imread(f)  # BGR
            else:  # read image
                im = cv2.imread(f)  # BGR
            if im is None:
                raise FileNotFoundError(f"Image Not Found {f}")

            h0, w0 = im.shape[:2]  # orig hw
            if rect_mode:  # 等比缩放：把整幅图装进 目标(高H, 宽W)，不裁剪
                r = min(hw[0] / h0, hw[1] / w0)  # ratio
                if r != 1:  # if sizes are not equal
                    w, h = min(math.ceil(w0 * r), hw[1]), min(math.ceil(h0 * r), hw[0])
                    im = cv2.resize(im, (w, h), interpolation=cv2.INTER_LINEAR)
            elif not (h0 == hw[0] and w0 == hw[1]):  # 拉伸到目标尺寸
                im = cv2.resize(im, (hw[1], hw[0]), interpolation=cv2.INTER_LINEAR)

            # Add to buffer if training with augmentations
            if self.augment:
                self.ims[i], self.im_hw0[i], self.im_hw[i] = im, (h0, w0), im.shape[:2]  # im, hw_original, hw_resized
                self.buffer.append(i)
                if 1 < len(self.buffer) >= self.max_buffer_length:  # prevent empty buffer
                    j = self.buffer.pop(0)
                    if self.cache != "ram":
                        self.ims[j], self.im_hw0[j], self.im_hw[j] = None, None, None
            return im, (h0, w0), im.shape[:2]
        return self.ims[i], self.im_hw0[i], self.im_hw[i]

    def _check_cache_ram_rect(self, safety_margin=0.5):
        """check_cache_ram 包装：按 (高, 宽) 两元素 imgsz 估算缓存所需内存"""
        hw = _hw_pair(self.imgsz)
        if hw is None:
            return _orig_check_cache_ram(self, safety_margin)

        import psutil

        b, gb = 0, 1 << 30  # bytes of cached images, bytes per gigabytes
        n = min(self.ni, 30)  # extrapolate from 30 random images
        for _ in range(n):
            im = cv2.imread(random.choice(self.im_files))  # sample image
            ratio = min(hw[0] / im.shape[0], hw[1] / im.shape[1])  # 等比缩放比
            b += im.nbytes * ratio**2
        mem_required = b * self.ni / n * (1 + safety_margin)  # GB required to cache dataset into RAM
        mem = psutil.virtual_memory()
        success = mem_required < mem.available  # to cache or not to cache, that is the question
        if not success:
            self.cache = None
            LOGGER.info(
                f"{self.prefix}{mem_required / gb:.1f}GB RAM required to cache images "
                f"with {int(safety_margin * 100)}% safety margin but only "
                f"{mem.available / gb:.1f}/{mem.total / gb:.1f}GB available, not caching images ⚠️"
            )
        return success

    _base.BaseDataset.load_image = _load_image_rect
    _base.BaseDataset.check_cache_ram = _check_cache_ram_rect

    # ============================================================
    # 补丁3: Mosaic 马赛克按 (2*高, 2*宽) 画布拼接
    # ============================================================
    # [2026-09-26 17:12:00] 修复: Mosaic 画布按正方形拼接，两元素尺寸下会抛 TypeError
    # 原因: Mosaic.__init__ 中 self.border = (-imgsz // 2, -imgsz // 2) 及 _mosaic4/_mosaic9/_cat_labels
    #       均把 imgsz 当标量使用（正方形画布 2*imgsz × 2*imgsz、clip(imgsz, imgsz)），
    #       传入 (480, 640) 会抛 "unsupported operand type(s) for //: 'tuple' and 'int'"
    # 解决方案: 补丁 Mosaic 的 __init__ / _mosaic4 / _mosaic9 / _cat_labels，两元素尺寸时改为
    #       border=(高/2, 宽/2)、画布=(2*高, 2*宽)、中心点分别在 [H/2, 1.5H] 与 [W/2, 1.5W] 采样、
    #       clip(2*宽, 2*高)；整数尺寸时调用原函数
    # 说明: 马赛克画布随后由 RandomPerspective 依 mosaic_border 裁到 (高, 宽)，因此马赛克图像与最终
    #       640×480 输入保持同一长宽比，不会出现灰边冗余
    _orig_mosaic_init = _augment.Mosaic.__init__
    _orig_mosaic4 = _augment.Mosaic._mosaic4
    _orig_mosaic9 = _augment.Mosaic._mosaic9
    _orig_mosaic_cat_labels = _augment.Mosaic._cat_labels

    def _mosaic_init_rect(self, dataset, imgsz=640, p=1.0, n=4):
        """Mosaic.__init__ 包装：支持 (高, 宽) 两元素 imgsz"""
        hw = _hw_pair(imgsz)
        if hw is None:
            return _orig_mosaic_init(self, dataset=dataset, imgsz=imgsz, p=p, n=n)
        assert 0 <= p <= 1.0, f"The probability should be in range [0, 1], but got {p}."
        assert n in {4, 9}, "grid must be equal to 4 or 9."
        _augment.BaseMixTransform.__init__(self, dataset=dataset, p=p)
        self.imgsz = hw  # 单张图的目标尺寸 (高, 宽)
        self.border = (-hw[0] // 2, -hw[1] // 2)  # 高度方向边框, 宽度方向边框
        self.n = n

    def _mosaic4_rect(self, labels):
        """Mosaic._mosaic4 包装：按 (2*高, 2*宽) 画布拼接 4 张图"""
        if _hw_pair(self.imgsz) is None:
            return _orig_mosaic4(self, labels)

        h, w = self.imgsz  # 单张图目标 (高, 宽)
        mosaic_labels = []
        yc, xc = (int(random.uniform(-b, 2 * s + b)) for s, b in zip(self.imgsz, self.border))  # 拼接中心点 y, x
        for i in range(4):
            labels_patch = labels if i == 0 else labels["mix_labels"][i - 1]
            # Load image
            img = labels_patch["img"]
            hp, wp = labels_patch.pop("resized_shape")

            # Place img in img4
            if i == 0:  # top left
                img4 = np.full((h * 2, w * 2, img.shape[2]), 114, dtype=np.uint8)  # base image with 4 tiles
                x1a, y1a, x2a, y2a = max(xc - wp, 0), max(yc - hp, 0), xc, yc  # xmin, ymin, xmax, ymax (large image)
                x1b, y1b, x2b, y2b = wp - (x2a - x1a), hp - (y2a - y1a), wp, hp  # xmin, ymin, xmax, ymax (small image)
            elif i == 1:  # top right
                x1a, y1a, x2a, y2a = xc, max(yc - hp, 0), min(xc + wp, w * 2), yc
                x1b, y1b, x2b, y2b = 0, hp - (y2a - y1a), min(wp, x2a - x1a), hp
            elif i == 2:  # bottom left
                x1a, y1a, x2a, y2a = max(xc - wp, 0), yc, xc, min(h * 2, yc + hp)
                x1b, y1b, x2b, y2b = wp - (x2a - x1a), 0, wp, min(y2a - y1a, hp)
            else:  # bottom right
                x1a, y1a, x2a, y2a = xc, yc, min(xc + wp, w * 2), min(h * 2, yc + hp)
                x1b, y1b, x2b, y2b = 0, 0, min(wp, x2a - x1a), min(y2a - y1a, hp)

            img4[y1a:y2a, x1a:x2a] = img[y1b:y2b, x1b:x2b]  # img4[ymin:ymax, xmin:xmax]
            padw = x1a - x1b
            padh = y1a - y1b

            mosaic_labels.append(self._update_labels(labels_patch, padw, padh))
        final_labels = self._cat_labels(mosaic_labels)
        final_labels["img"] = img4
        return final_labels

    def _mosaic9_rect(self, labels):
        """Mosaic._mosaic9 包装：按 (3*高, 3*宽) 画布拼接 9 张图"""
        if _hw_pair(self.imgsz) is None:
            return _orig_mosaic9(self, labels)

        h, w = self.imgsz  # 单张图目标 (高, 宽)
        mosaic_labels = []
        hp, wp = -1, -1  # 上一张图的高、宽
        for i in range(9):
            labels_patch = labels if i == 0 else labels["mix_labels"][i - 1]
            # Load image
            img = labels_patch["img"]
            hp_cur, wp_cur = labels_patch.pop("resized_shape")

            # Place img in img9（画布 3H × 3W，中心块左上角位于 (宽W, 高H)）
            if i == 0:  # center
                img9 = np.full((h * 3, w * 3, img.shape[2]), 114, dtype=np.uint8)  # base image with 9 tiles
                h0, w0 = hp_cur, wp_cur
                c = w, h, w + wp_cur, h + hp_cur  # xmin, ymin, xmax, ymax (base) coordinates
            elif i == 1:  # top
                c = w, h - hp_cur, w + wp_cur, h
            elif i == 2:  # top right
                c = w + wp, h - hp_cur, w + wp + wp_cur, h
            elif i == 3:  # right
                c = w + w0, h, w + w0 + wp_cur, h + hp_cur
            elif i == 4:  # bottom right
                c = w + w0, h + hp, w + w0 + wp_cur, h + hp + hp_cur
            elif i == 5:  # bottom
                c = w + w0 - wp_cur, h + h0, w + w0, h + h0 + hp_cur
            elif i == 6:  # bottom left
                c = w + w0 - wp - wp_cur, h + h0, w + w0 - wp, h + h0 + hp_cur
            elif i == 7:  # left
                c = w - wp_cur, h + h0 - hp_cur, w, h + h0
            else:  # top left
                c = w - wp_cur, h + h0 - hp - hp_cur, w, h + h0 - hp

            padw, padh = c[:2]
            x1, y1, x2, y2 = (max(x, 0) for x in c)  # allocate coords

            # Image
            img9[y1:y2, x1:x2] = img[y1 - padh :, x1 - padw :]  # img9[ymin:ymax, xmin:xmax]
            hp, wp = hp_cur, wp_cur  # 记录上一张图的高、宽

            # Labels assuming mosaic size（x 方向加宽度边框, y 方向加高度边框）
            labels_patch = self._update_labels(labels_patch, padw + self.border[1], padh + self.border[0])
            mosaic_labels.append(labels_patch)
        final_labels = self._cat_labels(mosaic_labels)

        final_labels["img"] = img9[-self.border[0] : self.border[0], -self.border[1] : self.border[1]]
        return final_labels

    def _mosaic_cat_labels_rect(self, mosaic_labels):
        """Mosaic._cat_labels 包装：马赛克输出尺寸记为 (2*高, 2*宽)"""
        hw = _hw_pair(self.imgsz)
        if hw is None:
            return _orig_mosaic_cat_labels(self, mosaic_labels)
        if len(mosaic_labels) == 0:
            return {}

        cls = []
        instances = []
        h, w = hw[0] * 2, hw[1] * 2  # 马赛克画布尺寸 (高, 宽)
        for labels in mosaic_labels:
            cls.append(labels["cls"])
            instances.append(labels["instances"])
        # Final labels
        final_labels = {
            "im_file": mosaic_labels[0]["im_file"],
            "ori_shape": mosaic_labels[0]["ori_shape"],
            "resized_shape": (h, w),
            "cls": np.concatenate(cls, 0),
            "instances": Instances.concatenate(instances, axis=0),
            "mosaic_border": self.border,
        }
        final_labels["instances"].clip(w, h)
        good = final_labels["instances"].remove_zero_area_boxes()
        final_labels["cls"] = final_labels["cls"][good]
        if "texts" in mosaic_labels[0]:
            final_labels["texts"] = mosaic_labels[0]["texts"]
        return final_labels

    _augment.Mosaic.__init__ = _mosaic_init_rect
    _augment.Mosaic._mosaic4 = _mosaic4_rect
    _augment.Mosaic._mosaic9 = _mosaic9_rect
    _augment.Mosaic._cat_labels = _mosaic_cat_labels_rect

    # ============================================================
    # 补丁4: 训练/验证变换管线按 (高, 宽) 定尺
    # ============================================================
    # [2026-09-26 17:12:00] 修复: v8_transforms/build_transforms 把 imgsz 当标量，两元素尺寸下 LetterBox 形状错误
    # 原因: v8_transforms 中 LetterBox(new_shape=(imgsz, imgsz))、YOLODataset.build_transforms 中
    #       LetterBox(new_shape=(self.imgsz, self.imgsz)) 都以「(imgsz, imgsz)」的正方形方式组装目标尺寸，
    #       传入 (480, 640) 会变成 ((480, 640), (480, 640)) 这种非法形状
    # 解决方案: 两元素尺寸时按 (高, 宽) 直接构造：LetterBox(new_shape=(H, W))、Mosaic(imgsz=(H, W))，
    #       其余增强（MixUp/Albumentations/RandomHSV/RandomFlip）与原生顺序保持一致；整数尺寸调用原函数
    # 说明: LetterBox 本身支持非正方形 new_shape，因此训练（Mosaic/RandomPerspective 链）与验证（直接 LetterBox）
    #       都会把图像定尺到精确的 (高480, 宽640)
    _orig_v8_transforms = _augment.v8_transforms

    def _v8_transforms_rect(dataset, imgsz, hyp, stretch=False):
        """v8_transforms 包装：支持 (高, 宽) 两元素 imgsz"""
        hw = _hw_pair(imgsz)
        if hw is None:
            return _orig_v8_transforms(dataset, imgsz, hyp, stretch=stretch)

        pre_transform = _augment.Compose(
            [
                _augment.Mosaic(dataset, imgsz=hw, p=hyp.mosaic),
                _augment.CopyPaste(p=hyp.copy_paste),
                _augment.RandomPerspective(
                    degrees=hyp.degrees,
                    translate=hyp.translate,
                    scale=hyp.scale,
                    shear=hyp.shear,
                    perspective=hyp.perspective,
                    pre_transform=None if stretch else _augment.LetterBox(new_shape=hw),
                ),
            ]
        )
        flip_idx = dataset.data.get("flip_idx", [])  # for keypoints augmentation
        if dataset.use_keypoints:
            kpt_shape = dataset.data.get("kpt_shape", None)
            if len(flip_idx) == 0 and hyp.fliplr > 0.0:
                hyp.fliplr = 0.0
                LOGGER.warning("WARNING ⚠️ No 'flip_idx' array defined in data.yaml, setting augmentation 'fliplr=0.0'")
            elif flip_idx and (len(flip_idx) != kpt_shape[0]):
                raise ValueError(f"data.yaml flip_idx={flip_idx} length must be equal to kpt_shape[0]={kpt_shape[0]}")

        return _augment.Compose(
            [
                pre_transform,
                _augment.MixUp(dataset, pre_transform=pre_transform, p=hyp.mixup),
                _augment.Albumentations(p=1.0),
                _augment.RandomHSV(hgain=hyp.hsv_h, sgain=hyp.hsv_s, vgain=hyp.hsv_v),
                _augment.RandomFlip(direction="vertical", p=hyp.flipud),
                _augment.RandomFlip(direction="horizontal", p=hyp.fliplr, flip_idx=flip_idx),
            ]
        )

    # [2026-09-26 17:12:00] 新增: YOLODataset.build_transforms 支持两元素 imgsz 的验证/训练变换
    # 原因: 验证（augment=False）分支使用 LetterBox(new_shape=(self.imgsz, self.imgsz)) 组装正方形目标尺寸
    # 解决方案: 包装 build_transforms，两元素尺寸时训练分支改用 _v8_transforms_rect，验证分支改用
    #       LetterBox(new_shape=(H, W))；Format 参数与原生完全一致
    # 说明: 训练中后期 close_mosaic() 会重新调用 build_transforms，同样走本包装逻辑
    _orig_build_transforms = _dataset.YOLODataset.build_transforms

    def _build_transforms_rect(self, hyp=None):
        """YOLODataset.build_transforms 包装：支持 (高, 宽) 两元素 imgsz"""
        hw = _hw_pair(self.imgsz)
        if hw is None:
            return _orig_build_transforms(self, hyp)

        if self.augment:
            hyp.mosaic = hyp.mosaic if self.augment and not self.rect else 0.0
            hyp.mixup = hyp.mixup if self.augment and not self.rect else 0.0
            transforms = _v8_transforms_rect(self, hw, hyp)
        else:
            transforms = _augment.Compose([_augment.LetterBox(new_shape=hw, scaleup=False)])
        transforms.append(
            _augment.Format(
                bbox_format="xywh",
                normalize=True,
                return_mask=self.use_segments,
                return_keypoint=self.use_keypoints,
                return_obb=self.use_obb,
                batch_idx=True,
                mask_ratio=hyp.mask_ratio,
                mask_overlap=hyp.overlap_mask,
                bgr=hyp.bgr if self.augment else 0.0,  # only affect training.
            )
        )
        return transforms

    _augment.v8_transforms = _v8_transforms_rect
    _dataset.v8_transforms = _v8_transforms_rect
    _dataset.YOLODataset.build_transforms = _build_transforms_rect

    # ============================================================
    # 补丁5: 验证模型预热尺寸支持非正方形
    # ============================================================
    # [2026-09-26 17:12:00] 修复: 独立验证（model.val）时 warmup 传入嵌套尺寸会报 TypeError
    # 原因: engine/validator.py 中 model.warmup(imgsz=(1, 3, imgsz, imgsz)) 的 imgsz 来自
    #       check_imgsz(..., min_dim=2)，两元素尺寸时为 [480, 640]，拼出 (1, 3, [480, 640], [480, 640])
    #       这种嵌套元组，torch.empty(*imgsz) 无法解析
    # 解决方案: 包装 AutoBackend.warmup，检测到 (N, C, [H, W], [H, W]) 形式时展开为 (N, C, H, W)；其它情况原样调用
    _orig_warmup = _autobackend.AutoBackend.warmup

    def _warmup_rect(self, imgsz=(1, 3, 640, 640)):
        """AutoBackend.warmup 包装：兼容 (N, C, [H, W], [H, W]) 的嵌套尺寸写法"""
        if (
            isinstance(imgsz, (list, tuple))
            and len(imgsz) == 4
            and _hw_pair(imgsz[2]) is not None
            and _hw_pair(imgsz[3]) is not None
        ):
            hw = _hw_pair(imgsz[2])
            imgsz = (imgsz[0], imgsz[1], hw[0], hw[1])
        return _orig_warmup(self, imgsz=imgsz)

    _autobackend.AutoBackend.warmup = _warmup_rect

    # ============================================================
    # 补丁6: 自动批大小（batch=-1）在非正方形分辨率下给出明确提示
    # ============================================================
    # [2026-09-26 17:12:00] 修复: batch=-1 自动批大小时按标量 imgsz 构造测试张量，两元素尺寸下会报错
    # 原因: utils/autobatch.py 的 autobatch() 用 torch.empty(b, 3, imgsz, imgsz) 构造测试输入，
    #       两元素尺寸时形状非法（autobatch 未适配非正方形）
    # 解决方案: 包装 autobatch，两元素尺寸时打印警告并回退为默认 batch（本工程训练脚本已显式指定 BATCH，
    #       不会走到该分支），整数尺寸时调用原函数
    _orig_autobatch = _autobatch.autobatch

    def _autobatch_rect(model, imgsz=640, fraction=0.60, batch_size=_autobatch.DEFAULT_CFG.batch):
        """autobatch 包装：非正方形分辨率暂不支持自动批大小，回退默认值"""
        if _hw_pair(imgsz) is not None:
            LOGGER.warning(
                f"WARNING ⚠️ 非正方形分辨率 imgsz={tuple(_hw_pair(imgsz))} 暂不支持自动批大小(batch=-1)，"
                f"回退为 batch={batch_size}，建议在训练脚本中显式指定 BATCH"
            )
            return batch_size
        return _orig_autobatch(model, imgsz=imgsz, fraction=fraction, batch_size=batch_size)

    _autobatch.autobatch = _autobatch_rect

    # ============================================================
    # 补丁7: 类别编号归一化（数据集类别数 = yaml 中 names 的数量）
    # ============================================================
    # [2026-09-26 17:12:00] 修改: 不再为缺失编号补占位类名，改为把标签编号映射为连续的 0..N-1
    # 原因: RDD_2026 沿用 RDD2022 原始编号 0/1/2/4（3=other corrosion 在本数据集中无样本），
    #       若保留原始编号，nc 只能是 5（多出一个无样本的占位类别 unused_3，会把验证 mAP 均值拉低）；
    #       本次训练目标为 4 类模型（nc=4）
    # 解决方案: ① check_class_names() 允许编号不连续（编号连续时仍走原生逻辑，保留 ImageNet 名称映射）；
    #       ② check_det_dataset() 按 names 的键排序建立「原始编号 → 训练编号(0..N-1)」映射，
    #          把 names 归一化为 0..N-1 并令 nc = len(names)；
    #       ③ YOLODataset.get_labels() 按该映射重写标签 cls（只在内存中转换，磁盘标签文件与 yaml 均不改动）；
    #       ④ 若标签里出现 names 中未定义的编号（例如只把 yaml 改成 0..3 而未同步修改标签），
    #          抛出明确中文报错并给出两种解决办法
    # 说明: RDD_2026 的映射为 {0:0, 1:1, 2:2, 4:3}，最终 nc=4，
    #       类别含义为 0=纵向裂缝 1=横向裂缝 2=龟裂 3=坑洞（坑洞编号由 4 变为 3，使用模型时按 4 类解析）；
    #       标签校验处（verify_image_label）用的是 num_cls <= 判断，原始编号 4 在 nc=4 时不会误判为损坏
    #       [2026-10-08 10:15:07] 补充: 本工程（yolov5）4:3 实验用的 RDD_China 类别编号本身连续
    #       （0=crack / 1=alligator crack / 2=pothole，nc=3），映射为恒等映射，且 check_class_names /
    #       check_det_dataset 会直接走原生分支，不改变任何编号与类别数
    from ultralytics.data import utils as _data_utils

    _orig_check_class_names = _autobackend.check_class_names
    _orig_check_det_dataset = _data_utils.check_det_dataset
    _orig_get_labels = _dataset.YOLODataset.get_labels

    def _check_class_names_gap(names):
        """check_class_names 包装：允许类别编号不连续（如 0/1/2/4）"""
        if isinstance(names, list):  # names is a list
            names = dict(enumerate(names))
        if isinstance(names, dict):
            names = {int(k): str(v) for k, v in names.items()}
            keys = sorted(names)
            if keys == list(range(len(keys))):  # 编号连续 → 完全走原生逻辑
                return _orig_check_class_names(names)
            LOGGER.warning(
                f"WARNING ⚠️ 数据集类别编号不连续 {keys}，训练时将按顺序映射为 0-{len(keys) - 1}："
                + "，".join(f"{k}→{i}" for i, k in enumerate(keys))
            )
            return names
        raise TypeError(f"'{names}' is of invalid type {type(names).__name__}. Valid 'names' types are dict or list")

    def _check_det_dataset_gap(dataset="coco8.yaml", autodownload=True):
        """check_det_dataset 包装：按 names 键顺序归一化类别编号，nc = names 数量"""
        data = _orig_check_det_dataset(dataset, autodownload)
        names = data.get("names")
        if isinstance(names, dict) and names:
            keys = sorted(names)
            data["nc"] = len(keys)  # 类别数 = names 数量（不再补占位类别）
            data["names"] = {i: names[k] for i, k in enumerate(keys)}  # 类别名归一化为 0..N-1
            data["class_map"] = {k: i for i, k in enumerate(keys)}  # 原始标签编号 → 训练编号
            if any(k != v for k, v in data["class_map"].items()):
                LOGGER.warning(
                    f"WARNING ⚠️ 数据集 {Path(str(dataset)).name} 共 {len(keys)} 类，"
                    f"标签原始编号将按 {data['class_map']} 映射为训练编号（仅内存转换，标签文件与 yaml 均不改动）"
                )
        return data

    def _get_labels_mapped(self):
        """YOLODataset.get_labels 包装：把标签类别编号按 class_map 映射为 0..nc-1，并校验编号一致性"""
        labels = _orig_get_labels(self)
        if not labels or not isinstance(self.data, dict):
            return labels

        cmap = self.data.get("class_map") or {}
        nc = int(self.data.get("nc") or 0)
        if nc <= 0 and cmap:
            nc = max(cmap) + 1
        if nc <= 0:
            return labels

        size = max(max(cmap) + 1 if cmap else 0, nc)  # 查表长度：需覆盖原始编号与训练编号
        lut = np.full(size, -1, dtype=np.int64)  # -1 表示该编号在数据集中未定义
        for i in range(nc):  # 连续编号数据集：训练编号可直接作为原始编号
            lut[i] = i
        for k, v in cmap.items():  # 非连续原始编号 → 训练编号
            lut[k] = v
        remap_needed = any(k != v for k, v in cmap.items())

        for lb in labels:
            cls = lb.get("cls")
            if cls is None or len(cls) == 0:
                continue
            ids = cls.astype(np.int64).ravel()
            unknown = sorted({int(i) for i in ids if i >= size or lut[i] < 0})
            if unknown:
                raise ValueError(
                    f"数据集类别编号不一致：{self.prefix}标签中出现编号 {unknown}，"
                    f"但数据集 yaml 的 names 只定义了 {sorted(cmap) if cmap else list(range(nc))}（nc={nc}）。请二选一：\n"
                    f"  ① 在 yaml 的 names 中保留这些编号（如 4: pothole），脚本会自动映射为训练编号；\n"
                    f"  ② 或把标签文件（labels/*.txt 第一列）中的这些编号改成 yaml 中对应的编号（如 4 → 3）"
                )
            if remap_needed:
                lb["cls"] = lut[ids].reshape(cls.shape).astype(cls.dtype)
        return labels

    # 同时替换「定义处」与「已按名导入处」的引用；之后被延迟导入的模块也会自动拿到补丁后的版本
    _autobackend.check_class_names = _check_class_names_gap
    _data_utils.check_class_names = _check_class_names_gap
    _data_utils.check_det_dataset = _check_det_dataset_gap
    _dataset.YOLODataset.get_labels = _get_labels_mapped
    _rebind_module_attr("check_class_names", _orig_check_class_names, _check_class_names_gap)
    _rebind_module_attr("check_det_dataset", _orig_check_det_dataset, _check_det_dataset_gap)
    _rebind_module_attr("check_imgsz", _orig_check_imgsz, _check_imgsz_rect)

    if verbose:
        LOGGER.info(
            f"非正方形分辨率支持已启用（补丁 {len(_PATCHES)} 项），当前 ultralytics 版本 {ultralytics.__version__}，"
            "imgsz 可传入 (高 H, 宽 W) 形式"
        )
