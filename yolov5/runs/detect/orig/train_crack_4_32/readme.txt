使用accuracy训练  weights使用D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\runs\detect\train_4_3\weights\best.pt

150 epochs completed in 0.306 hours.
Optimizer stripped from D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\runs\detect\train_crack_4_32\weights\last.pt, 2.7MB
Optimizer stripped from D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\runs\detect\train_crack_4_32\weights\best.pt, 2.7MB

Validating D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\runs\detect\train_crack_4_32\weights\best.pt...
Ultralytics YOLOv8.2.103 🚀 Python-3.10.11 torch-2.11.0+cu128 CUDA:0 (NVIDIA GeForce RTX 5060 Ti, 16311MiB)
YOLOv5_crack_accuracy summary (fused): 183 layers, 1,214,953 parameters, 0 gradients, 4.1 GFLOPs
                 Class     Images  Instances      Box(P          R      mAP50  mAP50-95): 100%|██████████| 8/8 [00:00<00:00,  8.30it/s]
                   all        231        373      0.762      0.484      0.635      0.365
                 crack        194        314      0.771      0.535      0.656       0.33
       alligator crack         41         45      0.855      0.489      0.674      0.414
               pothole         10         14       0.66      0.429      0.575       0.35
Speed: 0.1ms preprocess, 0.3ms inference, 0.0ms loss, 0.9ms postprocess per image
Results saved to D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\runs\detect\train_crack_4_32