/* R6.5 candidate / 10.xsa：在R6.4基础上试验3×3核横向双位置并行。
 * 本文件在profile_mark之后被包含，仅属于当前HLS实现。
 * 不增加m_axi/AXI-Lite端口，不改变C4、描述符或量化的数值顺序。
 * 常规1x1/s1/pad0/无残差路径按输出行处理，其他形状保留原分步路径。
 * 仅候选版本：每个MAC迭代处理两个kx位置；1×1在第二位置无效时仍只做一次乘加。
 * 预计提高3×3 MAC吞吐，但会增加乘法器、LUT和布线压力，效果须经HLS/板级验证。
 */
#ifndef YOLOV5N_R6_4_SCHEDULE_H
#define YOLOV5N_R6_4_SCHEDULE_H
#include <hls_stream.h>
#ifndef __SYNTHESIS__
#include <assert.h>
#endif

typedef ap_uint<HW_CO * 32> r64_acc_packet;

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

// R6.4：读/写方向各一个进程，分别保留单调连续访问，才能推断行burst。
// 直接在同一x循环混合读写虽然能II=1，却会丢失本工具的自动burst推断。
static void r64_pair_read(const int8_t *p_act, uint32_t input[HW_IFM_WORDS],
                          int src_off, int read_base, int ibase, int count) {
#pragma HLS INLINE off
    const uint32_t *src = (const uint32_t *)(p_act + src_off);
R64_PAIRED_READ:
    for (int x = 0; x < count; ++x) {
#pragma HLS PIPELINE II=1
        input[ibase + x] = src[read_base + x];
    }
}
static void r64_pair_write(const int8_t *p_act,
                           const uint32_t output[HW_MAX_OC / HW_CI][HW_ROW_PIXELS],
                           int dst_off, int base, int q, int count) {
#pragma HLS INLINE off
    uint32_t *dst = (uint32_t *)(p_act + dst_off);
R64_PAIRED_WRITE:
    for (int x = 0; x < count; ++x) {
#pragma HLS PIPELINE II=1
        dst[base + x] = output[q][x];
    }
}
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
        R64_OUTPUT_ROW:
            for (int x = 0; x < current.nc; ++x) {
#pragma HLS PIPELINE II=1
                dst[base + x] = output[q][x];
            }
            }
        }
    }
    if (compute.valid && c.add_off >= 0) {
        // 无残差时add_off=-1，不构造越过arena起点的无效指针。
        const uint32_t *res = (const uint32_t *)(p_act + c.add_off);
        for (int q = 0; q < compute.nwoc; ++q) {
            const int base = ((c.add_ch_off >> 2) + compute.ob * (HW_CO / HW_CI) + q)
                           * c.oh * c.ow + (current.tr + compute.y) * c.ow
                           + current.tc + compute.x0;
        R64_RESIDUAL:
            for (int x = 0; x < compute.nxx; ++x) {
#pragma HLS PIPELINE II=1
                residual[x][q] = res[base + x];
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
            R64_STAGE_VALID:
                for (int x = start; x < end; ++x) {
#pragma HLS PIPELINE II=1
                    next_ifm[base + x] = src[read_base + x];
                }
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

/* R6.3 改动1：MAC只访问当前IFM与本步acc；量化使用另一套acc。
 * 保留R6.2的ib/ky/kx/nx顺序、定长NX和dot4数值表达式。
 */
static void r64_mac(const uint32_t input[HW_IFM_WORDS],
                    const uint32_t weights[HW_WGT_BYTES / 4],
                    const int32_t bias[HW_MAX_OC],
                    int32_t acc[HW_NX][HW_CO], const r64_config c,
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
        for (int nx = 0; nx < HW_NX; ++nx) {
#pragma HLS UNROLL
            for (int co = 0; co < HW_CO; ++co) {
#pragma HLS UNROLL
                acc[nx][co] = nx < b.nxx ? bias[b.ob * HW_CO + co] : 0;
            }
        }
        const int ob_offset = b.ob * c.icb * c.kk * c.kk * HW_CO;
        for (int ib = 0; ib < c.icb; ++ib) {
            for (int ky = 0; ky < c.kk; ++ky) {
                for (int kx = 0; kx < c.kk; ++kx) {
                    const int wbase = ob_offset + ((ib * c.kk + ky) * c.kk + kx) * HW_CO;
                    const int ibase = ib * t.rows * t.cols
                                    + (b.y * c.ss + ky) * t.cols + b.x0 * c.ss + kx;
                R64_MAC_PIXELS:
                    for (int nx = 0; nx < HW_NX; ++nx) {
#pragma HLS PIPELINE II=1
                        if (nx < b.nxx) {
                            const uint32_t iv = input[ibase + nx * c.ss];
                            r64_acc_packet packet = 0;
                            for (int co = 0; co < HW_CO; ++co) {
#pragma HLS UNROLL factor=1
                                const uint32_t ww = weights[wbase + co];
                                const int32_t p0 = (int8_t)(iv)       * (int32_t)(int8_t)(ww);
                                const int32_t p1 = (int8_t)(iv >> 8)  * (int32_t)(int8_t)(ww >> 8);
                                const int32_t p2 = (int8_t)(iv >> 16) * (int32_t)(int8_t)(ww >> 16);
                                const int32_t p3 = (int8_t)(iv >> 24) * (int32_t)(int8_t)(ww >> 24);
                                const int32_t dot = (p0 + p1) + (p2 + p3);
                                const int32_t updated = acc[nx][co] + dot;
                                acc[nx][co] = updated;
                                packet.range(co * 32 + 31, co * 32) = (uint32_t)updated;
                            }
                            if (pointwise && b.nwoc > 0 && ib + 1 == c.icb) packets.write(packet);
                        }
                    }
                }
            }
        }
        ++bo;
        if (bo == c.ocb) { bo = 0; bx += HW_NX; }
    }
}

static void r64_quant(const int32_t acc[HW_NX][HW_CO],
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
            // 每有效像素恰好读一个512位包，尾像素不产生也不消费包。
            if (pointwise && q == 0) packet = packets.read();
            // R6.4：先展开为16个固定32位切片，再选通道。
            // 避免对512位值做动态part-select而生成四路宽桶形移位器。
            int32_t lanes[HW_CO];
#pragma HLS ARRAY_PARTITION variable=lanes complete
            for (int lane = 0; lane < HW_CO; ++lane) {
#pragma HLS UNROLL
                lanes[lane] = (int32_t)(uint32_t)packet.range(lane * 32 + 31, lane * 32);
            }
                uint32_t word = 0;
                for (int ci = 0; ci < HW_CI; ++ci) {
#pragma HLS UNROLL
                    const int co = (q << 2) + ci;
                    const int gco = b.ob * HW_CO + co;
                    int32_t v = 0;
                    if (gco < c.oc_real) {
                        const int32_t source = pointwise
                            ? lanes[co] : acc[nx][co];
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

/* R6.3：三个任务每步并发，步末交接缓冲。
 * 所有DDR访问集中在memory；MAC与quant没有m_axi指针。
 * DATAFLOW内不共写profile_event；观测标记在外层步边界统一发出。
 */
static void r64_wave(const int8_t *p_act,
                     const uint32_t current_ifm[HW_IFM_WORDS],
                     uint32_t next_ifm[HW_IFM_WORDS],
                     const uint32_t weights[HW_WGT_BYTES / 4],
                     const int32_t bias[HW_MAX_OC], const int32_t mq[HW_MAX_OC],
                     const int32_t shift[HW_MAX_OC],
                     int32_t acc_write[HW_NX][HW_CO],
                     const int32_t acc_read[HW_NX][HW_CO],
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
    // R6.4：16个像素包=1024 B；使用LUTRAM小FIFO，避免再加大IFM/行缓存。
    // 每次行任务生产/消费同样数量，退出wave时为空；非快路径两端均不访问。
    hls::stream<r64_acc_packet> packets("pointwise_acc");
#pragma HLS STREAM variable=packets depth=16
#pragma HLS BIND_STORAGE variable=packets type=fifo impl=lutram
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

static void conv_kernel(const int8_t *p_act, const int8_t *p_wgt, const int32_t *p_rqt,
                        int32_t src_off, int32_t dst_off,
                        int32_t wgt_off, int32_t rq_off, int32_t add_off,
                        int src_ch_off, int add_ch_off, int dst_ch_off,
                        int ih, int iw, int ic, int oh, int ow, int oc, int oc_real,
                        int kk, int ss, int pad, int act, int tile_r, int tile_c,
                        int profile_op, volatile uint16_t *profile_event,
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
#pragma HLS BIND_STORAGE variable=ifm_next type=ram_2p impl=bram
#pragma HLS BIND_STORAGE variable=halo type=ram_2p impl=bram
    int32_t acc0[HW_NX][HW_CO], acc1[HW_NX][HW_CO];
#pragma HLS ARRAY_PARTITION variable=acc0 complete dim=2
#pragma HLS ARRAY_PARTITION variable=acc1 complete dim=2
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
    profile_mark(profile_event, profile_op, HLS_PHASE_WEIGHTS);
    const uint32_t *wp = (const uint32_t *)(p_wgt + wgt_off);
    const int weight_words = c.ocb * c.icb * kk * kk * HW_CO;
    for (int i = 0; i < weight_words; ++i) {
#pragma HLS PIPELINE II=1
        weights[i] = wp[i];
    }
    profile_mark(profile_event, profile_op, HLS_PHASE_RQ_LOAD);
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
        profile_mark(profile_event, profile_op,
                     mode == 0 ? HLS_PHASE_INPUT_TILE : HLS_PHASE_WAVE_BEGIN);
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
        profile_mark(profile_event, profile_op, HLS_PHASE_WAVE_END);
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

#endif
