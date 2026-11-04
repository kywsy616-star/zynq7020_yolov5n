# ==========================================
# INT8 权重二进制文件转 C 语言头文件脚本（类型统一版）
# ==========================================
# 【脚本定位】
#   YOLOv5n FPGA部署权重处理流水线第三步：
#   weights_out.py（BN融合导出FP32）→ fp322int8.py（INT8量化）→ 本脚本（生成HLS头文件）
#   专门适配黑金7020 + Vitis HLS 2020.2工程，输出可直接加入HLS源码目录调用。
#
# 【核心功能】
#   批量读取weights_int8_bin文件夹下的INT8权重、float32缩放因子、int32偏置二进制文件，
#   统一转换为C语言数组形式，打包输出为单个weights_int8_data.h头文件，
#   无需手动复制权重，HLS工程直接include即可使用所有量化参数。
#
# 【与原始版本核心差异（解决编译报错关键修改）】
#   ✅ 全局类型统一：所有数组类型采用工程自定义的hls_int8 / hls_int32 / hls_float32
#      彻底解决「signed char* 无法转换为hls_int8*」的指针类型不匹配编译错误
#   ✅ 命名完全对应：数组名与二进制文件名一一对应，与yolov5n_top.cpp调用的变量名完全匹配
#   ✅ 保留原有排版：每10个元素换行，避免单行过长导致HLS编译解析缓慢
#   ✅ 自动分类处理：自动识别权重、缩放因子、偏置三类文件，按顺序生成
#
# 【避坑指南（踩过的坑总结）】
#   1. ❗类型名必须完全匹配
#      本脚本生成的hls_int8/hls_int32/hls_float32类型名，
#      必须与yolov5n_hls.h中typedef定义的类型名完全一致，
#      大小写、拼写差一个字符都会触发指针类型转换失败的编译错误。
#      这是本次修复「cannot convert 'signed char*' to 'hls_int8*'」错误的核心。
#
#   2. ❗变量名与bin文件强绑定
#      数组名直接由二进制文件名生成（去掉后缀+替换特殊字符），
#      上游weights_out.py导出的bin文件名不能随意修改，
#      否则yolov5n_top.cpp中调用的权重变量名会找不到，报未声明错误。
#
#   3. ❗纯二进制数据无形状信息
#      .bin文件和生成的数组只存储数值，不存储张量形状信息，
#      HLS端调用时必须严格对应该层的通道数、卷积核尺寸、特征图尺寸，
#      尺寸错配不会报错，但计算结果完全错误。
#
#   4. ❗内存顺序与C语言一致
#      numpy的tofile()输出为行优先（C风格）存储，与C语言数组内存顺序完全匹配，
#      且为小端格式，与Zynq ARM端、FPGA端字节序一致，无需额外转换。
#
#   5. ❗头文件大小注意
#      本方案适合小模型剪枝版（总权重<1MB），完整大模型不建议存头文件，
#      黑金7020的BRAM资源有限，过大会导致综合时内存溢出。
#      当前yolov5n剪枝版INT8总权重约0.7MB，放在头文件中完全可行。
#
#   6. ❗编码与注释注意
#      生成的头文件为UTF-8编码，HLS编译器对中文注释兼容性一般，
#      若编译出现乱码错误，可删除中文注释只保留英文。
#
# 【使用流程】
#   1. 确保已运行fp322int8.py，生成weights_int8_bin文件夹及内部bin文件
#   2. 运行本脚本：python convert_bin2h.py
#   3. 将生成的weight_data_h/weights_int8_data.h复制到HLS工程src目录下
#   4. 确保yolov5n_hls.h中已定义对应hls_*类型
#   5. 重新运行C仿真即可通过类型检查
# ==========================================

import numpy as np
import os
import datetime

def convert_int8_bin_to_h(input_dir="weights_int8_bin", target_folder="weight_data_h", output_file="weights_int8_data.h"):
    """
    将所有 INT8 相关 bin 文件合并为一个 C 头文件，供 HLS 工程调用
    """
    # -------------------------- 步骤1：路径检查与文件分类 --------------------------
    abs_input_path = os.path.abspath(input_dir)
    print(f"\n{'-' * 25} 路径检查 {'-' * 25}")
    print(f"[*] 读取文件夹: {abs_input_path}")
    print(f"[*] 当前工作目录: {os.getcwd()}")
    print(f"{'-' * 59}\n")
    
    if not os.path.exists(input_dir):
        print(f"【错误】: 找不到文件夹 '{input_dir}'，请先运行 fp322int8.py")
        return
    
    all_files = sorted(os.listdir(input_dir))
    weight_files = sorted([f for f in all_files if f.endswith('_int8.bin')])
    scale_files = sorted([f for f in all_files if f.endswith('_scale.bin')])
    bias_files = sorted([f for f in all_files if f.endswith('_int32.bin')])
    
    if not weight_files:
        print(f"【错误】: 在 '{input_dir}' 中没有找到 _int8.bin 文件！")
        return
    
    print(f"[*] 发现 {len(weight_files)} 个 INT8 权重文件")
    print(f"[*] 发现 {len(scale_files)} 个 scale 缩放因子文件")
    print(f"[*] 发现 {len(bias_files)} 个 int32 偏置文件")
    print(f"[*] 开始生成头文件...\n")
    
    # -------------------------- 步骤2：初始化输出内容 --------------------------
    os.makedirs(target_folder, exist_ok=True)
    output_path = os.path.join(target_folder, output_file)
    header_content = []
    
    # 文件头注释
    now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    header_content.append("/* ========================================================= */")
    header_content.append(f"/* YOLOv5n 剪枝版 INT8 量化权重头文件 - 生成于: {now} */")
    header_content.append(f"/* 权重层数: {len(weight_files)} | 缩放因子: {len(scale_files)} | 偏置层数: {len(bias_files)} */")
    header_content.append("/* 适配平台：黑金 XC7Z020 + Vitis HLS 2020.2 */")
    header_content.append("/* 类型说明：与工程全局自定义类型 hls_xxx 完全一致 */")
    header_content.append("/* ========================================================= */\n")
    
    # 头文件保护宏，防止重复包含导致重定义错误
    header_content.append("#ifndef WEIGHTS_INT8_DATA_H")
    header_content.append("#define WEIGHTS_INT8_DATA_H\n")
    
    total_weight_elems = 0
    
    # -------------------------- 步骤3：写入 INT8 权重数组（类型：hls_int8） --------------------------
    print("    [1/3] 正在写入 INT8 权重数组...")
    for bin_file in weight_files:
        full_path = os.path.join(input_dir, bin_file)
        # 变量名生成：去掉_int8.bin后缀，替换点和横杠为下划线
        var_name = bin_file.replace("_int8.bin", "").replace("-", "_").replace(".", "_")
        
        try:
            weights = np.fromfile(full_path, dtype=np.int8)
            num_elements = len(weights)
            total_weight_elems += num_elements
            
            header_content.append(f"// 来源: {bin_file} (INT8 权重)")
            header_content.append(f"hls_int8 {var_name}[{num_elements}] = {{")
            
            # 每10个元素换行，避免单行过长
            for i in range(0, num_elements, 10):
                chunk = weights[i: i + 10]
                line_str = ", ".join([str(v) for v in chunk])
                header_content.append(f"    {line_str},")
            
            header_content.append("};\n")
            
        except Exception as e:
            print(f"        【警告】读取 {bin_file} 失败: {e}")
    
    # -------------------------- 步骤4：写入 Scale 缩放因子数组（类型：hls_float32） --------------------------
    print("    [2/3] 正在写入 Scale 缩放因子数组...")
    for bin_file in scale_files:
        full_path = os.path.join(input_dir, bin_file)
        var_name = bin_file.replace("_scale.bin", "").replace("-", "_").replace(".", "_") + "_scale"
        
        try:
            scales = np.fromfile(full_path, dtype=np.float32)
            num_elements = len(scales)
            
            header_content.append(f"// 来源: {bin_file} (缩放因子，float32)")
            header_content.append(f"hls_float32 {var_name}[{num_elements}] = {{")
            
            for i in range(0, num_elements, 10):
                chunk = scales[i: i + 10]
                line_str = ", ".join([f"{v:.8f}f" for v in chunk])
                header_content.append(f"    {line_str},")
            
            header_content.append("};\n")
            
        except Exception as e:
            print(f"        【警告】读取 {bin_file} 失败: {e}")
    
    # -------------------------- 步骤5：写入 Int32 偏置数组（类型：hls_int32） --------------------------
    print("    [3/3] 正在写入 Int32 偏置数组...")
    for bin_file in bias_files:
        full_path = os.path.join(input_dir, bin_file)
        var_name = bin_file.replace("_int32.bin", "").replace("-", "_").replace(".", "_")
        
        try:
            biases = np.fromfile(full_path, dtype=np.int32)
            num_elements = len(biases)
            
            header_content.append(f"// 来源: {bin_file} (偏置，int32)")
            header_content.append(f"hls_int32 {var_name}[{num_elements}] = {{")
            
            for i in range(0, num_elements, 10):
                chunk = biases[i: i + 10]
                line_str = ", ".join([str(v) for v in chunk])
                header_content.append(f"    {line_str},")
            
            header_content.append("};\n")
            
        except Exception as e:
            print(f"        【警告】读取 {bin_file} 失败: {e}")
    
    # 闭合头文件保护宏
    header_content.append("#endif // WEIGHTS_INT8_DATA_H")
    
    # -------------------------- 步骤6：一次性写入文件 --------------------------
    print(f"\n[*] 正在写入文件: {output_path}")
    try:
        with open(output_path, "w", encoding='utf-8') as f:
            f.write("\n".join(header_content))
        
        print(f"{'-' * 25} 转换任务成功完成 {'-' * 25}")
        print(f"[成功] 累计权重元素: {total_weight_elems} 个")
        print(f"[成功] 文件保存位置: {os.path.abspath(output_path)}")
    except Exception as e:
        print(f"【系统错误】: 写入磁盘失败: {e}")

# -------------------------- 程序入口 --------------------------
if __name__ == "__main__":
    INPUT_DIR = r"D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\runs\weights_bin_int8\weights_bin_int8_2"  # INT8 权重输入文件夹
    TARGET_FOLDER = r"D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\runs\weights_h\weights_h_2"
    OUTPUT_FILE = "weights_int8_data.h"
    
    convert_int8_bin_to_h(INPUT_DIR, TARGET_FOLDER, OUTPUT_FILE)
