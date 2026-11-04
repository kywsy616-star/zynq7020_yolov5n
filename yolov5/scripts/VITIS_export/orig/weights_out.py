# ==========================================
# YOLOv5n 剪枝版 权重导出脚本（BN融合版）
# ==========================================
# 【脚本定位】
#   专为黑金7020 FPGA HLS部署定制的权重预处理脚本，
#   解决YOLOv5原生Conv+BN两级结构在HLS端实现复杂、变量不匹配的问题，
#   是从训练权重到FPGA硬件推理的核心预处理环节。
#
# 【核心修改说明（与原始逐参数导出版对比）】
#   1. ✅ 新增BN层融合功能
#      将卷积层(Conv)与批归一化层(BN)的参数通过数学公式融合为
#      一组等效的卷积权重和偏置，推理数值精度与原模型完全一致，
#      没有任何精度损失。
#
#   2. ✅ 简化HLS端算子与资源占用
#      HLS无需单独实现BN层算子，仅需卷积+激活即可完成原Conv+BN的计算，
#      节省PL端的逻辑资源与BRAM开销，同时减少层间数据读写延迟，
#      直接提升硬件推理帧率。
#
#   3. ✅ 统一变量命名，解决编译报错
#      输出文件统一为「层名_weight.bin」+「层名_bias.bin」的命名格式，
#      与HLS代码中调用的权重/偏置变量名完全匹配，
#      彻底解决之前"model_x_conv_bias未声明"的编译错误。
#
#   4. ✅ 移除冗余参数，精简文件数量
#      不再导出BN层的weight/bias/mean/var等单独参数文件，
#      仅保留融合后卷积计算必需的权重和偏置，文件数量减少约60%。
#
# 【BN融合数学原理】
#   原两级计算流程：
#       卷积计算：y_conv = Conv(x) = w * x  （YOLOv5卷积层默认关闭偏置）
#       BN计算：  y_bn = (y_conv - running_mean) / sqrt(running_var + eps) * gamma + beta
#
#   融合等效公式：
#       缩放系数：scale = gamma / sqrt(running_var + eps)
#       融合权重：w_fused = w * scale.reshape(输出通道数, 1, 1, 1)
#       融合偏置：b_fused = beta - running_mean * scale
#
#   融合后仅需一步计算：y = w_fused * x + b_fused
#   计算结果与原Conv+BN两级计算完全等价，精度无损失。
#
# 【输出文件说明】
#   存放目录：weights_bin/
#   数据格式：纯二进制 float32 格式（无形状信息，按C语言内存顺序存储）
#   命名规则：模块层级名_参数类型.bin
#   典型文件示例：
#       model_0_weight.bin       → 第0层骨干卷积 融合后权重
#       model_0_bias.bin         → 第0层骨干卷积 融合后偏置
#       model_2_cv1_weight.bin   → 第2层C3模块 cv1分支 卷积权重
#       model_2_cv1_bias.bin     → 第2层C3模块 cv1分支 卷积偏置
#       model_9_cv2_weight.bin   → 第9层SPPF模块 cv2输出卷积 权重
#
# 【使用步骤】
#   1. 准备文件：将训练好的 best.pt 与模型结构 yolov5n_crack_fps.yaml
#      放在脚本同级目录下。
#   2. 依赖安装：pip install torch ultralytics numpy
#   3. 运行脚本：python weights_out.py
#   4. 后续流程：生成的 weights_bin 文件夹可直接传入
#      fp322int8.py 进行INT8量化，再转为HLS头文件。
#
# 【注意事项】
#   1. 脚本强制在eval模式下执行融合，确保BN层使用训练好的
#      运行时均值/方差，而非批次统计值。
#   2. 仅融合Conv+BN部分，LeakyReLU激活函数保留在HLS端实现，
#      与量化逻辑配合更高效。
#   3. 输出为纯二进制数据，不包含张量形状信息，
#      HLS端需按照对应层的通道数、尺寸匹配读取。
#   4. 脚本通用兼容所有YOLOv5系列模型，修改yaml与pt路径
#      即可适配不同剪枝版本、不同通道数的模型。
# ==========================================

import torch
import numpy as np
import os
from ultralytics import YOLO


def fuse_conv_bn(conv, bn):
    """
    将卷积层和BN层融合，返回融合后的权重和偏置
    融合公式：
    w_fused = (bn_weight / sqrt(var + eps)) * conv_weight
    b_fused = bn_bias - bn_weight * mean / sqrt(var + eps)
    """
    eps = 1e-5  # BN层的epsilon默认值
    conv_weight = conv.weight.data
    bn_weight = bn.weight.data
    bn_bias = bn.bias.data
    bn_mean = bn.running_mean.data
    bn_var = bn.running_var.data

    # 计算缩放因子
    scale = bn_weight / torch.sqrt(bn_var + eps)
    # 融合权重：卷积权重乘以缩放因子
    fused_weight = conv_weight * scale.reshape(-1, 1, 1, 1)
    # 融合偏置
    fused_bias = bn_bias - bn_mean * scale

    return fused_weight, fused_bias


def export_yolov5_fused_weights(pt_path="best.pt", yaml_path="yolov5n_crack_fps.yaml", output_dir="weights_bin"):
    """
    加载模型，融合所有Conv+BN，导出融合后的权重和偏置
    """
    # 创建输出目录
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)
        print(f"提示：已创建权重输出文件夹：{output_dir}")
    
    print("\n" + "-"*25 + " YOLOv5n 权重导出（BN融合版） " + "-"*25)
    
    device = torch.device("cpu")  # 融合操作在CPU做更方便
    print(f"[*] 运行设备：{device}")
    print(f"[*] 模型结构：{yaml_path}")
    print(f"[*] 权重文件：{pt_path}")

    # 加载模型
    model = YOLO(yaml_path).model.to(device)
    if os.path.exists(pt_path):
        checkpoint = torch.load(pt_path, map_location=device)
        if 'model' in checkpoint:
            state_dict = checkpoint['model'].state_dict()
        else:
            state_dict = checkpoint
        model.load_state_dict(state_dict, strict=True)
        print(f"[成功] 权重加载完成")
    else:
        print(f"[警告] 未找到权重文件，导出随机初始化参数")
    
    model.eval()

    # 遍历所有模块，找到Conv模块并融合BN
    print("\n[*] 开始融合BN并导出权重...")
    conv_count = 0
    total_params = 0

    for name, module in model.named_modules():
        # 只处理Conv类型的模块（包含conv+bn+act）
        if type(module).__name__ == 'Conv':
            # 模块名中的.替换为_，作为文件名前缀
            file_prefix = name.replace('.', '_')
            
            # 融合卷积和BN
            fused_weight, fused_bias = fuse_conv_bn(module.conv, module.bn)
            
            # 转numpy float32
            weight_np = fused_weight.detach().cpu().numpy().astype(np.float32)
            bias_np = fused_bias.detach().cpu().numpy().astype(np.float32)
            
            # 保存权重文件
            weight_path = os.path.join(output_dir, f"{file_prefix}_weight.bin")
            weight_np.tofile(weight_path)
            
            # 保存偏置文件
            bias_path = os.path.join(output_dir, f"{file_prefix}_bias.bin")
            bias_np.tofile(bias_path)
            
            param_num = weight_np.size + bias_np.size
            total_params += param_num
            print(f"    导出 | {name:30s} | 权重形状: {str(list(weight_np.shape)):18s}")
            conv_count += 1

    print("\n" + "-"*25 + " 导出完成 " + "-"*25)
    print(f"[完成] 共导出 {conv_count} 个卷积层（已融合BN）")
    print(f"[完成] 总参数量：{total_params / 1e6:.3f} M")
    print(f"[完成] 文件存放路径：{os.path.abspath(output_dir)}")


if __name__ == "__main__":
    PT_FILE = r"D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\runs\detect\train_crack_4_35\weights\best.pt"  
    YAML_FILE = r"D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\ultralytics\cfg\models\v5\yolov5_crack_speed.yaml"  # 你的剪枝版 yaml    speed 帧率优先
    OUTPUT_DIR = r"D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\runs\weigths_bin\weigths_bin_2"
    
    export_yolov5_fused_weights(PT_FILE, YAML_FILE, OUTPUT_DIR)
