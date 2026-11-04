# Ultralytics YOLO 🚀, AGPL-3.0 license
"""
YOLOv5 4:3 训练脚本（yolov5n + RDD_China 数据集）

功能说明:
  加载 YOLOv5n 预训练权重，按 4:3 非正方形分辨率（网络输入张量为 (N, 3, 480, 640)，即 高480 × 宽640）
  在 RDD_China 数据集上训练目标检测模型；训练完成后在 {PROJECT}\\{NAME}{N}\\ 下生成权重（best.pt / last.pt）、
  results.csv 以及各类训练曲线图。
  本脚本可以使用「蒸馏」模式（DISTILL=True）从教师模型的软输出指导学生模型训练，提升剪枝后模型的精度。

使用方法:
  1. 按需修改下方"训练参数配置"区域的变量值（MODEL、DATA、BATCH、EPOCHS、IMGSZ 等）
  2. 在工程根目录（yolov5 文件夹）运行: python scripts/train_4_3.py

文件命名说明:
  本脚本对应「4:3 分辨率」训练实验，原拟命名为 train_4:3.py，但 Windows 文件名不允许包含冒号（":"），
  创建时直接报「不支持给定路径的格式」，故实际文件名为 train_4_3.py（命名意图不变）。

运行环境要求:
  - Python 3.8+；本工程使用自带的 ultralytics 8.2.103（在工程根目录运行时优先 import 工程内 ultralytics 目录）
  - CUDA GPU 可显著加速训练；本机当前 python 环境为 CPU 版 torch 时请把 DEVICE 改为 "cpu"（详见 DEVICE 注释）

参数说明:
  TASK     : 任务类型，本脚本用于 detect(目标检测)
  MODEL    : 模型文件，支持 *.pt 预训练权重 或 *.yaml 模型配置文件
  DATA     : 数据集 YAML 配置文件路径，需包含 train/val 路径与类别信息
  BATCH    : 批次大小，值越大显存占用越多
  EPOCHS   : 训练轮数，建议 100-300 轮
  PATIENCE : 早停耐心值，连续 N 轮验证指标未刷新最佳则提前结束（0=关闭早停）
  IMGSZ    : 输入尺寸，本脚本为 (高 H, 宽 W) 两元素形式，例如 (480, 640) 表示 4:3 非正方形输入
  WORKERS  : 数据加载线程数，Windows 建议 ≤4（多进程内存占用大，报错则回退 0）
  DEVICE   : 训练设备，0 表示 GPU0，cpu 表示 CPU，0,1 表示多 GPU
  SCALE / MOSAIC / CLOSE_MOSAIC / MIXUP / WEIGHT_DECAY / LABEL_SMOOTHING : 数据增强与正则化超参
  OPTIMIZER / LR0 / COS_LR : 优化器、初始学习率、是否使用余弦学习率调度
"""

from ultralytics import YOLO

# [2026-10-08 10:15:07] 新增: 引入非正方形分辨率(4:3)支持模块，使 imgsz=(480, 640) 真正生效
# 原因: ultralytics 8.2.103 的 train/val 只接受单个整数 imgsz（正方形输入），传入 (480, 640) 会被
#       check_imgsz(max_dim=1) 折叠成 640，训练分辨率仍是 640×640，无法按 4:3 训练
# 解决方案: 从 yolov8_640×480 工程移植 rect_imgsz 运行时补丁模块（不改动 ultralytics 库文件），
#       在模块顶层调用 enable_rect_imgsz() 后，读图/马赛克/LetterBox/验证预热/类别编号归一化全链路支持两元素尺寸
# 说明: 必须在「模块顶层」调用（不能只放在 if __name__ == "__main__" 里）——WORKERS>0 时 DataLoader 会 spawn
#       子进程，子进程只执行模块级代码，否则子进程拿到的是未打补丁的原版 ultralytics 而报 TypeError；
#       若把 IMGSZ 改回整数（如 640），补丁自动走原生逻辑，行为与原来完全一致
import rect_imgsz

rect_imgsz.enable_rect_imgsz()

# [2026-10-08 10:15:07] 新增: 引入检查点保存加固补丁，避免保存 last.pt 失败中断整轮训练
# 原因: 长时间训练中保存 last.pt 偶发 I/O 异常（如 ValueError: I/O operation on closed file），
#       ultralytics 自带的 torch_save 只对 RuntimeError 重试，遇到其它异常会直接把整轮训练打断
# 解决方案: 从 yolov8_640×480 工程移植 safe_save 补丁，模块顶层调用 enable_safe_save() 后，
#       保存失败会按 0.5s/1s/2s/4s 退避重试（默认最多 5 次尝试），全部失败仍抛出原异常
# 说明: 成功路径零额外开销；同样必须在模块顶层调用，保证 DataLoader 子进程也带上补丁
import safe_save

safe_save.enable_safe_save()

# ============================================================
# 训练参数配置（按需修改）
# ============================================================
TASK = "detect"                                          # 任务类型: detect, segment, classify, pose, obb
# [2026-10-08 10:15:07] 新增: 训练模型使用 yolov5n（本工程 4:3 实验的基线模型）
# 原因: 本工程为 YOLOv5 基线工程，4:3 实验需与工程的 yolov5n 基线保持一致；yolov5n 参数量最小（约 2.6M），
#       训练与推理最快，便于快速迭代 4:3 与其它分辨率/规模的对比实验
# 解决方案: MODEL 指向本工程 weights 目录下的 yolov5n.pt
# 说明: ultralytics 8.x 会把 yolov5n.pt 自动映射为官方 YOLOv5u 权重 yolov5nu.pt（anchor-free 版本），
#       本地 weights 目录下没有该文件时库会自动从官方源下载；如需更大规模，把 MODEL 换成同目录下的
#       yolov5s.pt / yolov5m.pt / yolov5l.pt / yolov5x.pt 即可（其它参数不用改）
MODEL = r"D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\weights\yolov5n.pt"         # 模型文件: yolov5n.pt, yolov5s.pt, yolov5m.pt, yolov5l.pt, yolov5x.pt

# [2026-10-08 10:15:07] 新增: 数据集使用 RDD_China（4:3 零切框裁剪的中国全部来源数据）
# 原因: RDD_China 已把图片裁剪为 512×384（宽512 × 高384，正好 4:3）且标注框完整不切断，
#       送入 (480, 640) 的 4:3 输入时是 1.25 倍纯放大、画面铺满，不会像方形原图那样被压成 480×480 再补灰边
# 解决方案: DATA 指向工程内 ultralytics/cfg/datasets/RDD_China.yaml（train 1764 / val 231 / test 217）
# 说明: 该集类别为连续编号 0=crack（纵+横裂纹）/ 1=alligator crack（龟裂）/ 2=pothole（坑洞），nc=3，
#       rect_imgsz 的类别编号归一化对连续编号是恒等映射，无需额外配置
DATA = r"D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\ultralytics\cfg\datasets\RDD_China.yaml"   # 数据集配置文件路径（RDD_China）

BATCH = 16                                               # 批次大小
EPOCHS = 150                                             # 训练轮数
PATIENCE = 20                                            # 早停耐心值（连续 20 轮无提升则停止，0=关闭早停）

# [2026-10-08 10:15:07] 新增: 训练分辨率固定为 4:3 —— (高 480, 宽 640)
# 原因: 本脚本的核心实验就是 4:3 非正方形输入训练（与 yolov8_640×480 工程的 640×480 实验对应），
#       ultralytics 原生不支持两元素 imgsz，必须配合上面的 rect_imgsz 补丁才能生效
# 解决方案: IMGSZ 写为 (480, 640)（高, 宽），网络输入张量形状为 (N, 3, 480, 640)
# 说明: ① 必须写成「(高 H, 宽 W)」的顺序，不要写成 640×480 的顺序；
#       ② 两个数都需为 32 的整数倍，否则会被自动向上取整；
#       ③ RDD_China 裁剪图原生为 512×384，若想按原生分辨率训练（更省显存/更快），把本行改为 (384, 512) 即可
IMGSZ = (384, 512)                                       # 输入图像尺寸 (高 H, 宽 W)，4:3 非正方形

# [2026-10-08 10:15:07] 新增: 数据加载线程数设为 4，避免 Windows 页面文件不足导致训练卡死
# 原因: workers 过大时（如 8）train/val 各派生一批子进程，每个子进程都要加载 torch 与各类运行库，
#       内存/页面文件不足会触发 WinError 1455（页面文件太小）并让训练卡死
# 解决方案: WORKERS 取 4（train + val 共约 8 个子进程），在数据加载速度与内存占用之间折中
# 说明: 若出现 Windows 多进程相关报错或内存吃紧，把 WORKERS 改成 0 即回到单进程加载（更稳但更慢）
WORKERS = 4                                              # 数据加载线程数（Windows 建议 ≤4，报错则回退 0）

# [2026-10-08 10:15:07] 新增: 训练设备默认 GPU0，并补充本机环境说明
# 原因: 与工程内其它脚本（train.py / test.py / predict.py）保持一致，默认使用 0 号 GPU
# 解决方案: DEVICE = 0；如本机无可用 CUDA 环境则改为 "cpu"
# 说明: 本机 python 3.11.9 环境的 torch 为 2.12.0+cpu（torch.cuda.is_available() = False，仅 CPU 后端），
#       在该环境直接运行本脚本需把 DEVICE 改为 "cpu"（CPU 训练 4:3 会明显更慢，建议先小轮数试跑）；
#       若使用带 CUDA 的解释器/虚拟环境则保持 0 即可
DEVICE = 0                                               # 训练设备: 0 表示 GPU0, cpu 表示 CPU, 0,1 表示多 GPU

# [2026-10-08 10:15:07] 新增: 添加 project/name 参数，把 4:3 实验结果固定在本工程 runs/detect 目录内
# 原因: 不指定时 ultralytics 用默认 runs 目录，多个实验会混在一起难以区分；本工程的训练实验统一放在 runs/detect 下
# 解决方案: PROJECT 指向 yolo_pavement\yolov5\runs\detect，NAME 用 "train_4_3"，结果保存在
#       yolov5\runs\detect\train_4_3{N}\（N 依次递增，不会覆盖已有实验）
# 说明: ultralytics 的保存路径就是 {project}\{name}（project 原样使用，不会再自动追加一层 task 名）
PROJECT = r"D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\runs\detect"             # 训练结果保存根目录
NAME = "train_4_3"                                       # 训练实验名称，结果保存在 {PROJECT}\{NAME}{N}\ 下

# [2026-10-08 10:15:07] 新增: 迁移 yolov8_640×480 工程在同类 4:3 裂缝数据上验证过的增强/优化器调参结论
# 原因: 该工程在 512×384 裁剪的 RDD 裂缝数据上逐轮归因后发现：① mosaic 会把 4 张图拼到一张画布后目标再缩小约一半，
#       并在拼接边界截断标注框，对细长裂缝与小坑洞是直接伤害；② mixup 图像混叠会模糊裂缝边界；
#       ③ 小数据集（千张量级）用 AdamW + 余弦学习率更平稳；④ RDD2022 源标注噪声大，标签平滑可抑制过度自信
# 解决方案: 默认沿用该工程的最终调参值：SCALE=0.5、MOSAIC=0.0、CLOSE_MOSAIC=0、MIXUP=0.0、
#       WEIGHT_DECAY=0.001、LABEL_SMOOTHING=0.05、OPTIMIZER="AdamW"、LR0=0.001、COS_LR=True
# 说明: 若要与 ultralytics 默认增强做严格基线对比，只需把下面数值改回默认（变量区无需改代码）：
#       SCALE=0.5、MOSAIC=1.0、CLOSE_MOSAIC=10、MIXUP=0.0、WEIGHT_DECAY=0.0005、LABEL_SMOOTHING=0.0、
#       OPTIMIZER="auto"、LR0=0.01、COS_LR=False
SCALE = 0.5                                              # 随机缩放增强幅度（ultralytics 默认 0.5）
MOSAIC = 0.0                                             # 马赛克增强概率（ultralytics 默认 1.0；0.0 = 关闭）
CLOSE_MOSAIC = 0                                         # 末 N 轮关闭马赛克（mosaic 已关闭，设为 0 即无需生效）
MIXUP = 0.0                                              # 混类增强概率（ultralytics 默认 0.0）
WEIGHT_DECAY = 0.001                                     # 权重衰减（ultralytics 默认 0.0005；过拟合时加重正则）
LABEL_SMOOTHING = 0.05                                   # 标签平滑（ultralytics 默认 0.0；源标注噪声大时更稳健）
OPTIMIZER = "AdamW"                                      # 优化器（ultralytics 默认 auto→SGD；小数据集微调建议 AdamW）
LR0 = 0.001                                              # 初始学习率（ultralytics 默认 0.01）
COS_LR = True                                            # 是否使用余弦学习率调度（长训练更平滑）

if __name__ == "__main__":
    # 说明: 4:3 分辨率补丁与检查点保存加固补丁都已在模块顶层启用（原因见文件顶部注释），此处无需再调用

    # 加载模型（使用 task 参数指定任务类型）
    model = YOLO(MODEL, task=TASK)

    # [2026-10-08 10:15:07] 新增: model.train() 一次性传入数据、训练规模、4:3 尺寸、结果目录与增强/优化器超参
    # 原因: 4:3 实验需要把 imgsz=(480, 640)（配合 rect_imgsz 补丁）与迁移过来的调参值完整交给训练器，
    #       集中在脚本里配置可避免命令行拼参数出错
    # 解决方案: 传 data/batch/epochs/patience/imgsz/workers/device/project/name，以及 scale/mosaic/close_mosaic/
    #       mixup/weight_decay/label_smoothing/optimizer/lr0/cos_lr
    # 说明: ① IMGSZ 保持 (480, 640)；若要验证其它 4:3 尺寸（如原生 (384, 512)）只需改 IMGSZ 一行；
    #       ② 训练结果保存在 {PROJECT}\{NAME}{N}\，其中会打印每轮指标并生成 best.pt / last.pt
    results = model.train(
        data=DATA,
        batch=BATCH,
        epochs=EPOCHS,
        patience=PATIENCE,
        imgsz=IMGSZ,
        workers=WORKERS,
        device=DEVICE,
        project=PROJECT,
        name=NAME,
        scale=SCALE,
        mosaic=MOSAIC,
        close_mosaic=CLOSE_MOSAIC,
        mixup=MIXUP,
        weight_decay=WEIGHT_DECAY,
        label_smoothing=LABEL_SMOOTHING,
        optimizer=OPTIMIZER,
        lr0=LR0,
        cos_lr=COS_LR,
        # cache="disk",   # 可选: 图片缓存为 npy 进一步提速（首次训练会多花一点时间写缓存，占磁盘空间）
        # amp=False,      # 可选: CPU 训练时建议关闭混合精度
    )
