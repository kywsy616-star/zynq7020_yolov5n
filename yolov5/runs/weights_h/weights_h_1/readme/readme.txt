PS D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5> (Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned) ; (& d:\PythonEnvs\yolov8\Scripts\Activate.ps1)
(yolov8) PS D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5> & d:\PythonEnvs\yolov8\Scripts\python.exe d:/02_workspace/05_ascend_projects/yolo_pavement/yolov5/scripts/HLS_export/convert_bin2h.py

------------------------- 路径检查 -------------------------
[*] 读取文件夹: D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\runs\weights_bin_int8\weights_bin_int8_1
[*] 当前工作目录: D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5
-----------------------------------------------------------

[*] 发现 137 个 INT8 权重文件
[*] 发现 137 个 scale 缩放因子文件
[*] 发现 71 个 int32 偏置文件
[*] 开始生成头文件...

    [1/3] 正在写入 INT8 权重数组...
    [2/3] 正在写入 Scale 缩放因子数组...
    [3/3] 正在写入 Int32 偏置数组...

[*] 正在写入文件: D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\runs\weights_h\weights_h_1\weights_int8_data.h
------------------------- 转换任务成功完成 -------------------------
[成功] 累计权重元素: 717792 个
[成功] 文件保存位置: D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\runs\weights_h\weights_h_1\weights_int8_data.h
(yolov8) PS D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5> 