PS D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5> (Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned) ; (& d:\PythonEnvs\yolov8\Scripts\Activate.ps1)
(yolov8) PS D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5> & d:\PythonEnvs\yolov8\Scripts\python.exe d:/02_workspace/05_ascend_projects/yolo_pavement/yolov5/scripts/HLS_export/fp322int8.py

------------------------- FP32 → INT8 量化开始 -------------------------
[*] 找到 130 个 FP32 文件，开始量化...

    [偏置] model_0_bias.bin                       → int32 | 元素数:     16
    [权重] model_0_weight.bin                     → int8 | scale: 0.22797603 | MSE: 4.179181e-03
    [偏置] model_10_bias.bin                      → int32 | 元素数:     48
    [权重] model_10_weight.bin                    → int8 | scale: 0.01035495 | MSE: 9.115368e-06
    [偏置] model_13_cv1_bias.bin                  → int32 | 元素数:     24
    [权重] model_13_cv1_weight.bin                → int8 | scale: 0.00542829 | MSE: 2.422154e-06
    [偏置] model_13_cv2_bias.bin                  → int32 | 元素数:     24
    [权重] model_13_cv2_weight.bin                → int8 | scale: 0.00498114 | MSE: 2.119322e-06
    [偏置] model_13_cv3_bias.bin                  → int32 | 元素数:     48
    [权重] model_13_cv3_weight.bin                → int8 | scale: 0.00963676 | MSE: 7.877285e-06
    [偏置] model_13_m_0_cv1_bias.bin              → int32 | 元素数:     24
    [权重] model_13_m_0_cv1_weight.bin            → int8 | scale: 0.01256893 | MSE: 1.337009e-05
    [偏置] model_13_m_0_cv2_bias.bin              → int32 | 元素数:     24
    [权重] model_13_m_0_cv2_weight.bin            → int8 | scale: 0.00320376 | MSE: 8.500634e-07
    [偏置] model_14_bias.bin                      → int32 | 元素数:     32
    [权重] model_14_weight.bin                    → int8 | scale: 0.00530656 | MSE: 2.378560e-06
    [偏置] model_17_cv1_bias.bin                  → int32 | 元素数:     16
    [权重] model_17_cv1_weight.bin                → int8 | scale: 0.00591806 | MSE: 3.022143e-06
    [偏置] model_17_cv2_bias.bin                  → int32 | 元素数:     16
    [权重] model_17_cv2_weight.bin                → int8 | scale: 0.00508003 | MSE: 2.116550e-06
    [偏置] model_17_cv3_bias.bin                  → int32 | 元素数:     32
    [权重] model_17_cv3_weight.bin                → int8 | scale: 0.01388900 | MSE: 1.633241e-05
    [偏置] model_17_m_0_cv1_bias.bin              → int32 | 元素数:     16
    [权重] model_17_m_0_cv1_weight.bin            → int8 | scale: 0.02505053 | MSE: 5.682231e-05
    [偏置] model_17_m_0_cv2_bias.bin              → int32 | 元素数:     16
    [权重] model_17_m_0_cv2_weight.bin            → int8 | scale: 0.00503414 | MSE: 2.057801e-06
    [偏置] model_18_bias.bin                      → int32 | 元素数:     48
    [权重] model_18_weight.bin                    → int8 | scale: 0.00351916 | MSE: 1.022498e-06
    [偏置] model_1_bias.bin                       → int32 | 元素数:     32
    [权重] model_1_weight.bin                     → int8 | scale: 0.02092530 | MSE: 3.710412e-05
    [偏置] model_20_cv1_bias.bin                  → int32 | 元素数:     32
    [权重] model_20_cv1_weight.bin                → int8 | scale: 0.00854142 | MSE: 6.170091e-06
    [偏置] model_20_cv2_bias.bin                  → int32 | 元素数:     32
    [权重] model_20_cv2_weight.bin                → int8 | scale: 0.00498407 | MSE: 2.002573e-06
    [偏置] model_20_cv3_bias.bin                  → int32 | 元素数:     64
    [权重] model_20_cv3_weight.bin                → int8 | scale: 0.01184166 | MSE: 1.154807e-05
    [偏置] model_20_m_0_cv1_bias.bin              → int32 | 元素数:     32
    [权重] model_20_m_0_cv1_weight.bin            → int8 | scale: 0.00830921 | MSE: 5.766903e-06
    [偏置] model_20_m_0_cv2_bias.bin              → int32 | 元素数:     32
    [权重] model_20_m_0_cv2_weight.bin            → int8 | scale: 0.00501635 | MSE: 2.088498e-06
    [偏置] model_21_bias.bin                      → int32 | 元素数:    128
    [权重] model_21_weight.bin                    → int8 | scale: 0.00303889 | MSE: 7.674711e-07
    [偏置] model_23_cv1_bias.bin                  → int32 | 元素数:     64
    [权重] model_23_cv1_weight.bin                → int8 | scale: 0.00645820 | MSE: 3.438750e-06
    [偏置] model_23_cv2_bias.bin                  → int32 | 元素数:     64
    [权重] model_23_cv2_weight.bin                → int8 | scale: 0.00500584 | MSE: 2.068361e-06
    [偏置] model_23_cv3_bias.bin                  → int32 | 元素数:    128
    [权重] model_23_cv3_weight.bin                → int8 | scale: 0.01227587 | MSE: 1.249603e-05
    [偏置] model_23_m_0_cv1_bias.bin              → int32 | 元素数:     64
    [权重] model_23_m_0_cv1_weight.bin            → int8 | scale: 0.00674340 | MSE: 3.728437e-06
    [偏置] model_23_m_0_cv2_bias.bin              → int32 | 元素数:     64
    [权重] model_23_m_0_cv2_weight.bin            → int8 | scale: 0.00375654 | MSE: 1.177022e-06
    [偏置] model_24_cv2_0_0_bias.bin              → int32 | 元素数:     64
    [权重] model_24_cv2_0_0_weight.bin            → int8 | scale: 0.00614861 | MSE: 3.126425e-06
    [偏置] model_24_cv2_0_1_bias.bin              → int32 | 元素数:     64
    [权重] model_24_cv2_0_1_weight.bin            → int8 | scale: 0.00832210 | MSE: 5.760583e-06
    [偏置] model_24_cv2_1_0_bias.bin              → int32 | 元素数:     64
    [权重] model_24_cv2_1_0_weight.bin            → int8 | scale: 0.00541029 | MSE: 2.433916e-06
    [偏置] model_24_cv2_1_1_bias.bin              → int32 | 元素数:     64
    [权重] model_24_cv2_1_1_weight.bin            → int8 | scale: 0.01007469 | MSE: 8.420569e-06
    [偏置] model_24_cv2_2_0_bias.bin              → int32 | 元素数:     64
    [权重] model_24_cv2_2_0_weight.bin            → int8 | scale: 0.00328213 | MSE: 9.035654e-07
    [偏置] model_24_cv2_2_1_bias.bin              → int32 | 元素数:     64
    [权重] model_24_cv2_2_1_weight.bin            → int8 | scale: 0.00717793 | MSE: 4.300751e-06
    [偏置] model_24_cv3_0_0_bias.bin              → int32 | 元素数:     32
    [权重] model_24_cv3_0_0_weight.bin            → int8 | scale: 0.00383124 | MSE: 1.207952e-06
    [偏置] model_24_cv3_0_1_bias.bin              → int32 | 元素数:     32
    [权重] model_24_cv3_0_1_weight.bin            → int8 | scale: 0.00353744 | MSE: 1.066784e-06
    [偏置] model_24_cv3_1_0_bias.bin              → int32 | 元素数:     32
    [权重] model_24_cv3_1_0_weight.bin            → int8 | scale: 0.00309869 | MSE: 7.950563e-07
    [偏置] model_24_cv3_1_1_bias.bin              → int32 | 元素数:     32
    [权重] model_24_cv3_1_1_weight.bin            → int8 | scale: 0.00303664 | MSE: 7.638339e-07
    [偏置] model_24_cv3_2_0_bias.bin              → int32 | 元素数:     32
    [权重] model_24_cv3_2_0_weight.bin            → int8 | scale: 0.00165017 | MSE: 2.282477e-07
    [偏置] model_24_cv3_2_1_bias.bin              → int32 | 元素数:     32
    [权重] model_24_cv3_2_1_weight.bin            → int8 | scale: 0.00398571 | MSE: 1.309453e-06
    [偏置] model_2_cv1_bias.bin                   → int32 | 元素数:     16
    [权重] model_2_cv1_weight.bin                 → int8 | scale: 0.00267168 | MSE: 6.309607e-07
    [偏置] model_2_cv2_bias.bin                   → int32 | 元素数:     16
    [权重] model_2_cv2_weight.bin                 → int8 | scale: 0.00704821 | MSE: 4.098017e-06
    [偏置] model_2_cv3_bias.bin                   → int32 | 元素数:     32
    [权重] model_2_cv3_weight.bin                 → int8 | scale: 0.00653340 | MSE: 3.609062e-06
    [偏置] model_2_m_0_cv1_bias.bin               → int32 | 元素数:     16
    [权重] model_2_m_0_cv1_weight.bin             → int8 | scale: 0.02038999 | MSE: 3.844245e-05
    [偏置] model_2_m_0_cv2_bias.bin               → int32 | 元素数:     16
    [权重] model_2_m_0_cv2_weight.bin             → int8 | scale: 0.00720354 | MSE: 4.212695e-06
    [偏置] model_3_bias.bin                       → int32 | 元素数:     32
    [权重] model_3_weight.bin                     → int8 | scale: 0.00161776 | MSE: 2.161736e-07
    [偏置] model_4_cv1_bias.bin                   → int32 | 元素数:     16
    [权重] model_4_cv1_weight.bin                 → int8 | scale: 0.00543185 | MSE: 2.467199e-06
    [偏置] model_4_cv2_bias.bin                   → int32 | 元素数:     16
    [权重] model_4_cv2_weight.bin                 → int8 | scale: 0.02011039 | MSE: 3.440851e-05
    [偏置] model_4_cv3_bias.bin                   → int32 | 元素数:     32
    [权重] model_4_cv3_weight.bin                 → int8 | scale: 0.00972904 | MSE: 8.035938e-06
    [偏置] model_4_m_0_cv1_bias.bin               → int32 | 元素数:     16
    [权重] model_4_m_0_cv1_weight.bin             → int8 | scale: 0.02633623 | MSE: 5.907434e-05
    [偏置] model_4_m_0_cv2_bias.bin               → int32 | 元素数:     16
    [权重] model_4_m_0_cv2_weight.bin             → int8 | scale: 0.00595583 | MSE: 2.849467e-06
    [偏置] model_5_bias.bin                       → int32 | 元素数:     48
    [权重] model_5_weight.bin                     → int8 | scale: 0.00368914 | MSE: 1.125141e-06
    [偏置] model_6_cv1_bias.bin                   → int32 | 元素数:     24
    [权重] model_6_cv1_weight.bin                 → int8 | scale: 0.00695088 | MSE: 3.986268e-06
    [偏置] model_6_cv2_bias.bin                   → int32 | 元素数:     24
    [权重] model_6_cv2_weight.bin                 → int8 | scale: 0.00856599 | MSE: 5.721076e-06
    [偏置] model_6_cv3_bias.bin                   → int32 | 元素数:     48
    [权重] model_6_cv3_weight.bin                 → int8 | scale: 0.00875794 | MSE: 6.450517e-06
    [偏置] model_6_m_0_cv1_bias.bin               → int32 | 元素数:     24
    [权重] model_6_m_0_cv1_weight.bin             → int8 | scale: 0.02809323 | MSE: 6.644826e-05
    [偏置] model_6_m_0_cv2_bias.bin               → int32 | 元素数:     24
    [权重] model_6_m_0_cv2_weight.bin             → int8 | scale: 0.00314616 | MSE: 8.345659e-07
    [偏置] model_6_m_1_cv1_bias.bin               → int32 | 元素数:     24
    [权重] model_6_m_1_cv1_weight.bin             → int8 | scale: 0.01721761 | MSE: 2.653123e-05
    [偏置] model_6_m_1_cv2_bias.bin               → int32 | 元素数:     24
    [权重] model_6_m_1_cv2_weight.bin             → int8 | scale: 0.00318795 | MSE: 8.488681e-07
    [偏置] model_7_bias.bin                       → int32 | 元素数:     96
    [权重] model_7_weight.bin                     → int8 | scale: 0.00223489 | MSE: 4.168489e-07
    [偏置] model_8_cv1_bias.bin                   → int32 | 元素数:     48
    [权重] model_8_cv1_weight.bin                 → int8 | scale: 0.00307632 | MSE: 7.810905e-07
    [偏置] model_8_cv2_bias.bin                   → int32 | 元素数:     48
    [权重] model_8_cv2_weight.bin                 → int8 | scale: 0.00448658 | MSE: 1.667288e-06
    [偏置] model_8_cv3_bias.bin                   → int32 | 元素数:     96
    [权重] model_8_cv3_weight.bin                 → int8 | scale: 0.00632673 | MSE: 3.333403e-06
    [偏置] model_8_m_0_cv1_bias.bin               → int32 | 元素数:     48
    [权重] model_8_m_0_cv1_weight.bin             → int8 | scale: 0.02778021 | MSE: 6.497089e-05
    [偏置] model_8_m_0_cv2_bias.bin               → int32 | 元素数:     48
    [权重] model_8_m_0_cv2_weight.bin             → int8 | scale: 0.00260582 | MSE: 5.596212e-07
    [偏置] model_9_cv1_bias.bin                   → int32 | 元素数:     48
    [权重] model_9_cv1_weight.bin                 → int8 | scale: 0.00351848 | MSE: 1.025848e-06
    [偏置] model_9_cv2_bias.bin                   → int32 | 元素数:     96
    [权重] model_9_cv2_weight.bin                 → int8 | scale: 0.00290015 | MSE: 6.986836e-07

------------------------- 量化任务完成 -------------------------
[完成] 共量化 65 个权重文件，65 个偏置文件
[完成] 平均量化 MSE：7.324316e-05
[完成] INT8 文件存放路径：D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\runs\weights_bin_int8\weights_bin_int8_2
(yolov8) PS D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5> 