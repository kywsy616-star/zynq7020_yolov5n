# ==========================================
# YOLOv5n 剪枝版 权重导出脚本（适配自定义 yaml）
# 支持 ultralytics 框架，加载 best.pt + yolov5n_crack_fps.yaml
# 输出：每一层权重/偏置对应一个 .bin 文件，格式为 float32
# ==========================================
import torch
import yaml
import numpy as np
import os
from ultralytics import YOLO  # 依赖 ultralytics 库：pip install ultralytics

def export_yolov5_weights(pt_path="best.pt", yaml_path="yolov5n_crack_fps.yaml", output_dir="weights_bin"):
    """
    加载自定义 yaml 结构与训练好的 pt 权重，导出所有层参数为 FP32 二进制文件
    :param pt_path: 训练好的权重文件路径
    :param yaml_path: 模型结构 yaml 文件路径
    :param output_dir: 导出 bin 文件存放目录
    """
    # -------------------------- 步骤1：创建输出目录 --------------------------
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)
        print(f"提示：已创建权重输出文件夹：{output_dir}")
    
    print("\n" + "-"*25 + " YOLOv5n 剪枝版 权重导出开始 " + "-"*25)
    
    # -------------------------- 步骤2：构建模型并加载权重 --------------------------
    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    print(f"[*] 运行设备：{device}")
    print(f"[*] 模型结构文件：{yaml_path}")
    print(f"[*] 权重文件：{pt_path}")

    # 用 ultralytics 加载自定义 yaml 构建模型结构
    model = YOLO(yaml_path).model.to(device)
    
    # 加载 best.pt 权重
    if os.path.exists(pt_path):
        checkpoint = torch.load(pt_path, map_location=device)
        # 兼容 ultralytics 保存格式：提取 state_dict
        if 'model' in checkpoint:
            state_dict = checkpoint['model'].state_dict()
        elif 'state_dict' in checkpoint:
            state_dict = checkpoint['state_dict']
        else:
            state_dict = checkpoint
        # 严格加载，确保权重和结构匹配
        model.load_state_dict(state_dict, strict=True)
        print(f"[成功] 权重加载完成，结构与权重完全匹配")
    else:
        print(f"[警告] 未找到 {pt_path}，将导出随机初始化权重（仅用于流程测试）")
    
    model.eval()  # 切换评估模式，固定 BN/Dropout
    
    # -------------------------- 步骤3：遍历所有参数并导出 --------------------------
    print("\n[*] 开始导出各层参数...")
    param_count = 0
    total_params = 0
    
    for name, param in model.named_parameters():
        # 文件名处理：层名中的 . 替换为 _，避免文件名非法
        # 示例：model.0.conv.weight → model_0_conv_weight.bin
        file_name = name.replace('.', '_') + ".bin"
        file_path = os.path.join(output_dir, file_name)
        
        # 数据格式转换流水线：detach → cpu → numpy → float32
        data = param.detach().cpu().numpy().astype(np.float32)
        data.tofile(file_path)
        
        # 统计与打印
        param_num = data.size
        total_params += param_num
        print(f"    导出 | {name:35s} | 形状: {str(list(data.shape)):18s} | 元素数: {param_num:>8d}")
        param_count += 1
    
    # -------------------------- 步骤4：任务收尾 --------------------------
    print("\n" + "-"*25 + " 权重导出任务完成 " + "-"*25)
    print(f"[完成] 共导出 {param_count} 个参数文件")
    print(f"[完成] 总参数量：{total_params / 1e6:.3f} M（与 yaml 标注的 0.721M 核对）")
    print(f"[完成] 文件存放路径：{os.path.abspath(output_dir)}")

# -------------------------- 程序入口 --------------------------
if __name__ == "__main__":
    # 按需修改为你的文件名
    PT_FILE = r"D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\runs\detect\train_crack_4_35\weights\best.pt"  
    YAML_FILE = r"D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\ultralytics\cfg\models\v5\yolov5_crack_speed.yaml"  # 你的剪枝版 yaml    speed 帧率优先
    OUTPUT_DIR = r"D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\runs\weigths_bin\weigths_bin_1"
    
    export_yolov5_weights(PT_FILE, YAML_FILE, OUTPUT_DIR)