# Zynq-7020 YOLOv5n 道路病害实时检测系统

> 基于 XC7Z020 的端到端视频检测参考设计：OV5640 采集 → HLS INT8 加速器 → 双核 Cortex-A9 后处理 → HDMI 实时显示。

![Board](https://img.shields.io/badge/Board-XC7Z020_CLG400--2-0b7285)
![Tool](https://img.shields.io/badge/Vivado%2FVitis-2020.2-1864ab)
![Model](https://img.shields.io/badge/Model-YOLOv5n_INT8-2b8a3e)
![Task](https://img.shields.io/badge/Task-3--class_Road_Defect-e8590c)

---

## 1. 项目简介

本项目在 Zynq-7020 上实现道路病害的**实时视频检测**，识别三类目标：

- `crack`：裂缝
- `alligator crack`：网状裂缝
- `pothole`：坑洞

系统从 OV5640 摄像头采集 800×480 图像，在 PL 中由 HLS 加速器执行完整的 YOLOv5n INT8 网络（84 个算子），CPU0/CPU1 以 AMP 方式完成后处理与显示，最终通过 HDMI 输出带检测框的实时画面。

设计目标不是“把模型搬到 FPGA 上跑通”，而是把**算法、量化、HLS 微架构、AXI 访存、双核调度和视频链路**作为一个整体优化，在 XC7Z020 上做到约 **67 ms/帧（≈14.8 FPS）** 的连续视频推理。

---

## 2. 主要特性

- **端到端视频链路**：OV5640 → VDMA → CPU0 预处理 → PL 推理 → CPU1 后处理 → HDMI。
- **HLS INT8 加速器**：
  - 16 个输出通道 × 8 个输入通道 = **128 个有效 INT8 MAC/周期**；
  - 64 个 DSP48E1 乘法器，每个用双 INT8 打包产生 2 个有符号乘积；
  - 26 位模累加 + BRAM 累加/残差/行缓存；
  - 64 位 AXI（AXI64）访问 HP1，HLS/SMC/HP1 统一到 150 MHz。
- **双核 AMP 软件**：
  - CPU0：摄像头/VDMA/HDMI 初始化、稳定帧快照、C4 预处理、PL 调度、串口日志；
  - CPU1：DFL16 解码、Sigmoid、阈值筛选、NMS、检测框绘制、显示提交；
  - 非缓存 OCM 状态机、两份 arena、三帧采集环、三缓冲显示、有界串口。
- **模型侧配合**：
  - YOLOv5n、512×384 输入、3 类输出；
  - RDD2022 中国分区（China_Drone / China_MotorBike）训练；
  - 对称 INT8 量化、共享 scale 组、输入零点、DFL 检测头裁剪；
  - 84 条描述符，权重/反量化/层表以 C 数组形式进入 Vitis 工程。

---

## 3. 系统架构

```text
┌──────────────┐     ┌──────────────────────────────┐     ┌──────────────┐
│   OV5640     │     │            Zynq-7020          │     │    HDMI      │
│  800×480     │────▶│  PS: 双核 Cortex-A9 + DDR     │────▶│   显示器      │
└──────────────┘     │                               │     └──────────────┘
                     │  CPU0: 采集/预处理/PL 调度    │
                     │  CPU1: DFL16/NMS/绘制/显示    │
                     │                               │
                     │  PL: HLS yolov5n_top          │
                     │      84 ops / 128 MAC/cycle   │
                     │      INT8 / AXI64 / 150 MHz   │
                     └──────────────────────────────┘
```

### 3.1 PS / PL 分工

| 单元 | 主要工作 |
|---|---|
| CPU0 | 摄像头、VDMA、HDMI、PL 初始化；稳定帧快照；中心裁剪 640×480 → 512×384；RGB/C4/INT8 预处理；启动 PL；串口日志 |
| PL | 执行 84 条算子的完整 YOLOv5n INT8 网络；通过 AXI64 访问 DDR；输出 P3/P4/P5 检测头张量 |
| CPU1 | 读取输出张量；Sigmoid；DFL16 距离分布解码；阈值筛选；NMS；绘制检测框；显示缓存切换确认 |

### 3.2 加速器数据路径

```text
DDR (descriptor / weights / rqt / activation arena)
        │  AXI64 / HP1
        ▼
┌─────────────────────────────────────────────┐
│ HLS yolov5n_top                             │
│  memory → IFM/权重/残差读取                 │
│  MAC    → 128 有效 INT8 MAC/cycle           │
│  quant  → mq/shift、LeakyReLU、饱和、C4 输出│
└─────────────────────────────────────────────┘
        │
        ▼
P3 / P4 / P5 输出张量（67 通道，C4 补齐到 68）
```

---

## 4. 性能与资源

### 4.1 板端实测

| 指标 | 结果 |
|---|---:|
| 单帧推理（infer） | **67.466 ms** |
| 吞吐 | **约 14.839 FPS** |
| 512 帧输出周期 | 67.390～67.392 ms |
| 计算/访存时钟 | 150 MHz |
| 视频时钟 | 100 MHz |
| 输入 | 512×384 INT8，C4 打包 |
| 计算接口 | 64 位 AXI，HP1 |

> 以上为 R6.6 参考实现的板端实测；当前仓库中的 R12 IP 在 6.667 ns/150 MHz 下重新综合，性能以本地实现与实测为准。

### 4.2 当前 R12 实现资源

| 资源 | 使用 / 可用 | 利用率 |
|---|---:|---:|
| DSP48E1 | 218 / 220 | 99.09% |
| LUT | 40,100 / 53,200 | 75.38% |
| FF | 57,500 / 106,400 | 54.04% |
| BRAM 36 Kb 等效 | 109 / 140 | 77.86% |

当前实现 setup WNS 约 **−0.833 ns**（150 MHz），时序接近但未完全闭合；详见：

```text
02_vivado/yolov5n_ip/yolov5n_ip.runs/impl_1/zynq_wrapper_timing_summary_routed.rpt
02_vivado/yolov5n_ip/yolov5n_ip.runs/impl_1/zynq_wrapper_utilization_placed.rpt
```

---

## 5. 模型与数据

| 项目 | 说明 |
|---|---|
| 基础模型 | YOLOv5n，轻量化检测网络 |
| 输入尺寸 | 512×384（4:3，无 letterbox 填充） |
| 类别 | crack / alligator crack / pothole |
| 数据集 | RDD2022 中国分区（China_Drone、China_MotorBike） |
| 量化 | 激活按张量对称 INT8；权重按输出通道对称 INT8 |
| 量化约束 | 残差/拷贝张量共享 scale；输入零点 −128；DFL 检测头单独裁剪 |
| 部署格式 | 84 条 64 B 描述符；权重 724,544 B；反量化 36,096 B；层表 5,376 B |
| PC 参考测试 | 217 张测试图 / 329 个实例：P≈0.758，R≈0.591，mAP@0.5≈0.711 |

> 上述 P/R/mAP 为 PC 端参考测试结果；板端 INT8 指标需要用同一测试集重新评估。  
> 数据集只覆盖 RDD2022 中国分区，跨地区、跨路面材质和跨光照的泛化能力仍有提升空间。

---

## 6. 仓库结构

```text
zynq7020_yolov5n/
├─ 01_hls/                         HLS C++ 加速器
│  ├─ src/                         yolov5n_top.cpp、schedule、AXI64 辅助
│  ├─ yolov5n_hls/                 Vitis HLS 工程
│  ├─ experiments/                 R6.4 / R6.5 实验
│  ├─ HLS_R5_*.md / HLS_R6_*.md    优化与综合记录
│  └─ model.yaml                   模型/训练配置
│
├─ 02_vivado/                      Vivado 硬件工程
│  ├─ yolov5n_ip/                  Vivado 工程、Block Design、实现报告
│  ├─ ip_repo/                     当前 R12 HLS IP + 视频 IP
│  ├─ ip_repo_orj/                 历史版本 IP（R1～R11）
│  ├─ reports/                     时序、资源、DRC 等报告
│  ├─ yolov5n_speed_wrapper_12.xsa 当前平台 XSA
│  └─ _bd_replicate_20261102/      BD 复刻备份与日志
│
├─ 03_vitis/                       Vitis 双核软件
│  ├─ yolov5n_speed/               CPU0 应用
│  ├─ yolov5n_speed_1/             CPU1 应用
│  ├─ yolov5n_speed_platform/      硬件平台
│  ├─ yolov5n_speed_system/        系统工程
│  ├─ src代码流程.md               双核 AMP 流程
│  └─ Makefile_Windows兼容问题修复记录.md
│
└─ yolov5/                         Ultralytics 训练/推理辅助环境
   ├─ docker/                      训练容器配置
   └─ ...                          权重、数据集和完整训练脚本不随仓库提供
```

### 仓库内容说明

- 仓库保留了 Vivado/Vitis 工程、XSA、Block Design、实现报告和部分 IP 缓存，因此体积较大。
- `.gitignore` 排除了 `*.bit`、`*.elf`、`*.log`、`solution*/`、`Debug/` 等构建产物；bit/ELF 需要本地重新生成。
- 训练权重、原始数据集和完整训练脚本不随仓库提供；部署用 INT8 权重/反量化/层表已以 C 数组形式放在：
  ```text
  03_vitis/yolov5n_speed/src/weights_speed_blob.c
  03_vitis/yolov5n_speed/src/rqt_speed_blob.c
  03_vitis/yolov5n_speed/src/yolov5n_speed_layers.h
  ```

---

## 7. 开发环境

| 项目 | 版本/型号 |
|---|---|
| FPGA 器件 | XC7Z020CLG400-2（Zynq-7020） |
| 开发工具 | Vivado / Vitis / Vitis HLS **2020.2** |
| 摄像头 | OV5640（RGB565，800×480） |
| 显示 | HDMI，800×480 |
| 调试 | JTAG + UART 115200 8N1 |
| HLS 时钟目标 | 6.667 ns（150 MHz） |
| PL 计算接口 | AXI64，HP1 |

---

## 8. 构建与运行

### 8.1 HLS IP

1. 用 Vitis HLS 2020.2 打开：
   ```text
   01_hls/yolov5n_hls
   ```
2. 源文件位于 `01_hls/src`，顶层为 `yolov5n_top`。
3. 按 6.667 ns（150 MHz）目标重新创建/打开 solution，执行：
   - `csim_design`
   - `csynth_design`
   - `cosim_design`
   - `export_design -rtl verilog -format ip_catalog`
4. 导出的 IP 放入 `02_vivado/ip_repo/xilinx_com_hls_yolov5n_top_12_0`（或保持当前 R12 目录）。

### 8.2 Vivado

1. 打开：
   ```text
   02_vivado/yolov5n_ip/yolov5n_ip.xpr
   ```
2. 确认 IP 仓库指向：
   ```text
   02_vivado/ip_repo
   ```
3. Block Design 名为 `zynq`，HLS 实例为 `yolov5n_top_12`（IP 版本 1.0 / R12）。
4. 运行综合、实现、生成 bitstream。
5. 导出 XSA；当前参考 XSA 为：
   ```text
   02_vivado/yolov5n_speed_wrapper_12.xsa
   ```

### 8.3 Vitis

1. 打开 Vitis 2020.2，工作区选择：
   ```text
   03_vitis
   ```
2. 硬件平台：
   ```text
   yolov5n_speed_platform
   ```
3. 两个应用：
   ```text
   yolov5n_speed       （CPU0）
   yolov5n_speed_1     （CPU1）
   ```
4. 系统工程：
   ```text
   yolov5n_speed_system
   ```
5. 依次构建 platform → CPU0/CPU1 应用 → system；平台硬件 XSA 指向 `yolov5n_speed_wrapper_12.xsa`。
6. 双核 AMP 的启动、slot 状态机、显示提交细节见：
   ```text
   03_vitis/src代码流程.md
   ```

### 8.4 上板运行

1. 连接开发板电源、JTAG、UART、OV5640 和 HDMI。
2. 用 Vitis/XSCT 下载：
   - FPGA bitstream（本地生成）
   - CPU0 ELF
   - CPU1 ELF
3. 确保完成整系统复位、PS7 初始化、双核下载。
4. 串口 115200 8N1 观察 `infer`、`period`、帧号和检测日志。
5. 摄像头对准道路/裂缝目标，HDMI 应输出带检测框的实时画面。

> 仓库不包含可直接下载的 bit/ELF；请先按 8.1～8.3 在本地重新构建。

---

## 9. 已知限制与后续工作

1. **时序**：当前 R12 实现 setup WNS 约 −0.833 ns，时序接近但未完全闭合；量产/高低温场景前应继续优化关键路径。
2. **数据泛化**：训练与验证基于 RDD2022 中国分区，场景、路面材质和光照相对集中；跨地区、跨场景泛化能力仍有提升空间。后续可引入更多地区、路面类型、拍摄角度和光照条件的数据集进行联合训练/微调，并结合难例挖掘与域自适应。
3. **资源余量**：DSP 已用 218/220、BRAM 109/140，进一步扩展并行度需要重新分配计算资源或选择更大器件。
4. **板端精度评估**：当前仓库提供 PC 参考指标；板端 P/R/mAP 需用固定测试集和检测日志重新统计。

---

## 10. 第三方组件与许可

- **Ultralytics YOLO**：`yolov5/` 相关训练/推理框架来自 Ultralytics，遵循其 AGPL-3.0 许可；使用/分发前请阅读上游 LICENSE。
- **Digilent axi_dynclk**：`02_vivado/ip_repo/axi_dynclk_v1_0`，遵循 Digilent 原始许可。
- **Xilinx IP/工具**：Vivado/Vitis/Vitis HLS 及 Xilinx IP 遵循 Xilinx/AMD 许可。
- **RDD2022 数据集**：不随仓库提供，使用请遵循数据集原始许可。
- 本仓库未附独立 `LICENSE` 文件；如用于公开发布或商业用途，请根据你的意图补充许可证，并保留第三方版权声明。

---

## 11. 致谢

- Ultralytics YOLO 开源社区
- Xilinx/AMD Vivado、Vitis、Vitis HLS
- Digilent Zybo Z7 / OV5640 参考设计
- RDD2022 道路病害数据集

---

> 如果这个工程对你的 Zynq 视频推理或 HLS 加速器设计有帮助，欢迎 Star / Issue 交流。
