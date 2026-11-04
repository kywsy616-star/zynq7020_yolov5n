# Ultralytics YOLO 🚀, AGPL-3.0 license
"""
YOLOv5 训练脚本

功能说明:
  加载预训练模型，使用指定的数据集进行目标检测（或分割/分类/姿态估计/旋转框检测）训练。
  训练完成后会在 runs/detect/train{N}/ 目录下生成训练权重和训练日志。

使用方法:
  1. 修改下方"训练参数配置"区域的变量值（如 MODEL、DATA、BATCH、EPOCHS 等）
  2. 在终端运行: python scripts/train.py

运行环境要求:
  - Python 3.8+
  - ultralytics 已安装 (pip install ultralytics)
  - CUDA GPU 可加速训练（CPU 也可运行但较慢）

参数说明:
  TASK    : 任务类型，可选 detect(目标检测), segment(实例分割), classify(图像分类), pose(姿态估计), obb(旋转框检测)
  MODEL   : 模型文件，支持 *.pt 预训练权重 或 *.yaml 模型配置文件
  DATA    : 数据集 YAML 配置文件路径，需包含 train/val 路径和类别信息
  BATCH   : 批次大小，值越大显存占用越多，需根据 GPU 显存调整
  EPOCHS  : 训练轮数，建议 100-300 轮
  IMGSZ   : 输入图像尺寸，默认 640
  WORKERS : 数据加载线程数，Windows 系统建议设为 0（多线程在 Windows 上可能出错）
  DEVICE  : 训练设备，0 表示 GPU0，cpu 表示 CPU，0,1 表示多 GPU
"""

from ultralytics import YOLO

# ============================================================
# 训练参数配置（按需修改）
# ============================================================
TASK = "detect"                                          # 任务类型: detect, segment, classify, pose, obb
# [2026-10-08 09:58:45] 修改: 预训练模型权重由 yolov8s.pt 更换为 yolov5n.pt，训练改用 YOLOv5n 模型
# 原因: 本工程为 YOLOv5 基线工程（yolov5 文件夹），原 MODEL 指向 new\yolov8\weights\yolov8s.pt（YOLOv8s 模型），
#       训练使用的模型版本与工程要验证的 YOLOv5n 不一致
# 解决方案: MODEL 改为本工程 weights 目录下的 yolov5n.pt，训练从 YOLOv5n（最小规模）预训练权重启动
# 说明: ultralytics 8.x 会把 yolov5n.pt 自动映射为官方 YOLOv5u 权重 yolov5nu.pt（anchor-free 版本），
#       本机 weights 目录下没有该文件时库会自动从官方源下载；如需更大规模可换成 yolov5s.pt / yolov5m.pt / yolov5l.pt / yolov5x.pt
MODEL = r"D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\weights\yolov5n.pt"       # 模型文件: yolov5n.pt, yolov5s.pt, yolov5m.pt, yolov5l.pt, yolov5x.pt
DATA = r"D:\02_workspace\05_ascend_projects\yolo_pavement\yolov8\ultralytics\cfg\datasets\RDD_SPLIT-test.yaml"          # 数据集配置文件路径
BATCH =  16                                              # 批次大小
EPOCHS = 100                                             # 训练轮数
IMGSZ = 640                                              # 输入图像尺寸
WORKERS = 0                                              # 数据加载线程数（Windows 建议设为 0）
DEVICE = 0                                               # 训练设备: 0 表示 GPU0, cpu 表示 CPU, 0,1 表示多 GPU

# [2026-06-22 18:21:00] 新增: 创建可配置参数的训练脚本
# 原因: 每次训练需要手动在命令行输入完整的 yolo train 命令，参数多容易出错，不够便捷
# 解决方案: 编写独立的 train.py 脚本，将训练参数以变量形式集中在脚本顶部，用户只需修改变量值后直接运行脚本即可开始训练
# 说明: 脚本基于 ultralytics YOLO API，参数与 CLI 命令一一对应，运行方式为 python scripts/train.py

# [2026-06-29 09:04:00] 修改: 添加 project/name 参数，限制训练结果保存在 yolov8/runs 目录内
# 原因: 默认 model.train() 的 project 参数为 "runs"，训练结果保存在项目根目录的 runs/ 下，与 yolov8 项目文件夹分离
# 解决方案: 添加 PROJECT/NAME 配置变量，指定 project="yolov8/runs"、name="train"，确保训练权重和日志保存在 yolov8/runs/detect/train{N}/ 内
PROJECT = "yolov5/runs/detect"                                  # 训练结果保存根目录，限制在 yolov8 文件夹内
NAME = "train"                                           # 训练实验名称，结果保存在 {PROJECT}/detect/{NAME}{N}/ 下

if __name__ == "__main__":
    # 加载模型（使用 task 参数指定任务类型）
    model = YOLO(MODEL, task=TASK)

    # [2026-06-29 09:04:00] 修改: model.train() 添加 project/name 参数，限制结果在 yolov8/runs 内
    # 原因: 默认 project="runs" 保存在项目根目录，需限制在 yolov8 文件夹内便于管理
    # 解决方案: 添加 project=PROJECT 和 name=NAME 参数，结果保存到 yolov8/runs/detect/train{N}/
    # 开始训练
    results = model.train(
        data=DATA,
        batch=BATCH,
        epochs=EPOCHS,
        imgsz=IMGSZ,
        workers=WORKERS,
        device=DEVICE,
        project=PROJECT,
        name=NAME,
        # amp=False,
    )
