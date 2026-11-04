# ==========================================
# FP32 权重转 INT8 量化脚本（适配 YOLOv5n 剪枝版）
# 量化方式：对称逐张量量化（FPGA 友好，计算逻辑最简）
# 输出：
#   *_int8.bin   : INT8 格式权重
#   *_scale.bin  : 对应缩放因子（float32，每层1个）
#   *_int32.bin  : 偏置转为 int32（直接参与 int32 累加）
# ==========================================
import numpy as np
import os

def quantize_fp32_to_int8(input_dir="weights_bin", output_dir="weights_int8_bin"):
    """
    批量将 FP32 权重量化为 INT8，偏置转为 int32
    :param input_dir: FP32 权重所在文件夹
    :param output_dir: INT8 结果输出文件夹
    """
    # -------------------------- 步骤1：环境检查 --------------------------
    if not os.path.exists(input_dir):
        print(f"【错误】找不到输入文件夹 {input_dir}，请先运行 weights_out.py")
        return
    
    os.makedirs(output_dir, exist_ok=True)
    print("\n" + "-"*25 + " FP32 → INT8 量化开始 " + "-"*25)
    
    bin_files = sorted([f for f in os.listdir(input_dir) if f.endswith('.bin')])
    if not bin_files:
        print(f"【错误】{input_dir} 中没有找到 .bin 文件")
        return
    print(f"[*] 找到 {len(bin_files)} 个 FP32 文件，开始量化...\n")
    
    weight_count = 0
    bias_count = 0
    total_error = 0.0
    
    # -------------------------- 步骤2：遍历文件逐个量化 --------------------------
    for bin_file in bin_files:
        file_path = os.path.join(input_dir, bin_file)
        fp32_data = np.fromfile(file_path, dtype=np.float32)
        
        # 通过文件名区分权重与偏置
        is_bias = "bias" in bin_file
        
        if is_bias:
            # -------------------------- 偏置处理：转 int32 --------------------------
            # 卷积累加结果为 int32，偏置直接以 int32 形式相加，无需额外缩放
            int32_data = np.round(fp32_data).astype(np.int32)
            out_file = bin_file.replace(".bin", "_int32.bin")
            out_path = os.path.join(output_dir, out_file)
            int32_data.tofile(out_path)
            
            print(f"    [偏置] {bin_file:38s} → int32 | 元素数: {len(fp32_data):>6d}")
            bias_count += 1
        
        else:
            # -------------------------- 权重处理：对称 INT8 量化 --------------------------
            max_abs = np.max(np.abs(fp32_data))
            
            # 防止全零权重导致除零
            if max_abs == 0:
                scale = 1.0
            else:
                scale = max_abs / 127.0  # 正数最大值映射到 127，对称量化零点为0
            
            # 量化计算：除以缩放因子 → 四舍五入 → 裁剪到 int8 范围
            int8_data = np.round(fp32_data / scale)
            int8_data = np.clip(int8_data, -128, 127).astype(np.int8)
            
            # 计算量化误差（均方误差）
            dequant_data = int8_data.astype(np.float32) * scale
            mse = np.mean((fp32_data - dequant_data) ** 2)
            total_error += mse
            
            # 保存 INT8 权重
            out_weight_file = bin_file.replace(".bin", "_int8.bin")
            out_weight_path = os.path.join(output_dir, out_weight_file)
            int8_data.tofile(out_weight_path)
            
            # 保存缩放因子（float32 格式）
            scale_file = bin_file.replace(".bin", "_scale.bin")
            scale_path = os.path.join(output_dir, scale_file)
            np.array([scale], dtype=np.float32).tofile(scale_path)
            
            print(f"    [权重] {bin_file:38s} → int8 | scale: {scale:.8f} | MSE: {mse:.6e}")
            weight_count += 1
    
    # -------------------------- 步骤3：任务收尾 --------------------------
    print("\n" + "-"*25 + " 量化任务完成 " + "-"*25)
    print(f"[完成] 共量化 {weight_count} 个权重文件，{bias_count} 个偏置文件")
    print(f"[完成] 平均量化 MSE：{total_error / weight_count:.6e}")
    print(f"[完成] INT8 文件存放路径：{os.path.abspath(output_dir)}")

# -------------------------- 程序入口 --------------------------
if __name__ == "__main__":
    INPUT_DIR = r"D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\runs\weigths_bin\weigths_bin_2"        # FP32 权重输入文件夹
    OUTPUT_DIR = r"D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\runs\weights_bin_int8\weights_bin_int8_2"  # INT8 结果输出文件夹
    quantize_fp32_to_int8(INPUT_DIR, OUTPUT_DIR)

# ==========================================
# 进阶说明：
# 1. 当前为逐张量量化（整个权重共享1个scale），7020 实现最简单
# 2. 若需提升精度，可改为逐通道量化（每个输出通道1个scale）
#    需修改：按输出通道维度计算 max_abs，生成通道数长度的 scale 数组
# 3. 你的模型通道都是16的倍数，逐通道量化后 AXI 总线对齐更友好
# ==========================================