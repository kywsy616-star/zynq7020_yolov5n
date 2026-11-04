所使用的是D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\runs\detect\train_crack_4_35\weights\best.pt


(yolov8) PS D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5> & d:\PythonEnvs\yolov8\Scripts\python.exe d:/02_workspace/05_ascend_projects/yolo_pavement/yolov5/scripts/test.py
WARNING ⚠️ updating to 'imgsz=512'. 'train' and 'val' imgsz must be an integer, while 'predict' and 'export' imgsz may be a [h, w] list or an integer, i.e. 'yolo export imgsz=640,480' or 'yolo export imgsz=640'
Ultralytics YOLOv8.2.103 🚀 Python-3.10.11 torch-2.11.0+cu128 CUDA:0 (NVIDIA GeForce RTX 5060 Ti, 16311MiB)
YOLOv5_crack_speed summary (fused): 183 layers, 717,993 parameters, 0 gradients, 2.7 GFLOPs
val: Scanning D:\02_workspace\05_ascend_projects\yolo_pavement\dataset\RDD_China\val\labels.cache... 231 images, 0 backgrounds, 0 corrupt: 100%|██████████| 
                 Class     Images  Instances      Box(P          R      mAP50  mAP50-95): 100%|██████████| 15/15 [00:01<00:00, 14.73it/s]
                   all        231        373      0.681      0.653       0.66      0.393
                 crack        194        314      0.635      0.697      0.677      0.365
       alligator crack         41         45      0.724      0.644      0.702      0.432
               pothole         10         14      0.684      0.619      0.602      0.383
Speed: 0.2ms preprocess, 0.7ms inference, 0.0ms loss, 1.0ms postprocess per image
Results saved to D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\runs\test\test

======================================================================
⚡ 推理速度：
  单张推理耗时: 0.69 毫秒
  推理 FPS: 1455.10 张/秒
  测试总耗时: 28.09 秒

📊 检测精度（mAP）：
  mAP@0.5:      0.6603
  mAP@0.75:     0.4336
  mAP@0.5:0.95: 0.3932

🔋 GPU 功耗：
  平均 GPU 功耗: 24.64 瓦 (W)
  测试总能耗: 692.27 焦耳 (J)
======================================================================
(yolov8) PS D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5> 