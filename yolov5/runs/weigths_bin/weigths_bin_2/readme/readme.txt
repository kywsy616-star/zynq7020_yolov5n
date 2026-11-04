PS D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5> (Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned) ; (& d:\PythonEnvs\yolov8\Scripts\Activate.ps1)
(yolov8) PS D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5> & d:\PythonEnvs\yolov8\Scripts\python.exe d:/02_workspace/05_ascend_projects/yolo_pavement/yolov5/scripts/HLS_export/weights_out.py
提示：已创建权重输出文件夹：D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\runs\weigths_bin\weigths_bin_2

------------------------- YOLOv5n 权重导出（BN融合版） -------------------------
[*] 运行设备：cpu
[*] 模型结构：D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\ultralytics\cfg\models\v5\yolov5_crack_speed.yaml
[*] 权重文件：D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\runs\detect\train_crack_4_35\weights\best.pt
[成功] 权重加载完成

[*] 开始融合BN并导出权重...
    导出 | model.0                        | 权重形状: [16, 3, 3, 3]     
    导出 | model.1                        | 权重形状: [32, 16, 3, 3]    
    导出 | model.2.cv1                    | 权重形状: [16, 32, 1, 1]    
    导出 | model.2.cv2                    | 权重形状: [16, 32, 1, 1]    
    导出 | model.2.cv3                    | 权重形状: [32, 32, 1, 1]    
    导出 | model.2.m.0.cv1                | 权重形状: [16, 16, 1, 1]    
    导出 | model.2.m.0.cv2                | 权重形状: [16, 16, 3, 3]    
    导出 | model.3                        | 权重形状: [32, 32, 3, 3]    
    导出 | model.4.cv1                    | 权重形状: [16, 32, 1, 1]    
    导出 | model.4.cv2                    | 权重形状: [16, 32, 1, 1]    
    导出 | model.4.cv3                    | 权重形状: [32, 32, 1, 1]    
    导出 | model.4.m.0.cv1                | 权重形状: [16, 16, 1, 1]    
    导出 | model.4.m.0.cv2                | 权重形状: [16, 16, 3, 3]    
    导出 | model.5                        | 权重形状: [48, 32, 3, 3]    
    导出 | model.6.cv1                    | 权重形状: [24, 48, 1, 1]    
    导出 | model.6.cv2                    | 权重形状: [24, 48, 1, 1]    
    导出 | model.6.cv3                    | 权重形状: [48, 48, 1, 1]    
    导出 | model.6.m.0.cv1                | 权重形状: [24, 24, 1, 1]    
    导出 | model.6.m.0.cv2                | 权重形状: [24, 24, 3, 3]    
    导出 | model.6.m.1.cv1                | 权重形状: [24, 24, 1, 1]    
    导出 | model.6.m.1.cv2                | 权重形状: [24, 24, 3, 3]    
    导出 | model.7                        | 权重形状: [96, 48, 3, 3]    
    导出 | model.8.cv1                    | 权重形状: [48, 96, 1, 1]    
    导出 | model.8.cv2                    | 权重形状: [48, 96, 1, 1]    
    导出 | model.8.cv3                    | 权重形状: [96, 96, 1, 1]    
    导出 | model.8.m.0.cv1                | 权重形状: [48, 48, 1, 1]    
    导出 | model.8.m.0.cv2                | 权重形状: [48, 48, 3, 3]    
    导出 | model.9.cv1                    | 权重形状: [48, 96, 1, 1]    
    导出 | model.9.cv2                    | 权重形状: [96, 192, 1, 1]   
    导出 | model.10                       | 权重形状: [48, 96, 1, 1]    
    导出 | model.13.cv1                   | 权重形状: [24, 96, 1, 1]    
    导出 | model.13.cv2                   | 权重形状: [24, 96, 1, 1]    
    导出 | model.13.cv3                   | 权重形状: [48, 48, 1, 1]    
    导出 | model.13.m.0.cv1               | 权重形状: [24, 24, 1, 1]    
    导出 | model.13.m.0.cv2               | 权重形状: [24, 24, 3, 3]    
    导出 | model.14                       | 权重形状: [32, 48, 1, 1]    
    导出 | model.17.cv1                   | 权重形状: [16, 64, 1, 1]    
    导出 | model.17.cv2                   | 权重形状: [16, 64, 1, 1]    
    导出 | model.17.cv3                   | 权重形状: [32, 32, 1, 1]    
    导出 | model.17.m.0.cv1               | 权重形状: [16, 16, 1, 1]    
    导出 | model.17.m.0.cv2               | 权重形状: [16, 16, 3, 3]    
    导出 | model.18                       | 权重形状: [48, 32, 3, 3]    
    导出 | model.20.cv1                   | 权重形状: [32, 80, 1, 1]    
    导出 | model.20.cv2                   | 权重形状: [32, 80, 1, 1]    
    导出 | model.20.cv3                   | 权重形状: [64, 64, 1, 1]    
    导出 | model.20.m.0.cv1               | 权重形状: [32, 32, 1, 1]    
    导出 | model.20.m.0.cv2               | 权重形状: [32, 32, 3, 3]    
    导出 | model.21                       | 权重形状: [128, 64, 3, 3]   
    导出 | model.23.cv1                   | 权重形状: [64, 176, 1, 1]   
    导出 | model.23.cv2                   | 权重形状: [64, 176, 1, 1]   
    导出 | model.23.cv3                   | 权重形状: [128, 128, 1, 1]  
    导出 | model.23.m.0.cv1               | 权重形状: [64, 64, 1, 1]    
    导出 | model.23.m.0.cv2               | 权重形状: [64, 64, 3, 3]    
    导出 | model.24.cv2.0.0               | 权重形状: [64, 32, 3, 3]    
    导出 | model.24.cv2.0.1               | 权重形状: [64, 64, 3, 3]    
    导出 | model.24.cv2.1.0               | 权重形状: [64, 64, 3, 3]    
    导出 | model.24.cv2.1.1               | 权重形状: [64, 64, 3, 3]    
    导出 | model.24.cv2.2.0               | 权重形状: [64, 128, 3, 3]   
    导出 | model.24.cv2.2.1               | 权重形状: [64, 64, 3, 3]    
    导出 | model.24.cv3.0.0               | 权重形状: [32, 32, 3, 3]    
    导出 | model.24.cv3.0.1               | 权重形状: [32, 32, 3, 3]    
    导出 | model.24.cv3.1.0               | 权重形状: [32, 64, 3, 3]    
    导出 | model.24.cv3.1.1               | 权重形状: [32, 32, 3, 3]    
    导出 | model.24.cv3.2.0               | 权重形状: [32, 128, 3, 3]   
    导出 | model.24.cv3.2.1               | 权重形状: [32, 32, 3, 3]    

------------------------- 导出完成 -------------------------
[完成] 共导出 65 个卷积层（已融合BN）
[完成] 总参数量：0.705 M
[完成] 文件存放路径：D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\runs\weigths_bin\weigths_bin_2
(yolov8) PS D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5> 