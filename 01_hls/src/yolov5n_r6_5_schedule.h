/* R6.4 / 10.xsa：在R6.3基础上增加1×1行级流调度和读写配对。
 * R6.4 compute schedule.
 * 不增加m_axi/AXI-Lite端口，不改变C4、描述符或量化的数值顺序。
 * 常规1x1/s1/pad0/无残差路径按输出行处理，其他形状保留原分步路径。
 * 仍使用同一个MAC任务和同一处dot4表达式，不复制1x1/3x3乘法阵列。
 */
#ifndef YOLOV5N_R6_4_SCHEDULE_H
#define YOLOV5N_R6_4_SCHEDULE_H
#include <hls_stream.h>
#ifndef __SYNTHESIS__
#include <assert.h>
#endif

// Quantization already casts every completed sum to signed26 before multiplication.
// Addition modulo2^26 commutes with that final truncation, including bias/overflow.
// Keep the model/AXI/descriptor ABI unchanged; only internal storage is narrower.
typedef ap_int<26> r65_accum_t;
typedef ap_uint<HW_CO * 26> r64_acc_packet;

struct r64_tile {
    int tr, tc, nr, nc, rows, cols, r0, c0;
    bool valid;
};
struct r64_block {
    int y, x0, ob, nxx, nwoc;
    bool valid, row_last;
};
struct r64_config {
    int src_off, dst_off, add_off;
    int src_ch_off, dst_ch_off, add_ch_off;
    int ih, iw, oh, ow, icb, ocb, oc_real;
    int kk, ss, pad, act;
};

// R6.4：只对输入/输出同尺寸且无残差的标准pointwise启用快路径。
// 当前模型43条1×1均满足；非标准描述符保留R6.3语义和原地残差安全性。
static bool r64_pointwise(const r64_config c) {
#pragma HLS INLINE
    return c.kk == 1 && c.ss == 1 && c.pad == 0 && c.add_off < 0
        && c.ih == c.oh && c.iw == c.ow;
}
/* 交接说明 函数 r64_pointwise 结束后
 * 检查1x1快路径的形状前提：stride1、pad0、无残差且尺寸一致；不满足的描述符回退到普通路径，避免误加速改变数值。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */

static r64_tile r64_make_tile(int tr, int tc, int tile_r, int tile_c,
                            const r64_config c) {
#pragma HLS INLINE
    r64_tile t;
    t.tr = tr; t.tc = tc;
    t.valid = tr < c.oh;
    t.nr = (tr + tile_r <= c.oh) ? tile_r : c.oh - tr;
    t.nc = (tc + tile_c <= c.ow) ? tile_c : c.ow - tc;
    t.rows = (t.nr - 1) * c.ss + c.kk;
    t.cols = (t.nc - 1) * c.ss + c.kk;
    t.r0 = tr * c.ss - c.pad;
    t.c0 = tc * c.ss - c.pad;
    return t;
}
/* 交接说明 函数 r64_make_tile 结束后
 * 根据输出tr/tc和tile边界算出真实nr/nc、输入窗口rows/cols及padding偏移；最后一个不满tile必须用真实长度，防止越界与错误halo。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */

static r64_block r64_make_block(int y, int x0, int ob,
                                const r64_tile t, const r64_config c) {
#pragma HLS INLINE
    r64_block b;
    b.y = y; b.x0 = x0; b.ob = ob;
    b.valid = y < t.nr;
    b.nxx = (x0 + HW_NX <= t.nc) ? HW_NX : t.nc - x0;
    b.nwoc = c.oc_real > ob * HW_CO
           ? (c.oc_real - ob * HW_CO + 3) >> 2 : 0;
    if (b.nwoc > HW_CO / HW_CI) b.nwoc = HW_CO / HW_CI;
    b.row_last = b.valid && ob + 1 == c.ocb && x0 + HW_NX >= t.nc;
    return b;
}
/* 交接说明 函数 r64_make_block 结束后
 * 计算每个空间块和输出通道组的有效宽度、要写回的C4组数及row_last；只在完整输出行结束时触发行写回。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */

// R6.4：读/写方向各一个进程，分别保留单调连续访问，才能推断行burst。
// 直接在同一x循环混合读写虽然能II=1，却会丢失本工具的自动burst推断。
static void r64_pair_read(const int8_t *p_act, uint32_t input[HW_IFM_WORDS],
                          int src_off, int read_base, int ibase, int count) {
#pragma HLS INLINE off
    axi64_read_words<HW_IFM_WORDS>(p_act, (src_off >> 2) + read_base,
                                  input, ibase, count);
}
/* 交接说明 函数 r64_pair_read 结束后
 * 保持单调连续输入地址的读任务，交给原生AXI64辅助函数处理对齐头尾；独立任务有利于burst推断。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */
static void r64_pair_write(const int8_t *p_act,
                           const uint32_t output[HW_MAX_OC / HW_CI][HW_ROW_PIXELS],
                           int dst_off, int base, int q, int count) {
#pragma HLS INLINE off
    axi64_write_row(p_act, (dst_off >> 2) + base, output, q, count);
}
/* 交接说明 函数 r64_pair_write 结束后
 * 将完成的输出行按连续地址写回，和pair_read在安全不重叠时并发；不可提前复用尚未写完的row缓冲。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */
static void r64_pair_rows(const int8_t *p_act, uint32_t input[HW_IFM_WORDS],
                          const uint32_t output[HW_MAX_OC / HW_CI][HW_ROW_PIXELS],
                          int src_off, int read_base, int ibase,
                          int dst_off, int base, int q, int count) {
#pragma HLS INLINE off
#pragma HLS DATAFLOW
#pragma HLS STABLE variable=output
    r64_pair_read(p_act, input, src_off, read_base, ibase, count);
    r64_pair_write(p_act, output, dst_off, base, q, count);
}
/* 交接说明 函数 r64_pair_rows 结束后
 * 对不重叠的连续行进行DATAFLOW读写配对；读写分为独立循环以保持burst推断，不在同一小循环混杂指针操作。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */

/* R6.3 改动1：只有本任务访问p_act，避免DATAFLOW任务争用同一个gmem。
 * 一个调度步内：写已完成的旧行、读取当前块残差、预取下一tile若干输入行。
 * 残差与当前MAC同时准备，下一步的量化才使用它，避免同一步读写依赖。
 * 每次返回就是缓冲交接屏障，不能在未完成时交换IFM/acc/row的所有权。
 */
static void r64_memory(const int8_t *p_act, uint32_t next_ifm[HW_IFM_WORDS],
                       uint32_t halo[HW_R63_HALO_WORDS],
                       uint32_t residual[HW_NX][HW_CO / HW_CI],
                       const uint32_t output[HW_MAX_OC / HW_CI][HW_ROW_PIXELS],
                       const r64_config c, const r64_tile current,
                       const r64_tile next, const r64_block compute,
                       const r64_block store, int quota, bool reuse,
                       int &load_g, int &load_r) {
#pragma HLS INLINE off
    const uint32_t *src = (const uint32_t *)(p_act + c.src_off);
    uint32_t *dst = (uint32_t *)(p_act + c.dst_off);
    int paired = 0;
    if (store.valid && store.row_last) {
        const int groups = (c.oc_real + 3) >> 2;
        for (int q = 0; q < groups; ++q) {
            const int base = ((c.dst_ch_off >> 2) + q) * c.oh * c.ow
                           + (current.tr + store.y) * c.ow + current.tc;
            const int read_base = ((c.src_ch_off >> 2) + load_g) * c.ih * c.iw
                                + (next.r0 + load_r) * c.iw + next.c0;
            const int read_first = (c.src_off >> 2) + read_base;
            const int write_first = (c.dst_off >> 2) + base;
            const bool disjoint = read_first + current.nc <= write_first
                               || write_first + current.nc <= read_first;
            // R6.4：同宽1×1的下一输入行与旧输出行配对执行各自连续x循环。
            // AXI读/写通道可并行，避免先整行写完再开始读；仍只有memory访问DDR。
            // 尾tile宽度不同、没有后继tile或配额用完时，沿用独立写回。
            if (r64_pointwise(c) && next.valid && next.cols == current.nc
                && paired < quota && load_g < c.icb && disjoint) {
                const int ibase = load_g * next.rows * next.cols + load_r * next.cols;
                r64_pair_rows(p_act, next_ifm, output, c.src_off, read_base, ibase,
                              c.dst_off, base, q, current.nc);
                ++paired;
                ++load_r;
                if (load_r == next.rows) { load_r = 0; ++load_g; }
            } else {
                axi64_write_row(p_act, (c.dst_off >> 2) + base,
                                 output, q, current.nc);
            }
        }
    }
    if (compute.valid && c.add_off >= 0) {
        // 无残差时add_off=-1，不构造越过arena起点的无效指针。
        // Burst into a small dual-port RAM first. Only one scatter assignment
        // writes the fully-partitioned residual bank, avoiding a multi-write mux.
        uint32_t residual_words[HW_NX * (HW_CO / HW_CI)];
#pragma HLS BIND_STORAGE variable=residual_words type=ram_t2p impl=bram
        for (int q = 0; q < compute.nwoc; ++q) {
            const int base = ((c.add_ch_off >> 2) + compute.ob * (HW_CO / HW_CI) + q)
                           * c.oh * c.ow + (current.tr + compute.y) * c.ow
                           + current.tc + compute.x0;
            axi64_read_words<HW_NX * (HW_CO / HW_CI)>(
                p_act, (c.add_off >> 2) + base, residual_words, q * HW_NX, compute.nxx);
        }
        for (int q = 0; q < compute.nwoc; ++q) {
        R65_RESBUF_SCATTER:
            for (int x = 0; x < compute.nxx; ++x) {
#pragma HLS PIPELINE II=1
#pragma HLS LOOP_FLATTEN
                residual[x][q] = residual_words[q * HW_NX + x];
            }
        }
    }

    const int overlap = c.kk > c.ss ? c.kk - c.ss : 0;
    const bool cache_ok = overlap > 0 && overlap <= 2
                       && c.icb * next.rows * overlap <= HW_R63_HALO_WORDS;
    // 配对读已经消耗的额度不重复加载；load_g/load_r保持唯一输入游标。
    for (int j = paired; j < quota; ++j) {
        if (next.valid && load_g < c.icb) {
            const int sr = next.r0 + load_r;
            const int base = load_g * next.rows * next.cols + load_r * next.cols;
            const int cache_base = (load_g * next.rows + load_r) * overlap;
            int first = next.c0 < 0 ? -next.c0 : 0;
            if (first > next.cols) first = next.cols;
            int end = c.iw - next.c0;
            if (end < first) end = first;
            if (end > next.cols) end = next.cols;
            // R6.3 改动3：旧tile最右overlap列就是新tile最左overlap列。
            // 先读旧halo，再更新本行halo；新tr/容量不足时不复用。
            const int kept = reuse && cache_ok ? overlap : 0;
            for (int x = 0; x < kept; ++x) {
#pragma HLS PIPELINE II=1
                next_ifm[base + x] = halo[cache_base + x];
            }
            if (sr < 0 || sr >= c.ih) {
                for (int x = kept; x < next.cols; ++x) {
#pragma HLS PIPELINE II=1
                    next_ifm[base + x] = 0;
                }
            } else {
                for (int x = kept; x < first; ++x) {
#pragma HLS PIPELINE II=1
                    next_ifm[base + x] = 0;
                }
                const int start = first > kept ? first : kept;
                const int read_base = ((c.src_ch_off >> 2) + load_g) * c.ih * c.iw
                                    + sr * c.iw + next.c0;
                axi64_read_words<HW_IFM_WORDS>(p_act, (c.src_off >> 2) + read_base + start,
                                              next_ifm, base + start, end - start);
                const int right = end > kept ? end : kept;
                for (int x = right; x < next.cols; ++x) {
#pragma HLS PIPELINE II=1
                    next_ifm[base + x] = 0;
                }
            }
            if (cache_ok) {
                for (int x = 0; x < overlap; ++x) {
#pragma HLS PIPELINE II=1
                    halo[cache_base + x] = next_ifm[base + next.cols - overlap + x];
                }
            }
            ++load_r;
            if (load_r == next.rows) { load_r = 0; ++load_g; }
        }
    }
}
/* 交接说明 函数 r64_memory 结束后
 * 唯一DDR调度任务。负责旧输出回写、当前残差读取和下一tile预取；残差先落真双口BRAM再scatter，避免直接多写bank的LUT爆炸。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */

/* R6.3 改动1：MAC只访问当前IFM与本步acc；量化使用另一套acc。
 * 保留R6.2的ib/ky/kx/nx顺序、定长NX和dot4数值表达式。
 */
// R6.6: exact two signed INT8 products with a shared activation in one25x8 DSP.
// Low weight is unsigned-packed; explicitly correct its sign and high borrow.
static void r66_mul_pair(ap_int<8> x, ap_int<8> w0, ap_int<8> w1,
                         ap_int<16> &p0, ap_int<16> &p1) {
#pragma HLS INLINE
    ap_int<25> joined = 0;
    joined.range(24,17) = (ap_uint<8>)w1;
    joined.range(7,0) = (ap_uint<8>)w0;
    ap_int<33> product = joined * x;
#pragma HLS BIND_OP variable=product op=mul impl=dsp latency=3
    const ap_int<17> low = (ap_int<17>)product.range(16,0);
    const ap_int<17> signfix = w0 < 0 ? ((ap_int<17>)x << 8) : (ap_int<17>)0;
    p0 = (ap_int<16>)(low - signfix);
    p1 = (ap_int<16>)((product >> 17) + (low < 0 ? 1 : 0));
}
/* 交接说明 函数 r66_mul_pair 结束后
 * 新增精确双INT8共享激活乘法。把w1放在bit17以上、w0按无符号低8位打包，以符号修正和高位借位修正分别还原两个16位乘积。不是近似乘法；参见报告推导与RTL证明。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */
// Isolated allocation study: place useful accumulation/reduction adds in spareDSPs.
// Target45usefuladders: previous43variantactually218DSP after optimization; add2realreductions then reverify220.
#define R66_DSP_ACC_CHANNELS 16
#define R66_DSP_DOT_CHANNELS 16
#define R66_DSP_GROUP_CHANNELS 13
static ap_int<26> r66_acc26_dsp(ap_int<26> a, ap_int<26> b) {
#pragma HLS INLINE
    ap_int<26> sum = a + b;
#pragma HLS BIND_OP variable=sum op=add impl=dsp latency=0
    return sum;
}
/* 交接说明 函数 r66_acc26_dsp 结束后
 * 将真实26位累加加法绑定DSP，结果仍按模2^26解释；实际资源必须看最终Vivado报告，不能拿绑定意图当220已占满。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */
static int32_t r66_add32_dsp(int32_t a, int32_t b) {
#pragma HLS INLINE
    ap_int<32> sum = (ap_int<32>)a + (ap_int<32>)b;
#pragma HLS BIND_OP variable=sum op=add impl=dsp latency=0
    return (int32_t)sum;
}
/* 交接说明 函数 r66_add32_dsp 结束后
 * 把真实32位部分和归约绑定DSP；为节约LUT与布线而做，不额外添加无用运算。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */
// Keep this binding inside its own module: HLS2020.2 inliner otherwise moves
// SpecFUCore annotations across conditional reused adds and breaks LLVM IR.
static int32_t r66_group32_dsp(int32_t a, int32_t b) {
#pragma HLS INLINE off
    ap_int<32> sum = (ap_int<32>)a + (ap_int<32>)b;
#pragma HLS BIND_OP variable=sum op=add impl=dsp latency=0
    return (int32_t)sum;
}
/* 交接说明 函数 r66_group32_dsp 结束后
 * 归约加法采用独立非内联模块，规避HLS2020.2内联跨条件传播绑定导致的IR问题；仍保持同样整数和。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */
static void r64_mac(const uint32_t input[HW_IFM_WORDS],
                    const uint32_t weights[HW_WGT_BYTES / 4],
                    const int32_t bias[HW_MAX_OC],
                    r65_accum_t acc[HW_NX][HW_CO], const r64_config c,
                    const r64_tile t, const r64_block first,
                    hls::stream<r64_acc_packet> &packets) {
#pragma HLS INLINE off
    const bool pointwise = r64_pointwise(c);
    const int count = first.valid ? (pointwise ? ((t.nc + HW_NX - 1) / HW_NX) * c.ocb : 1) : 0;
    int bx = 0, bo = 0;
    // R6.4：同一MAC任务连续处理一行全部x/ob块，复用原16×16累加器。
    // 只在最后一个输入通道组输出完成像素；FIFO反压防止量化落后时覆盖数据。
R64_MAC_BLOCKS:
    for (int block = 0; block < count; ++block) {
        const r64_block b = pointwise
            ? r64_make_block(first.y, bx, bo, t, c) : first;
        // Seed valid model blocks on their first tap. This removes sixteen
        // simultaneous writes and permits a single read/write RAM per channel.
        // Preserve the old bias-only behavior for empty-tap descriptors.
        if (c.icb <= 0 || c.kk <= 0) {
        R65_ACC_BIAS_ONLY:
            for (int nx = 0; nx < HW_NX; ++nx) {
#pragma HLS PIPELINE II=1
                for (int co = 0; co < HW_CO; ++co) {
#pragma HLS UNROLL
                    acc[nx][co] = nx < b.nxx ? bias[b.ob * HW_CO + co] : 0;
                }
            }
        }
        const int ob_offset = b.ob * c.icb * c.kk * c.kk * HW_CO;
        for (int ib = 0; ib < c.icb; ib += 2) {
            for (int ky = 0; ky < c.kk; ++ky) {
                for (int kx = 0; kx < c.kk; ++kx) {
                R65_MAC_FLAT_PIXELS:
                    for (int nx = 0; nx < HW_NX; ++nx) {
#pragma HLS PIPELINE II=1
#pragma HLS LOOP_FLATTEN
                        // Keep ib/ky/kx/nx a perfect nest: one continuous pipeline.
                        // Defining these outside nx prevented flattening in the
                        // 6.667 ns candidate, draining the pipeline every 16 pixels.
                        const int wbase = ob_offset + ((ib * c.kk + ky) * c.kk + kx) * HW_CO;
                        const int ibase = ib * t.rows * t.cols
                                        + (b.y * c.ss + ky) * t.cols + b.x0 * c.ss + kx;
                        if (nx < b.nxx) {
                            const uint32_t iv0 = input[ibase + nx * c.ss];
                            const bool have_second = ib + 1 < c.icb;
                            const uint32_t iv1 = have_second
                                ? input[ibase + t.rows * t.cols + nx * c.ss] : 0;
                            const int wbase1 = wbase + c.kk * c.kk * HW_CO;
                            r64_acc_packet packet = 0;
                            for (int pair = 0; pair < HW_CO / 2; ++pair) {
#pragma HLS UNROLL
                                const int co0 = 2 * pair, co1 = co0 + 1;
                                const uint32_t wa0 = weights[wbase + co0];
                                const uint32_t wb0 = weights[wbase + co1];
                                const uint32_t wa1 = have_second ? weights[wbase1 + co0] : 0;
                                const uint32_t wb1 = have_second ? weights[wbase1 + co1] : 0;
                                ap_int<16> pa[8], pb[8];
#pragma HLS ARRAY_PARTITION variable=pa complete
#pragma HLS ARRAY_PARTITION variable=pb complete
                                for (int ci = 0; ci < 4; ++ci) {
#pragma HLS UNROLL
                                    r66_mul_pair((ap_int<8>)(iv0 >> (8*ci)),
                                        (ap_int<8>)(wa0 >> (8*ci)),
                                        (ap_int<8>)(wb0 >> (8*ci)), pa[ci], pb[ci]);
                                    r66_mul_pair((ap_int<8>)(iv1 >> (8*ci)),
                                        (ap_int<8>)(wa1 >> (8*ci)),
                                        (ap_int<8>)(wb1 >> (8*ci)), pa[ci+4], pb[ci+4]);
                                }
                                const int32_t a0 = co0 < R66_DSP_GROUP_CHANNELS ? r66_group32_dsp((int32_t)pa[0]+pa[1],(int32_t)pa[2]+pa[3]) : (int32_t)(((int32_t)pa[0]+pa[1])+((int32_t)pa[2]+pa[3]));
                                const int32_t a1 = co0 < 2 ? r66_group32_dsp((int32_t)pa[4]+pa[5],(int32_t)pa[6]+pa[7]) : (int32_t)(((int32_t)pa[4]+pa[5])+((int32_t)pa[6]+pa[7]));
                                const int32_t b0 = co1 < R66_DSP_GROUP_CHANNELS ? r66_group32_dsp((int32_t)pb[0]+pb[1],(int32_t)pb[2]+pb[3]) : (int32_t)(((int32_t)pb[0]+pb[1])+((int32_t)pb[2]+pb[3]));
                                const int32_t b1 = co1 < 2 ? r66_group32_dsp((int32_t)pb[4]+pb[5],(int32_t)pb[6]+pb[7]) : (int32_t)(((int32_t)pb[4]+pb[5])+((int32_t)pb[6]+pb[7]));
                                const int32_t dota = co0 < R66_DSP_DOT_CHANNELS ? r66_add32_dsp(a0,a1) : a0+a1;
                                const int32_t dotb = co1 < R66_DSP_DOT_CHANNELS ? r66_add32_dsp(b0,b1) : b0+b1;
                                const bool first_tap = ib == 0 && ky == 0 && kx == 0;
                                const r65_accum_t prior0 = first_tap
                                    ? (r65_accum_t)bias[b.ob * HW_CO + co0] : acc[nx][co0];
                                const r65_accum_t prior1 = first_tap
                                    ? (r65_accum_t)bias[b.ob * HW_CO + co1] : acc[nx][co1];
                                const r65_accum_t updated0 = co0 < R66_DSP_ACC_CHANNELS ? r66_acc26_dsp(prior0,(r65_accum_t)dota) : (r65_accum_t)(prior0+dota);
                                const r65_accum_t updated1 = co1 < R66_DSP_ACC_CHANNELS ? r66_acc26_dsp(prior1,(r65_accum_t)dotb) : (r65_accum_t)(prior1+dotb);
                                acc[nx][co0] = updated0; acc[nx][co1] = updated1;
                                packet.range(co0 * 26 + 25, co0 * 26) = (ap_uint<26>)updated0;
                                packet.range(co1 * 26 + 25, co1 * 26) = (ap_uint<26>)updated1;
                            }
                            if (pointwise && b.nwoc > 0 && ib + 2 >= c.icb) packets.write(packet);
                        }
                    }
                }
            }
        }
        ++bo;
        if (bo == c.ocb) { bo = 0; bx += HW_NX; }
    }
}
/* 交接说明 函数 r64_mac 结束后
 * 最终卷积MAC任务。每次处理两组C4输入，16输出通道，峰值128有效MAC/拍；首tap种入bias，后续26位模累加，完美循环嵌套和II1减少反复排空。只访问片上缓冲，不直接抢DDR。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */

static void r64_quant(const r65_accum_t acc[HW_NX][HW_CO],
                      const uint32_t residual[HW_NX][HW_CO / HW_CI],
                      const int32_t mq[HW_MAX_OC], const int32_t shift[HW_MAX_OC],
                      uint32_t output[HW_MAX_OC / HW_CI][HW_ROW_PIXELS],
                      const r64_config c, const r64_tile t, const r64_block first,
                      hls::stream<r64_acc_packet> &packets) {
#pragma HLS INLINE off
    const bool pointwise = r64_pointwise(c);
    const int count = first.valid ? (pointwise ? ((t.nc + HW_NX - 1) / HW_NX) * c.ocb : 1) : 0;
    int bx = 0, bo = 0;
R64_QUANT_BLOCKS:
    for (int block = 0; block < count; ++block) {
        const r64_block b = pointwise
            ? r64_make_block(first.y, bx, bo, t, c) : first;
        int nx = 0, q = 0;
        r64_acc_packet packet = 0;
    R64_QUANT_PIXELS:
        for (int word_index = 0; word_index < b.nxx * b.nwoc; ++word_index) {
#pragma HLS PIPELINE II=1
            // R6.4：pointwise消费当前行MAC结果；普通路径仍读上一块acc bank。
            // 每有效像素恰好读一个416位包，尾像素不产生也不消费包。
            if (pointwise && q == 0) packet = packets.read();
            // R6.4：先展开为16个固定26位切片，再选通道。
            // 避免对416位值做动态part-select而生成四路宽桶形移位器。
            int32_t lanes[HW_CO];
#pragma HLS ARRAY_PARTITION variable=lanes complete
            for (int lane = 0; lane < HW_CO; ++lane) {
#pragma HLS UNROLL
                lanes[lane] = (int32_t)(r65_accum_t)packet.range(lane * 26 + 25, lane * 26);
            }
                uint32_t word = 0;
                for (int ci = 0; ci < HW_CI; ++ci) {
#pragma HLS UNROLL
                    const int co = (q << 2) + ci;
                    const int gco = b.ob * HW_CO + co;
                    int32_t v = 0;
                    if (gco < c.oc_real) {
                        const int32_t source = pointwise
                            ? lanes[co] : (int32_t)acc[nx][co];
                        ap_int<26> aa = source;
                        ap_int<18> mm = mq[gco];
                        ap_int<44> pp = aa * mm;
                        v = rshift_round_ap(pp, shift[gco]);
                        if (c.act == ACT_LEAKY && v < 0) v = (v * 3277) >> 15;
                        v = sat8(v);
                        if (c.add_off >= 0) {
                            const uint32_t rv = residual[nx][q];
                            const int8_t rsv = (int8_t)((rv >> (ci * 8)) & 0xff);
                            v = sat8(v + (int32_t)rsv);
                        }
                    }
                    word |= (uint32_t)(v & 0xff) << (ci * 8);
                }
                output[b.ob * (HW_CO / HW_CI) + q][b.x0 + nx] = word;
            ++q;
            if (q == b.nwoc) { q = 0; ++nx; }
        }
        ++bo;
        if (bo == c.ocb) { bo = 0; bx += HW_NX; }
    }
}
/* 交接说明 函数 r64_quant 结束后
 * 量化与输出打包。保留有符号26位解释、比例乘法、移位、激活和饱和顺序；1x1可从FIFO取MAC结果，其他路径读交接后的累加buffer。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */

/* R6.3：三个任务每步并发，步末交接缓冲。
 * 所有DDR访问集中在memory；MAC与quant没有m_axi指针。

 */
static void r64_wave(const int8_t *p_act,
                     const uint32_t current_ifm[HW_IFM_WORDS],
                     uint32_t next_ifm[HW_IFM_WORDS],
                     const uint32_t weights[HW_WGT_BYTES / 4],
                     const int32_t bias[HW_MAX_OC], const int32_t mq[HW_MAX_OC],
                     const int32_t shift[HW_MAX_OC],
                     r65_accum_t acc_write[HW_NX][HW_CO],
                     const r65_accum_t acc_read[HW_NX][HW_CO],
                     uint32_t res_write[HW_NX][HW_CO / HW_CI],
                     const uint32_t res_read[HW_NX][HW_CO / HW_CI],
                     uint32_t row_write[HW_MAX_OC / HW_CI][HW_ROW_PIXELS],
                     const uint32_t row_read[HW_MAX_OC / HW_CI][HW_ROW_PIXELS],
                     uint32_t halo[HW_R63_HALO_WORDS],
                     const r64_config c, const r64_tile current,
                     const r64_tile next, const r64_block compute,
                     const r64_block quant, const r64_block store,
                     int quota, bool reuse, int &load_g, int &load_r) {
#pragma HLS INLINE off
#pragma HLS DATAFLOW
    // R6.3：调用者直到wave完成才改这些输入，禁止生成整块输入的同步副本。
    // 可写acc/res/row/next_ifm不标stable，保持其写入完成交接。
#pragma HLS STABLE variable=current_ifm
#pragma HLS STABLE variable=weights
#pragma HLS STABLE variable=bias
#pragma HLS STABLE variable=mq
#pragma HLS STABLE variable=shift
#pragma HLS STABLE variable=acc_read
#pragma HLS STABLE variable=res_read
#pragma HLS STABLE variable=row_read
    // R6.4：16个像素包=832 B；使用BRAM FIFO，减少分布式存储压力。
    // 每次行任务生产/消费同样数量，退出wave时为空；非快路径两端均不访问。
    hls::stream<r64_acc_packet> packets("pointwise_acc");
#pragma HLS STREAM variable=packets depth=16
#pragma HLS BIND_STORAGE variable=packets type=fifo impl=bram
    r64_memory(p_act, next_ifm, halo, res_write, row_read,
               c, current, next, compute, store, quota, reuse, load_g, load_r);
    r64_mac(current_ifm, weights, bias, acc_write, c, current, compute, packets);
    r64_quant(acc_read, res_read, mq, shift, row_write, c, current, quant, packets);
#ifndef __SYNTHESIS__
    // C仿真不模拟FIFO容量，但仍检查每次wave产生与消费的包数相等。
    // 深度16、反压及真正并发另由RTL协同仿真和握手波形验证。
    assert(packets.empty());
#endif
}
/* 交接说明 函数 r64_wave 结束后
 * 函数r64_wave属于HLS计算及数据流。保留原实现，负责调用者所需的局部处理；输入输出及调用位置见本函数签名和正文。本次交接只新增说明，不改变活动语句。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */

static void conv_kernel(const int8_t *p_act, const int8_t *p_wgt, const int32_t *p_rqt,
                        int32_t src_off, int32_t dst_off,
                        int32_t wgt_off, int32_t rq_off, int32_t add_off,
                        int src_ch_off, int add_ch_off, int dst_ch_off,
                        int ih, int iw, int ic, int oh, int ow, int oc, int oc_real,
                        int kk, int ss, int pad, int act, int tile_r, int tile_c,
                        uint32_t ifm_current[HW_IFM_WORDS]) {
#pragma HLS INLINE off
// R6.4：统一静态调用入口共享wave；最终RTL核对实例唯一性。
    r64_config c = {src_off, dst_off, add_off, src_ch_off, dst_ch_off, add_ch_off,
                    ih, iw, oh, ow, ic / HW_CI, oc / HW_CO, oc_real, kk, ss, pad, act};
    const bool pointwise = r64_pointwise(c);
    uint32_t weights[HW_WGT_BYTES / 4];
#pragma HLS ARRAY_PARTITION variable=weights cyclic factor=16 dim=1
    int32_t bias[HW_MAX_OC], mq[HW_MAX_OC], shift[HW_MAX_OC];
#pragma HLS ARRAY_PARTITION variable=bias cyclic factor=16
#pragma HLS ARRAY_PARTITION variable=mq cyclic factor=4
#pragma HLS ARRAY_PARTITION variable=shift cyclic factor=4

    // R6.3：bank0由顶层传入并与Pool/Copy复用；仅新增bank1。
    // 它是普通局部数组参数，不是全局变量，也不是新增AXI端口。
    uint32_t ifm_next[HW_IFM_WORDS];
    uint32_t halo[HW_R63_HALO_WORDS];
#pragma HLS BIND_STORAGE variable=ifm_next type=ram_t2p impl=bram
#pragma HLS BIND_STORAGE variable=halo type=ram_2p impl=bram
    r65_accum_t acc0[HW_NX][HW_CO], acc1[HW_NX][HW_CO];
#pragma HLS ARRAY_PARTITION variable=acc0 complete dim=2
#pragma HLS ARRAY_PARTITION variable=acc1 complete dim=2
#pragma HLS BIND_STORAGE variable=acc0 type=ram_2p impl=bram
#pragma HLS BIND_STORAGE variable=acc1 type=ram_2p impl=bram
    uint32_t res0[HW_NX][HW_CO / HW_CI], res1[HW_NX][HW_CO / HW_CI];
#pragma HLS ARRAY_PARTITION variable=res0 complete dim=0
#pragma HLS ARRAY_PARTITION variable=res1 complete dim=0
    uint32_t row0[HW_MAX_OC / HW_CI][HW_ROW_PIXELS];
    uint32_t row1[HW_MAX_OC / HW_CI][HW_ROW_PIXELS];
#pragma HLS BIND_STORAGE variable=row0 type=ram_2p impl=bram
#pragma HLS BIND_STORAGE variable=row1 type=ram_2p impl=bram

    // R6.2容量判定保留：Vitis继续传tile_c=16，内部选择64/32/16。
    int width = tile_c < HW_ROW_PIXELS ? tile_c : HW_ROW_PIXELS;
    if (tile_c == HW_NX && ow > tile_c) {
        const int max_nr = tile_r < oh ? tile_r : oh;
        const int row_words = c.icb * ((max_nr - 1) * ss + kk);
        const int wide = ow < HW_ROW_PIXELS ? ow : HW_ROW_PIXELS;
        const int mid = ow < HW_ROW_PIXELS / 2 ? ow : HW_ROW_PIXELS / 2;
        if (row_words * ((wide - 1) * ss + kk) <= HW_IFM_WORDS) width = wide;
        else if (row_words * ((mid - 1) * ss + kk) <= HW_IFM_WORDS) width = mid;
    }
    const int weight_words = c.ocb * c.icb * kk * kk * HW_CO;
    axi64_read_words<HW_WGT_BYTES/4>(p_wgt, wgt_off >> 2, weights, 0, weight_words);
    // 只清零本算子的补齐通道；有效通道随后从DDR加载。
    // 不清空全部128通道，避免给小算子增加无用的固定初始化延迟。
    for (int co = oc_real; co < oc; ++co) {
#pragma HLS PIPELINE II=1
        bias[co] = 0; mq[co] = 0; shift[co] = 0;
    }
    for (int co = 0; co < oc_real; ++co) {
#pragma HLS PIPELINE II=1
        bias[co] = p_rqt[(rq_off >> 2) + co * 3];
        mq[co] = p_rqt[(rq_off >> 2) + co * 3 + 1];
        shift[co] = p_rqt[(rq_off >> 2) + co * 3 + 2];
    }

    r64_tile current = r64_make_tile(0, 0, tile_r, width, c);
    r64_tile next = current;
    r64_block empty = {}, previous = {}, older = {};
    int load_g = 0, load_r = 0;
    int step = 0, y = 0, x0 = 0, ob = 0;
    int blocks = pointwise ? current.nr
        : current.nr * ((current.nc + HW_NX - 1) / HW_NX) * c.ocb;
    int quota = 1;
    int mode = 0; // 0首tile加载，1并行计算，2补齐预取，3完成。
    bool input_bank = false;
    while (mode != 3) {
        // R6.3：所有路径汇合到相同调用点，避免引用别名导致HLS克隆wave/MAC。
        // 初始、正常、排空都通过valid使能同一套物理任务。
        const r64_tile run_current = current;
        const r64_tile run_next = mode == 0 ? current : next;
        const r64_block run_compute = mode == 1
            ? r64_make_block(y, x0, ob, current, c) : empty;
        // R6.4：pointwise一行一个wave，MAC与量化通过FIFO同时处理当前行。
        // 上一行已在上个wave完成，memory可写回；末tile只需一次行写回排空。
        const r64_block run_quant = mode == 1 ? (pointwise ? run_compute : previous) : empty;
        const r64_block run_store = mode == 1 ? (pointwise ? previous : older) : empty;
        const int run_quota = mode == 1 ? quota : c.icb * run_next.rows;
        const bool reuse = mode != 0 && next.valid && next.tr == current.tr;
        const bool in_bank = mode == 0 ? true : input_bank;
        const bool acc_bank = (step & 1) != 0;
        const bool row_bank = run_quant.valid ? (run_quant.y & 1) != 0
            : !(run_store.valid && (run_store.y & 1) != 0);
        if (!in_bank && !acc_bank && !row_bank) {
            r64_wave(p_act, ifm_current, ifm_next, weights, bias, mq, shift,
                     acc0, acc1, res0, res1, row0, row1, halo,
                     c, run_current, run_next, run_compute, run_quant, run_store,
                     run_quota, reuse, load_g, load_r);
        }
        else if (!in_bank && !acc_bank && row_bank) {
            r64_wave(p_act, ifm_current, ifm_next, weights, bias, mq, shift,
                     acc0, acc1, res0, res1, row1, row0, halo,
                     c, run_current, run_next, run_compute, run_quant, run_store,
                     run_quota, reuse, load_g, load_r);
        }
        else if (!in_bank && acc_bank && !row_bank) {
            r64_wave(p_act, ifm_current, ifm_next, weights, bias, mq, shift,
                     acc1, acc0, res1, res0, row0, row1, halo,
                     c, run_current, run_next, run_compute, run_quant, run_store,
                     run_quota, reuse, load_g, load_r);
        }
        else if (!in_bank && acc_bank && row_bank) {
            r64_wave(p_act, ifm_current, ifm_next, weights, bias, mq, shift,
                     acc1, acc0, res1, res0, row1, row0, halo,
                     c, run_current, run_next, run_compute, run_quant, run_store,
                     run_quota, reuse, load_g, load_r);
        }
        else if (in_bank && !acc_bank && !row_bank) {
            r64_wave(p_act, ifm_next, ifm_current, weights, bias, mq, shift,
                     acc0, acc1, res0, res1, row0, row1, halo,
                     c, run_current, run_next, run_compute, run_quant, run_store,
                     run_quota, reuse, load_g, load_r);
        }
        else if (in_bank && !acc_bank && row_bank) {
            r64_wave(p_act, ifm_next, ifm_current, weights, bias, mq, shift,
                     acc0, acc1, res0, res1, row1, row0, halo,
                     c, run_current, run_next, run_compute, run_quant, run_store,
                     run_quota, reuse, load_g, load_r);
        }
        else if (in_bank && acc_bank && !row_bank) {
            r64_wave(p_act, ifm_next, ifm_current, weights, bias, mq, shift,
                     acc1, acc0, res1, res0, row0, row1, halo,
                     c, run_current, run_next, run_compute, run_quant, run_store,
                     run_quota, reuse, load_g, load_r);
        }
        else if (in_bank && acc_bank && row_bank) {
            r64_wave(p_act, ifm_next, ifm_current, weights, bias, mq, shift,
                     acc1, acc0, res1, res0, row1, row0, halo,
                     c, run_current, run_next, run_compute, run_quant, run_store,
                     run_quota, reuse, load_g, load_r);
        }
        bool tile_finished = false;
        if (mode == 0) {
            // 首tile已加载到bank0；设置下一tile，开始正常流水。
            mode = 1;
            next = r64_make_tile(width < ow ? 0 : tile_r,
                                 width < ow ? width : 0, tile_r, width, c);
            load_g = 0; load_r = 0;
        } else if (mode == 2) {
            tile_finished = true;
        } else {
            older = previous; previous = run_compute;
            if (pointwise && previous.valid) previous.row_last = true;
            if (run_compute.valid) {
                if (pointwise) { ++y; }
                else {
                    ++ob;
                    if (ob == c.ocb) {
                        ob = 0; x0 += HW_NX;
                        if (x0 >= current.nc) { x0 = 0; ++y; }
                    }
                }
            }
            ++step;
            if (step == blocks + (pointwise ? 1 : 2)) {
                if (next.valid && load_g < c.icb) mode = 2;
                else tile_finished = true;
            }
        }
        if (tile_finished) {
            if (!next.valid) { mode = 3; }
            else {
                current = next;
                const int ntc = current.tc + width < ow ? current.tc + width : 0;
                const int ntr = current.tc + width < ow ? current.tr : current.tr + tile_r;
                next = r64_make_tile(ntr, ntc, tile_r, width, c);
                input_bank = !input_bank;
                load_g = 0; load_r = 0;
                step = 0; y = 0; x0 = 0; ob = 0;
                previous = empty; older = empty;
                blocks = pointwise ? current.nr
                    : current.nr * ((current.nc + HW_NX - 1) / HW_NX) * c.ocb;
                mode = 1;
            }
        }
        // R6.3：用2的幂配额将下一tile输入行分摊到计算步骤，避免运行时除法。
        quota = 1;
        const int next_rows = c.icb * next.rows;
        if (next_rows > blocks) quota = 2;
        if (next_rows > blocks * 2) quota = 4;
        if (next_rows > blocks * 4) quota = 8;
        if (next_rows > blocks * 8) quota = 16;
        // R6.4：1×1每wave计算一行；每输出行分配IC/4个C4输入行。
        // 后继tile高度不会大于当前tile，额度足够且不被原来的16上限截断。
        // 用确切icb代替向上取2的幂，减少低OC层中额外串行读取的峰值。
        if (pointwise) quota = c.icb;
    }
}
/* 交接说明 函数 conv_kernel 结束后
 * 函数conv_kernel属于HLS计算及数据流。包含HLS流水线指示，修改循环边界后必须复核II与启动开销。本次交接只新增说明，不改变活动语句。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */

#endif

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
// --- C:\Users\Lenovo\Desktop\yolov5n_speed_prj\yolov5n_speed_prj\submission_2026\src\candidate_r6_5_acc26_resbram\yolov5n_r6_5_schedule.h
// 
// +++ C:\Users\Lenovo\Desktop\yolov5n_speed_prj\yolov5n_speed_prj\01_hls\FINAL_R66_20261027\src\yolov5n_r6_5_schedule.h
// 
// @@ -216,12 +216,52 @@
// 
//      }
//  }
//  
//  /* R6.3 改动1：MAC只访问当前IFM与本步acc；量化使用另一套acc。
//   * 保留R6.2的ib/ky/kx/nx顺序、定长NX和dot4数值表达式。
//   */
// +// R6.6: exact two signed INT8 products with a shared activation in one25x8 DSP.
// +// Low weight is unsigned-packed; explicitly correct its sign and high borrow.
// +static void r66_mul_pair(ap_int<8> x, ap_int<8> w0, ap_int<8> w1,
// +                         ap_int<16> &p0, ap_int<16> &p1) {
// +#pragma HLS INLINE
// +    ap_int<25> joined = 0;
// +    joined.range(24,17) = (ap_uint<8>)w1;
// +    joined.range(7,0) = (ap_uint<8>)w0;
// +    ap_int<33> product = joined * x;
// +#pragma HLS BIND_OP variable=product op=mul impl=dsp latency=3
// +    const ap_int<17> low = (ap_int<17>)product.range(16,0);
// +    const ap_int<17> signfix = w0 < 0 ? ((ap_int<17>)x << 8) : (ap_int<17>)0;
// +    p0 = (ap_int<16>)(low - signfix);
// +    p1 = (ap_int<16>)((product >> 17) + (low < 0 ? 1 : 0));
// +}
// +// Isolated allocation study: place useful accumulation/reduction adds in spareDSPs.
// +// Target45usefuladders: previous43variantactually218DSP after optimization; add2realreductions then reverify220.
// +#define R66_DSP_ACC_CHANNELS 16
// +#define R66_DSP_DOT_CHANNELS 16
// +#define R66_DSP_GROUP_CHANNELS 13
// +static ap_int<26> r66_acc26_dsp(ap_int<26> a, ap_int<26> b) {
// +#pragma HLS INLINE
// +    ap_int<26> sum = a + b;
// +#pragma HLS BIND_OP variable=sum op=add impl=dsp latency=0
// +    return sum;
// +}
// +static int32_t r66_add32_dsp(int32_t a, int32_t b) {
// +#pragma HLS INLINE
// +    ap_int<32> sum = (ap_int<32>)a + (ap_int<32>)b;
// +#pragma HLS BIND_OP variable=sum op=add impl=dsp latency=0
// +    return (int32_t)sum;
// +}
// +// Keep this binding inside its own module: HLS2020.2 inliner otherwise moves
// +// SpecFUCore annotations across conditional reused adds and breaks LLVM IR.
// +static int32_t r66_group32_dsp(int32_t a, int32_t b) {
// +#pragma HLS INLINE off
// +    ap_int<32> sum = (ap_int<32>)a + (ap_int<32>)b;
// +#pragma HLS BIND_OP variable=sum op=add impl=dsp latency=0
// +    return (int32_t)sum;
// +}
//  static void r64_mac(const uint32_t input[HW_IFM_WORDS],
//                      const uint32_t weights[HW_WGT_BYTES / 4],
//                      const int32_t bias[HW_MAX_OC],
//                      r65_accum_t acc[HW_NX][HW_CO], const r64_config c,
//                      const r64_tile t, const r64_block first,
//                      hls::stream<r64_acc_packet> &packets) {
// @@ -246,13 +286,13 @@
// 
//  #pragma HLS UNROLL
//                      acc[nx][co] = nx < b.nxx ? bias[b.ob * HW_CO + co] : 0;
//                  }
//              }
//          }
//          const int ob_offset = b.ob * c.icb * c.kk * c.kk * HW_CO;
// -        for (int ib = 0; ib < c.icb; ++ib) {
// +        for (int ib = 0; ib < c.icb; ib += 2) {
//              for (int ky = 0; ky < c.kk; ++ky) {
//                  for (int kx = 0; kx < c.kk; ++kx) {
//                  R65_MAC_FLAT_PIXELS:
//                      for (int nx = 0; nx < HW_NX; ++nx) {
//  #pragma HLS PIPELINE II=1
//  #pragma HLS LOOP_FLATTEN
// @@ -260,29 +300,55 @@
// 
//                          // Defining these outside nx prevented flattening in the
//                          // 6.667 ns candidate, draining the pipeline every 16 pixels.
//                          const int wbase = ob_offset + ((ib * c.kk + ky) * c.kk + kx) * HW_CO;
//                          const int ibase = ib * t.rows * t.cols
//                                          + (b.y * c.ss + ky) * t.cols + b.x0 * c.ss + kx;
//                          if (nx < b.nxx) {
// -                            uint32_t iv = input[ibase + nx * c.ss];
// +                            const uint32_t iv0 = input[ibase + nx * c.ss];
// +                            const bool have_second = ib + 1 < c.icb;
// +                            const uint32_t iv1 = have_second
// +                                ? input[ibase + t.rows * t.cols + nx * c.ss] : 0;
// +                            const int wbase1 = wbase + c.kk * c.kk * HW_CO;
//                              r64_acc_packet packet = 0;
// -                            for (int co = 0; co < HW_CO; ++co) {
// +                            for (int pair = 0; pair < HW_CO / 2; ++pair) {
//  #pragma HLS UNROLL
// -                                const uint32_t ww = weights[wbase + co];
// -                                const int32_t p0 = (int8_t)(iv)       * (int32_t)(int8_t)(ww);
// -                                const int32_t p1 = (int8_t)(iv >> 8)  * (int32_t)(int8_t)(ww >> 8);
// -                                const int32_t p2 = (int8_t)(iv >> 16) * (int32_t)(int8_t)(ww >> 16);
// -                                const int32_t p3 = (int8_t)(iv >> 24) * (int32_t)(int8_t)(ww >> 24);
// -                                const int32_t dot4 = (p0 + p1) + (p2 + p3);
// -                                const r65_accum_t prior = (ib == 0 && ky == 0 && kx == 0)
// -                                    ? (r65_accum_t)bias[b.ob * HW_CO + co] : acc[nx][co];
// -                                const r65_accum_t updated = prior + dot4;
// -                                acc[nx][co] = updated;
// -                                packet.range(co * 26 + 25, co * 26) = (ap_uint<26>)updated;
// +                                const int co0 = 2 * pair, co1 = co0 + 1;
// +                                const uint32_t wa0 = weights[wbase + co0];
// +                                const uint32_t wb0 = weights[wbase + co1];
// +                                const uint32_t wa1 = have_second ? weights[wbase1 + co0] : 0;
// +                                const uint32_t wb1 = have_second ? weights[wbase1 + co1] : 0;
// +                                ap_int<16> pa[8], pb[8];
// +#pragma HLS ARRAY_PARTITION variable=pa complete
// +#pragma HLS ARRAY_PARTITION variable=pb complete
// +                                for (int ci = 0; ci < 4; ++ci) {
// +#pragma HLS UNROLL
// +                                    r66_mul_pair((ap_int<8>)(iv0 >> (8*ci)),
// +                                        (ap_int<8>)(wa0 >> (8*ci)),
// +                                        (ap_int<8>)(wb0 >> (8*ci)), pa[ci], pb[ci]);
// +                                    r66_mul_pair((ap_int<8>)(iv1 >> (8*ci)),
// +                                        (ap_int<8>)(wa1 >> (8*ci)),
// +                                        (ap_int<8>)(wb1 >> (8*ci)), pa[ci+4], pb[ci+4]);
// +                                }
// +                                const int32_t a0 = co0 < R66_DSP_GROUP_CHANNELS ? r66_group32_dsp((int32_t)pa[0]+pa[1],(int32_t)pa[2]+pa[3]) : (int32_t)(((int32_t)pa[0]+pa[1])+((int32_t)pa[2]+pa[3]));
// +                                const int32_t a1 = co0 < 2 ? r66_group32_dsp((int32_t)pa[4]+pa[5],(int32_t)pa[6]+pa[7]) : (int32_t)(((int32_t)pa[4]+pa[5])+((int32_t)pa[6]+pa[7]));
// +                                const int32_t b0 = co1 < R66_DSP_GROUP_CHANNELS ? r66_group32_dsp((int32_t)pb[0]+pb[1],(int32_t)pb[2]+pb[3]) : (int32_t)(((int32_t)pb[0]+pb[1])+((int32_t)pb[2]+pb[3]));
// +                                const int32_t b1 = co1 < 2 ? r66_group32_dsp((int32_t)pb[4]+pb[5],(int32_t)pb[6]+pb[7]) : (int32_t)(((int32_t)pb[4]+pb[5])+((int32_t)pb[6]+pb[7]));
// +                                const int32_t dota = co0 < R66_DSP_DOT_CHANNELS ? r66_add32_dsp(a0,a1) : a0+a1;
// +                                const int32_t dotb = co1 < R66_DSP_DOT_CHANNELS ? r66_add32_dsp(b0,b1) : b0+b1;
// +                                const bool first_tap = ib == 0 && ky == 0 && kx == 0;
// +                                const r65_accum_t prior0 = first_tap
// +                                    ? (r65_accum_t)bias[b.ob * HW_CO + co0] : acc[nx][co0];
// +                                const r65_accum_t prior1 = first_tap
// +                                    ? (r65_accum_t)bias[b.ob * HW_CO + co1] : acc[nx][co1];
// +                                const r65_accum_t updated0 = co0 < R66_DSP_ACC_CHANNELS ? r66_acc26_dsp(prior0,(r65_accum_t)dota) : (r65_accum_t)(prior0+dota);
// +                                const r65_accum_t updated1 = co1 < R66_DSP_ACC_CHANNELS ? r66_acc26_dsp(prior1,(r65_accum_t)dotb) : (r65_accum_t)(prior1+dotb);
// +                                acc[nx][co0] = updated0; acc[nx][co1] = updated1;
// +                                packet.range(co0 * 26 + 25, co0 * 26) = (ap_uint<26>)updated0;
// +                                packet.range(co1 * 26 + 25, co1 * 26) = (ap_uint<26>)updated1;
//                              }
// -                            if (pointwise && b.nwoc > 0 && ib + 1 == c.icb) packets.write(packet);
// +                            if (pointwise && b.nwoc > 0 && ib + 2 >= c.icb) packets.write(packet);
//                          }
//                      }
//                  }
//              }
//          }
//          ++bo;
// @@ -426,14 +492,14 @@
// 
//      uint32_t halo[HW_R63_HALO_WORDS];
//  #pragma HLS BIND_STORAGE variable=ifm_next type=ram_t2p impl=bram
//  #pragma HLS BIND_STORAGE variable=halo type=ram_2p impl=bram
//      r65_accum_t acc0[HW_NX][HW_CO], acc1[HW_NX][HW_CO];
//  #pragma HLS ARRAY_PARTITION variable=acc0 complete dim=2
//  #pragma HLS ARRAY_PARTITION variable=acc1 complete dim=2
// -#pragma HLS BIND_STORAGE variable=acc0 type=ram_2p impl=lutram
// -#pragma HLS BIND_STORAGE variable=acc1 type=ram_2p impl=lutram
// +#pragma HLS BIND_STORAGE variable=acc0 type=ram_2p impl=bram
// +#pragma HLS BIND_STORAGE variable=acc1 type=ram_2p impl=bram
//      uint32_t res0[HW_NX][HW_CO / HW_CI], res1[HW_NX][HW_CO / HW_CI];
//  #pragma HLS ARRAY_PARTITION variable=res0 complete dim=0
//  #pragma HLS ARRAY_PARTITION variable=res1 complete dim=0
//      uint32_t row0[HW_MAX_OC / HW_CI][HW_ROW_PIXELS];
//      uint32_t row1[HW_MAX_OC / HW_CI][HW_ROW_PIXELS];
//  #pragma HLS BIND_STORAGE variable=row0 type=ram_2p impl=bram
#endif

/* 交接补充
 * 本文件名和旧头部仍写R6.4，但活动r66_mul_pair与ib+=2为最终R6.6。16输出×2组×4输入=128有效MAC/拍；47真实加法绑定不是最终DSP总量，Routed实占218。原残差BRAM与26位模累加保留。
 */
