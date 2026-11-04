PS D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5> (Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned) ; (& d:\PythonEnvs\yolov8\Scripts\Activate.ps1)
(yolov8) PS D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5> & d:\PythonEnvs\yolov8\Scripts\python.exe d:/02_workspace/05_ascend_projects/yolo_pavement/yolov5/scripts/HLS_export/fp322int8.py

------------------------- FP32 → INT8 量化开始 -------------------------
[*] 找到 208 个 FP32 文件，开始量化...

    [偏置] model_0_bn_bias.bin                    → int32 | 元素数:     16
    [权重] model_0_bn_weight.bin                  → int8 | scale: 0.04358391 | MSE: 1.623820e-04
    [权重] model_0_conv_weight.bin                → int8 | scale: 0.00358329 | MSE: 1.083249e-06
    [偏置] model_10_bn_bias.bin                   → int32 | 元素数:     48
    [权重] model_10_bn_weight.bin                 → int8 | scale: 0.01317206 | MSE: 1.302748e-05
    [权重] model_10_conv_weight.bin               → int8 | scale: 0.00233183 | MSE: 4.537638e-07
    [偏置] model_13_cv1_bn_bias.bin               → int32 | 元素数:     24
    [权重] model_13_cv1_bn_weight.bin             → int8 | scale: 0.01231853 | MSE: 1.435727e-05
    [权重] model_13_cv1_conv_weight.bin           → int8 | scale: 0.00194640 | MSE: 3.178253e-07
    [偏置] model_13_cv2_bn_bias.bin               → int32 | 元素数:     24
    [权重] model_13_cv2_bn_weight.bin             → int8 | scale: 0.00955032 | MSE: 5.313414e-06
    [权重] model_13_cv2_conv_weight.bin           → int8 | scale: 0.00171187 | MSE: 2.492874e-07
    [偏置] model_13_cv3_bn_bias.bin               → int32 | 元素数:     48
    [权重] model_13_cv3_bn_weight.bin             → int8 | scale: 0.01031927 | MSE: 8.985487e-06
    [权重] model_13_cv3_conv_weight.bin           → int8 | scale: 0.00186085 | MSE: 2.796799e-07
    [偏置] model_13_m_0_cv1_bn_bias.bin           → int32 | 元素数:     24
    [权重] model_13_m_0_cv1_bn_weight.bin         → int8 | scale: 0.00878137 | MSE: 5.793723e-06
    [权重] model_13_m_0_cv1_conv_weight.bin       → int8 | scale: 0.00243564 | MSE: 5.080961e-07
    [偏置] model_13_m_0_cv2_bn_bias.bin           → int32 | 元素数:     24
    [权重] model_13_m_0_cv2_bn_weight.bin         → int8 | scale: 0.00757797 | MSE: 4.961041e-06
    [权重] model_13_m_0_cv2_conv_weight.bin       → int8 | scale: 0.00208385 | MSE: 3.701838e-07
    [偏置] model_14_bn_bias.bin                   → int32 | 元素数:     32
    [权重] model_14_bn_weight.bin                 → int8 | scale: 0.00743187 | MSE: 4.286085e-06
    [权重] model_14_conv_weight.bin               → int8 | scale: 0.00264902 | MSE: 5.891710e-07
    [偏置] model_17_cv1_bn_bias.bin               → int32 | 元素数:     16
    [权重] model_17_cv1_bn_weight.bin             → int8 | scale: 0.00667830 | MSE: 3.317113e-06
    [权重] model_17_cv1_conv_weight.bin           → int8 | scale: 0.00227993 | MSE: 4.391126e-07
    [偏置] model_17_cv2_bn_bias.bin               → int32 | 元素数:     16
    [权重] model_17_cv2_bn_weight.bin             → int8 | scale: 0.00690899 | MSE: 3.543587e-06
    [权重] model_17_cv2_conv_weight.bin           → int8 | scale: 0.00234721 | MSE: 4.603775e-07
    [偏置] model_17_cv3_bn_bias.bin               → int32 | 元素数:     32
    [权重] model_17_cv3_bn_weight.bin             → int8 | scale: 0.00746647 | MSE: 3.954922e-06
    [权重] model_17_cv3_conv_weight.bin           → int8 | scale: 0.00273745 | MSE: 6.347278e-07
    [偏置] model_17_m_0_cv1_bn_bias.bin           → int32 | 元素数:     16
    [权重] model_17_m_0_cv1_bn_weight.bin         → int8 | scale: 0.00784710 | MSE: 4.741560e-06
    [权重] model_17_m_0_cv1_conv_weight.bin       → int8 | scale: 0.00216459 | MSE: 3.796292e-07
    [偏置] model_17_m_0_cv2_bn_bias.bin           → int32 | 元素数:     16
    [权重] model_17_m_0_cv2_bn_weight.bin         → int8 | scale: 0.00707431 | MSE: 4.210383e-06
    [权重] model_17_m_0_cv2_conv_weight.bin       → int8 | scale: 0.00270285 | MSE: 6.354300e-07
    [偏置] model_18_bn_bias.bin                   → int32 | 元素数:     48
    [权重] model_18_bn_weight.bin                 → int8 | scale: 0.01076526 | MSE: 1.007411e-05
    [权重] model_18_conv_weight.bin               → int8 | scale: 0.00308348 | MSE: 7.831765e-07
    [偏置] model_1_bn_bias.bin                    → int32 | 元素数:     32
    [权重] model_1_bn_weight.bin                  → int8 | scale: 0.05376476 | MSE: 2.368182e-04
    [权重] model_1_conv_weight.bin                → int8 | scale: 0.00455985 | MSE: 1.709452e-06
    [偏置] model_20_cv1_bn_bias.bin               → int32 | 元素数:     32
    [权重] model_20_cv1_bn_weight.bin             → int8 | scale: 0.01236467 | MSE: 1.063301e-05
    [权重] model_20_cv1_conv_weight.bin           → int8 | scale: 0.00230684 | MSE: 4.335901e-07
    [偏置] model_20_cv2_bn_bias.bin               → int32 | 元素数:     32
    [权重] model_20_cv2_bn_weight.bin             → int8 | scale: 0.00818159 | MSE: 5.812808e-06
    [权重] model_20_cv2_conv_weight.bin           → int8 | scale: 0.00216651 | MSE: 3.911700e-07
    [偏置] model_20_cv3_bn_bias.bin               → int32 | 元素数:     64
    [权重] model_20_cv3_bn_weight.bin             → int8 | scale: 0.01094211 | MSE: 1.050811e-05
    [权重] model_20_cv3_conv_weight.bin           → int8 | scale: 0.00214344 | MSE: 3.818532e-07
    [偏置] model_20_m_0_cv1_bn_bias.bin           → int32 | 元素数:     32
    [权重] model_20_m_0_cv1_bn_weight.bin         → int8 | scale: 0.01026544 | MSE: 6.341537e-06
    [权重] model_20_m_0_cv1_conv_weight.bin       → int8 | scale: 0.00207616 | MSE: 3.791696e-07
    [偏置] model_20_m_0_cv2_bn_bias.bin           → int32 | 元素数:     32
    [权重] model_20_m_0_cv2_bn_weight.bin         → int8 | scale: 0.01092673 | MSE: 6.775424e-06
    [权重] model_20_m_0_cv2_conv_weight.bin       → int8 | scale: 0.00297967 | MSE: 7.406246e-07
    [偏置] model_21_bn_bias.bin                   → int32 | 元素数:    128
    [权重] model_21_bn_weight.bin                 → int8 | scale: 0.01331816 | MSE: 1.311622e-05
    [权重] model_21_conv_weight.bin               → int8 | scale: 0.00268747 | MSE: 6.024670e-07
    [偏置] model_23_cv1_bn_bias.bin               → int32 | 元素数:     64
    [权重] model_23_cv1_bn_weight.bin             → int8 | scale: 0.01397945 | MSE: 1.734419e-05
    [权重] model_23_cv1_conv_weight.bin           → int8 | scale: 0.00288355 | MSE: 6.945501e-07
    [偏置] model_23_cv2_bn_bias.bin               → int32 | 元素数:     64
    [权重] model_23_cv2_bn_weight.bin             → int8 | scale: 0.01124969 | MSE: 9.839399e-06
    [权重] model_23_cv2_conv_weight.bin           → int8 | scale: 0.00210115 | MSE: 3.685344e-07
    [偏置] model_23_cv3_bn_bias.bin               → int32 | 元素数:    128
    [权重] model_23_cv3_bn_weight.bin             → int8 | scale: 0.01788570 | MSE: 2.514677e-05
    [权重] model_23_cv3_conv_weight.bin           → int8 | scale: 0.00312577 | MSE: 8.140364e-07
    [偏置] model_23_m_0_cv1_bn_bias.bin           → int32 | 元素数:     64
    [权重] model_23_m_0_cv1_bn_weight.bin         → int8 | scale: 0.01220319 | MSE: 1.167955e-05
    [权重] model_23_m_0_cv1_conv_weight.bin       → int8 | scale: 0.00245486 | MSE: 5.019675e-07
    [偏置] model_23_m_0_cv2_bn_bias.bin           → int32 | 元素数:     64
    [权重] model_23_m_0_cv2_bn_weight.bin         → int8 | scale: 0.01608637 | MSE: 2.088746e-05
    [权重] model_23_m_0_cv2_conv_weight.bin       → int8 | scale: 0.00349486 | MSE: 1.020072e-06
    [偏置] model_24_cv2_0_0_bn_bias.bin           → int32 | 元素数:     64
    [权重] model_24_cv2_0_0_bn_weight.bin         → int8 | scale: 0.01354115 | MSE: 1.307254e-05
    [权重] model_24_cv2_0_0_conv_weight.bin       → int8 | scale: 0.00313154 | MSE: 8.141494e-07
    [偏置] model_24_cv2_0_1_bn_bias.bin           → int32 | 元素数:     64
    [权重] model_24_cv2_0_1_bn_weight.bin         → int8 | scale: 0.03552534 | MSE: 8.778974e-05
    [权重] model_24_cv2_0_1_conv_weight.bin       → int8 | scale: 0.00329109 | MSE: 8.974435e-07
    [偏置] model_24_cv2_0_2_bias.bin              → int32 | 元素数:     64
    [权重] model_24_cv2_0_2_weight.bin            → int8 | scale: 0.00397161 | MSE: 1.319379e-06
    [偏置] model_24_cv2_1_0_bn_bias.bin           → int32 | 元素数:     64
    [权重] model_24_cv2_1_0_bn_weight.bin         → int8 | scale: 0.01822404 | MSE: 3.042307e-05
    [权重] model_24_cv2_1_0_conv_weight.bin       → int8 | scale: 0.00380629 | MSE: 1.202808e-06
    [偏置] model_24_cv2_1_1_bn_bias.bin           → int32 | 元素数:     64
    [权重] model_24_cv2_1_1_bn_weight.bin         → int8 | scale: 0.03641732 | MSE: 1.078225e-04
    [权重] model_24_cv2_1_1_conv_weight.bin       → int8 | scale: 0.00331801 | MSE: 9.112621e-07
    [偏置] model_24_cv2_1_2_bias.bin              → int32 | 元素数:     64
    [权重] model_24_cv2_1_2_weight.bin            → int8 | scale: 0.00418307 | MSE: 1.433348e-06
    [偏置] model_24_cv2_2_0_bn_bias.bin           → int32 | 元素数:     64
    [权重] model_24_cv2_2_0_bn_weight.bin         → int8 | scale: 0.01876230 | MSE: 2.931129e-05
    [权重] model_24_cv2_2_0_conv_weight.bin       → int8 | scale: 0.00411387 | MSE: 1.408476e-06
    [偏置] model_24_cv2_2_1_bn_bias.bin           → int32 | 元素数:     64
    [权重] model_24_cv2_2_1_bn_weight.bin         → int8 | scale: 0.03807825 | MSE: 1.326397e-04
    [权重] model_24_cv2_2_1_conv_weight.bin       → int8 | scale: 0.00398314 | MSE: 1.312811e-06
    [偏置] model_24_cv2_2_2_bias.bin              → int32 | 元素数:     64
    [权重] model_24_cv2_2_2_weight.bin            → int8 | scale: 0.00483668 | MSE: 1.945909e-06
    [偏置] model_24_cv3_0_0_bn_bias.bin           → int32 | 元素数:     32
    [权重] model_24_cv3_0_0_bn_weight.bin         → int8 | scale: 0.00909664 | MSE: 7.246261e-06
    [权重] model_24_cv3_0_0_conv_weight.bin       → int8 | scale: 0.00276436 | MSE: 6.283321e-07
    [偏置] model_24_cv3_0_1_bn_bias.bin           → int32 | 元素数:     32
    [权重] model_24_cv3_0_1_bn_weight.bin         → int8 | scale: 0.00972718 | MSE: 9.168069e-06
    [权重] model_24_cv3_0_1_conv_weight.bin       → int8 | scale: 0.00244525 | MSE: 4.949267e-07
    [偏置] model_24_cv3_0_2_bias.bin              → int32 | 元素数:      3
    [权重] model_24_cv3_0_2_weight.bin            → int8 | scale: 0.00549797 | MSE: 2.655206e-06
    [偏置] model_24_cv3_1_0_bn_bias.bin           → int32 | 元素数:     32
    [权重] model_24_cv3_1_0_bn_weight.bin         → int8 | scale: 0.00967335 | MSE: 4.872219e-06
    [权重] model_24_cv3_1_0_conv_weight.bin       → int8 | scale: 0.00349486 | MSE: 1.005730e-06
    [偏置] model_24_cv3_1_1_bn_bias.bin           → int32 | 元素数:     32
    [权重] model_24_cv3_1_1_bn_weight.bin         → int8 | scale: 0.01055764 | MSE: 7.996664e-06
    [权重] model_24_cv3_1_1_conv_weight.bin       → int8 | scale: 0.00273553 | MSE: 6.298362e-07
    [偏置] model_24_cv3_1_2_bias.bin              → int32 | 元素数:      3
    [权重] model_24_cv3_1_2_weight.bin            → int8 | scale: 0.00597856 | MSE: 2.968618e-06
    [偏置] model_24_cv3_2_0_bn_bias.bin           → int32 | 元素数:     32
    [权重] model_24_cv3_2_0_bn_weight.bin         → int8 | scale: 0.01031158 | MSE: 1.021082e-05
    [权重] model_24_cv3_2_0_conv_weight.bin       → int8 | scale: 0.00352754 | MSE: 1.038979e-06
    [偏置] model_24_cv3_2_1_bn_bias.bin           → int32 | 元素数:     32
    [权重] model_24_cv3_2_1_bn_weight.bin         → int8 | scale: 0.01068836 | MSE: 7.668918e-06
    [权重] model_24_cv3_2_1_conv_weight.bin       → int8 | scale: 0.00336030 | MSE: 9.543871e-07
    [偏置] model_24_cv3_2_2_bias.bin              → int32 | 元素数:      3
    [权重] model_24_cv3_2_2_weight.bin            → int8 | scale: 0.00524806 | MSE: 2.382277e-06
    [权重] model_24_dfl_conv_weight.bin           → int8 | scale: 0.11811024 | MSE: 1.085005e-03
    [偏置] model_2_cv1_bn_bias.bin                → int32 | 元素数:     16
    [权重] model_2_cv1_bn_weight.bin              → int8 | scale: 0.03204970 | MSE: 9.766475e-05
    [权重] model_2_cv1_conv_weight.bin            → int8 | scale: 0.00510965 | MSE: 2.182999e-06
    [偏置] model_2_cv2_bn_bias.bin                → int32 | 元素数:     16
    [权重] model_2_cv2_bn_weight.bin              → int8 | scale: 0.03706324 | MSE: 1.396463e-04
    [权重] model_2_cv2_conv_weight.bin            → int8 | scale: 0.00438684 | MSE: 1.605209e-06
    [偏置] model_2_cv3_bn_bias.bin                → int32 | 元素数:     32
    [权重] model_2_cv3_bn_weight.bin              → int8 | scale: 0.01899299 | MSE: 2.599001e-05
    [权重] model_2_cv3_conv_weight.bin            → int8 | scale: 0.00374669 | MSE: 1.150719e-06
    [偏置] model_2_m_0_cv1_bn_bias.bin            → int32 | 元素数:     16
    [权重] model_2_m_0_cv1_bn_weight.bin          → int8 | scale: 0.02329909 | MSE: 4.287268e-05
    [权重] model_2_m_0_cv1_conv_weight.bin        → int8 | scale: 0.00358714 | MSE: 1.122829e-06
    [偏置] model_2_m_0_cv2_bn_bias.bin            → int32 | 元素数:     16
    [权重] model_2_m_0_cv2_bn_weight.bin          → int8 | scale: 0.02708231 | MSE: 6.174007e-05
    [权重] model_2_m_0_cv2_conv_weight.bin        → int8 | scale: 0.00352370 | MSE: 1.013640e-06
    [偏置] model_3_bn_bias.bin                    → int32 | 元素数:     32
    [权重] model_3_bn_weight.bin                  → int8 | scale: 0.01028851 | MSE: 9.622689e-06
    [权重] model_3_conv_weight.bin                → int8 | scale: 0.00254906 | MSE: 5.346287e-07
    [偏置] model_4_cv1_bn_bias.bin                → int32 | 元素数:     16
    [权重] model_4_cv1_bn_weight.bin              → int8 | scale: 0.01148807 | MSE: 1.203432e-05
    [权重] model_4_cv1_conv_weight.bin            → int8 | scale: 0.00212806 | MSE: 3.603018e-07
    [偏置] model_4_cv2_bn_bias.bin                → int32 | 元素数:     16
    [权重] model_4_cv2_bn_weight.bin              → int8 | scale: 0.01445620 | MSE: 1.689443e-05
    [权重] model_4_cv2_conv_weight.bin            → int8 | scale: 0.00345834 | MSE: 1.010815e-06
    [偏置] model_4_cv3_bn_bias.bin                → int32 | 元素数:     32
    [权重] model_4_cv3_bn_weight.bin              → int8 | scale: 0.00895823 | MSE: 6.848507e-06
    [权重] model_4_cv3_conv_weight.bin            → int8 | scale: 0.00282396 | MSE: 6.564209e-07
    [偏置] model_4_m_0_cv1_bn_bias.bin            → int32 | 元素数:     16
    [权重] model_4_m_0_cv1_bn_weight.bin          → int8 | scale: 0.01284141 | MSE: 1.321234e-05
    [权重] model_4_m_0_cv1_conv_weight.bin        → int8 | scale: 0.00216651 | MSE: 3.537450e-07
    [偏置] model_4_m_0_cv2_bn_bias.bin            → int32 | 元素数:     16
    [权重] model_4_m_0_cv2_bn_weight.bin          → int8 | scale: 0.00787017 | MSE: 3.855687e-06
    [权重] model_4_m_0_cv2_conv_weight.bin        → int8 | scale: 0.00381590 | MSE: 1.228637e-06
    [偏置] model_5_bn_bias.bin                    → int32 | 元素数:     48
    [权重] model_5_bn_weight.bin                  → int8 | scale: 0.01561731 | MSE: 1.857812e-05
    [权重] model_5_conv_weight.bin                → int8 | scale: 0.00198965 | MSE: 3.309018e-07
    [偏置] model_6_cv1_bn_bias.bin                → int32 | 元素数:     24
    [权重] model_6_cv1_bn_weight.bin              → int8 | scale: 0.00822773 | MSE: 5.974947e-06
    [权重] model_6_cv1_conv_weight.bin            → int8 | scale: 0.00324303 | MSE: 9.045477e-07
    [偏置] model_6_cv2_bn_bias.bin                → int32 | 元素数:     24
    [权重] model_6_cv2_bn_weight.bin              → int8 | scale: 0.01460999 | MSE: 1.337016e-05
    [权重] model_6_cv2_conv_weight.bin            → int8 | scale: 0.00203963 | MSE: 3.604063e-07
    [偏置] model_6_cv3_bn_bias.bin                → int32 | 元素数:     48
    [权重] model_6_cv3_bn_weight.bin              → int8 | scale: 0.01218012 | MSE: 1.131334e-05
    [权重] model_6_cv3_conv_weight.bin            → int8 | scale: 0.00239335 | MSE: 4.734249e-07
    [偏置] model_6_m_0_cv1_bn_bias.bin            → int32 | 元素数:     24
    [权重] model_6_m_0_cv1_bn_weight.bin          → int8 | scale: 0.01121125 | MSE: 1.201436e-05
    [权重] model_6_m_0_cv1_conv_weight.bin        → int8 | scale: 0.00161959 | MSE: 2.233400e-07
    [偏置] model_6_m_0_cv2_bn_bias.bin            → int32 | 元素数:     24
    [权重] model_6_m_0_cv2_bn_weight.bin          → int8 | scale: 0.00750108 | MSE: 4.337314e-06
    [权重] model_6_m_0_cv2_conv_weight.bin        → int8 | scale: 0.00191083 | MSE: 3.069142e-07
    [偏置] model_6_m_1_cv1_bn_bias.bin            → int32 | 元素数:     24
    [权重] model_6_m_1_cv1_bn_weight.bin          → int8 | scale: 0.01048844 | MSE: 6.830949e-06
    [权重] model_6_m_1_cv1_conv_weight.bin        → int8 | scale: 0.00222033 | MSE: 4.295103e-07
    [偏置] model_6_m_1_cv2_bn_bias.bin            → int32 | 元素数:     24
    [权重] model_6_m_1_cv2_bn_weight.bin          → int8 | scale: 0.01147269 | MSE: 9.104368e-06
    [权重] model_6_m_1_cv2_conv_weight.bin        → int8 | scale: 0.00202425 | MSE: 3.339949e-07
    [偏置] model_7_bn_bias.bin                    → int32 | 元素数:     96
    [权重] model_7_bn_weight.bin                  → int8 | scale: 0.01245694 | MSE: 1.162988e-05
    [权重] model_7_conv_weight.bin                → int8 | scale: 0.00167438 | MSE: 2.356435e-07
    [偏置] model_8_cv1_bn_bias.bin                → int32 | 元素数:     48
    [权重] model_8_cv1_bn_weight.bin              → int8 | scale: 0.00878906 | MSE: 6.780028e-06
    [权重] model_8_cv1_conv_weight.bin            → int8 | scale: 0.00163401 | MSE: 2.255366e-07
    [偏置] model_8_cv2_bn_bias.bin                → int32 | 元素数:     48
    [权重] model_8_cv2_bn_weight.bin              → int8 | scale: 0.01221088 | MSE: 1.152098e-05
    [权重] model_8_cv2_conv_weight.bin            → int8 | scale: 0.00182529 | MSE: 2.738796e-07
    [偏置] model_8_cv3_bn_bias.bin                → int32 | 元素数:     96
    [权重] model_8_cv3_bn_weight.bin              → int8 | scale: 0.01742434 | MSE: 2.442156e-05
    [权重] model_8_cv3_conv_weight.bin            → int8 | scale: 0.00361213 | MSE: 1.093824e-06
    [偏置] model_8_m_0_cv1_bn_bias.bin            → int32 | 元素数:     48
    [权重] model_8_m_0_cv1_bn_weight.bin          → int8 | scale: 0.01441006 | MSE: 1.399173e-05
    [权重] model_8_m_0_cv1_conv_weight.bin        → int8 | scale: 0.00176569 | MSE: 2.546676e-07
    [偏置] model_8_m_0_cv2_bn_bias.bin            → int32 | 元素数:     48
    [权重] model_8_m_0_cv2_bn_weight.bin          → int8 | scale: 0.01943898 | MSE: 3.349748e-05
    [权重] model_8_m_0_cv2_conv_weight.bin        → int8 | scale: 0.00179165 | MSE: 2.662722e-07
    [偏置] model_9_cv1_bn_bias.bin                → int32 | 元素数:     48
    [权重] model_9_cv1_bn_weight.bin              → int8 | scale: 0.01487143 | MSE: 1.997346e-05
    [权重] model_9_cv1_conv_weight.bin            → int8 | scale: 0.00218189 | MSE: 4.048361e-07
    [偏置] model_9_cv2_bn_bias.bin                → int32 | 元素数:     96
    [权重] model_9_cv2_bn_weight.bin              → int8 | scale: 0.01180333 | MSE: 1.142998e-05
    [权重] model_9_cv2_conv_weight.bin            → int8 | scale: 0.00268939 | MSE: 5.997246e-07

------------------------- 量化任务完成 -------------------------
[完成] 共量化 137 个权重文件，71 个偏置文件
[完成] 平均量化 MSE：2.087146e-05
[完成] INT8 文件存放路径：D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\runs\weight_bin_int8\weight_bin_int8_1
(yolov8) PS D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5> 