PS D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5> (Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned) ; (& d:\PythonEnvs\yolov8\Scripts\Activate.ps1)
(yolov8) PS D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5> & d:\PythonEnvs\yolov8\Scripts\python.exe d:/02_workspace/05_ascend_projects/yolo_pavement/yolov5/scripts/HLS_export/weights_out.py

------------------------- YOLOv5n 剪枝版 权重导出开始 -------------------------
[*] 运行设备：cuda
[*] 模型结构文件：D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\ultralytics\cfg\models\v5\yolov5_crack_speed.yaml
[*] 权重文件：D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\runs\detect\train_crack_4_35\weights\best.pt
[成功] 权重加载完成，结构与权重完全匹配

[*] 开始导出各层参数...
    导出 | model.0.conv.weight                 | 形状: [16, 3, 3, 3]      | 元素数:      432
    导出 | model.0.bn.weight                   | 形状: [16]               | 元素数:       16
    导出 | model.0.bn.bias                     | 形状: [16]               | 元素数:       16
    导出 | model.1.conv.weight                 | 形状: [32, 16, 3, 3]     | 元素数:     4608
    导出 | model.1.bn.weight                   | 形状: [32]               | 元素数:       32
    导出 | model.1.bn.bias                     | 形状: [32]               | 元素数:       32
    导出 | model.2.cv1.conv.weight             | 形状: [16, 32, 1, 1]     | 元素数:      512
    导出 | model.2.cv1.bn.weight               | 形状: [16]               | 元素数:       16
    导出 | model.2.cv1.bn.bias                 | 形状: [16]               | 元素数:       16
    导出 | model.2.cv2.conv.weight             | 形状: [16, 32, 1, 1]     | 元素数:      512
    导出 | model.2.cv2.bn.weight               | 形状: [16]               | 元素数:       16
    导出 | model.2.cv2.bn.bias                 | 形状: [16]               | 元素数:       16
    导出 | model.2.cv3.conv.weight             | 形状: [32, 32, 1, 1]     | 元素数:     1024
    导出 | model.2.cv3.bn.weight               | 形状: [32]               | 元素数:       32
    导出 | model.2.cv3.bn.bias                 | 形状: [32]               | 元素数:       32
    导出 | model.2.m.0.cv1.conv.weight         | 形状: [16, 16, 1, 1]     | 元素数:      256
    导出 | model.2.m.0.cv1.bn.weight           | 形状: [16]               | 元素数:       16
    导出 | model.2.m.0.cv1.bn.bias             | 形状: [16]               | 元素数:       16
    导出 | model.2.m.0.cv2.conv.weight         | 形状: [16, 16, 3, 3]     | 元素数:     2304
    导出 | model.2.m.0.cv2.bn.weight           | 形状: [16]               | 元素数:       16
    导出 | model.2.m.0.cv2.bn.bias             | 形状: [16]               | 元素数:       16
    导出 | model.3.conv.weight                 | 形状: [32, 32, 3, 3]     | 元素数:     9216
    导出 | model.3.bn.weight                   | 形状: [32]               | 元素数:       32
    导出 | model.3.bn.bias                     | 形状: [32]               | 元素数:       32
    导出 | model.4.cv1.conv.weight             | 形状: [16, 32, 1, 1]     | 元素数:      512
    导出 | model.4.cv1.bn.weight               | 形状: [16]               | 元素数:       16
    导出 | model.4.cv1.bn.bias                 | 形状: [16]               | 元素数:       16
    导出 | model.4.cv2.conv.weight             | 形状: [16, 32, 1, 1]     | 元素数:      512
    导出 | model.4.cv2.bn.weight               | 形状: [16]               | 元素数:       16
    导出 | model.4.cv2.bn.bias                 | 形状: [16]               | 元素数:       16
    导出 | model.4.cv3.conv.weight             | 形状: [32, 32, 1, 1]     | 元素数:     1024
    导出 | model.4.cv3.bn.weight               | 形状: [32]               | 元素数:       32
    导出 | model.4.cv3.bn.bias                 | 形状: [32]               | 元素数:       32
    导出 | model.4.m.0.cv1.conv.weight         | 形状: [16, 16, 1, 1]     | 元素数:      256
    导出 | model.4.m.0.cv1.bn.weight           | 形状: [16]               | 元素数:       16
    导出 | model.4.m.0.cv1.bn.bias             | 形状: [16]               | 元素数:       16
    导出 | model.4.m.0.cv2.conv.weight         | 形状: [16, 16, 3, 3]     | 元素数:     2304
    导出 | model.4.m.0.cv2.bn.weight           | 形状: [16]               | 元素数:       16
    导出 | model.4.m.0.cv2.bn.bias             | 形状: [16]               | 元素数:       16
    导出 | model.5.conv.weight                 | 形状: [48, 32, 3, 3]     | 元素数:    13824
    导出 | model.5.bn.weight                   | 形状: [48]               | 元素数:       48
    导出 | model.5.bn.bias                     | 形状: [48]               | 元素数:       48
    导出 | model.6.cv1.conv.weight             | 形状: [24, 48, 1, 1]     | 元素数:     1152
    导出 | model.6.cv1.bn.weight               | 形状: [24]               | 元素数:       24
    导出 | model.6.cv1.bn.bias                 | 形状: [24]               | 元素数:       24
    导出 | model.6.cv2.conv.weight             | 形状: [24, 48, 1, 1]     | 元素数:     1152
    导出 | model.6.cv2.bn.weight               | 形状: [24]               | 元素数:       24
    导出 | model.6.cv2.bn.bias                 | 形状: [24]               | 元素数:       24
    导出 | model.6.cv3.conv.weight             | 形状: [48, 48, 1, 1]     | 元素数:     2304
    导出 | model.6.cv3.bn.weight               | 形状: [48]               | 元素数:       48
    导出 | model.6.cv3.bn.bias                 | 形状: [48]               | 元素数:       48
    导出 | model.6.m.0.cv1.conv.weight         | 形状: [24, 24, 1, 1]     | 元素数:      576
    导出 | model.6.m.0.cv1.bn.weight           | 形状: [24]               | 元素数:       24
    导出 | model.6.m.0.cv1.bn.bias             | 形状: [24]               | 元素数:       24
    导出 | model.6.m.0.cv2.conv.weight         | 形状: [24, 24, 3, 3]     | 元素数:     5184
    导出 | model.6.m.0.cv2.bn.weight           | 形状: [24]               | 元素数:       24
    导出 | model.6.m.0.cv2.bn.bias             | 形状: [24]               | 元素数:       24
    导出 | model.6.m.1.cv1.conv.weight         | 形状: [24, 24, 1, 1]     | 元素数:      576
    导出 | model.6.m.1.cv1.bn.weight           | 形状: [24]               | 元素数:       24
    导出 | model.6.m.1.cv1.bn.bias             | 形状: [24]               | 元素数:       24
    导出 | model.6.m.1.cv2.conv.weight         | 形状: [24, 24, 3, 3]     | 元素数:     5184
    导出 | model.6.m.1.cv2.bn.weight           | 形状: [24]               | 元素数:       24
    导出 | model.6.m.1.cv2.bn.bias             | 形状: [24]               | 元素数:       24
    导出 | model.7.conv.weight                 | 形状: [96, 48, 3, 3]     | 元素数:    41472
    导出 | model.7.bn.weight                   | 形状: [96]               | 元素数:       96
    导出 | model.7.bn.bias                     | 形状: [96]               | 元素数:       96
    导出 | model.8.cv1.conv.weight             | 形状: [48, 96, 1, 1]     | 元素数:     4608
    导出 | model.8.cv1.bn.weight               | 形状: [48]               | 元素数:       48
    导出 | model.8.cv1.bn.bias                 | 形状: [48]               | 元素数:       48
    导出 | model.8.cv2.conv.weight             | 形状: [48, 96, 1, 1]     | 元素数:     4608
    导出 | model.8.cv2.bn.weight               | 形状: [48]               | 元素数:       48
    导出 | model.8.cv2.bn.bias                 | 形状: [48]               | 元素数:       48
    导出 | model.8.cv3.conv.weight             | 形状: [96, 96, 1, 1]     | 元素数:     9216
    导出 | model.8.cv3.bn.weight               | 形状: [96]               | 元素数:       96
    导出 | model.8.cv3.bn.bias                 | 形状: [96]               | 元素数:       96
    导出 | model.8.m.0.cv1.conv.weight         | 形状: [48, 48, 1, 1]     | 元素数:     2304
    导出 | model.8.m.0.cv1.bn.weight           | 形状: [48]               | 元素数:       48
    导出 | model.8.m.0.cv1.bn.bias             | 形状: [48]               | 元素数:       48
    导出 | model.8.m.0.cv2.conv.weight         | 形状: [48, 48, 3, 3]     | 元素数:    20736
    导出 | model.8.m.0.cv2.bn.weight           | 形状: [48]               | 元素数:       48
    导出 | model.8.m.0.cv2.bn.bias             | 形状: [48]               | 元素数:       48
    导出 | model.9.cv1.conv.weight             | 形状: [48, 96, 1, 1]     | 元素数:     4608
    导出 | model.9.cv1.bn.weight               | 形状: [48]               | 元素数:       48
    导出 | model.9.cv1.bn.bias                 | 形状: [48]               | 元素数:       48
    导出 | model.9.cv2.conv.weight             | 形状: [96, 192, 1, 1]    | 元素数:    18432
    导出 | model.9.cv2.bn.weight               | 形状: [96]               | 元素数:       96
    导出 | model.9.cv2.bn.bias                 | 形状: [96]               | 元素数:       96
    导出 | model.10.conv.weight                | 形状: [48, 96, 1, 1]     | 元素数:     4608
    导出 | model.10.bn.weight                  | 形状: [48]               | 元素数:       48
    导出 | model.10.bn.bias                    | 形状: [48]               | 元素数:       48
    导出 | model.13.cv1.conv.weight            | 形状: [24, 96, 1, 1]     | 元素数:     2304
    导出 | model.13.cv1.bn.weight              | 形状: [24]               | 元素数:       24
    导出 | model.13.cv1.bn.bias                | 形状: [24]               | 元素数:       24
    导出 | model.13.cv2.conv.weight            | 形状: [24, 96, 1, 1]     | 元素数:     2304
    导出 | model.13.cv2.bn.weight              | 形状: [24]               | 元素数:       24
    导出 | model.13.cv2.bn.bias                | 形状: [24]               | 元素数:       24
    导出 | model.13.cv3.conv.weight            | 形状: [48, 48, 1, 1]     | 元素数:     2304
    导出 | model.13.cv3.bn.weight              | 形状: [48]               | 元素数:       48
    导出 | model.13.cv3.bn.bias                | 形状: [48]               | 元素数:       48
    导出 | model.13.m.0.cv1.conv.weight        | 形状: [24, 24, 1, 1]     | 元素数:      576
    导出 | model.13.m.0.cv1.bn.weight          | 形状: [24]               | 元素数:       24
    导出 | model.13.m.0.cv1.bn.bias            | 形状: [24]               | 元素数:       24
    导出 | model.13.m.0.cv2.conv.weight        | 形状: [24, 24, 3, 3]     | 元素数:     5184
    导出 | model.13.m.0.cv2.bn.weight          | 形状: [24]               | 元素数:       24
    导出 | model.13.m.0.cv2.bn.bias            | 形状: [24]               | 元素数:       24
    导出 | model.14.conv.weight                | 形状: [32, 48, 1, 1]     | 元素数:     1536
    导出 | model.14.bn.weight                  | 形状: [32]               | 元素数:       32
    导出 | model.14.bn.bias                    | 形状: [32]               | 元素数:       32
    导出 | model.17.cv1.conv.weight            | 形状: [16, 64, 1, 1]     | 元素数:     1024
    导出 | model.17.cv1.bn.weight              | 形状: [16]               | 元素数:       16
    导出 | model.17.cv1.bn.bias                | 形状: [16]               | 元素数:       16
    导出 | model.17.cv2.conv.weight            | 形状: [16, 64, 1, 1]     | 元素数:     1024
    导出 | model.17.cv2.bn.weight              | 形状: [16]               | 元素数:       16
    导出 | model.17.cv2.bn.bias                | 形状: [16]               | 元素数:       16
    导出 | model.17.cv3.conv.weight            | 形状: [32, 32, 1, 1]     | 元素数:     1024
    导出 | model.17.cv3.bn.weight              | 形状: [32]               | 元素数:       32
    导出 | model.17.cv3.bn.bias                | 形状: [32]               | 元素数:       32
    导出 | model.17.m.0.cv1.conv.weight        | 形状: [16, 16, 1, 1]     | 元素数:      256
    导出 | model.17.m.0.cv1.bn.weight          | 形状: [16]               | 元素数:       16
    导出 | model.17.m.0.cv1.bn.bias            | 形状: [16]               | 元素数:       16
    导出 | model.17.m.0.cv2.conv.weight        | 形状: [16, 16, 3, 3]     | 元素数:     2304
    导出 | model.17.m.0.cv2.bn.weight          | 形状: [16]               | 元素数:       16
    导出 | model.17.m.0.cv2.bn.bias            | 形状: [16]               | 元素数:       16
    导出 | model.18.conv.weight                | 形状: [48, 32, 3, 3]     | 元素数:    13824
    导出 | model.18.bn.weight                  | 形状: [48]               | 元素数:       48
    导出 | model.18.bn.bias                    | 形状: [48]               | 元素数:       48
    导出 | model.20.cv1.conv.weight            | 形状: [32, 80, 1, 1]     | 元素数:     2560
    导出 | model.20.cv1.bn.weight              | 形状: [32]               | 元素数:       32
    导出 | model.20.cv1.bn.bias                | 形状: [32]               | 元素数:       32
    导出 | model.20.cv2.conv.weight            | 形状: [32, 80, 1, 1]     | 元素数:     2560
    导出 | model.20.cv2.bn.weight              | 形状: [32]               | 元素数:       32
    导出 | model.20.cv2.bn.bias                | 形状: [32]               | 元素数:       32
    导出 | model.20.cv3.conv.weight            | 形状: [64, 64, 1, 1]     | 元素数:     4096
    导出 | model.20.cv3.bn.weight              | 形状: [64]               | 元素数:       64
    导出 | model.20.cv3.bn.bias                | 形状: [64]               | 元素数:       64
    导出 | model.20.m.0.cv1.conv.weight        | 形状: [32, 32, 1, 1]     | 元素数:     1024
    导出 | model.20.m.0.cv1.bn.weight          | 形状: [32]               | 元素数:       32
    导出 | model.20.m.0.cv1.bn.bias            | 形状: [32]               | 元素数:       32
    导出 | model.20.m.0.cv2.conv.weight        | 形状: [32, 32, 3, 3]     | 元素数:     9216
    导出 | model.20.m.0.cv2.bn.weight          | 形状: [32]               | 元素数:       32
    导出 | model.20.m.0.cv2.bn.bias            | 形状: [32]               | 元素数:       32
    导出 | model.21.conv.weight                | 形状: [128, 64, 3, 3]    | 元素数:    73728
    导出 | model.21.bn.weight                  | 形状: [128]              | 元素数:      128
    导出 | model.21.bn.bias                    | 形状: [128]              | 元素数:      128
    导出 | model.23.cv1.conv.weight            | 形状: [64, 176, 1, 1]    | 元素数:    11264
    导出 | model.23.cv1.bn.weight              | 形状: [64]               | 元素数:       64
    导出 | model.23.cv1.bn.bias                | 形状: [64]               | 元素数:       64
    导出 | model.23.cv2.conv.weight            | 形状: [64, 176, 1, 1]    | 元素数:    11264
    导出 | model.23.cv2.bn.weight              | 形状: [64]               | 元素数:       64
    导出 | model.23.cv2.bn.bias                | 形状: [64]               | 元素数:       64
    导出 | model.23.cv3.conv.weight            | 形状: [128, 128, 1, 1]   | 元素数:    16384
    导出 | model.23.cv3.bn.weight              | 形状: [128]              | 元素数:      128
    导出 | model.23.cv3.bn.bias                | 形状: [128]              | 元素数:      128
    导出 | model.23.m.0.cv1.conv.weight        | 形状: [64, 64, 1, 1]     | 元素数:     4096
    导出 | model.23.m.0.cv1.bn.weight          | 形状: [64]               | 元素数:       64
    导出 | model.23.m.0.cv1.bn.bias            | 形状: [64]               | 元素数:       64
    导出 | model.23.m.0.cv2.conv.weight        | 形状: [64, 64, 3, 3]     | 元素数:    36864
    导出 | model.23.m.0.cv2.bn.weight          | 形状: [64]               | 元素数:       64
    导出 | model.23.m.0.cv2.bn.bias            | 形状: [64]               | 元素数:       64
    导出 | model.24.cv2.0.0.conv.weight        | 形状: [64, 32, 3, 3]     | 元素数:    18432
    导出 | model.24.cv2.0.0.bn.weight          | 形状: [64]               | 元素数:       64
    导出 | model.24.cv2.0.0.bn.bias            | 形状: [64]               | 元素数:       64
    导出 | model.24.cv2.0.1.conv.weight        | 形状: [64, 64, 3, 3]     | 元素数:    36864
    导出 | model.24.cv2.0.1.bn.weight          | 形状: [64]               | 元素数:       64
    导出 | model.24.cv2.0.1.bn.bias            | 形状: [64]               | 元素数:       64
    导出 | model.24.cv2.0.2.weight             | 形状: [64, 64, 1, 1]     | 元素数:     4096
    导出 | model.24.cv2.0.2.bias               | 形状: [64]               | 元素数:       64
    导出 | model.24.cv2.1.0.conv.weight        | 形状: [64, 64, 3, 3]     | 元素数:    36864
    导出 | model.24.cv2.1.0.bn.weight          | 形状: [64]               | 元素数:       64
    导出 | model.24.cv2.1.0.bn.bias            | 形状: [64]               | 元素数:       64
    导出 | model.24.cv2.1.1.conv.weight        | 形状: [64, 64, 3, 3]     | 元素数:    36864
    导出 | model.24.cv2.1.1.bn.weight          | 形状: [64]               | 元素数:       64
    导出 | model.24.cv2.1.1.bn.bias            | 形状: [64]               | 元素数:       64
    导出 | model.24.cv2.1.2.weight             | 形状: [64, 64, 1, 1]     | 元素数:     4096
    导出 | model.24.cv2.1.2.bias               | 形状: [64]               | 元素数:       64
    导出 | model.24.cv2.2.0.conv.weight        | 形状: [64, 128, 3, 3]    | 元素数:    73728
    导出 | model.24.cv2.2.0.bn.weight          | 形状: [64]               | 元素数:       64
    导出 | model.24.cv2.2.0.bn.bias            | 形状: [64]               | 元素数:       64
    导出 | model.24.cv2.2.1.conv.weight        | 形状: [64, 64, 3, 3]     | 元素数:    36864
    导出 | model.24.cv2.2.1.bn.weight          | 形状: [64]               | 元素数:       64
    导出 | model.24.cv2.2.1.bn.bias            | 形状: [64]               | 元素数:       64
    导出 | model.24.cv2.2.2.weight             | 形状: [64, 64, 1, 1]     | 元素数:     4096
    导出 | model.24.cv2.2.2.bias               | 形状: [64]               | 元素数:       64
    导出 | model.24.cv3.0.0.conv.weight        | 形状: [32, 32, 3, 3]     | 元素数:     9216
    导出 | model.24.cv3.0.0.bn.weight          | 形状: [32]               | 元素数:       32
    导出 | model.24.cv3.0.0.bn.bias            | 形状: [32]               | 元素数:       32
    导出 | model.24.cv3.0.1.conv.weight        | 形状: [32, 32, 3, 3]     | 元素数:     9216
    导出 | model.24.cv3.0.1.bn.weight          | 形状: [32]               | 元素数:       32
    导出 | model.24.cv3.0.1.bn.bias            | 形状: [32]               | 元素数:       32
    导出 | model.24.cv3.0.2.weight             | 形状: [3, 32, 1, 1]      | 元素数:       96
    导出 | model.24.cv3.0.2.bias               | 形状: [3]                | 元素数:        3
    导出 | model.24.cv3.1.0.conv.weight        | 形状: [32, 64, 3, 3]     | 元素数:    18432
    导出 | model.24.cv3.1.0.bn.weight          | 形状: [32]               | 元素数:       32
    导出 | model.24.cv3.1.0.bn.bias            | 形状: [32]               | 元素数:       32
    导出 | model.24.cv3.1.1.conv.weight        | 形状: [32, 32, 3, 3]     | 元素数:     9216
    导出 | model.24.cv3.1.1.bn.weight          | 形状: [32]               | 元素数:       32
    导出 | model.24.cv3.1.1.bn.bias            | 形状: [32]               | 元素数:       32
    导出 | model.24.cv3.1.2.weight             | 形状: [3, 32, 1, 1]      | 元素数:       96
    导出 | model.24.cv3.1.2.bias               | 形状: [3]                | 元素数:        3
    导出 | model.24.cv3.2.0.conv.weight        | 形状: [32, 128, 3, 3]    | 元素数:    36864
    导出 | model.24.cv3.2.0.bn.weight          | 形状: [32]               | 元素数:       32
    导出 | model.24.cv3.2.0.bn.bias            | 形状: [32]               | 元素数:       32
    导出 | model.24.cv3.2.1.conv.weight        | 形状: [32, 32, 3, 3]     | 元素数:     9216
    导出 | model.24.cv3.2.1.bn.weight          | 形状: [32]               | 元素数:       32
    导出 | model.24.cv3.2.1.bn.bias            | 形状: [32]               | 元素数:       32
    导出 | model.24.cv3.2.2.weight             | 形状: [3, 32, 1, 1]      | 元素数:       96
    导出 | model.24.cv3.2.2.bias               | 形状: [3]                | 元素数:        3
    导出 | model.24.dfl.conv.weight            | 形状: [1, 16, 1, 1]      | 元素数:       16

------------------------- 权重导出任务完成 -------------------------
[完成] 共导出 208 个参数文件
[完成] 总参数量：0.721 M（与 yaml 标注的 0.721M 核对）
[完成] 文件存放路径：D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\runs\weigths_bin\weigths_bin_1
(yolov8) PS D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5> 