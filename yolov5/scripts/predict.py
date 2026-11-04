# Ultralytics YOLO 🚀, AGPL-3.0 license
"""
YOLOv5 预测脚本

功能说明:
  加载训练好的模型权重，对指定的图片/目录/视频进行目标检测（或分割/分类/姿态估计）推理。
  预测结果默认保存在 runs/detect/predict{N}/ 目录下，包含带检测框的图片和标注文件。

使用方法:
  1. 修改下方"预测参数配置"区域的变量值（如 MODEL、SOURCE、DEVICE 等）
  2. 在终端运行: python scripts/predict.py

运行环境要求:
  - Python 3.8+
  - ultralytics 已安装 (pip install ultralytics)
  - 已有训练好的模型权重文件（*.pt）

参数说明:
  TASK  : 任务类型，可选 detect(目标检测), segment(实例分割), classify(图像分类), pose(姿态估计), obb(旋转框检测)
  MODEL : 训练好的模型权重路径，如 runs/detect/train3/weights/best.pt
  SOURCE: 预测数据源，支持图片路径、图片目录、视频文件路径、摄像头（如 0 表示默认摄像头）
  DEVICE: 预测设备，0 表示 GPU0，cpu 表示 CPU
"""

from ultralytics import YOLO

# [2026-09-07 08:28:00] 新增: 添加 FPS/mAP/GPU 功耗统计所需依赖库
# 原因: 原预测脚本只输出检测结果，无法评估推理速度(FPS)、检测精度(mAP@0.5/0.75/0.5:0.95)以及 GPU 功耗
# 解决方案: 引入 os/time/threading/numpy 用于计时、后台功耗采样与数值计算，pynvml 用于读取 NVIDIA GPU 实时功耗
import os
import time
import threading
import numpy as np
try:
    import pynvml  # NVIDIA GPU 管理库（读取实时功耗）
except ImportError:
    pynvml = None

# [2026-09-07 08:28:00] 新增: GPU 功耗监测器，推理期间后台采样 NVIDIA GPU 实时功耗
# 原因: 需要统计推理过程中的 GPU 功耗，评估模型在硬件上的能耗表现
# 解决方案: 使用 pynvml 在后台线程按固定间隔采样 GPU 功耗(mW)，结束后取平均(W)
class GPUPowerMonitor:
    def __init__(self):
        self.power_samples = []
        self.running = False
        self.thread = None
        self.handle = None

    def start(self):
        if pynvml is None:
            print("⚠️  未安装 pynvml，跳过 GPU 功耗监测")
            return False
        try:
            pynvml.nvmlInit()
            self.handle = pynvml.nvmlDeviceGetHandleByIndex(0)
            self.running = True
            self.power_samples = []
            self.thread = threading.Thread(target=self._monitor, daemon=True)
            self.thread.start()
            return True
        except Exception as e:
            print(f"⚠️  GPU 功耗监测不可用: {e}")
            self.running = False
            return False

    def _monitor(self):
        while self.running:
            try:
                power_mw = pynvml.nvmlDeviceGetPowerUsage(self.handle)
                self.power_samples.append(power_mw / 1000.0)  # mW -> W
            except Exception:
                pass
            time.sleep(0.05)

    def stop(self):
        self.running = False
        if self.thread:
            self.thread.join(timeout=2)
        try:
            if self.handle is not None:
                pynvml.nvmlShutdown()
        except Exception:
            pass
        return float(np.mean(self.power_samples)) if self.power_samples else 0.0


# [2026-09-07 08:28:00] 新增: 计算两个框的 IOU（交并比），供 mAP 匹配判定使用
# 原因: mAP 需要判断预测框与真实框是否匹配（IOU 超过阈值视为正确检测），需要 IOU 计算函数
# 解决方案: 实现标准 IOU 公式：交集面积 / 并集面积
def calculate_iou(box1, box2):
    x1 = max(box1[0], box2[0])
    y1 = max(box1[1], box2[1])
    x2 = min(box1[2], box2[2])
    y2 = min(box1[3], box2[3])

    intersection = max(0, x2 - x1) * max(0, y2 - y1)
    if intersection == 0:
        return 0.0

    box1_area = (box1[2] - box1[0]) * (box1[3] - box1[1])
    box2_area = (box2[2] - box2[0]) * (box2[3] - box2[1])
    union = box1_area + box2_area - intersection

    return intersection / union


# [2026-09-07 08:28:00] 新增: 根据 PR 曲线计算 AP（COCO 全点插值法）
# 原因: 每个 IoU 阈值下的检测精度由精确率-召回率曲线下面积(AP)得到，需要标准 AP 计算实现
# 解决方案: 对召回率曲线做单调化处理后计算曲线下面积（COCO all-point interpolation）
def compute_ap(recall, precision):
    mrec = np.concatenate(([0.0], recall, [1.0]))
    mpre = np.concatenate(([0.0], precision, [0.0]))
    for i in range(mpre.size - 1, 0, -1):
        mpre[i - 1] = max(mpre[i - 1], mpre[i])
    idx = np.where(mrec[1:] != mrec[:-1])[0]
    ap = np.sum((mrec[idx + 1] - mrec[idx]) * mpre[idx + 1])
    return float(ap)


# [2026-09-07 08:28:00] 新增: 计算 COCO 风格 mAP@0.5、mAP@0.75、mAP@0.5:0.95
# 原因: 预测脚本需要输出检测精度指标，用于评估模型效果
# 解决方案: 解析真实标注与预测框，按类别对每个 IoU 阈值计算 AP，再求均值得到 mAP
def compute_map(results, labels_dir, num_classes):
    # 1. 按类别收集真实框(GT)和预测框
    gt_by_class = [[] for _ in range(num_classes)]
    pred_by_class = [[] for _ in range(num_classes)]

    for img_idx, result in enumerate(results):
        img_name = os.path.splitext(os.path.basename(result.path))[0]
        label_path = os.path.join(labels_dir, f"{img_name}.txt")

        # 解析真实标注（YOLO 归一化 xywh -> 像素 xyxy）
        if os.path.exists(label_path):
            with open(label_path, "r") as f:
                for line in f:
                    parts = line.strip().split()
                    if len(parts) < 5:
                        continue
                    cls = int(parts[0])
                    if not (0 <= cls < num_classes):
                        continue
                    x_center = float(parts[1]) * result.orig_shape[1]
                    y_center = float(parts[2]) * result.orig_shape[0]
                    width = float(parts[3]) * result.orig_shape[1]
                    height = float(parts[4]) * result.orig_shape[0]
                    box = [x_center - width / 2, y_center - height / 2,
                           x_center + width / 2, y_center + height / 2]
                    gt_by_class[cls].append((img_idx, box))

        # 解析预测框（含置信度）
        if len(result.boxes) > 0:
            boxes = result.boxes.xyxy.cpu().numpy()
            clss = result.boxes.cls.cpu().numpy().astype(int)
            confs = result.boxes.conf.cpu().numpy()
            for box, cls, conf in zip(boxes, clss, confs):
                if 0 <= cls < num_classes:
                    pred_by_class[cls].append((float(conf), img_idx, box.tolist()))

    # 2. 对每个类别、每个 IoU 阈值计算 AP
    iou_thresholds = np.arange(0.5, 1.0, 0.05)  # [0.5, 0.55, ..., 0.95] 共 10 个
    ap_by_threshold = [[] for _ in iou_thresholds]

    for cls in range(num_classes):
        preds = pred_by_class[cls]
        gts = gt_by_class[cls]
        if not preds and not gts:
            continue

        preds.sort(key=lambda x: x[0], reverse=True)  # 按置信度降序

        gt_local = {}  # 每个图片的 GT 局部索引，便于匹配后去重
        for img_idx, box in gts:
            gt_local.setdefault(img_idx, []).append(box)

        for t_idx, thr in enumerate(iou_thresholds):
            tp = np.zeros(len(preds))
            fp = np.zeros(len(preds))
            matched = {}  # img_idx -> 已匹配的 GT 局部索引集合

            for i, (conf, img_idx, pred_box) in enumerate(preds):
                best_iou = 0.0
                best_j = -1
                for j, gt_box in enumerate(gt_local.get(img_idx, [])):
                    if j in matched.get(img_idx, set()):
                        continue
                    iou = calculate_iou(pred_box, gt_box)
                    if iou > best_iou:
                        best_iou = iou
                        best_j = j

                if best_j >= 0 and best_iou >= thr:
                    tp[i] = 1
                    matched.setdefault(img_idx, set()).add(best_j)
                else:
                    fp[i] = 1

            tp_cum = np.cumsum(tp)
            fp_cum = np.cumsum(fp)
            recall = tp_cum / len(gts) if len(gts) > 0 else np.zeros_like(tp_cum)
            precision = tp_cum / (tp_cum + fp_cum + 1e-16)
            ap_by_threshold[t_idx].append(compute_ap(recall, precision))

    # 3. 汇总 mAP 指标
    def mean_or_zero(lst):
        return float(np.mean(lst)) if lst else 0.0

    map50 = mean_or_zero(ap_by_threshold[0])      # IoU=0.5
    map75 = mean_or_zero(ap_by_threshold[5])      # IoU=0.75
    map50_95 = float(np.mean([mean_or_zero(aps) for aps in ap_by_threshold]))

    return map50, map75, map50_95


# ============================================================
# 预测参数配置（按需修改）
# ============================================================
TASK = "detect"                                          # 任务类型: detect, segment, classify, pose, obb
# [2026-10-08 09:58:45] 修改: 推理预测模型由 YOLOv8 训练权重 best.pt 换成 yolov5n.pt，预测改用 YOLOv5n 模型
# 原因: 本工程为 YOLOv5 基线工程（yolov5 文件夹），原 MODEL 指向 yolov8 工程的训练权重 best.pt（YOLOv8 模型），
#       用于预测的模型版本与工程要验证的 YOLOv5n 不一致
# 解决方案: MODEL 改为本工程 weights 目录下的 yolov5n.pt，预测脚本直接加载 YOLOv5n 权重做推理
# 说明: 如需用本工程自己训练出来的模型预测，把 MODEL 改为 yolov5\runs\detect\train\weights\best.pt；
#       当前 yolov5n.pt 为 COCO 预训练权重（80 类），与下方 NUM_CLASSES=5、LABELS_DIR 的路面 5 类标注不一致，此时打印的 mAP 指标无参考意义
MODEL = r"D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\weights\yolov5n.pt"             # 推理使用的模型权重路径（YOLOv5n）
SOURCE = r"C:\Users\kkbrave\Desktop\e45d9d0ac72635c53cb87912f7f284f3.png"  # 预测数据源: 图片路径/目录/视频/摄像头
DEVICE = 0                                               # 预测设备: 0 表示 GPU0, cpu 表示 CPU
# [2026-06-29 09:04:00] 修改: PROJECT 路径从 "runs" 改为 "yolov8/runs"，限制预测结果在 yolov8 文件夹内
# 原因: 原 project="runs" 将预测结果保存在项目根目录下，需统一限制在 yolov8 文件夹内便于管理
# 解决方案: 修改 PROJECT 值为 "yolov8/runs"，预测结果保存到 yolov8/runs/detect/predict{N}/
PROJECT = r"D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\runs\predict"                                  # 预测结果保存根目录，限制在 yolov8 文件夹内
NAME = "predict"                                         # 预测实验名称，结果保存在 {PROJECT}/detect/{NAME}{N}/ 下
SAVE = True                                              # 是否保存预测结果（图片/标注/文本），True 保存，False 仅在内存中返回结果
CONF = 0.45                                               # 置信度阈值，低于此值的检测框不显示（过滤低质量预测），默认 0.25，建议 0.3~0.

# [2026-06-29 09:31:00] 新增: 添加 IOU 参数，控制 NMS 中重叠框的去重阈值
# 原因: 默认 iou=0.7，同一目标可能出现多个高度重叠的检测框，需要调整 IOU 阈值控制去重力度
# 解决方案: 添加 IOU 配置变量和 iou=IOU 参数，值越小去重越激进（留更少框），值越大保留框越多
# 说明: IOU 用于 NMS（非极大值抑制），当两个检测框的 IOU 超过此阈值时，保留置信度更高的那个
IOU = 0.65                                                 # NMS 的 IOU 阈值，默认 0.7，值越小框越少，建议 0.3~0.7

# [2026-06-29 09:47:00] 修复: 添加 AGNOSTIC_NMS 参数，解决同一目标出现黄白双框问题
# 原因: 模型对同一目标（如狗）同时预测出两个类别（如奇宝+七夕），默认 NMS 是按类别独立去重（class-specific），
#       不同类别的框即使高度重叠也不会互相抑制，导致同一目标出现黄色框（A类）+ 白色框（B类）
# 解决方案: 添加 AGNOSTIC_NMS=True，将 NMS 改为类别无关模式（class-agnostic），
#           使不同类别但 IOU 超过阈值的重叠框也参与去重，仅保留置信度最高的那个框
# 说明: agnostic_nms=True 后，同一目标只保留置信度最高的类别框；
#       agnostic_nms=False（默认）时，每个类别独立做 NMS，可能保留多个不同类别的重叠框
AGNOSTIC_NMS = True                                       # 类别无关 NMS，True=不同类别重叠框也去重，False=仅同类去重

# [2026-09-07 08:28:00] 新增: 添加 LABELS_DIR / NUM_CLASSES 配置，用于计算 mAP 精度指标
# 原因: 计算 mAP 需要真实标注文件(Ground Truth)和类别总数，原脚本没有相关配置
# 解决方案: 新增 LABELS_DIR 指向标注目录、NUM_CLASSES 指定类别总数，供 compute_map 计算 mAP 使用
# 说明: 只有存在标注文件时才能计算 mAP；若无标注可把 LABELS_DIR 置空字符串，脚本将输出 mAP=0
LABELS_DIR = r"D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\dataset_infer\labels"  # 真实标注目录（YOLO 格式 txt），用于计算 mAP
NUM_CLASSES = 5                                          # 类别总数（与训练时的 nc 一致）

# [2026-06-22 18:27:00] 新增: 创建可配置参数的预测脚本
# 原因: 每次预测需要手动在命令行输入完整的 yolo predict 命令，参数多容易出错，不够便捷
# 解决方案: 编写独立的 predict.py 脚本，将预测参数以变量形式集中在脚本顶部，用户只需修改变量值后直接运行脚本即可开始预测
# 说明: 脚本基于 ultralytics YOLO API，参数与 CLI 命令一一对应，运行方式为 python scripts/predict.py

if __name__ == "__main__":
    # 加载模型（使用 task 参数指定任务类型）
    model = YOLO(MODEL, task=TASK)

    # [2026-09-07 08:28:00] 新增: 启动 GPU 功耗监测 + 推理计时
    # 原因: 需要统计推理总耗时（用于 FPS）和 GPU 实时功耗（用于能耗评估）
    # 解决方案: 在调用 model.predict() 前启动 GPUPowerMonitor 后台线程并记录开始时间
    gpu_monitor = GPUPowerMonitor()
    gpu_ok = gpu_monitor.start()
    start_time = time.time()

    # [2026-06-23 07:12:00] 修改: 添加 project/name/save 参数，确保预测结果保存到 runs 文件夹
    # 原因: 默认 predict() 虽会自动保存，但未显式指定 project 和 save 参数，结果保存路径不够明确
    # 解决方案: 添加 PROJECT/NAME/SAVE 配置变量和对应的 model.predict() 参数，确保结果明确保存到 runs 目录下
    # 说明: project 指定根目录（runs），name 指定实验名（predict），最终保存路径为 runs/detect/predict{N}/
    # [2026-06-23 08:24:00] 修改: 添加 conf 置信度阈值参数，过滤低置信度检测框
    # 原因: 默认 conf=0.25，会出现很多低质量预测框（如小狗仅 79% 置信度），干扰结果判断
    # 解决方案: 添加 CONF=0.5 配置变量和 conf=CONF 参数，低于 0.5 置信度的检测框不显示
    # 说明: conf 值越高框越少但越准，值越低框越多但误检增多，可根据实际效果调整 0.3~0.7
    # [2026-06-29 09:31:00] 新增: 添加 iou 参数，NMS 去重阈值
    # 原因: 默认 iou=0.7，可能保留过多高度重叠的检测框，需要可配置
    # 解决方案: 添加 iou=IOU 参数，用户可调整 NMS 去重力度
    # [2026-06-29 09:47:00] 修复: 添加 agnostic_nms 参数，解决不同类别重叠框导致的双框问题
    # 原因: 默认 agnostic_nms=False，NMS 按类别独立执行，不同类别的重叠框不会被抑制，
    #       导致同一目标出现多个不同颜色的检测框
    # 解决方案: 添加 agnostic_nms=AGNOSTIC_NMS=True，NMS 无视类别，重叠框只保留最高置信度
    results = model.predict(
        source=SOURCE,
        device=DEVICE,
        project=PROJECT,
        name=NAME,
        save=SAVE,
        conf=CONF,
        iou=IOU,
        agnostic_nms=AGNOSTIC_NMS,
    )

    # [2026-09-07 08:28:00] 新增: 统计推理耗时、FPS、GPU 功耗，并计算 mAP 精度指标
    # 原因: 原脚本 predict() 结束后直接结束，没有输出任何性能/精度指标，无法评估模型效果
    # 解决方案: 停止计时和 GPU 监测，计算 FPS 与平均 GPU 功耗；调用 compute_map 计算 mAP@0.5/0.75/0.5:0.95
    inference_time = time.time() - start_time
    avg_gpu_power = gpu_monitor.stop()
    total_images = len(results)
    fps = total_images / inference_time if inference_time > 0 else 0.0
    map50, map75, map50_95 = compute_map(results, LABELS_DIR, NUM_CLASSES)

    # ============================================================
    # 性能与精度指标输出
    # ============================================================
    print("\n" + "=" * 70)
    print("⚡ 推理速度：")
    print(f"  处理图片总数: {total_images} 张")
    print(f"  推理总时间: {inference_time:.2f} 秒")
    print(f"  推理 FPS: {fps:.2f} 张/秒")

    print("\n📊 检测精度（mAP）：")
    print(f"  mAP@0.5:      {map50:.4f}")
    print(f"  mAP@0.75:     {map75:.4f}")
    print(f"  mAP@0.5:0.95: {map50_95:.4f}")

    print("\n🔋 GPU 功耗：")
    if gpu_ok and avg_gpu_power > 0:
        print(f"  平均 GPU 功耗: {avg_gpu_power:.2f} 瓦 (W)")
        print(f"  推理总能耗: {avg_gpu_power * inference_time:.2f} 焦耳 (J)")
    else:
        print("  GPU 功耗监测不可用（未检测到 NVIDIA GPU 或 pynvml 未安装）")
    print("=" * 70)
