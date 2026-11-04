这个代码是使用了D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\runs\detect\train_4_3\weights\crack_speed_init.pt"   # 预训练权重 的结果 
可以与D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\runs\detect\train_crack_4_34\readme.txt做对比验证

150 epochs completed in 0.327 hours.
Optimizer stripped from D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\runs\detect\train_crack_4_35\weights\last.pt, 1.7MB
Optimizer stripped from D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\runs\detect\train_crack_4_35\weights\best.pt, 1.7MB

Validating D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\runs\detect\train_crack_4_35\weights\best.pt...
Ultralytics YOLOv8.2.103 🚀 Python-3.10.11 torch-2.11.0+cu128 CUDA:0 (NVIDIA GeForce RTX 5060 Ti, 16311MiB)
YOLOv5_crack_speed summary (fused): 183 layers, 717,993 parameters, 0 gradients, 2.7 GFLOPs
                 Class     Images  Instances      Box(P          R      mAP50  mAP50-95): 100%|██████████| 8/8 [00:01<00:00,  7.76it/s]
                   all        231        373       0.75      0.636      0.736      0.435
                 crack        194        314      0.657       0.65      0.692       0.37
       alligator crack         41         45      0.776      0.614      0.706      0.443
               pothole         10         14      0.818      0.643       0.81      0.493
Speed: 0.1ms preprocess, 0.3ms inference, 0.0ms loss, 1.0ms postprocess per image