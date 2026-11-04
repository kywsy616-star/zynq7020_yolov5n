这个代码是使用了D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\runs\detect\train_4_3\weights\crack_balance_init.pt"   # 预训练权重 的结果 
可以与D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\runs\detect\train_crack_4_3\readme.txt做对比验证

99 epochs completed in 0.197 hours.
Optimizer stripped from D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\runs\detect\train_crack_4_34\weights\last.pt, 1.7MB
Optimizer stripped from D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\runs\detect\train_crack_4_34\weights\best.pt, 1.7MB

Validating D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\runs\detect\train_crack_4_34\weights\best.pt...
Ultralytics YOLOv8.2.103 🚀 Python-3.10.11 torch-2.11.0+cu128 CUDA:0 (NVIDIA GeForce RTX 5060 Ti, 16311MiB)
YOLOv5n_crack summary (fused): 183 layers, 754,489 parameters, 0 gradients, 2.9 GFLOPs
                 Class     Images  Instances      Box(P          R      mAP50  mAP50-95): 100%|██████████| 8/8 [00:00<00:00,  9.24it/s]
                   all        231        373      0.854      0.606      0.753      0.449
                 crack        194        314      0.822      0.522      0.681      0.357
       alligator crack         41         45       0.86      0.511      0.686      0.414
               pothole         10         14      0.882      0.786      0.893      0.575