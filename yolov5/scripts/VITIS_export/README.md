# VITIS_export —— yolov5n_speed 模型侧导出流水线

把 speed 档训练好的 `best.pt` 变成 **Vitis PS 端应用能吃的四个文件**。

> 本目录只服务 `yolov5n_speed_prj` 这一个工程（帧率优先档，骨干 P3 = 32 通道）。

---

## 0. 先说清楚：这些产物给谁用

```
        best.pt
           │
           │  本目录的脚本（模型侧 / PC 端）
           ▼
   weights.bin  rqt.bin  layers.bin  + C 源文件
           │
           │  emit_vitis_files.py 改名
           ▼
   ┌───────────────────────────────────────────────┐
   │  03_vitis/yolov5n_speed/src/                  │
   │      weights_speed_blob.c                     │
   │      rqt_speed_blob.c                         │
   │      yolov5n_speed_layers.h                   │
   │      yolov5n_speed_desc.h                     │
   └───────────────────────────────────────────────┘
           │
           ▼
      Vitis 编译 → PS 端 ARM 程序 → 上板

   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   HLS 工程（01_hls/src/）**不读本目录的任何东西**。
   那边是纯算法：yolov5n_top.cpp（数据通路）+ yolov5n_hls.h
   （接口和硬件常量的合并头，常量是写死在文件里的）。
   它的 testbench 也明说了 "does NOT load golden bin files"。
   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
```

所以：**改模型 → 只需要重跑本目录的脚本 + Rebuild Vitis 应用，不用动 HLS。**

（唯一例外：改 `gen/hw_config.h` 里那几个缓冲常量意味着要重新综合 IP。
但那是"改硬件"，不是本流水线的日常工作，详见第 5 节。）

---

## 1. 流水线怎么跑（5 步）

**cmd / PowerShell 里 `cd` 要加引号**（路径里有 `\` 和空格风险）：

```bat
cd /d "D:\02_workspace\05_ascend_projects\yolo_pavement\yolov5\scripts\VITIS_export"

python make_layer_plan.py     :: ① 摊平 + BN 融合 + DDR 地址分配（含 fp32 自检）
python calibrate.py --n 128   :: ② 用 128 张验证图统计每层激活分布（约 70 秒）
python quantize.py            :: ③ int8 量化 + 打包（核心步骤）
python verify_blobs.py        :: ④ 按 PL 的读法反解成品，逐字节复核
python emit_vitis_files.py    :: ⑤ 改名拷进 Vitis 工程 src/
```

> `cd` 后面那个 `/d` 不是必须的，但如果你在别的盘符下运行，加上它才切得过去。

第 ④ 步不能省 —— 它专门抓"层表 / 权重 / requant 三者对不上"这一类错误，详见 2.4。

### 产物目录

```
build_speed/
├── layer_plan.json       ① 84 个算子 + 59 个中间张量的 DDR 偏移
├── fused_weights.npz     ① 卷积+BN 融合后的 fp32 权重
├── calib.json            ② 每个张量的 max / p99.9 / 8192-bin 直方图
├── weights.bin           ③ int8 权重（724544 B）
├── rqt.bin               ③ 每通道 {bias, mq, shift}（36096 B = 3008 条 × 12 B）
├── layers.bin            ③ 84 × 64 B 描述符表
├── quant.json            ③ 全部 scale / 乘数（给 refsim 的 int8 模式）
└── gen/                  ③ 自动生成的 C 源码
    ├── yolov5n_desc.h        描述符结构体 + 输出张量地址/尺度   ┐
    ├── yolov5n_layers.h      层表本体                          │ 这 5 个由
    ├── weights_blob.c        权重字节                          │ emit_vitis_files
    ├── rqt_blob.c            requant 字节                      │ 改名后进 Vitis
    └── hw_config.h           硬件常量 —— **只是对账账本**，见第 5 节
```

---

## 2. 各脚本做什么

### 2.1 `make_layer_plan.py` —— 把 PyTorch 模型摊平成算子表

PyTorch 的 `forward` 是张量程序，C3 / SPPF / Detect 内部怎么算是框架定的。
PL 加速器只会三种算子：

```
LT_CONV     = 0   卷积（K 是运行时参数，1x1 / 3x3 共用一个数据通路）
LT_MAXPOOL  = 1   3x3 / stride1 / pad1 最大池化
LT_COPY     = 2   通道拷贝（Concat）或 2 倍最近邻上采样（Upsample）
```

所以：

- `C3`  → `cv1` + N 个 `Bottleneck(cv1,cv2)` + `cv2` + `cv3`
- `SPPF`→ `cv1` + 3 次 `maxpool` + `cv2`
- `Detect` → 3 个尺度 × (cv2 三层 + cv3 三层)

**三个必须记住的约定**（写错任何一个，PL 结果就是错的）：

1. **激活布局**：int8，4 通道打包进 1 个 32 位字 → `[C/4][H][W][4]`

   ```
   字节下标 = (((c>>2)*H + h)*W + w)*4 + (c&3)
   通道数向上取整到 4 的倍数 → 67 通道实际占 68 通道的位置
   ```

2. **通道偏移复用**：C3/SPPF 内部的 Concat 靠 `src_ch_off` / `dst_ch_off`
   指向同一块 DDR，不搬数据；只有模块级的 Concat/Upsample 才用
   `LT_COPY` 算子（约 1 MB/帧，占总量 7%）。

3. **每个张量有 64 字节对齐的 DDR 偏移 `off`**，写进描述符，PL 靠它取数，
   PS 端解码也靠它找张量。

**自检**：跑完会做一遍 fp32 numpy 模拟，和原版 PyTorch `forward` 逐元素对比，
相对误差 > 1e-4 直接 `SystemExit`。实测：

```
  P3  shape=(67,48,64)  rel=1.9e-06
  P4  shape=(67,24,32)  rel=2.7e-06
  P5  shape=(67,12,16)  rel=1.7e-06
  RESULT: PASS
```

### 2.2 `calibrate.py` —— 给量化器定"裁剪门限"

int8 只有 256 个格子。把张量压到 int8 就是选一个代表范围 `c`
（对称量化 `real = q * c/127`）：`c` 太大 → 步长粗；`c` 太小 → 大值饱和。

先用 fp32 模拟器跑 128 张验证图，统计每个张量的 `|value|` 分布：

- 第 1 趟：历史最大值 `max`
- 第 2 趟：以 `max` 为上限划 8192 个 bin 做直方图

`quantize.py` 拿到直方图后算 p99.9 / p99.99 分位数和 **MSE 最优裁剪点**（默认用后者）。
用验证集而不是训练集，是因为训练集里的分布偏乐观。

### 2.3 `quantize.py` —— 量化 + 打包（核心）

**量化契约**（PL 硬件实际执行的就是这一套）：

```
激活  : int8，按张量对称量化       real = q * s
权重  : int8，按输出通道对称量化   real = q * sw[oc]
卷积  : acc   = Σ wq*xq
        y_int = acc + bi[oc]              （bi = round(b/(sw*sx)) 整数偏置）
        y_q   = round(acc * mq[oc] >> shift[oc])
        然后 LeakyReLU（整数域 *3277>>15），再饱和到 int8
```

`mq/shift` 由 `make_requant_vec` 算出：把 `m` 归一化到 `[2^16, 2^17)`，
这样 DSP48 的 25×18 乘法器刚好吃得下，剩下的指数放进 per-channel shift。

**四条缩放规则**：

1. 一个张量一个 scale。
2. **有残差 Add 关系、或拷贝（concat / upsample）关系的张量必须共用同一个 scale。**
   否则 PL 要么得插 requant（没这条通路），要么要做两次对齐（也没有）。
   这些关系构成并查集分组，每组取组内最大的自然 scale。
3. **三个 Detect 输出张量的裁剪门限要故意调小**（`--outclip`）：
   DFL 的 16-bin softmax 全靠相邻 bin 的 logit 差值（只有 0.2~0.5），
   MSE 最优裁剪点会贴到最大值，步长 ~0.3 就把差值抹平了 →
   softmax 退化成均匀分布 → 期望值恒等于 7.5 → **所有框都回归成固定大小**。
   裁狠一点反而让饱和的离群值把 softmax 锐化。
4. **输入张量用零点技巧**：`v∈[0,1]` 存成 `q = round(v*255) - 128`，
   `sx = 1/255`（比朴素对称的 1/127 精度高一倍），`+128` 折进第一层卷积的 bias。
   ★ 这就是 `yolov5n_speed_app.c` 里 `p[c] = (int8_t)(v - 128)` 的来历。

**权重布局**：`[OC/CO][IC/CI][K][K][CO][CI]`
（输出通道块 → 输入通道块 → 卷积核 → 输出 lane → 输入 lane）。
这样 PL "暂存一个输出通道块的权重"时读到的是连续的一段 AXI 突发。
打包完脚本会**反解回来逐元素 assert**。

### 2.4 `verify_blobs.py` —— 按 PL 的读法反解成品（**最值钱的一步**）

这一节存在的理由：**产物之间对不上时，编译期看不出来**。
`layers` / `weights` / `rqt` 三份文件只要有任意两份不是同一次导出，
或者某个字段填错一位，PL 就会安静地算出一堆垃圾特征 —— 它不会报错，
因为 C 数组就是一堆 `uint8_t`，没有类型信息可查。

所以本脚本按 PL 的读法重新解析成品，并**独立重算真值**：

1. `layers.bin` → 84 个描述符，检查所有偏移越界、形状是否和 plan 一致、
   `ic/oc` 是否都是 4/16 的倍数（PL 的并行度要求）。
2. 每个 conv op：**从 `fused_weights.npz` 的 fp32 权重独立重算量化 + 打包**，
   再和 `weights.bin` 的对应字节逐字节比（不是拿 `quant.json` 比，
   是真算一遍 —— 连量化公式写错也能抓出来）。
3. `rqt.bin` 的 `{bias, mq, shift}` 逐通道对比。

实测结果：

```
weights.bin 724544 B, rqt.bin 36096 B, layers.bin 5376 B (84 条描述符)
描述符结构检查：通过
卷积 op：71 个；独立重算并逐字节复核权重点数 724544；requant 逐通道复核 3008 条
全部通过：描述符表、权重、requant 表互相自洽，且与 layer_plan 完全一致。
```

### 2.5 `emit_vitis_files.py` —— 改名写进 Vitis 工程

把 `gen/` 里的通用名改成 Vitis 工程的命名，覆盖前自动留 `.bak`，
并且打印每个 blob 的 **CRC32 指纹** —— 上板出问题时用它对账
"板子上跑的到底是哪一版"。最后还会把写进工程的 C 层表文本反解回来，
和 `layers.bin` 逐字节比一遍。

---

## 3. 生成的文件逐个说明（含真实示例）

### 3.0 一眼看全

| 生成物（`build_speed/gen/`） | 字节数 | 进 Vitis 后改名成 | 是什么 | 谁读它 |
|---|---|---|---|---|
| `yolov5n_desc.h` | 1947 | `yolov5n_speed_desc.h` | 描述符**结构体定义** + 输出张量地址/尺度等宏 | `yolov5n_speed_app.c` / `main.c` |
| `yolov5n_layers.h` | 16854 | `yolov5n_speed_layers.h` | 层表本体，84 条描述符（C 数组） | `main.c` 交给 PL |
| `weights_blob.c` | 3713481 | `weights_speed_blob.c` | 全部 int8 权重字节 | `main.c` 交给 PL |
| `rqt_blob.c` | 185169 | `rqt_speed_blob.c` | 每输出通道的反量化参数 | `main.c` 交给 PL |
| `hw_config.h` | 1081 | **不拷** | 硬件资源账本，只作对账 | 人看（见第 5 节） |

（前两个 blob 拷过去时**逐字节一致**，只改文件名；后两个因为要把
`_speed_` 写进 include guard 和 `#include`，各比 gen 侧多 18 字节。）

对应关系（`emit_vitis_files.py` 做的就是改名 + 加 `_speed_` 前缀）：

```
gen/yolov5n_desc.h      ──►  src/yolov5n_speed_desc.h
gen/yolov5n_layers.h    ──►  src/yolov5n_speed_layers.h
gen/weights_blob.c      ──►  src/weights_speed_blob.c
gen/rqt_blob.c          ──►  src/rqt_speed_blob.c
gen/hw_config.h         ──►  （不拷，只给人对账用）
```

三者怎么配合：**`layers` 是"做什么"，`weights` 是"用什么做"，`rqt` 是"做完怎么变回数"**。
`layers[i].wgt_off` 指到 `weights` 里，`layers[i].rq_off` 指到 `rqt` 里。

---

### 3.1 `yolov5n_desc.h` → `yolov5n_speed_desc.h`

**做什么**：定义 64 字节描述符的 C 结构体，以及 PS 端解码时要用到的常量。
**它自己不含数据**，是给 `yolov5n_speed_layers.h` 和 `yolov5n_speed_app.c` 用的。

**关键内容**（宏和数值都是文件里的真实值；结构体为了排版压成了几行，
**字段顺序和文件里完全一致**，文件里是一行一个）：

```c
/* 64-byte record; layout is pinned by quantize.py::pack_desc */
typedef struct {
    int32_t  src_off;      int32_t  dst_off;      int32_t  wgt_off;   int32_t  rq_off;
    int32_t  add_off;      int32_t  add_ch_off;   int32_t  reserved0;
    int16_t  ih, iw, oh, ow, ic, oc, oc_real, src_ch_off, dst_ch_off, tile_r, tile_c;
    uint8_t  k, s, pad, act, up, type, pad0, pad1;
    int16_t  pad2;         int32_t  pad3;
} layer_desc_t;                                  /* ← sizeof == 64，已用 ctypes 验过 */

typedef struct { int32_t bias, mq, shift; } requant_t;    /* 12 字节 */

#define LT_CONV     0                            /* desc.type 的取值 */
#define LT_MAXPOOL  1
#define LT_COPY     2
#define ACT_NONE    0                            /* desc.act */
#define ACT_LEAKY   1

#define YOLO_N_OPS        84
#define YOLO_INPUT_OFF    0
#define YOLO_INPUT_CH     3
#define YOLO_INPUT_H      384
#define YOLO_INPUT_W      512

#define YOLO_OUT_P3_OFF   4697088                /* ← PS 端就靠这个找 P3 输出 */
#define YOLO_OUT_P3_CH    67
#define YOLO_OUT_P3_H     48
#define YOLO_OUT_P3_W     64
#define YOLO_OUT_P4_OFF   5495808
#define YOLO_OUT_P4_CH    67
#define YOLO_OUT_P4_H     24
#define YOLO_OUT_P4_W     32
#define YOLO_OUT_P5_OFF   5695488
#define YOLO_OUT_P5_CH    67
#define YOLO_OUT_P5_H     12
#define YOLO_OUT_P5_W     16

/* DFL softmax 和 class sigmoid 对 scale 敏感，PS 必须乘上它们 */
#define YOLO_OUT_P3_SCALE 0.174680194f
#define YOLO_OUT_P4_SCALE 0.155798821f
#define YOLO_OUT_P5_SCALE 0.190347595f
#define YOLO_ARENA_BYTES  5745408                /* main.c 用它开 arena */
```

**这三个 `*_SCALE` 怎么用**（`yolov5n_speed_app.c::decode_level()` 里的真实代码）：

```c
float p = sigmoidf((float)*c4_px(plane, 64 + s, y, x, h, w) * scale);
/*                                ^^^^^^^^                ^^^^^
   通道 64..66 是类别 logits（前面 64 个是 DFL 分布）    这里乘的就是 Px_SCALE */
```

> ⚠️ `67` 通道在存储上是按 4 补齐的（占 68 个通道位），
> 所以解码时是 `plane, 64 + s` 而不是 `plane, 67 + s` 之类 ——
> 这个坑见 2.1 的"激活布局"。

---

### 3.2 `yolov5n_layers.h` → `yolov5n_speed_layers.h`

**做什么**：把 84 条描述符写成一个 C 数组。`main.c` 把它整个 flush 到 DDR，
把首地址交给 PL，PL 就照着一条一条执行 —— **这就是"程序"**。

```c
/* layer table for the Vitis application (64B aligned to match hardware) */
static const layer_desc_t yolo_layers[YOLO_N_OPS] __attribute__((aligned(64))) = {
  /* 0 L00                     */
  {         0,   786432,        0,        0,       -1,        0, 0,    384,  512,  192,  256,    4,   16,   16,     0,    0,   16,   16, 3,2,1,1,1,0,0,0, 0,0 },
  ...
  /*71 Detect.L0.cv3.2         */
  {   5397504,  4697088,   456768,    29376,       -1,        0, 0,     48,   64,   48,   64,   32,   16,    3,     0,   64,   16,   16, 1,1,0,0,1,0,0,0, 0,0 },
  ...
};
```

**字段顺序 = 上面那个 `layer_desc_t` 的顺序**，逐字段解释（用第 0 条 `L00` 当例子 ——
它是网络的 stem，`3×384×512 → 16×192×256`，3×3 卷积 stride 2）：

| # | 字段 | 值 | 含义 |
|---|---|---|---|
| 0 | `src_off` | `0` | 源张量在 arena 里的字节偏移。0 = 网络输入 |
| 1 | `dst_off` | `786432` | 目标张量偏移。输入占 4×384×512 = 786432 字节，所以输出紧跟在后面 |
| 2 | `wgt_off` | `0` | **这个 op 的权重在 `yolov5n_weights[]` 里的字节偏移** |
| 3 | `rq_off` | `0` | **这个 op 的 requant 在 `yolov5n_rqt[]` 里的字节偏移** |
| 4 | `add_off` | `-1` | 残差来源张量的偏移；`-1` = 没有残差 |
| 5 | `add_ch_off` | `0` | 残差从来源张量的第几个通道开始取 |
| 6 | `reserved0` | `0` | 占位 |
| 7,8 | `ih, iw` | `384, 512` | 源张量的 H / W |
| 9,10 | `oh, ow` | `192, 256` | 输出 H / W |
| 11 | `ic` | `4` | **补齐后**的输入通道（真实是 3，补到 4 的倍数） |
| 12 | `oc` | `16` | **补齐后**的输出通道（16 的倍数，PL 一次算 16 个） |
| 13 | `oc_real` | `16` | 真实输出通道（PL 只把前 `oc_real` 个写出去） |
| 14 | `src_ch_off` | `0` | 从源张量第几个通道开始读 |
| 15 | `dst_ch_off` | `0` | 写到目标张量第几个通道 |
| 16,17 | `tile_r, tile_c` | `16, 16` | 空间分块尺寸（PL 按块把输入窗口搬进片上 BRAM） |
| 18 | `k` | `3` | 卷积核 3×3 |
| 19 | `s` | `2` | 步长 2 |
| 20 | `pad` | `1` | 填充 1 |
| 21 | `act` | `1` | `1` = 后面接 LeakyReLU，`0` = 不接 |
| 22 | `up` | `1` | `1` = 普通拷贝，`2` = 2 倍最近邻上采样 |
| 23 | `type` | `0` | `0`=conv，`1`=maxpool，`2`=copy |

**五个"非默认"的例子**（都能在上面那个文件里搜到）：

**① 残差相加 —— `add_off` 指向 shortcut 张量**

```c
/* 4 L02.m0.cv2 */
{ 2359296, 1966080, 5952, 960, 1966080, 0, 0, 96,128, 96,128, 16,16,16, 0,0, 16,16, 3,1,1,1,1,0,0,0, 0,0 },
```

- `add_off = 1966080` → 残差来自偏移 1966080 的张量，也就是上面第 2 条 `L02.cv1` 的 `dst_off`
  → 这就是 C3 里 Bottleneck 的 shortcut
- `act = 1` → PL 是**先激活、再整数相加**（相加能直接做，是因为两个张量共用同一个 scale）

**② 最大池化 —— 源和目标同一块内存，靠通道偏移错开，不搬数据**

```c
/*28 L09.m0 */
{ 3523584, 3523584, 0, 0, -1, 0, 0, 12,16, 12,16, 48,48,48, 0,48, 12,16, 3,1,1,0,1,1,0,0, 0,0 },
```

- `src_off == dst_off == 3523584` → 原地操作
- `src_ch_off = 0`，`dst_ch_off = 48` → 从通道 0 读，结果写到通道 48 起
  （SPPF 的 `m0/m1/m2` 是串联池化，m2 的 `src_ch_off` 就是 96，看第 30 条）
- `type = 1`（maxpool），`act = 0`，`wgt_off = rq_off = 0`（池化不需要权重）

**③ 2 倍上采样 —— `up = 2`**

```c
/*33 L11.up.c0 */
{ 3578880, 3588096, 0, 0, -1, 0, 0, 12,16, 24,32, 48,48,48, 0,0, 16,16, 1,1,0,0,2,2,0,0, 0,0 },
```

- `ih,iw = 12,16` → `oh,ow = 24,32`：输出是输入的两倍
- `up = 2`（上采样），`type = 2`（拷贝类）
- 每个像素复制成 2×2，输出 = `round(input * scale)` 不参与（scale 由并查集强制与输入一致）

**④ Concat —— 一段一段拷进同一个 cat 张量的不同通道段**

```c
/*35 L12.cat.c48 */
{ 3422208, 3624960, 0, 0, -1, 0, 0, 24,32, 24,32, 48,48,48, 0,48, 16,16, 1,1,0,0,1,2,0,0, 0,0 },
```

- `src_off = 3422208` → 骨干 P4（`L07`）的输出；`dst_off = 3624960` → 这个 cat 张量
- `dst_ch_off = 48` → 拷到 cat 的第 48 通道起（第 0..47 通道由前一条 `L12.cat.c0` 填）
- `up = 1`（不是上采样），`type = 2`

**⑤ 检测头最后一层 —— `oc_real = 3` + `dst_ch_off = 64`**

```c
/*71 Detect.L0.cv3.2 */
{ 5397504, 4697088, 456768, 29376, -1, 0, 0, 48,64, 48,64, 32,16,3, 0,64, 16,16, 1,1,0,0,1,0,0,0, 0,0 },
```

- `dst_off = 4697088` = **`YOLO_OUT_P3_OFF`**，所以它就是 P3 输出张量
- `oc = 16` 但 `oc_real = 3` → PL 会算满 16 个通道（浪费一点），**但只把前 3 个写出去**
- `dst_ch_off = 64` → 写进 P3 输出张量的第 64 通道起
  → 前 64 个通道（`Detect.L0.cv2.2` 写的）是 DFL 分布，这 3 个是类别 logits
  → 所以 `decode_level()` 里读类别用的是 `c4_px(plane, 64 + s, ...)`

**PS 端怎么用它**（`main.c` 的真实代码）：

```c
extern const uint8_t  yolov5n_weights[];      /* weights_speed_blob.c 里 */
extern const uint32_t yolov5n_weights_len;
extern const uint8_t  yolov5n_rqt[];          /* rqt_speed_blob.c 里     */
extern const uint32_t yolov5n_rqt_len;

Xil_DCacheFlushRange((u32)yolov5n_weights, yolov5n_weights_len);
Xil_DCacheFlushRange((u32)yolov5n_rqt,     yolov5n_rqt_len);
Xil_DCacheFlushRange((u32)yolo_layers,     sizeof(yolo_layers));

XYolov5n_top_Set_p_act(&acc, (u32)yolo_arena);      /* 激活 arena       */
XYolov5n_top_Set_p_wgt(&acc, (u32)yolov5n_weights); /* → gmem 端口 p_wgt */
XYolov5n_top_Set_p_rqt(&acc, (u32)yolov5n_rqt);     /* → gmem 端口 p_rqt */
XYolov5n_top_Set_p_tbl(&acc, (u32)yolo_layers);     /* → gmem 端口 p_tbl */
XYolov5n_top_Set_start_op(&acc, 0);
XYolov5n_top_Set_n_ops(&acc, YOLO_N_OPS);           /* 84 */
XYolov5n_top_Start(&acc);
while (!XYolov5n_top_IsDone(&acc)) { }
```

---

### 3.3 `weights_blob.c` → `weights_speed_blob.c`

**做什么**：全部 int8 权重，拼成一块连续内存，让 PL 能一段一段地突发读。

```c
/* AUTO-GENERATED from weights.bin -- do not edit */
#include <stdint.h>
const uint8_t yolov5n_weights[724544] __attribute__((aligned(64))) = {
  0x10,0x02,0x06,0x00,0x0f,0x09,0x09,0x00,0x1a,0xd8,0xd1,0x00,0xdc,0x0e,0x08,0x00, ...
  ...                                                          /* 共 724544 字节 */
};
const uint32_t yolov5n_weights_len = 724544;
```

**布局**：按 op 顺序首尾相接，每个 op 内部是 `[OC/CO][IC/CI][K][K][CO][CI]`：

```
每个 op 的块 = ┌─ 输出通道块 ob = 0 ────────────────┐┌─ ob = 1 ─┐ ...
               │ 输入通道块 ib │ ky │ kx │ co │ ci  ││          │
               └────────────────┴────┴────┴────┴───┘└──────────┘
               ic/4 个 blk × k × k × 16 个 co × 4 个 ci
```

这样 PL 暂存"一个输出通道块的权重"时，读到的是**一整段连续地址**，一个 AXI 突发就搬完。

**真实示例**：第 0 条描述符 `L00` 的 `wgt_off = 0`，所以 `weights.bin[0...]` 就是 L00 的权重。
前 4 个字节是 `(ob=0, ib=0, ky=0, kx=0, co=0)` 这 4 个输入通道：

```
weights.bin[0:4] = 0x10 0x02 0x06 0x00  =  int8 {16, 2, 6, 0}
```

反推一下确实对得上（`fused_weights.npz` 里 `L00_w` 的 fp32 原值）：

```
op0 的 sw[0] = amax[0]/127 = 23.260824/127 = 0.18315610
L00_w[0, :, 0, 0] = [2.893766, 0.403017, 1.080189]        （ci = 0,1,2；ci=3 是补齐车道）
   round(2.893766 / 0.18315610) = 16   → 0x10
   round(0.403017 / 0.18315610) =  2   → 0x02
   round(1.080189 / 0.18315610) =  6   → 0x06
   补齐车道                      =  0   → 0x00
```

> `verify_blobs.py` 就是把这个反推过程对全部 71 个卷积算子做了 724544 字节。

---

### 3.4 `rqt_blob.c` → `rqt_speed_blob.c`

**做什么**：反量化（requant）参数。PL 卷积累加完之后，要对**每一个输出通道**
做一次 `y = round(acc * mq >> shift)`，`mq`/`shift` 就在这里。

```c
/* AUTO-GENERATED from rqt.bin -- do not edit */
const uint8_t yolov5n_rqt[36096] __attribute__((aligned(64))) = {
  0x65,0xdf,0xff,0xff,0x08,0x14,0x01,0x00,0x18,0x00,0x00,0x00, ...
  ...                                                  /* 共 36096 字节 */
};
const uint32_t yolov5n_rqt_len = 36096;
```

**布局**：按 op 顺序首尾相接，每个 op 是 `oc` 组 `{int32 bias, int32 mq, int32 shift}`，
每组 12 字节。`layers[i].rq_off` 就是这个 op 在里面的字节偏移。

```
36096 字节 ÷ 12 = 3008 条 = 所有卷积算子的 oc 之和
```

**PL 侧的用法**（`yolov5n_top.cpp::conv_kernel` 里的真实代码）：

```c
int idx = (rq_off >> 2) + (oc_base + co) * 3;
rq_bias[co] = p_rqt[idx + 0];
rq_mq[co]   = p_rqt[idx + 1];
rq_sh[co]   = p_rqt[idx + 2];
...
ap_int<44> pp = aa * mm;                  /* aa = 累加器, mm = mq */
v = rshift_round_ap(pp, rq_sh[co]);       /* 相当于 round(aa * mq / 2^shift) */
```

**真实示例**：第 0 条描述符 `L00` 的 `rq_off = 0`，所以它前 4 个输出通道就是：

```
rqt.bin[0:12]  = 65 df ff ff | 08 14 01 00 | 18 00 00 00   →  bias=-8347   mq=70664  shift=24
rqt.bin[12:24] = 32 f3 ff ff | 81 3a 01 00 | 18 00 00 00   →  bias=-3278   mq=80513  shift=24
rqt.bin[24:36] = 44 ff fe ff | c1 37 01 00 | 1b 00 00 00   →  bias=-65724  mq=79809  shift=27
rqt.bin[36:48] = 8e e8 ff ff | d7 a6 01 00 | 1a 00 00 00   →  bias=-6002   mq=108247 shift=26
```

（这三列就是 `0xFFFFDF65 / 0x00011408 / 0x00000018` 按**小端序**写出来的字节。
负数的 `ff` 都在高字节，所以显示成 `65 df ff ff` 这种"结尾是 ff"的样子。）

> 数组在 C 里声明成 `uint8_t`，但 `yolov5n_weights` / `yolov5n_rqt` 都加了
> `__attribute__((aligned(64)))` —— 就是为了让 `main.c` 把地址直接交给 PL
> （PL 侧是 `const int32_t *p_rqt`，`rq_off >> 2` 把字节偏移换算成 int32 下标）。
> 对齐掉了的话 PL 读出来的就是错位的数。

**`bias` 为什么是整数而不是浮点**：真实的偏置 `b` 已经被折算成
`bi = round(b / (sw * sx))`，除以量化步长了，所以 PL 可以直接
`acc = Σwq*xq + bi` 在整数域完成。**输入张量的 +128 零点也在这里被折进
第一个卷积的 bias**（见 2.3 的第 4 条规则）。

---

### 3.5 `hw_config.h`（**不拷进 Vitis**）

**做什么**：一份"这个模型需要多大的片上缓冲"的账本，用来核对**已经综合好的 IP** 够不够用。
不是 HLS 的构建输入，也不是 Vitis 的输入。详见第 5 节。

```c
/* ---- parallelism ---- */
#define HW_CO       16     /* 一次并行算多少个输出通道 */
#define HW_CI       4      /* 一个 32 位字里打包几个输入通道 */
#define HW_NX       16     /* 一个流水线块算几个输出像素 */
#define HW_ICG      16
#define HW_ICW      4

/* ---- on-chip buffers ---- */
#define HW_TROWS    33     /* tile 输入窗口最大行数 = (16-1)*2+3 */
#define HW_TCOLS    33
#define HW_IFM_WORDS 13248    /* 输入窗口缓冲（32 位字） */
#define HW_WGT_BYTES 18432    /* 一个输出通道块的权重缓冲（字节） */
#define HW_ACC_N    256
#define HW_MAX_PIX  256
#define HW_MAX_IC   192

/* ---- system ---- */
#define HW_ARENA_BYTES 5745408
#define HW_N_OPS 84
```

---

### 3.6 二进制中间产物（`build_speed/` 根目录）

`gen/` 里的 `.c` 就是从这几个 `.bin` 转出来的，留着是为了方便排查和给 PC 端工具用。

| 文件 | 字节数 | 是什么 | 对应的 C 文件 | 谁需要它 |
|---|---|---|---|---|
| `weights.bin` | 724544 | int8 权重裸字节 | `gen/weights_blob.c` | `verify_blobs.py`、`emit_vitis_files.py` 打 CRC |
| `rqt.bin` | 36096 | requant 裸字节 | `gen/rqt_blob.c` | 同上 |
| `layers.bin` | 5376 | 84 × 64 B 描述符 | `gen/yolov5n_layers.h` | 同上；也是核对 C 层表文本的基准 |
| `quant.json` | 198176 | 每个 op 的 `sw / bi / mq / shift / wgt_off / rq_off` | — | `refsim.py` 的 int8 模式、`verify_blobs.py` |
| `layer_plan.json` | 47997 | 84 个算子 + 59 个张量的完整参数（含 DDR 偏移） | — | `calibrate.py`、`quantize.py` 的输入 |
| `fused_weights.npz` | 2593192 | 卷积+BN 融合后的 fp32 权重 | — | `calibrate.py`、`verify_blobs.py`（用它独立重算） |
| `calib.json` | 304171 | 每个张量的 max / p99.9 / 512-bin 直方图 | — | `quantize.py` 的输入 |

> `layer_plan.json` / `fused_weights.npz` / `calib.json` 是**上一步的产物、下一步的输入**，
> 不要删 —— 删了就得从头重跑整条流水线（标定那步要 70 秒）。

---

### 3.7 三张表怎么配合 —— 完整走一遍 op 71

用 `Detect.L0.cv3.2`（检测头 P3 尺度的分类输出层）把三个文件串起来：

```
layers[71] = { src_off=5397504, dst_off=4697088, wgt_off=456768, rq_off=29376,
               add_off=-1, ih=48, iw=64, oh=48, ow=64,
               ic=32, oc=16, oc_real=3, src_ch_off=0, dst_ch_off=64,
               tile=16x16, k=1, s=1, pad=0, act=0, up=1, type=0 }

PL 读到这里就明白四件事：

  ① 从哪读输入
       arena + src_off(=5397504)，32 通道 48×64

  ② 用哪份权重、哪份 requant
       yolov5n_weights[wgt_off .. wgt_off + oc*ic*k*k]
           = yolov5n_weights[456768 .. 457280]   共 16×32×1×1 = 512 字节
       yolov5n_rqt    [rq_off  .. rq_off + oc*12]
           = yolov5n_rqt[29376 .. 29568]         共 16 组 {bias, mq, shift}

  ③ 算什么
       type=0(conv)  k=1 s=1 pad=0  act=0(无激活)
       输出 oc=16 个通道、48×64

  ④ 写到哪
       arena + dst_off(=4697088) + 通道偏移 dst_ch_off(=64)
       而且只写前 oc_real=3 个通道
                │
                └─► dst_off 4697088 就是 YOLO_OUT_P3_OFF
                    往后再数 64 个通道，就是 P3 输出的第 64..66 通道
                    （前 64 个是 Detect.L0.cv2.2 写的 DFL 分布，
                      这 3 个是类别 logits）
```

然后 PS 端 `app_postprocess()` 里：

```c
const int8_t *pb = arena + YOLO_OUT_P3_OFF;          /* 4697088 */
...decode_level(pb, YOLO_OUT_P3_H, YOLO_OUT_P3_W, YOLO_STRIDE_P3,
                YOLO_OUT_P3_SCALE, conf_thr, ...);
```

一处对不上（比如 `wgt_off` 差了一个字节、或者某个字段填错了），
PL 不会报错 —— 它只是安静地算出一堆垃圾特征。这就是 `verify_blobs.py` 存在的理由。

---

## 4. 上板后怎么确认这一版是对的

`main.c` 开机第一行会打印三个数：

```
 arena 5745408 bytes, 84 ops, weights 724544 bytes
```

它们分别是 `YOLO_ARENA_BYTES` / `YOLO_N_OPS` / `yolov5n_weights_len`，
都是编译进 ELF 的常量。**对不上就是 Vitis 没重新编译**
（`Debug/` 里的 `.o` 是旧的），Clean 一下再 Rebuild。

---

## 5. `hw_config.h` 的定位：**对账账本，不是构建输入**

`gen/hw_config.h` 把"这个模型需要多大的片上缓冲"列出来，用来核对**已经
综合好的 IP** 够不够用。`quantize.py` 跑完会自动打一张对账表：

```
---- 和已综合 IP 的对账（只读，不改任何东西）----
  HW_IFM_WORDS   本模型需要 13248   已综合 IP 提供 13248   够用
  HW_WGT_BYTES   本模型需要 18432   已综合 IP 提供 18432   够用
  ...
```

核对的实物在：

```
01_hls/yolov5n_hls/solution1/impl/ip/hdl/verilog/
    yolov5n_top_ifm_buf.v                       ← AddressRange / MEM_SIZE
    yolov5n_top_conv_kernel_wgt_buf.v
```

**结论**：本模型的每一项都 ≤ 已综合的 IP，所以**不用重新综合 HLS**，
直接 Rebuild Vitis 应用就行。

**只有**哪天某个数字变大了，才需要走这条路：
改 HLS 源 → `csynth` → 重新 `export_design` 出 IP → 重跑 Vivado 出 bitstream
→ Vitis 重建 platform → 再 Rebuild 应用。

---

## 6. 目录里其它文件

| 文件 | 说明 |
|---|---|
| `orig/weights_out.py`、`orig/fp322int8.py`、`orig/convert_bin2h.py` | **上一代"逐层展开"格式的旧脚本**（产出 `weights_int8_data.h`，里面是 `model_x_weight[]` 那种一层一个数组的写法）。和现在这个"指令驱动"的加速器**不兼容**，Vitis 工程里的 `weights_int8_data.h` 也没被任何人 include。放 `orig/` 只作参考，**不要**混进来跑。 |
| `build_speed/step*.log` | 每一步的运行日志，出问题时先看这里 |

---

## 7. 已知问题

**PL 吞吐只有理想的 1/18**（`infer 2449 ms` 而不是 ~150 ms）—— 这不是本流水线
的问题，产物是对的，是 HLS 里 `conv_kernel` 的数组被实现成了双口 BRAM，
带 16 路并发访问时被限速到 II=16。详细分析和修法见：

```
D:\02_workspace\02_vitis_projects\yolov5n_speed_prj\修复记录.md
```
