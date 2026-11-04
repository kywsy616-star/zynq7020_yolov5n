使用balance训练  weights使用D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\runs\detect\train_4_3\weights\best.pt

121 epochs completed in 0.224 hours.
Optimizer stripped from D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\runs\detect\train_crack_4_3\weights\last.pt, 1.7MB
Optimizer stripped from D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\runs\detect\train_crack_4_3\weights\best.pt, 1.7MB

Validating D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\runs\detect\train_crack_4_3\weights\best.pt...
Ultralytics YOLOv8.2.103 🚀 Python-3.10.11 torch-2.11.0+cu128 CUDA:0 (NVIDIA GeForce RTX 5060 Ti, 16311MiB)
YOLOv5n_crack summary (fused): 183 layers, 754,489 parameters, 0 gradients, 2.9 GFLOPs
                 Class     Images  Instances      Box(P          R      mAP50  mAP50-95): 100%|██████████| 8/8 [00:00<00:00,  8.73it/s]
                   all        231        373      0.696      0.495      0.599      0.341
                 crack        194        314      0.617      0.545      0.579      0.286
       alligator crack         41         45      0.786      0.511      0.631      0.379
               pothole         10         14      0.685      0.429      0.586      0.356