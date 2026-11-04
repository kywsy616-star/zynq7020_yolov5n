这个代码是原版的v5n  结果  可以当成teacher模型

150 epochs completed in 0.328 hours.
Optimizer stripped from D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\runs\detect\train_4_3\weights\last.pt, 5.2MB
Optimizer stripped from D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\runs\detect\train_4_3\weights\best.pt, 5.2MB

Validating D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\runs\detect\train_4_3\weights\best.pt...
Ultralytics YOLOv8.2.103 🚀 Python-3.10.11 torch-2.11.0+cu128 CUDA:0 (NVIDIA GeForce RTX 5060 Ti, 16311MiB)
YOLOv5n summary (fused): 193 layers, 2,503,529 parameters, 0 gradients, 7.1 GFLOPs
                 Class     Images  Instances      Box(P          R      mAP50  mAP50-95): 100%|██████████| 8/8 [00:01<00:00,  7.94it/s]
                   all        231        373      0.866      0.785      0.869      0.555
                 crack        194        314      0.822      0.755      0.815      0.488
       alligator crack         41         45      0.776      0.756      0.826      0.517
               pothole         10         14          1      0.844      0.965       0.66
Speed: 0.1ms preprocess, 0.4ms inference, 0.0ms loss, 1.0ms postprocess per image
Results saved to D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\runs\detect\train_4_3