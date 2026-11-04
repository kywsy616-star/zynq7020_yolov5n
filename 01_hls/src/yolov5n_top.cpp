/*
 * yolov5n_top.cpp -- int8 CNN accelerator for yolov5n_crack on Zynq-7020.
 *
 * Architecture
 *   * one op at a time, driven by a 64-byte descriptor table in DDR
 *     一次执行一个算子，由DDR中存放的64字节算子描述符表驱动
 *   * all weights for ONE op stay on chip; each input tile is loaded once,
 *     then reused by all output-channel blocks (R3.5/R4.2 architecture).
 *     单算子权重全驻留；tile在外、ob在内，输入tile复用于所有输出通道块。
 *   * each spatial tile stages its input window (including the halo) in BRAM
 *     as packed c4 words (4 int8 per 32-bit word)
 *     每个图像空间分块，将输入窗口（包含卷积所需halo边界填充像素）缓存到片上BRAM，
 *     采用c4打包格式：1个32bit uint32存放4个int8像素，提升AXI总线带宽利用率
 *   * a HW_CO x HW_CI (16x4) multiplier array accumulates 64 MACs/cycle
 *     硬件乘法阵列：16×4，每个时钟周期可以并行完成64次乘累加(MAC)运算
 *   * requant -> LeakyReLU -> int8 saturation -> residual add -> saturation.
 *     mq / shift / bias are per output channel and live in
 *     DDR, so re-quantising never needs a re-synthesis.
 *     数值顺序：重量化、LeakyReLU、sat8、残差相加、sat8；R5保持此顺序。
 *     mq缩放系数、shift移位量、bias偏置按输出通道独立存在DDR；量化参数可动态修改，不需要重新综合FPGA工程
 *
 * Hot loop:
 *     tr,tc    : spatial tile                           图像空间tile分块坐标
 *     y        : row inside the tile                    tile内部行坐标
 *     x0       : block of HW_NX output pixels           输出像素块起始位置
 *     ob       : output channel block                  输出通道块
 *       ib,ky,kx : input channel block / kernel taps
 *         nx     : fixed HW_NX iterations, valid-tail guard (R5).
 *     R5: clipped row bursts, one dot4/accumulator update, residual q/nx order.
 *     R6.2: capacity-checked wider Conv tiles; requant directly into BRAM,
 *     then one contiguous output segment per C4 plane and tile row.
 *     See ../HLS_R5_调度访存优化与综合记录_20261015.md for synthesis results.
 *
 * ============================================================================
 *  ★★  yaml 模型是怎么在这个 IP 里实现的  ★★
 * ============================================================================
 *
 * ----------------------------------------------------------------------------
 * 一、三层抽象：从 yaml 到 RTL
 * ----------------------------------------------------------------------------
 *      yolov5_crack_speed.yaml                  "网络长什么样"     ← 人写的
 *              │
 *              │  make_layer_plan.py  摊平：把复合模块拆成 3 种基本算子
 *              ▼
 *      layer_plan.json                        "84 条指令"
 *      ↓  quantize.py 打包
 *      layers.bin / yolov5n_speed_layers.h     "64字节×84 的描述符表"
 *              │
 *              │  PS 把表首地址写进 AXI-Lite 寄存器
 *              ▼
 *      yolov5n_top()  ← 本文件                  "3 种算子"        ← 综合成 RTL
 *
 *  ★★ 关键：这个 IP 内部**没有 yolov5 的任何形状信息**。
 *     硬件里只有 3 条数据通路（卷积 / 池化 / 搬运），
 *     yaml 里的 C3 / SPPF / Upsample / Concat / Detect 全都不存在，
 *     它们被摊平成这 3 种算子、逐条写进描述符表。
 *     所以换模型不用重新综合 IP —— 换一张表就行（前提：形状不超过本 IP 的
 *     缓冲区容量，见 yolov5n_hls.h 里的 HW_IFM_WORDS / HW_WGT_BYTES）。
 *
 * ----------------------------------------------------------------------------
 * 二、yaml 的每种模块 → PL 的什么算子
 * ----------------------------------------------------------------------------
 *
 *   ┌────────────────┬────────────────────────────────────────────────────────
 *   │ yaml 模块       │ PL（本文件）里的实现                                  │
 *   ├────────────────┼────────────────────────────────────────────────────────
 *   │ Conv [c,k,s]   │ **1 条** LT_CONV                                      │
 *   │                │ k 和 s 直接进描述符；k=1 和 k=3 **共用同一套数据通路** │
 *   │                │ （conv_kernel 里 kk 是运行时参数，为此不模板化 K ——   │
 *   │                │   模板化会让 HLS 生成两套乘法阵列，LUT 飙到 159%）    │
 *   ├────────────────┼────────────────────────────────────────────────────────
 *   │ C3 [c]         │ **2n+3 条**（n = bottleneck 个数）                    │
 *   │                │ 见下面"三、C3 的拆法"                                 │
 *   ├────────────────┼────────────────────────────────────────────────────────
 *   │ SPPF [c,k]     │ **5 条**：cv1 + 3×LT_MAXPOOL + cv2                    │
 *   │                │ 三级池化是**串联**的：m1 读 m0 的输出，m2 读 m1 的输出│
 *   │                │ 靠 src_ch_off 递增实现，见下面"四、SPPF 的拆法"       │
 *   ├────────────────┼────────────────────────────────────────────────────────
 *   │ nn.Upsample    │ **1 条** LT_COPY，up=2                                │
 *   │  (2x nearest)  │ 每个源像素复制成 2×2 = 一次读、四次写                 │
 *   ├────────────────┼────────────────────────────────────────────────────────
 *   │ Concat         │ **有几个输入就几条** LT_COPY，up=1                    │
 *   │                │ 每一路靠 dst_ch_off 写到同一个 cat 张量的不同通道段   │
 *   │                │ （不重新排数据，只是往不同偏移上写）                  │
 *   ├────────────────┼────────────────────────────────────────────────────────
 *   │ Detect         │ **每个尺度 6 条** = 18 条 LT_CONV                     │
 *   │                │ cv2 三层 → 写 obuf[0:64]   （DFL 的 4×16 个分布值）   │
 *   │                │ cv3 三层 → 写 obuf[64:67]  （3 个类别 logit）         │
 *   │                │ ★ DFL 的 16-bin softmax 和 cls.sigmoid() **不在 PL 做**│
 *   │                │   由 PS 端 decode_level() 解码（yaml 注释第 4 条）    │
 *   └────────────────┴────────────────────────────────────────────────────────
 *
 * ----------------------------------------------------------------------------
 * 三、C3 的拆法（以本模型的 C3 32 为例，yaml #2 → 算子 2~6）
 * ----------------------------------------------------------------------------
 *   C3 的结构是：  cat = concat( 瓶颈链的输出 , cv2(src) )， out = cv3(cat)
 *   c_ = c/2 = 16，cat 是 2*c_ = 32 通道
 *
 *     op2  L02.cv1      1x1   src(L01_out) ────► cat[0 : 16]
 *     op3  L02.m0.cv1   1x1   cat[0:16]     ────► tmp
 *     op4  L02.m0.cv2   3x3   tmp           ────► cat[0:16]   ← 残差：+cat[0:16]
 *     op5  L02.cv2      1x1   src(L01_out) ────► cat[16 : 32] （旁路分支）
 *     op6  L02.cv3      1x1   cat[0:32]     ────► out
 *
 *   ★ 两个 Concat **一条 COPY 算子都没有** —— cat 是预先分配好的一块 DDR，
 *     各分支靠 dst_ch_off 往它的不同通道段写，src_ch_off 从不同段读。
 *     这是"通道偏移复用"，省掉两次搬运。
 *
 *   ★ 残差（Bottleneck 的 shortcut）也不用额外算子：op4 描述符里
 *     add_off = cat 的偏移，硬件在激活之后做一次**整数加**（见 conv_kernel
 *     第 5 步）。能直接加是因为 quantize.py 用并查集强制 dst 和 add_src
 *     共用同一个量化 scale。
 *
 *   Bottleneck 多一个就多 2 条（m_i.cv1 + m_i.cv2），且**只有最后一个**
 *   m.cv2 的结果落进 cat[0:c_]，中间的落在各自的临时张量上。
 *   本模型：C3 32 是 n=1 → 5 条；C3 48（yaml #6 的 repeats=2）是 n=2 → 7 条。
 *
 * ----------------------------------------------------------------------------
 * 四、SPPF 的拆法（yaml #9 → 算子 27~31）
 * ----------------------------------------------------------------------------
 *     op27 L09.cv1  1x1   src(L08_out) ───► cat[0 : 48]
 *     op28 L09.m0   3x3池  cat[0:48]   ───► cat[48 : 96]     ← 读0，写1
 *     op29 L09.m1   3x3池  cat[48:96]  ───► cat[96 : 144]    ← 读1，写2
 *     op30 L09.m2   3x3池  cat[96:144] ───► cat[144 : 192]   ← 读2，写3
 *     op31 L09.cv2  1x1   cat[0:192]   ───► out
 *
 *   ★ 三级池化串成一条链：每一级的 src_ch_off 指向前一级刚写出来的那段，
  
  
  
 *       3    Conv 32 3s2          7          1    32ch  48x64   ← P3 骨干（本档 32）
 *       4    C3 32                8..12      5    32ch  48x64
 *       5    Conv 48 3s2         13          1    48ch  24x32
 *       6    C3 48 (repeats=2)   14..20      7    48ch  24x32
 *       7    Conv 96 3s2         21          1    96ch  12x16   ← P5 骨干
 *       8    C3 96               22..26      5    96ch  12x16
 *       9    SPPF 96             27..31      5    96ch  12x16
 *      10    Conv 48 1x1         32          1    48ch  12x16
 *      11    Upsample            33          1    48ch  12x16 → 24x32
 *      12    Concat(-1, #6)      34,35       2    96ch  24x32   (48+48)
 *      13    C3 48               36..40      5    48ch  24x32
 *      14    Conv 32 1x1         41          1    32ch  24x32
 *      15    Upsample            42          1    32ch  24x32 → 48x64
 *      16    Concat(-1, #4)      43,44       2    64ch  48x64   (32+32)
 *      17    C3 32               45..49      5    32ch  48x64   ← P3 检测头输入
 *      18    Conv 48 3s2         50          1    48ch  24x32
 *      19    Concat(-1, #14)     51,52       2    80ch  24x32   (48+32)
 *      20    C3 64               53..57      5    64ch  24x32   ← P4 检测头输入
 *      21    Conv 128 3s2        58          1   128ch  12x16
 *      22    Concat(-1, #10)     59,60       2   176ch  12x16   (128+48)
 *      23    C3 128              61..65      5   128ch  12x16   ← P5 检测头输入
 *      --    Detect(17,20,23)    66..83     18    67ch × 3 个尺度
 *                                            ----
 *                                            84 条
 *
 * ----------------------------------------------------------------------------
 * 六、三种算子怎么处理数据（对应描述符里的字段）
 * ----------------------------------------------------------------------------
 *   所有激活值都在同一块 DDR arena 里（PS 端 yolo_arena[]，5,745,408 B）。
 *   描述符里的 src_off / dst_off / add_off 就是这块 arena 里的**字节偏移**。
 *
 *     LT_CONV    读 p_act + src_off + c4_index(src_ch_off + ...)
 *                卷完 写 p_act + dst_off + c4_index(dst_ch_off + ...)
 *                若 add_off >= 0，在激活之后再加一次残差
 *     LT_MAXPOOL 同上取数，但换成 3x3 取最大；src/dst 常是同一块张量的不同段
 *     LT_COPY    不计算，只搬；up=2 时 1 个源像素写成 4 个输出像素
 *
 *   ★ c4 打包（全片统一的布局，写错必错）：
 *         int8 激活，4 个通道塞进一个 32 位字 → [C/4][H][W][4]
 *         字节下标 = (((c>>2)*H + h)*W + w)*4 + (c&3)
 *     所以 67 通道的检测头输出实际占 68 个通道的位置，第 68 道是填充。
 *     两个硬性推论：
 *        · ic 必须是 4 的倍数、oc 必须是 16 的倍数（否则数组边界对不齐）
 *        · src_ch_off / dst_ch_off / add_ch_off 必须是 4 的倍数
 *         —— 这两条在 yolov5n_top() 里都加了校验（见那里的"防御 2"）
 *
 *   ★ 量化参数（rqt）也是运行时从 DDR 读的：
 *         M[oc] = sw[oc]*sx/sy 存成 {mq, shift}，偏置存成整数 bi
 *         —— PC 端 quantize.py 离线算好，IP 只管用。
 *         换量化方案不用重新综合 IP。
 */
#include <ap_int.h>
#include "yolov5n_hls.h"
#include "axi64_native_io.h"
#define CO  HW_CO   // 单次并行输出通道数，你的工程设为16
#define CI  HW_CI   // 单次并行输入通道数，你的工程设为4
#define NX  HW_NX   // 单次并行空间像素数量
#if HW_CI != 4
#error R5_dot4_requires_the_existing_c4_layout
#endif

/* ------------------------------------------------------------------ buffers */
/* ★ 一条 HLS 的硬性规则：**#pragma HLS 只能写在函数作用域里**。
   写在文件作用域（数组声明旁边）会直接报错、综合根本起不来：
       ERROR: [HLS 214-122] '#pragma HLS' is only allowed in function scope
   所以"数组分区"这类指令必须放进**使用该数组的函数内部**。
   （2026-10-11 踩过一次：6 条 ARRAY_PARTITION 放在这里 → csynth 直接失败）

   R6.3修改：原文件级ifm_buf改为顶层局部共享scratch并显式传参。
   Conv/Pool/Copy逐算子串行，复用同一块bank0；Conv另加一块bank1。
   这样不额外保留第三份IFM，也避免全局缓存角色触发HLS函数克隆。
   数组分区仍放在声明或使用它的函数作用域。
*/
/* --------------------------------------------------------------- utilities */
/**
 * @brief 饱和截断函数，将int32数值限制在int8范围 [-128,127]
 * @param v 待截断32bit整数
 * @return 饱和后int8范围数值
 * #pragma HLS INLINE：函数内联，消除函数调用开销
 */
static inline int32_t sat8(int32_t v)
{
#pragma HLS INLINE
    if (v > 127)  return 127;
    if (v < -128) return -128;
    return v;
}
/* 交接说明 函数 sat8 结束后
 * 函数sat8属于HLS计算及数据流。保留原实现，负责调用者所需的局部处理；输入输出及调用位置见本函数签名和正文。本次交接只新增说明，不改变活动语句。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */

/**
 * @brief 带四舍五入的右移，定点运算标准舍入
 * @param v 64bit输入累加值
 * @param sh 移位位数
 * @return 舍入右移后的32bit结果
 */
static inline int32_t rshift_round(int64_t v, int sh)
{
#pragma HLS INLINE
    if (sh <= 0) return (int32_t)(v << (-sh));
    int64_t h = ((int64_t)1) << (sh - 1); // 四舍五入偏移量，+0.5
    return (int32_t)((v + (v >= 0 ? h : -h)) >> sh);
}
/* 交接说明 函数 rshift_round 结束后
 * 函数rshift_round属于HLS计算及数据流。保留原实现，负责调用者所需的局部处理；输入输出及调用位置见本函数签名和正文。本次交接只新增说明，不改变活动语句。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */

/**
 * @brief 带四舍五入右移（ap_int版本，HLS专用任意精度整数）
 * @param v 44bit任意精度累加乘积
 * @param sh 移位位数
 * @return 舍入右移后32bit结果
 */
static inline int32_t rshift_round_ap(ap_int<44> v, int sh)
{
#pragma HLS INLINE
    if (sh <= 0) return (v << (-sh)).to_int();
    ap_int<44> h = ((ap_int<44>)1) << (sh - 1);
    ap_int<44> r = (v >= 0) ? (v + h) : (v - h);
    return (r >> sh).to_int();
}
/* 交接说明 函数 rshift_round_ap 结束后
 * 函数rshift_round_ap属于HLS计算及数据流。保留原实现，负责调用者所需的局部处理；输入输出及调用位置见本函数签名和正文。本次交接只新增说明，不改变活动语句。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */

/**
 * @brief c4打包张量寻址函数：计算通道c、坐标(h,w)对应的字节偏移
 * @param c 通道号
 * @param h 图像高
 * @param w 图像宽
 * @param H 张量总高度
 * @param W 张量总宽度
 * @return 字节地址偏移
 * 打包规则：每4个连续通道打包进1个uint32；c>>2 找到是第几个c4 word；c&3 是word内第几个字节
 */
static inline uint32_t c4_index(int c, int h, int w, int H, int W)
{
#pragma HLS INLINE
    return (uint32_t)((((c >> 2) * H + h) * W + w) * 4 + (c & 3));
}
/* 交接说明 函数 c4_index 结束后
 * 函数c4_index属于HLS计算及数据流。保留原实现，负责调用者所需的局部处理；输入输出及调用位置见本函数签名和正文。本次交接只新增说明，不改变活动语句。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */

/* ------------------------------------------------------------------- copy */
/**
 * @brief Copy算子：张量搬运（Concat/Upsample），R3改动#3重构为两步法
 *
 * ★ R3改动#3：抄 conv 的两步法重构
 * 原来循环体是 v=load(); store(v)，读→写数据依赖，II=16、iter_lat=21，
 * 只有 ~1.3 个迭代在飞，DDR 读延迟完全没被掩盖。实测 63 周期/源字，10条全部一致）。
 * 现在改成，
 *   第一步：按空间 tile 把源数据读到片上 ifm_buf（只有DDR读，II=1，
 *   第二步：从 ifm_buf 写回 DDR（只有DDR写，II=1，
 * 两个循环各自只有一种访存方向，都能跑到 II=1。
 * up=2 的最近邻上采样：输出(y,x)对应源(y/2, x/2)，在第二步里做。
 *
 * @param p_act DDR特征图基地址
 * @param src_off 源张量偏移
 * @param dst_off 目标张量偏移
 * @param src_ch_off 源通道起始偏移
 * @param dst_ch_off 目标通道起始偏移
 * @param cch 当前处理通道总数
 * @param ih 输入高
 * @param iw 输入宽
 * @param up 上采样倍数 up=1原样拷贝；up=2最近邻×2上采样
 * @param tile_r,tile_c 空间分块大小（从描述符读取，与conv/pool共用）
 * #pragma HLS INLINE off：不内联，单独生成硬件模块，作为独立算子
 */
static void copy_op(const int8_t *p_act, int32_t src_off, int32_t dst_off,
                    int src_ch_off, int dst_ch_off, int cch, int ih, int iw,
                    int up, int tile_r, int tile_c,
                    uint32_t ifm_buf[HW_IFM_WORDS])
{
#pragma HLS INLINE off
    /* 防御：up 只允许 1（普通拷贝）和 2（2 倍上采样）。
       若描述符里写成 0，下面 oh = ih*0 = 0，而 c4_index() 里 H/W 传 0 会让
       `h` 从地址式子里消失 —— 所有行都写同一个地址，最后只剩最后一行，
       盖在 dst 开头一小块里，后面所有层全读到垃圾，且不会报任何错。 */
    if (up != 2) up = 1;
    int oh = ih * up;
    int ow = iw * up;
    int nw = (cch + 3) >> 2;                       /* c4 words per pixel：总通道转成c4 word数量 */

    // g：遍历每组c4通道（4通道一组）
    for (int g = 0; g < nw; g++) {
        // 按输出空间 tile 分块（R3改动#3：原来整张张量一把梭，现在按tile分块，
        for (int tr = 0; tr < oh; tr += tile_r) {
            for (int tc = 0; tc < ow; tc += tile_c) {
                int nr = (tr + tile_r <= oh) ? tile_r : (oh - tr);
                int nc = (tc + tile_c <= ow) ? tile_c : (ow - tc);

                // 源tile尺寸：up=2时输出是输入的2倍，源尺寸是输出的一半（向上取整，
                int src_nr = (up == 2 ? (nr + 1) >> 1 : nr);
                int src_nc = (up == 2 ? (nc + 1) >> 1 : nc);
                int src_tr = (up == 2 ? tr >> 1 : tr);   // 输出tile起始坐标对应的源坐标
                int src_tc = (up == 2 ? tc >> 1 : tc);

                /* ---- 第一步：把源tile从DDR读到片上ifm_buf（只有DDR读，II=1） ----
                 * 这一步和 conv 的 staging 循环完全同构：只有 m_axi 读，
                 * 综合报告已证明纯读循环能跑到 II achieved = 1。
                 * ★ LUT优化：去掉边界检查（sr<ih && sc<iw）。
                 *   描述符里tile_r/tile_c=16，所有特征图尺寸都是16的倍数（
                 *   up=2时输出=输入×2也都是16倍数，tile不会越界。
                 *   去掉比较器和mux，降低LUT。 */
                for (int r = 0; r < src_nr; r++) {
                    const int first = (src_off + c4_index(src_ch_off + (g << 2),
                                       src_tr + r, src_tc, ih, iw)) >> 2;
                    axi64_read_words<HW_IFM_WORDS>(p_act, first, ifm_buf,
                                                  r * src_nc, src_nc);
                }

                /* ---- 第二步：从片上ifm_buf写回DDR（只有DDR写，II=1） ----
                 * up=1：1个源像素→1个输出像素（sy=y, sx=x，
                 * up=2：1个源像素→2×2=4个输出像素（最近邻，sy=y/2, sx=x/2，
                 * 这一步和 conv 的写回循环完全同构：只有 m_axi 写，II=1。
                 * 原来 up=2 的四次写里有两处相隔整整一行，现在按输出坐标顺序写，
                 * 地址沿w方向连续，可以凑burst。 */
                uint32_t line[HW_ROW_PIXELS];
#pragma HLS BIND_STORAGE variable=line type=ram_2p impl=bram
                for (int y = 0; y < nr; y++) {
                    for (int chunk = 0; chunk < nc; chunk += HW_ROW_PIXELS) {
                        const int n = nc - chunk < HW_ROW_PIXELS ? nc - chunk : HW_ROW_PIXELS;
                        const int sy = up == 2 ? y >> 1 : y;
                        for (int x = 0; x < n; x++) {
#pragma HLS PIPELINE II=1
                            const int sx = up == 2 ? (chunk + x) >> 1 : chunk + x;
                            line[x] = ifm_buf[sy * src_nc + sx];
                        }
                        const int first = (dst_off + c4_index(dst_ch_off + (g << 2),
                                           tr + y, tc + chunk, oh, ow)) >> 2;
                        axi64_write_line(p_act, first, line, n);
                    }
                }
            }
        }
    }
}
/* 交接说明 函数 copy_op 结束后
 * 函数copy_op属于HLS计算及数据流。包含HLS流水线指示，修改循环边界后必须复核II与启动开销。本次交接只新增说明，不改变活动语句。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */

/* ------------------------------------------------------------------- pool */
/**
 * @brief Pool算子：固定3×3 MaxPool，stride=1，pad=1（SPPF专用池化算子）
 * @param p_act DDR特征图基地址
 * @param src_off 源张量偏移
 * @param dst_off 目标张量偏移
 * @param src_ch_off 源通道起始
 * @param dst_ch_off 目标通道起始
 * @param cch 当前处理通道数
 * @param ih,iw 输入特征图高宽
 * @param tile_r tile_c 空间分块大小
 */
static void pool_op(const int8_t *p_act, int32_t src_off, int32_t dst_off,
                    int src_ch_off, int dst_ch_off, int cch,
                    int ih, int iw, int tile_r, int tile_c,
                    uint32_t ifm_buf[HW_IFM_WORDS])
{
#pragma HLS INLINE off
    int nw = (cch + 3) >> 2;                       /* c4 words (channel groups) */
    int oh = ih, ow = iw;                          /* 3x3/s1/p1，输出尺寸不变 */
    // g：遍历c4通道组
    for (int g = 0; g < nw; g++) {
        // 空间维度分块tile，降低片上BRAM缓存大小
        for (int tr = 0; tr < oh; tr += tile_r) {
            for (int tc = 0; tc < ow; tc += tile_c) {
                int nr = (tr + tile_r <= oh) ? tile_r : (oh - tr);
                int nc = (tc + tile_c <= ow) ? tile_c : (ow - tc);
                int rows = nr + 2, cols = nc + 2; // tile+halo边界，3×3池化需要外围一圈像素
                int r0 = tr - 1, c0 = tc - 1;     // 池化的窗口直接用 r*cols+c 寻址，不需要 stride
                // 第一步：把包含halo的窗口从DDR读到片上ifm_buf
                for (int r = 0; r < rows; r++) {
                    int sr = r0 + r;
                    int inrow = (sr >= 0) && (sr < ih); // 判断是否越界，越界填充int8最小值
                    for (int c = 0; c < cols; c++) {
#pragma HLS PIPELINE II=1
                        ifm_buf[r * cols + c] = 0x80808080u;
                    }
                    if (inrow) {
                        int begin = c0 < 0 ? -c0 : 0;
                        if (begin > cols) begin = cols;
                        int end = iw - c0;
                        if (end > cols) end = cols;
                        if (end < begin) end = begin;
                        if (end > begin) {
                            const int first = (src_off + c4_index(src_ch_off + (g << 2),
                                               sr, c0 + begin, ih, iw)) >> 2;
                            axi64_read_words<HW_IFM_WORDS>(p_act, first, ifm_buf,
                                                          r * cols + begin, end - begin);
                        }
                    }
                }
                // 第二步：片上ifm_buf滑动窗口做3×3最大值池化
                uint32_t line[HW_ROW_PIXELS];
#pragma HLS BIND_STORAGE variable=line type=ram_2p impl=bram
                for (int y = 0; y < nr; y++) {
                    for (int chunk = 0; chunk < nc; chunk += HW_ROW_PIXELS) {
                        const int n = nc - chunk < HW_ROW_PIXELS ? nc - chunk : HW_ROW_PIXELS;
                        for (int x = 0; x < n; x++) {
#pragma HLS PIPELINE II=1
                        uint32_t mx = 0x80808080u;
                        int base = y * cols + chunk + x;
                        // 3×3卷积核循环，完全展开unroll
                        for (int ky = 0; ky < 3; ky++) {
#pragma HLS UNROLL
                            for (int kx = 0; kx < 3; kx++) {
#pragma HLS UNROLL
                                uint32_t v = ifm_buf[base + ky * cols + kx];
                                // c4打包4个通道并行比较最大值
                                for (int ci = 0; ci < 4; ci++) {
#pragma HLS UNROLL
                                    int8_t a = (int8_t)((mx >> (ci * 8)) & 0xFF);
                                    int8_t b = (int8_t)((v  >> (ci * 8)) & 0xFF);
                                    if (b > a) mx = (mx & ~(0xFFu << (ci * 8)))
                                                  | ((uint32_t)(uint8_t)b << (ci * 8));
                                }
                            }
                        }
                        line[x] = mx;
                        }
                        const int first = (dst_off + c4_index(dst_ch_off + (g << 2),
                                           tr + y, tc + chunk, oh, ow)) >> 2;
                        axi64_write_line(p_act, first, line, n);
                    }
                }
            }
        }
    }
}
/* 交接说明 函数 pool_op 结束后
 * 函数pool_op属于HLS计算及数据流。包含HLS流水线指示，修改循环边界后必须复核II与启动开销。本次交接只新增说明，不改变活动语句。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */

/* ------------------------------------------------------------------- conv */
/**
 * @brief Conv算子：支持动态1×1 /3×3卷积，stride/pad可配置；支持残差add、LeakyReLU激活、INT8重量化
 * @param p_act DDR特征图基地址
 * @param p_wgt DDR权重基地址（int8 c4打包，
 * @param p_rqt DDR重量化参数(mq,shift,bias)
 * @param src_off 输入特征偏移
 * @param dst_off 输出特征偏移
 * @param wgt_off 权重偏移
 * @param rq_off 量化参数偏移
 * @param add_off 残差分支输入偏移，add_off >=0代表启用残差shortcut（C3模块残差）
 * @param add_ch_off 残差通道起始
 * @param dst_ch_off 输出通道起始
 * @param ih,iw 输入高宽
 * @param ic 输入通道总数
 * @param oh,ow 输出高宽
 * @param oc 输出通道（向上补齐到16倍数）
 * @param oc_real 模型真实输出通道（剔除补齐虚拟通道）
 * @param kk 卷积核尺寸 1 or 3
 * @param ss stride步长
 * @param pad 填充
 * @param act 激活类型 ACT_LEAKY or NO_ACT
 * @param tile_r tile_c 空间分块大小
 * 设计亮点：运行时动态kk，不需要模板；只生成一套乘法阵列，避免综合两套卷积硬件造成LUT爆炸
 */
// R6.3 / 9.xsa：调度实现独立成头文件，保留顶层接口和Pool/Copy。
// R6.4 / 10.xsa：1×1行级流调度；普通卷积仍走R6.3兼容路径。
#include "yolov5n_r6_5_schedule.h"

/* -------------------------------------------------------------------- top */
/**
 * @brief 加速器顶层函数，PL IP入口
 * 读取DDR算子描述符表，循环调度Conv/Pool/Copy三类算子；
 * AXI4-Master接口访问DDR特征图、权重、量化参数；AXI-Lite寄存器由PS控制启停
 * @param p_act 特征图DDR地址
 * @param p_wgt 权重DDR地址
 * @param p_rqt 重量化参数DDR地址
 * @param p_tbl 算子描述符表DDR地址
 * @param start_op 起始算子序号
 * @param n_ops 需要执行算子数量 */
void yolov5n_top(const int8_t  *p_act,
                 const int8_t  *p_wgt,
                 const int32_t *p_rqt,
                 const int32_t *p_tbl,
                 int start_op,
                 int n_ops)
{
// AXI Master接口配置，全部挂在gmem总线；设置burst长度、 outstanding，提升DDR带宽
#pragma HLS INTERFACE m_axi port=p_act bundle=gmem depth=2097152 offset=slave max_widen_bitwidth=64 \
    num_read_outstanding=4 num_write_outstanding=4 max_read_burst_length=16 max_write_burst_length=16
#pragma HLS INTERFACE m_axi port=p_wgt bundle=gmem depth=262144  offset=slave max_widen_bitwidth=64 \
    num_read_outstanding=4 num_write_outstanding=4 max_read_burst_length=16 max_write_burst_length=16
#pragma HLS INTERFACE m_axi port=p_rqt bundle=gmem depth=16384   offset=slave max_widen_bitwidth=64 \
    num_read_outstanding=4 num_write_outstanding=4 max_read_burst_length=16 max_write_burst_length=16
#pragma HLS INTERFACE m_axi port=p_tbl bundle=gmem depth=16384   offset=slave max_widen_bitwidth=64 \
    num_read_outstanding=4 num_write_outstanding=4 max_read_burst_length=16 max_write_burst_length=16
// AXI-Lite从接口，PS ARM通过该寄存器控制IP，传递函数入参
#pragma HLS INTERFACE s_axilite port=p_act    bundle=control
#pragma HLS INTERFACE s_axilite port=p_wgt    bundle=control
#pragma HLS INTERFACE s_axilite port=p_rqt    bundle=control
#pragma HLS INTERFACE s_axilite port=p_tbl    bundle=control
#pragma HLS INTERFACE s_axilite port=start_op bundle=control
#pragma HLS INTERFACE s_axilite port=n_ops    bundle=control
#pragma HLS INTERFACE s_axilite port=return   bundle=control

    // R6.3：内部共享缓存，不是新增顶层参数或软件寄存器。
    // Pool/Copy仅改内部传参，原数据访问、运算和tile策略保留。
    uint32_t ifm_buf[HW_IFM_WORDS];
#pragma HLS BIND_STORAGE variable=ifm_buf type=ram_t2p impl=bram

    /* ---- 防御 1：把 start_op / n_ops 夹进描述符表范围内 ----
       表只有 HW_N_OPS = 84 条。start_op / n_ops 是留给"逐层调试"的入参
       （PS 端 Set_start_op() / Set_n_ops()），是人手填的。
       一旦 start_op + n_ops 越过表尾，下面就会把 yolo_layers[] 后面的
       .rodata 当成描述符执行 —— oh/ow/ic/oc 全是随机值，轻则跑很久，
       重则写到 arena 外面，在 DDR 里乱写。 */
    if (start_op < 0) start_op = 0;
    if (start_op > HW_N_OPS) start_op = HW_N_OPS;
    if (n_ops < 0) n_ops = 0;
    if (start_op + n_ops > HW_N_OPS) n_ops = HW_N_OPS - start_op;

    int32_t d[HW_DESC_WORDS]; // 存放单个算子描述符
#pragma HLS ARRAY_PARTITION variable=d complete // 数组完全拆分，并行读取描述符字段

    // 循环依次执行算子表内每一个算子
    for (int op = start_op; op < start_op + n_ops; op++) {
        // 从DDR读取当前算子完整描述符到数组d
        for (int i = 0; i < HW_DESC_WORDS; i++) {
#pragma HLS PIPELINE II=1
            d[i] = p_tbl[op * HW_DESC_WORDS + i];
        }
        // 解析描述符各个字段，拆分偏移、尺寸、通道、卷积参数、算子类型
        int32_t src_off = d[0], dst_off = d[1], wgt_off = d[2], rq_off = d[3];
        int32_t add_off = d[4], add_ch_off = d[5];
        int ih      = d[7]  & 0xFFFF, iw = (d[7]  >> 16) & 0xFFFF;
        int oh      = d[8]  & 0xFFFF, ow = (d[8]  >> 16) & 0xFFFF;
        int ic      = d[9]  & 0xFFFF, oc = (d[9]  >> 16) & 0xFFFF;
        int oc_real = d[10] & 0xFFFF, src_ch_off = (d[10] >> 16) & 0xFFFF;
        int dst_ch_off = d[11] & 0xFFFF, tile_r = (d[11] >> 16) & 0xFFFF;
        int tile_c  = d[12] & 0xFFFF;
        int kk      = (d[12] >> 16) & 0xFF, ss = (d[12] >> 24) & 0xFF;
        int pad     = d[13] & 0xFF;
        int act     = (d[13] >> 8)  & 0xFF;
        int up      = (d[13] >> 16) & 0xFF;
        int typ     = (d[13] >> 24) & 0xFF;

        /* ---- 防御 2：非法描述符直接跳过，绝不拿去执行 ----
           下面每条都是"违反了硬件隐含约定"的情况。硬件不会报错，
           只会安静地算出垃圾、并写进 DDR（可能还写到 arena 外面）。
           宁可跳过这个算子，也不要带着非法参数跑。 */
        {
            int bad = 0;
            /* c4_index() 只在通道偏移是 4 的倍数时才等价于"从第 c/4 组开始"，
               否则读出来的 32 位字里装的是隔壁通道，4 个 lane 全部错位 */
            if (((src_ch_off | dst_ch_off) & 3) != 0)          bad = 1;
            if (add_off >= 0 && ((add_ch_off & 3) != 0))       bad = 1;
            if (typ == LT_CONV) {
                /* 乘法器阵列是 CO 路并行、c4 打包是 CI 通道一组，
                   所以 ic 必须是 CI 的倍数、oc 必须是 CO 的倍数 */
                if ((ic % CI) != 0 || (oc % CO) != 0)          bad = 1;
            } else if (typ == LT_MAXPOOL) {
                /* pool_op 只实现了 3x3 / stride1 / pad1 这一种（SPPF 专用），
                   描述符里的 k/s/pad 它根本不看 —— 参数一变就会静默算错 */
                if (!(kk == 3 && ss == 1 && pad == 1))         bad = 1;
            } else if (typ == LT_COPY) {
                if (up != 1 && up != 2)                        bad = 1;
            } else {
                bad = 1;                                        /* 未知算子类型 */
            }
            if (bad) {
                continue;
            }
        }

        // 根据算子类型，分发到对应的硬件算子函数
        if (typ == LT_CONV) {
            conv_kernel(p_act, p_wgt, p_rqt, src_off, dst_off, wgt_off, rq_off, add_off,
                        src_ch_off, add_ch_off, dst_ch_off,
                        ih, iw, ic, oh, ow, oc, oc_real, kk, ss, pad, act,
                        tile_r, tile_c, ifm_buf);
        } else if (typ == LT_MAXPOOL) {
            pool_op(p_act, src_off, dst_off, src_ch_off, dst_ch_off, ic,
                    ih, iw, tile_r, tile_c, ifm_buf);
        } else {
            // R3改动#3：copy_op 现在需要 tile_r/tile_c 参数（两步法按tile分块，
            copy_op(p_act, src_off, dst_off, src_ch_off, dst_ch_off, ic,
                    ih, iw, up, tile_r, tile_c, ifm_buf);
        }
        }
    }
/* 交接说明 函数 yolov5n_top 结束后
 * 函数yolov5n_top属于HLS计算及数据流。包含HLS流水线指示，修改循环边界后必须复核II与启动开销。本次交接只新增说明，不改变活动语句。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */

/*
 * 最终版交接说明 2026年10月27日
 * 文件角色：HLS计算及数据流
 * 本文件活动代码对应已验证R6.6 IP1.16 COLOR_AWB，交接阶段不增加算法。
 * 依赖：HLS2020.2或Vitis2020.2，具体目录和构建顺序见根目录上板运行操作步骤。
 * 修改要求：保持C4布局、64B描述符、量化截断顺序、双核共享内存和缓冲所有权。
 * 删除/替换记录：下方仅在确有前驱差异时保存禁用旧代码；不虚构曾删除的代码。
 */

#if 0 /* 已删除或替换代码的交接存档，禁止参与编译 */
// 下面为真实前驱差异：减号行已被替换或删除，加号行为当前实现。
// --- C:\Users\Lenovo\Desktop\yolov5n_speed_prj\yolov5n_speed_prj\submission_2026\src\baseline_r6_4\yolov5n_top.cpp
// 
// +++ C:\Users\Lenovo\Desktop\yolov5n_speed_prj\yolov5n_speed_prj\01_hls\FINAL_R66_20261027\src\yolov5n_top.cpp
// 
// @@ -178,12 +178,13 @@
// 
//   *         M[oc] = sw[oc]*sx/sy 存成 {mq, shift}，偏置存成整数 bi
//   *         —— PC 端 quantize.py 离线算好，IP 只管用。
//   *         换量化方案不用重新综合 IP。
//   */
//  #include <ap_int.h>
//  #include "yolov5n_hls.h"
// +#include "axi64_native_io.h"
//  #define CO  HW_CO   // 单次并行输出通道数，你的工程设为16
//  #define CI  HW_CI   // 单次并行输入通道数，你的工程设为4
//  #define NX  HW_NX   // 单次并行空间像素数量
//  #if HW_CI != 4
//  #error R5_dot4_requires_the_existing_c4_layout
//  #endif
// @@ -306,50 +307,51 @@
// 
//          for (int tr = 0; tr < oh; tr += tile_r) {
//              for (int tc = 0; tc < ow; tc += tile_c) {
//                  int nr = (tr + tile_r <= oh) ? tile_r : (oh - tr);
//                  int nc = (tc + tile_c <= ow) ? tile_c : (ow - tc);
//  
//                  // 源tile尺寸：up=2时输出是输入的2倍，源尺寸是输出的一半（向上取整，
// -                int src_nr = (nr + up - 1) / up;
// -                int src_nc = (nc + up - 1) / up;
// -                int src_tr = tr / up;   // 输出tile起始坐标对应的源坐标
// -                int src_tc = tc / up;
// +                int src_nr = (up == 2 ? (nr + 1) >> 1 : nr);
// +                int src_nc = (up == 2 ? (nc + 1) >> 1 : nc);
// +                int src_tr = (up == 2 ? tr >> 1 : tr);   // 输出tile起始坐标对应的源坐标
// +                int src_tc = (up == 2 ? tc >> 1 : tc);
//  
//                  /* ---- 第一步：把源tile从DDR读到片上ifm_buf（只有DDR读，II=1） ----
//                   * 这一步和 conv 的 staging 循环完全同构：只有 m_axi 读，
//                   * 综合报告已证明纯读循环能跑到 II achieved = 1。
//                   * ★ LUT优化：去掉边界检查（sr<ih && sc<iw）。
//                   *   描述符里tile_r/tile_c=16，所有特征图尺寸都是16的倍数（
//                   *   up=2时输出=输入×2也都是16倍数，tile不会越界。
//                   *   去掉比较器和mux，降低LUT。 */
//                  for (int r = 0; r < src_nr; r++) {
// -                    for (int c = 0; c < src_nc; c++) {
// -#pragma HLS PIPELINE II=1
// -                        int sr = src_tr + r;
// -                        int sc = src_tc + c;
// -                        // 直接读DDR（tile对齐不越界，无需边界检查）
// -                        uint32_t v = *(const uint32_t *)(p_act + src_off
// -                                     + c4_index(src_ch_off + (g << 2), sr, sc, ih, iw));
// -                        ifm_buf[r * src_nc + c] = v;
// -                    }
// +                    const int first = (src_off + c4_index(src_ch_off + (g << 2),
// +                                       src_tr + r, src_tc, ih, iw)) >> 2;
// +                    axi64_read_words<HW_IFM_WORDS>(p_act, first, ifm_buf,
// +                                                  r * src_nc, src_nc);
//                  }
//  
//                  /* ---- 第二步：从片上ifm_buf写回DDR（只有DDR写，II=1） ----
//                   * up=1：1个源像素→1个输出像素（sy=y, sx=x，
//                   * up=2：1个源像素→2×2=4个输出像素（最近邻，sy=y/2, sx=x/2，
//                   * 这一步和 conv 的写回循环完全同构：只有 m_axi 写，II=1。
//                   * 原来 up=2 的四次写里有两处相隔整整一行，现在按输出坐标顺序写，
//                   * 地址沿w方向连续，可以凑burst。 */
// +                uint32_t line[HW_ROW_PIXELS];
// +#pragma HLS BIND_STORAGE variable=line type=ram_2p impl=bram
//                  for (int y = 0; y < nr; y++) {
// -                    for (int x = 0; x < nc; x++) {
// +                    for (int chunk = 0; chunk < nc; chunk += HW_ROW_PIXELS) {
// +                        const int n = nc - chunk < HW_ROW_PIXELS ? nc - chunk : HW_ROW_PIXELS;
// +                        const int sy = up == 2 ? y >> 1 : y;
// +                        for (int x = 0; x < n; x++) {
//  #pragma HLS PIPELINE II=1
// -                        int sy = y / up;  // up=1: sy=y; up=2: sy=y/2（最近邻，
// -                        int sx = x / up;
// -                        uint32_t v = ifm_buf[sy * src_nc + sx];
// -                        *(uint32_t *)(p_act + dst_off + c4_index(
// -                            dst_ch_off + (g << 2), tr + y, tc + x, oh, ow)) = v;
// +                            const int sx = up == 2 ? (chunk + x) >> 1 : chunk + x;
// +                            line[x] = ifm_buf[sy * src_nc + sx];
// +                        }
// +                        const int first = (dst_off + c4_index(dst_ch_off + (g << 2),
// +                                           tr + y, tc + chunk, oh, ow)) >> 2;
// +                        axi64_write_line(p_act, first, line, n);
//                      }
//                  }
//              }
//          }
//      }
//  }
// @@ -386,26 +388,38 @@
// 
//                  // 第一步：把包含halo的窗口从DDR读到片上ifm_buf
//                  for (int r = 0; r < rows; r++) {
//                      int sr = r0 + r;
//                      int inrow = (sr >= 0) && (sr < ih); // 判断是否越界，越界填充int8最小值
//                      for (int c = 0; c < cols; c++) {
//  #pragma HLS PIPELINE II=1
// -                        int sc = c0 + c;
// -                        uint32_t v = 0x80808080u;      /* int8最小值，不会参与max比较 */
// -                        if (inrow && sc >= 0 && sc < iw)
// -                            v = *(const uint32_t *)(p_act + src_off
// -                                 + c4_index(src_ch_off + (g << 2), sr, sc, ih, iw));
// -                        ifm_buf[r * cols + c] = v;
// +                        ifm_buf[r * cols + c] = 0x80808080u;
// +                    }
// +                    if (inrow) {
// +                        int begin = c0 < 0 ? -c0 : 0;
// +                        if (begin > cols) begin = cols;
// +                        int end = iw - c0;
// +                        if (end > cols) end = cols;
// +                        if (end < begin) end = begin;
// +                        if (end > begin) {
// +                            const int first = (src_off + c4_index(src_ch_off + (g << 2),
// +                                               sr, c0 + begin, ih, iw)) >> 2;
// +                            axi64_read_words<HW_IFM_WORDS>(p_act, first, ifm_buf,
// +                                                          r * cols + begin, end - begin);
// +                        }
//                      }
//                  }
//                  // 第二步：片上ifm_buf滑动窗口做3×3最大值池化
// +                uint32_t line[HW_ROW_PIXELS];
// +#pragma HLS BIND_STORAGE variable=line type=ram_2p impl=bram
//                  for (int y = 0; y < nr; y++) {
// -                    for (int x = 0; x < nc; x++) {
// +                    for (int chunk = 0; chunk < nc; chunk += HW_ROW_PIXELS) {
// +                        const int n = nc - chunk < HW_ROW_PIXELS ? nc - chunk : HW_ROW_PIXELS;
// +                        for (int x = 0; x < n; x++) {
//  #pragma HLS PIPELINE II=1
//                          uint32_t mx = 0x80808080u;
// -                        int base = y * cols + x;
// +                        int base = y * cols + chunk + x;
//                          // 3×3卷积核循环，完全展开unroll
//                          for (int ky = 0; ky < 3; ky++) {
//  #pragma HLS UNROLL
//                              for (int kx = 0; kx < 3; kx++) {
//  #pragma HLS UNROLL
//                                  uint32_t v = ifm_buf[base + ky * cols + kx];
// @@ -416,41 +430,25 @@
// 
//                                      int8_t b = (int8_t)((v  >> (ci * 8)) & 0xFF);
//                                      if (b > a) mx = (mx & ~(0xFFu << (ci * 8)))
//                                                    | ((uint32_t)(uint8_t)b << (ci * 8));
//                                  }
//                              }
//                          }
// -                        // 池化结果写回DDR
// -                        *(uint32_t *)(p_act + dst_off + c4_index(dst_ch_off + (g << 2),
// -                                       tr + y, tc + x, oh, ow)) = mx;
// +                        line[x] = mx;
// +                        }
// +                        const int first = (dst_off + c4_index(dst_ch_off + (g << 2),
// +                                           tr + y, tc + chunk, oh, ow)) >> 2;
// +                        axi64_write_line(p_act, first, line, n);
//                      }
//                  }
//              }
//          }
//      }
//  }
//  
//  /* ------------------------------------------------------------------- conv */
// -/* R6.1 修改：R5只有调用级计时；现在在关键阶段写出事件供ILA观测。
// - * 编码为 (op << 8) | phase，例如0x4307表示op67进入MAC。
// - * 每个输出valid有效沿都要采样；相邻事件的外部计数器差才是周期数。
// - * 标记不写DDR、不改量化运算；新增接口的BD接法见头文件及R6记录。
// - */
// -/* Volatile keeps intermediate events in RTL. ap_ovld has no receiver ready/
// - * acknowledge, so the monitor cannot stall the accelerator. This is a phase
// - * boundary event, NOT a cycle counter or an AXI transaction completion fence.
// - */
// -static void profile_mark(volatile uint16_t *profile_event, int op,
// -                         hls_profile_phase phase)
// -{
// -#pragma HLS INLINE
// -    // Native volatile retains EVERY event in HLS 2020.2. ap_ovld gives the
// -    // inferred, unused input half ap_none semantics (no valid/ready wait).
// -    *profile_event = (uint16_t)(((op & 0xff) << 8) | (int)phase);
// -}
// -
//  /**
//   * @brief Conv算子：支持动态1×1 /3×3卷积，stride/pad可配置；支持残差add、LeakyReLU激活、INT8重量化
//   * @param p_act DDR特征图基地址
//   * @param p_wgt DDR权重基地址（int8 c4打包，
//   * @param p_rqt DDR重量化参数(mq,shift,bias)
//   * @param src_off 输入特征偏移
// @@ -471,62 +469,54 @@
// 
//   * @param act 激活类型 ACT_LEAKY or NO_ACT
//   * @param tile_r tile_c 空间分块大小
//   * 设计亮点：运行时动态kk，不需要模板；只生成一套乘法阵列，避免综合两套卷积硬件造成LUT爆炸
//   */
//  // R6.3 / 9.xsa：调度实现独立成头文件，保留顶层接口和Pool/Copy。
//  // R6.4 / 10.xsa：1×1行级流调度；普通卷积仍走R6.3兼容路径。
// -#include "yolov5n_r6_4_schedule.h"
// +#include "yolov5n_r6_5_schedule.h"
//  
//  /* -------------------------------------------------------------------- top */
//  /**
//   * @brief 加速器顶层函数，PL IP入口
//   * 读取DDR算子描述符表，循环调度Conv/Pool/Copy三类算子；
//   * AXI4-Master接口访问DDR特征图、权重、量化参数；AXI-Lite寄存器由PS控制启停
//   * @param p_act 特征图DDR地址
//   * @param p_wgt 权重DDR地址
//   * @param p_rqt 重量化参数DDR地址
//   * @param p_tbl 算子描述符表DDR地址
//   * @param start_op 起始算子序号
// - * @param n_ops 需要执行算子数量
// - * @param profile_event R6.1阶段事件，接收端按输出valid采样，详见R6.1记录
// - */
// + * @param n_ops 需要执行算子数量 */
//  void yolov5n_top(const int8_t  *p_act,
//                   const int8_t  *p_wgt,
//                   const int32_t *p_rqt,
//                   const int32_t *p_tbl,
//                   int start_op,
// -                 int n_ops,
// -                 volatile uint16_t *profile_event)
// -{
// -// R6.1 修改：追加观测端口，不增加AXI-Lite寄存器，也不需要Vitis写事件。
// -// BD中输入半口接16位常量0；输出事件和valid接同ap_clk下的ILA。
// -#pragma HLS INTERFACE ap_ovld port=profile_event
// +                 int n_ops)
// +{
//  // AXI Master接口配置，全部挂在gmem总线；设置burst长度、 outstanding，提升DDR带宽
// -#pragma HLS INTERFACE m_axi port=p_act bundle=gmem depth=2097152 offset=slave \
// -    num_read_outstanding=16 num_write_outstanding=16 max_read_burst_length=128 max_write_burst_length=128
// -#pragma HLS INTERFACE m_axi port=p_wgt bundle=gmem depth=262144  offset=slave \
// -    num_read_outstanding=16 num_write_outstanding=16 max_read_burst_length=128 max_write_burst_length=128
// -#pragma HLS INTERFACE m_axi port=p_rqt bundle=gmem depth=16384   offset=slave \
// -    num_read_outstanding=16 num_write_outstanding=16 max_read_burst_length=128 max_write_burst_length=128
// -#pragma HLS INTERFACE m_axi port=p_tbl bundle=gmem depth=16384   offset=slave \
// -    num_read_outstanding=16 num_write_outstanding=16 max_read_burst_length=128 max_write_burst_length=128
// +#pragma HLS INTERFACE m_axi port=p_act bundle=gmem depth=2097152 offset=slave max_widen_bitwidth=64 \
// +    num_read_outstanding=4 num_write_outstanding=4 max_read_burst_length=16 max_write_burst_length=16
// +#pragma HLS INTERFACE m_axi port=p_wgt bundle=gmem depth=262144  offset=slave max_widen_bitwidth=64 \
// +    num_read_outstanding=4 num_write_outstanding=4 max_read_burst_length=16 max_write_burst_length=16
// +#pragma HLS INTERFACE m_axi port=p_rqt bundle=gmem depth=16384   offset=slave max_widen_bitwidth=64 \
// +    num_read_outstanding=4 num_write_outstanding=4 max_read_burst_length=16 max_write_burst_length=16
// +#pragma HLS INTERFACE m_axi port=p_tbl bundle=gmem depth=16384   offset=slave max_widen_bitwidth=64 \
// +    num_read_outstanding=4 num_write_outstanding=4 max_read_burst_length=16 max_write_burst_length=16
//  // AXI-Lite从接口，PS ARM通过该寄存器控制IP，传递函数入参
//  #pragma HLS INTERFACE s_axilite port=p_act    bundle=control
//  #pragma HLS INTERFACE s_axilite port=p_wgt    bundle=control
//  #pragma HLS INTERFACE s_axilite port=p_rqt    bundle=control
//  #pragma HLS INTERFACE s_axilite port=p_tbl    bundle=control
//  #pragma HLS INTERFACE s_axilite port=start_op bundle=control
//  #pragma HLS INTERFACE s_axilite port=n_ops    bundle=control
//  #pragma HLS INTERFACE s_axilite port=return   bundle=control
//  
//      // R6.3：内部共享缓存，不是新增顶层参数或软件寄存器。
//      // Pool/Copy仅改内部传参，原数据访问、运算和tile策略保留。
//      uint32_t ifm_buf[HW_IFM_WORDS];
// -#pragma HLS BIND_STORAGE variable=ifm_buf type=ram_2p impl=bram
// -
// -    profile_mark(profile_event, 0xff, HLS_PHASE_CALL_BEGIN);
// +#pragma HLS BIND_STORAGE variable=ifm_buf type=ram_t2p impl=bram
//  
//      /* ---- 防御 1：把 start_op / n_ops 夹进描述符表范围内 ----
//         表只有 HW_N_OPS = 84 条。start_op / n_ops 是留给"逐层调试"的入参
//         （PS 端 Set_start_op() / Set_n_ops()），是人手填的。
//         一旦 start_op + n_ops 越过表尾，下面就会把 yolo_layers[] 后面的
//         .rodata 当成描述符执行 —— oh/ow/ic/oc 全是随机值，轻则跑很久，
// @@ -538,13 +528,12 @@
// 
//  
//      int32_t d[HW_DESC_WORDS]; // 存放单个算子描述符
//  #pragma HLS ARRAY_PARTITION variable=d complete // 数组完全拆分，并行读取描述符字段
//  
//      // 循环依次执行算子表内每一个算子
//      for (int op = start_op; op < start_op + n_ops; op++) {
// -        profile_mark(profile_event, op, HLS_PHASE_DESCRIPTOR);
//          // 从DDR读取当前算子完整描述符到数组d
//          for (int i = 0; i < HW_DESC_WORDS; i++) {
//  #pragma HLS PIPELINE II=1
//              d[i] = p_tbl[op * HW_DESC_WORDS + i];
//          }
//          // 解析描述符各个字段，拆分偏移、尺寸、通道、卷积参数、算子类型
// @@ -559,13 +548,12 @@
// 
//          int kk      = (d[12] >> 16) & 0xFF, ss = (d[12] >> 24) & 0xFF;
//          int pad     = d[13] & 0xFF;
//          int act     = (d[13] >> 8)  & 0xFF;
//          int up      = (d[13] >> 16) & 0xFF;
//          int typ     = (d[13] >> 24) & 0xFF;
//  
// -        profile_mark(profile_event, op, HLS_PHASE_DISPATCH);
//          /* ---- 防御 2：非法描述符直接跳过，绝不拿去执行 ----
//             下面每条都是"违反了硬件隐含约定"的情况。硬件不会报错，
//             只会安静地算出垃圾、并写进 DDR（可能还写到 arena 外面）。
//             宁可跳过这个算子，也不要带着非法参数跑。 */
//          {
//              int bad = 0;
// @@ -584,32 +572,26 @@
// 
//              } else if (typ == LT_COPY) {
//                  if (up != 1 && up != 2)                        bad = 1;
//              } else {
//                  bad = 1;                                        /* 未知算子类型 */
//              }
//              if (bad) {
// -                profile_mark(profile_event, op, HLS_PHASE_INVALID);
// -                profile_mark(profile_event, op, HLS_PHASE_OP_END);
//                  continue;
//              }
//          }
//  
//          // 根据算子类型，分发到对应的硬件算子函数
//          if (typ == LT_CONV) {
//              conv_kernel(p_act, p_wgt, p_rqt, src_off, dst_off, wgt_off, rq_off, add_off,
//                          src_ch_off, add_ch_off, dst_ch_off,
//                          ih, iw, ic, oh, ow, oc, oc_real, kk, ss, pad, act,
// -                        tile_r, tile_c, op, profile_event, ifm_buf);
// +                        tile_r, tile_c, ifm_buf);
//          } else if (typ == LT_MAXPOOL) {
// -            profile_mark(profile_event, op, HLS_PHASE_POOL);
//              pool_op(p_act, src_off, dst_off, src_ch_off, dst_ch_off, ic,
//                      ih, iw, tile_r, tile_c, ifm_buf);
//          } else {
// -            profile_mark(profile_event, op, HLS_PHASE_COPY);
//              // R3改动#3：copy_op 现在需要 tile_r/tile_c 参数（两步法按tile分块，
//              copy_op(p_act, src_off, dst_off, src_ch_off, dst_ch_off, ic,
//                      ih, iw, up, tile_r, tile_c, ifm_buf);
//          }
// -        profile_mark(profile_event, op, HLS_PHASE_OP_END);
// +        }
//      }
// -    profile_mark(profile_event, 0xff, HLS_PHASE_CALL_END);
// -}
#endif

/* 交接补充
 * 本次仅补充中文职责和历史替换说明；活动表达式、寄存器、延时和默认返回值均保留。未删除的历史代码不伪造删除块。
 */
