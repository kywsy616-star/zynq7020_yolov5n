# Ultralytics YOLO 🚀, AGPL-3.0 license
"""
训练检查点保存加固补丁（运行时补丁，不改动 ultralytics 库文件）

功能说明:
  包装 ultralytics 的 torch_save，使检查点保存失败时先做退避重试，而不是直接把整轮训练打断。

使用方法:
  在训练脚本的「模块顶层」调用一次（必须在 model.train() 之前）：
      import safe_save
      safe_save.enable_safe_save()

注意事项:
  1. 必须在模块顶层调用（与 rect_imgsz 同理），否则多进程 DataLoader 的 worker 子进程拿不到补丁；
  2. 只包一层重试，不改变保存的文件名、路径与内容；
  3. 重试全部失败时仍会抛出原异常（避免掩盖真正的错误）。
"""

# [2026-09-26 21:00:00] 新增: 检查点保存失败自动退避重试，避免一次 I/O 抖动终结整轮训练
# 原因: train4 在第 58 轮结束调用 trainer.save_model() 保存 last.pt 时抛
#       ValueError: I/O operation on closed file（save_model 内部把 ckpt 序列化到缓冲区时句柄已关闭），
#       而 ultralytics 自带的 torch_save 只捕获 RuntimeError 重试 3 次
#       （源码注释：possibly waiting for device to flush or antivirus scan），遇到 ValueError/OSError
#       会直接向上抛 → 十几分钟的训练当场结束，只剩上一次的 last.pt / best.pt
# 解决方案: 用运行时补丁把 torch_save 包成「失败后按 0.5s→1s→2s→4s 退避重试」的版本（默认最多 5 次尝试），
#       并覆盖两处引用：① ultralytics.utils.patches.torch_save（模块属性）
#       ② ultralytics.engine.trainer.torch_save（trainer.py 用 from ... import torch_save 绑定，
#          只改 patches 模块里的同名函数不会影响它，必须一并替换才生效）
# 说明: 成功路径零额外开销（第一次调用即返回）；重试仍失败时抛出原异常，不会掩盖真正的错误；
#       实测确认拦截点必须是 torch.save —— trainer.save_model() 里写的是 torch.save(ckpt, buffer)，
#       而 ultralytics 在 import 时已把 torch.save 换成自己的 torch_save，只改 patches 模块属性无效；
#       另外从第二次重试起改用标准 pickle（use_dill=False），绕开 dill 序列化路径
import inspect
import time

import torch

from ultralytics.utils import patches as _patches

_ORIG_TORCH_SAVE = _patches.torch_save  # 保留原始实现（ultralytics 版 torch_save），便于回溯/恢复
_ENABLED = False


def _supports_use_dill(func):
    """判断目标函数是否带 use_dill 开关（ultralytics 的 torch_save 有，标准 torch.save 没有）"""
    try:
        return "use_dill" in inspect.signature(func).parameters
    except (TypeError, ValueError):
        return False


def _wrap_with_retry(orig, retries, verbose):
    """把保存函数包装成失败后退避重试的版本（重试 retries 次仍失败则抛出原异常）"""
    allow_no_dill = _supports_use_dill(orig)  # 目标函数是否支持重试时改用标准 pickle

    def _retrying(*args, **kwargs):
        for attempt in range(retries + 1):
            call_kwargs = dict(kwargs)
            if attempt >= 1 and allow_no_dill:
                # 二次重试起改用标准 pickle：ultralytics 默认用 dill 序列化（torch_save(use_dill=True)），
                # 而检查点内容（model / ema / optimizer / train_args）用标准 pickle 完全可序列化
                call_kwargs["use_dill"] = False
            try:
                return orig(*args, **call_kwargs)
            except Exception as exc:  # 覆盖 ValueError / OSError / RuntimeError 等各类保存异常
                if attempt >= retries:
                    raise
                delay = (2**attempt) / 2.0  # 0.5s, 1.0s, 2.0s, ...
                if verbose:
                    print(
                        f"[safe_save] 检查点保存第 {attempt + 1} 次失败"
                        f"（{type(exc).__name__}: {exc}），{delay:.1f}s 后重试（剩余 {retries - attempt} 次）",
                        flush=True,
                    )
                time.sleep(delay)

    return _retrying


def enable_safe_save(verbose=True, retries=4):
    """
    启用检查点保存重试补丁。

    参数:
        verbose (bool): 是否打印启用日志与重试过程
        retries (int): 失败后额外重试的次数（默认 4，即最多 5 次尝试）

    返回:
        bool: True 表示已启用（含此前已启用的情况），False 表示启用失败
    """
    global _ENABLED
    if _ENABLED:
        return True

    wrapped = _wrap_with_retry(_ORIG_TORCH_SAVE, retries, verbose)
    replaced = []

    # ① torch.save —— 真正要拦的入口：trainer.save_model() 里写的是 torch.save(ckpt, buffer)，
    #    而 ultralytics 在 import 时已把 torch.save 替换成自己的 torch_save，
    #    因此只改 patches 模块里的同名函数不会生效，必须替换 torch.save 这个属性
    if getattr(torch, "save", None) is not None:
        torch.save = wrapped
        replaced.append("torch.save")

    # ② ultralytics.utils.patches.torch_save（库内其它直接引用该函数的地方）
    _patches.torch_save = wrapped
    replaced.append("ultralytics.utils.patches.torch_save")

    # ③ 少数版本会把 torch_save 直接绑定进 trainer 模块，存在时一并替换（不存在则跳过）
    try:
        from ultralytics.engine import trainer as _trainer

        if getattr(_trainer, "torch_save", None) is not None:
            _trainer.torch_save = wrapped
            replaced.append("ultralytics.engine.trainer.torch_save")
    except Exception as exc:  # 库结构变化时不影响其它功能
        if verbose:
            print(f"[safe_save] 检查 trainer 模块内的 torch_save 时跳过: {exc}")

    _ENABLED = True
    if verbose:
        print(
            f"[safe_save] 检查点保存重试已启用（最多 {retries + 1} 次尝试，退避 0.5s/1s/2s/4s），"
            f"已覆盖: {'、'.join(replaced)}"
        )
    return True
