from ultralytics import YOLO

# 加载导出的 ONNX 模型
onnx_model = YOLO(r"D:\02_workspace\05_ascend_projects\yolo_pavement\yolov8\onnx_export\best.onnx")

# 指定保存结果的目录
save_dir = r"D:\02_workspace\05_ascend_projects\yolo_pavement\yolov8\runs\onnx_infer\onnx2"

# 运行推理并保存结果
results = onnx_model(
    #"D:/ultralytics-main (1)/ultralytics-main/ultralytics/assets/bridge.jpg",
    r"D:\02_workspace\05_ascend_projects\yolo_pavement\yolov8\dataset_infer\images\China_Drone_000004.jpg",
    conf=0.5,            # 置信度阈值，低于 0.5 的检测框不显示
    save=True,           # 保存可视化结果
    save_txt=True,       # 保存边界框坐标到文本文件
    save_conf=True,      # 保存置信度分数
    project=save_dir,    # 指定保存位置
    agnostic_nms=True,   # 类别无关NMS，不同类别重叠框也去重，避免同一目标出现多个框
)
    