from ultralytics import YOLO
import os
import numpy as np
import psutil
import time
import threading
import onnx
from onnx import helper, shape_inference
import onnxruntime as ort


# 辅助函数：计算两个框的IOU（交并比）
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


# ===================== 1. 功耗监测相关函数 =====================
class CPUMonitor:
    def __init__(self):
        self.cpu_usage = []
        self.running = False
        self.thread = None

    def start(self):
        self.running = True
        self.cpu_usage = []
        self.thread = threading.Thread(target=self._monitor)
        self.thread.start()

    def _monitor(self):
        while self.running:
            self.cpu_usage.append(psutil.cpu_percent(interval=0.1))

    def stop(self):
        self.running = False
        if self.thread:
            self.thread.join()
        return np.mean(self.cpu_usage) if self.cpu_usage else 0.0


def calculate_power_consumption(avg_cpu_usage, inference_time, cpu_tdp=65):
    """计算推理能耗（焦耳）和平均功耗（瓦）"""
    avg_power = cpu_tdp * (avg_cpu_usage / 100)
    energy = avg_power * inference_time
    return avg_power, energy


# ===================== 2. GFLOPS计算核心函数（修复StopIteration） =====================
def get_tensor_shape(model, tensor_name):
    """
    从ONNX模型中查找张量的形状（优先input → value_info → output）
    :param model: ONNX模型对象
    :param tensor_name: 张量名称
    :return: 张量形状列表，找不到返回None
    """
    # 1. 先查输入张量
    for tensor in model.graph.input:
        if tensor.name == tensor_name:
            return [dim.dim_value if dim.dim_value != 0 else 1 for dim in tensor.type.tensor_type.shape.dim]
    # 2. 再查中间张量
    for tensor in model.graph.value_info:
        if tensor.name == tensor_name:
            return [dim.dim_value if dim.dim_value != 0 else 1 for dim in tensor.type.tensor_type.shape.dim]
    # 3. 最后查输出张量
    for tensor in model.graph.output:
        if tensor.name == tensor_name:
            return [dim.dim_value if dim.dim_value != 0 else 1 for dim in tensor.type.tensor_type.shape.dim]
    # 4. 找不到返回None
    return None


def calculate_onnx_flops(onnx_model_path, input_shape=(1, 3, 640, 640)):
    """
    计算ONNX模型的理论浮点运算次数（FLOPs），修复StopIteration错误
    :param onnx_model_path: ONNX模型路径
    :param input_shape: 模型输入形状 (batch, channel, height, width)
    :return: 总FLOPs（浮点运算次数），单位：次
    """
    # 加载并简化ONNX模型（确保形状信息完整）
    try:
        model = onnx.load(onnx_model_path)
        # 推理形状信息（关键：补充缺失的形状）
        model = shape_inference.infer_shapes(model)
        onnx.checker.check_model(model)
    except Exception as e:
        print(f"⚠️  加载/简化ONNX模型失败：{e}，将使用默认输入形状估算FLOPs")
        # 估算默认FLOPs（YOLOv8n级别）
        return 5e9

    flops = 0
    # 遍历所有节点，计算主要算子的FLOPs（覆盖YOLO核心算子）
    for node in model.graph.node:
        op_type = node.op_type.lower()
        if op_type in ['conv', 'convolution']:
            # 卷积算子FLOPs计算：output_size * kernel_size * channels_in * channels_out / groups
            # 获取输入/输出形状（修复核心：使用get_tensor_shape函数）
            input_shape_ = get_tensor_shape(model, node.input[0])
            output_shape_ = get_tensor_shape(model, node.output[0])

            # 跳过形状获取失败的节点
            if input_shape_ is None or output_shape_ is None:
                continue
            if len(input_shape_) != 4 or len(output_shape_) != 4:
                continue

            batch, c_out, h_out, w_out = output_shape_
            c_in = input_shape_[1]

            # 获取卷积核参数（kernel_size, groups）
            kernel_shape = None
            groups = 1
            for attr in node.attribute:
                if attr.name == 'kernel_shape':
                    kernel_shape = attr.ints
                if attr.name == 'groups':
                    groups = attr.i

            if kernel_shape is None:
                kernel_shape = [3, 3]  # 默认3x3卷积核

            k_h, k_w = kernel_shape
            # 处理维度为0的情况（避免除以0）
            if groups == 0:
                groups = 1
            # 卷积FLOPs公式：H_out * W_out * C_out * (C_in * K_h * K_w) * batch / groups
            conv_flops = h_out * w_out * c_out * (c_in * k_h * k_w) * batch / groups
            flops += conv_flops

        elif op_type in ['matmul', 'gemm']:
            # 矩阵乘法FLOPs：M*N*K（A: MxK, B: KxN → MxN）
            input1_shape = get_tensor_shape(model, node.input[0])
            input2_shape = get_tensor_shape(model, node.input[1])

            if input1_shape is None or input2_shape is None:
                continue
            if len(input1_shape) != 2 or len(input2_shape) != 2:
                continue

            m, k = input1_shape
            k2, n = input2_shape
            if k == k2:
                matmul_flops = m * n * k
                flops += matmul_flops

        elif op_type in ['add', 'mul', 'sub', 'div']:
            # 逐元素运算FLOPs：元素总数
            output_shape_ = get_tensor_shape(model, node.output[0])
            if output_shape_ is None:
                continue
            elem_count = np.prod(output_shape_)
            flops += elem_count

    # 如果计算结果为0，返回默认值（避免后续除以0）
    if flops == 0:
        flops = 5e9  # YOLOv8n级别默认值
    return flops


def calculate_gflops(total_flops, inference_time, total_images):
    """
    计算实测GFLOPS（修复参数传递问题）
    :param total_flops: 模型总浮点运算次数（次）
    :param inference_time: 推理时间（秒）
    :param total_images: 处理的图片总数
    :return: 理论GFLOPS（单张）、实测GFLOPS（整体）
    """
    # 理论GFLOPS（单张图片的计算量 ÷ 1e9）
    flops_per_img_gflops = total_flops / 1e9
    # 实测GFLOPS = 总FLOPs * 处理图片数 / 推理时间 / 1e9
    actual_gflops = (total_flops * total_images) / inference_time / 1e9 if inference_time > 0 else 0.0
    return flops_per_img_gflops, actual_gflops


# ===================== 3. 核心执行代码 =====================
# 配置参数
ONNX_MODEL_PATH = r"D:\02_workspace\05_ascend_projects\yolo_pavement\yolov8\onnx_export\best.onnx"  # 自定义修改
INPUT_SHAPE = (1, 3, 640, 640)  # 与推理的imgsz一致
save_dir = r"D:\02_workspace\05_ascend_projects\yolo_pavement\yolov8\runs\onnx_infer\onnx3"
labels_dir = r"D:\02_workspace\05_ascend_projects\yolo_pavement\yolov8\dataset_infer\labels"  # 需要精确率、召回率、F1时，必须要有标注文件
NUM_CLASSES = 1
CPU_TDP = 125  # 你的CPU额定功耗（瓦）  270kplus额定功耗
 
# 1. 预计算模型理论FLOPs
print("🔍 正在计算模型理论FLOPs...")
total_flops = calculate_onnx_flops(ONNX_MODEL_PATH, INPUT_SHAPE)
print(f"✅ 模型理论FLOPs（单张）: {total_flops / 1e9:.2f} GFLOPs")

# 2. 加载模型
onnx_model = YOLO(ONNX_MODEL_PATH)
os.makedirs(save_dir, exist_ok=True)

# 3. 初始化监测器
cpu_monitor = CPUMonitor()

# 4. 开始推理计时+CPU监测
start_time = time.time()
cpu_monitor.start()

# 运行推理
results = onnx_model(
    r"D:\02_workspace\05_ascend_projects\yolo_pavement\yolov8\dataset_infer\images",
    save=True,
    save_txt=True,
    save_conf=True,
    project=save_dir,
    name="predict",       # 子文件夹名称，自动递增 predict、predict2、predict3...
    device='cpu',  # 使用GPU推理，若无GPU可改为 'CPU'
    imgsz=640,
    agnostic_nms=True,   # 类别无关NMS，不同类别重叠框也去重，避免同一目标出现多个框
    # [2026-06-29 15:50:00] 注释: 补充 conf 和 iou 参数的详细说明
    # =====================================================================
    # conf（置信度阈值，第221行）: 只有当模型预测某个框属于某类别的概率 ≥ conf 时，该框才被保留

    #- 小了（0.01）：框太多，画面杂乱，误检严重
    #- 大了（0.9）：框太少，漏检增多
    #- 建议：日常 0.25~0.5，精度评估用 0.001

    #   - 设小了（如 conf=0.01）: 几乎所有预测框都保留，结果中会出现大量低质量、误检的框，画面杂乱，FPS/功耗等指标无意义
    #   - 设大了（如 conf=0.9）: 只保留模型非常确信的框，漏检会增多，召回率下降（有些目标检测不到）
    #   - 建议: 日常查看结果用 0.25~0.5，做精度评估（mAP）建议用 0.001（让模型输出所有可能的框，由评估工具筛选）
    #      当前 conf=0.25 为 ultralytics 默认值，适合大部分场景
    # =====================================================================
    # iou（NMS 去重阈值；NMS 中的 IOU 阈值，第222行）: 当两个检测框的 IOU（交并比）≥ iou 时，只保留置信度更高的那个框，另一个被丢弃

    #- 小了（0.1）：去重激进，同一目标附近框被合并掉
    #- 大了（0.9）：去重宽松，同一目标出现多个重复框
    #- 建议：0.45~0.7

    #   - 设小了（如 iou=0.1）: NMS 去重非常激进，同一目标附近稍微重叠的框就消失了，可能导致漏检
    #   - 设大了（如 iou=0.9）: NMS 去重非常宽松，只有几乎完全重合的框才去重，同一目标上可能出现多个重复框
    #   - 建议: 0.45~0.7，值越小去重越狠（剩更少框），值越大保留框越多
    #      当前 iou=0.45 为 ultralytics 默认值，适合大部分场景
    # =====================================================================
    conf=0.5,
    iou=0.5
)

# 5. 停止监测+计算基础指标
inference_time = time.time() - start_time
avg_cpu_usage = cpu_monitor.stop()
total_images = len(results)
fps = total_images / inference_time if inference_time > 0 else 0.0

# 6. 计算GFLOPS（修复参数传递）
flops_per_img_gflops, actual_gflops = calculate_gflops(total_flops, inference_time, total_images)

# 7. 计算精度（仅整体平均）
total_precision = []
total_recall = []
total_f1 = []

for result in results:
    img_name = os.path.splitext(os.path.basename(result.path))[0]
    label_path = os.path.join(labels_dir, f"{img_name}.txt")

    if os.path.exists(label_path):
        with open(label_path, 'r') as f:
            lines = f.readlines()
        true_boxes = []
        true_cls = []
        for line in lines:
            parts = line.strip().split()
            if len(parts) >= 5:
                cls = int(parts[0])
                x_center = float(parts[1])
                y_center = float(parts[2])
                width = float(parts[3])
                height = float(parts[4])
                x1 = (x_center - width / 2) * result.orig_shape[1]
                y1 = (y_center - height / 2) * result.orig_shape[0]
                x2 = (x_center + width / 2) * result.orig_shape[1]
                y2 = (y_center + height / 2) * result.orig_shape[0]
                true_boxes.append([x1, y1, x2, y2])
                true_cls.append(cls)

        pred_boxes = result.boxes.xyxy.cpu().numpy() if len(result.boxes) > 0 else np.array([])
        pred_cls = result.boxes.cls.cpu().numpy() if len(result.boxes) > 0 else np.array([])

        if len(true_boxes) > 0 or len(pred_boxes) > 0:
            tp = 0
            fp = len(pred_boxes)
            matched = []

            for i, pred_box in enumerate(pred_boxes):
                for j, true_box in enumerate(true_boxes):
                    if j in matched:
                        continue
                    iou = calculate_iou(pred_box, true_box)
                    if iou > 0.5 and pred_cls[i] == true_cls[j]:
                        tp += 1
                        fp -= 1
                        matched.append(j)
                        break

            precision = tp / (tp + fp) if (tp + fp) > 0 else 0.0
            fn = len(true_boxes) - tp
            recall = tp / (tp + fn) if (tp + fn) > 0 else 0.0
            f1 = 2 * (precision * recall) / (precision + recall) if (precision + recall) > 0 else 0.0

            total_precision.append(precision)
            total_recall.append(recall)
            total_f1.append(f1)

# 8. 计算功耗
avg_power, energy = calculate_power_consumption(avg_cpu_usage, inference_time, CPU_TDP)

# ===================== 4. 最终输出 =====================
print("\n" + "=" * 70)
# 精度输出
if total_precision:
    avg_precision = np.mean(total_precision)
    avg_recall = np.mean(total_recall)
    avg_f1 = np.mean(total_f1)
    print("📊 模型推理整体平均精度：")
    print(f"  平均精确率(AP): {avg_precision:.4f}")
    print(f"  平均召回率(AR): {avg_recall:.4f}")
    print(f"  平均F1分数: {avg_f1:.4f}")
else:
    print("⚠️  未计算出精度指标，请检查标注文件路径是否正确！")

# 速度/FPS/GFLOPS输出
print("\n⚡ 推理速度与算力消耗：")
print(f"  处理图片总数: {total_images} 张")
print(f"  推理总时间: {inference_time:.2f} 秒")
print(f"  推理FPS: {fps:.2f} 张/秒")
print(f"  模型理论计算量（单张）: {flops_per_img_gflops:.2f} GFLOPs")
print(f"  实测推理GFLOPS: {actual_gflops:.2f} GFLOPS")

# 功耗输出
print("\n🔋 推理功耗与能耗：")
print(f"  平均CPU使用率: {avg_cpu_usage:.2f} %")
print(f"  平均功耗: {avg_power:.2f} 瓦 (W)")
print(f"  总能耗: {energy:.2f} 焦耳 (J)")
print(f"  能耗（12V）: {energy / (12 * 3.6):.2f} 毫瓦时 (mAh)")
print("=" * 70)