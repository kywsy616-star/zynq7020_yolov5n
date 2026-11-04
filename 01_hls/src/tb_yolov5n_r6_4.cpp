/* Testbench only: independent scalar reference and the frozen uninstrumented R5 kernel.

 * argv[1] is the directory made by tools/prepare_r5_testdata.js.

 */

#include <stdio.h>

#include <stdint.h>

#include <stdlib.h>

#include <string.h>

#include <vector>

using Bytes = std::vector<int8_t>;

#include "yolov5n_hls.h"

void yolov5n_top_r5(const int8_t *, const int8_t *, const int32_t *, const int32_t *, int, int);

static_assert(sizeof(layer_desc_t) == 64, "Descriptor ABI must stay 64 bytes");

static bool rtl_smoke = false;

static uint32_t rng_state = 0x6d2b79f5u;

static uint32_t rnd() { rng_state = rng_state * 1664525u + 1013904223u; return rng_state; }
/* 交接说明 函数 rnd 结束后
 * 函数rnd属于HLS计算及数据流。保留原实现，负责调用者所需的局部处理；输入输出及调用位置见本函数签名和正文。本次交接只新增说明，不改变活动语句。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */

static void run_r61(const int8_t *a, const int8_t *w, const int32_t *r,

                    const int32_t *t, int start, int n) {

    yolov5n_top(a, w, r, t, start, n);

}
/* 交接说明 函数 run_r61 结束后
 * 函数run_r61属于HLS计算及数据流。保留原实现，负责调用者所需的局部处理；输入输出及调用位置见本函数签名和正文。本次交接只新增说明，不改变活动语句。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */

static size_t c4(int c, int y, int x, int h, int w) {

    return ((((size_t)c >> 2) * h + y) * w + x) * 4 + (c & 3);

}
/* 交接说明 函数 c4 结束后
 * 函数c4属于HLS计算及数据流。保留原实现，负责调用者所需的局部处理；输入输出及调用位置见本函数签名和正文。本次交接只新增说明，不改变活动语句。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */

static int clip(int v) { return v < -128 ? -128 : v > 127 ? 127 : v; }
/* 交接说明 函数 clip 结束后
 * 函数clip属于HLS计算及数据流。保留原实现，负责调用者所需的局部处理；输入输出及调用位置见本函数签名和正文。本次交接只新增说明，不改变活动语句。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */

static bool same(const Bytes &a, const Bytes &b, const char *where) {

    if (a == b) return true;

    for (size_t i = 0; i < a.size(); ++i) if (a[i] != b[i]) {

        printf("FAIL %s byte=%lu actual=%d expected=%d\n", where, (unsigned long)i, (int)a[i], (int)b[i]);

        break;

    }

    return false;

}
/* 交接说明 函数 same 结束后
 * 函数same属于HLS计算及数据流。保留原实现，负责调用者所需的局部处理；输入输出及调用位置见本函数签名和正文。本次交接只新增说明，不改变活动语句。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */

static void scalar_conv(const Bytes &input, Bytes &out, const Bytes &wgt,

                        const std::vector<int32_t> &rq, const layer_desc_t &d) {

    // Output-pixel/channel reference, independent of the HLS tile schedule.

    for (int y = 0; y < d.oh; ++y) for (int x = 0; x < d.ow; ++x)

        for (int co = 0; co < ((d.oc_real + 3) & ~3); ++co) {

            int v = 0;

            if (co < d.oc_real) {

                int64_t acc = rq[co * 3];

                for (int ci = 0; ci < d.ic; ++ci) for (int ky = 0; ky < d.k; ++ky)

                    for (int kx = 0; kx < d.k; ++kx) {

                        int sy = y * d.s - d.pad + ky, sx = x * d.s - d.pad + kx;

                        int xv = (sy < 0 || sx < 0 || sy >= d.ih || sx >= d.iw) ? 0 :

                                 input[d.src_off + c4(d.src_ch_off + ci, sy, sx, d.ih, d.iw)];

                        size_t wi = (((((co / HW_CO) * (d.ic / HW_CI) + ci / HW_CI)

                                      * d.k + ky) * d.k + kx) * HW_CO + co % HW_CO) * HW_CI + ci % HW_CI;

                        acc += xv * (int)wgt[wi];

                    }

                int64_t pp = acc * rq[co * 3 + 1];

                int sh = rq[co * 3 + 2];

                if (sh > 0) {

                    int64_t half = (int64_t)1 << (sh - 1);

                    v = (int)((pp + (pp >= 0 ? half : -half)) >> sh);

                } else v = (int)(pp * ((int64_t)1 << -sh));

                if (d.act == ACT_LEAKY && v < 0) v = (v * 3277) >> 15;

                v = clip(v);

                if (d.add_off >= 0)

                    v = clip(v + input[d.add_off + c4(d.add_ch_off + co, y, x, d.oh, d.ow)]);

            }

            out[d.dst_off + c4(d.dst_ch_off + co, y, x, d.oh, d.ow)] = (int8_t)v;

        }

}
/* 交接说明 函数 scalar_conv 结束后
 * 函数scalar_conv属于HLS计算及数据流。保留原实现，负责调用者所需的局部处理；输入输出及调用位置见本函数签名和正文。本次交接只新增说明，不改变活动语句。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */

static bool unit(const char *name, int ih, int iw, int ic, int oc, int real,

                 int k, int s, int tr, int tc, bool residual, bool offsets, bool leaky,

                 int pad_override = -1) {

    layer_desc_t d = {};

    d.src_off = 0;

    // Keep the full source (including a channel offset) separate from output.

    // Larger fallback-width tests exceed the old fixed 64 KiB source slot.

    int source_bytes = (ic + (offsets ? 4 : 0)) * ih * iw;

    d.dst_off = ((source_bytes + 65535) / 65536) * 65536;

    d.add_off = residual ? d.dst_off : -1;

    d.ih = ih; d.iw = iw; d.ic = ic; d.oc = oc; d.oc_real = real;

    d.k = k; d.s = s; d.pad = pad_override < 0 ? k / 2 : pad_override;

    d.act = leaky ? ACT_LEAKY : ACT_NONE;

    d.up = 1; d.type = LT_CONV; d.tile_r = tr; d.tile_c = tc;

    d.oh = (ih + 2 * d.pad - k) / s + 1;

    d.ow = (iw + 2 * d.pad - k) / s + 1;

    d.src_ch_off = offsets ? 4 : 0;

    d.dst_ch_off = offsets ? 8 : 0; d.add_ch_off = d.dst_ch_off;

    // HLS wrapc copies the full declared interface depth, even for tiny ops.

    Bytes initial(rtl_smoke ? 2097152 : 262144);

    Bytes weights(rtl_smoke ? 262144 : oc * ic * k * k);

    for (size_t i = 0; i < initial.size(); ++i) initial[i] = (int8_t)(rnd() & 255);

    for (size_t i = 0; i < weights.size(); ++i) weights[i] = (int8_t)((int)(rnd() % 15) - 7);

    std::vector<int32_t> rq(rtl_smoke ? 16384 : oc * 3);

    for (int c = 0; c < oc; ++c) {

        rq[c * 3] = (int)(rnd() % 40001) - 20000;

        rq[c * 3 + 1] = 65536 + (rnd() & 65535);

        rq[c * 3 + 2] = 20 + c % 3;

    }

    Bytes actual = initial, old = initial, golden = initial;

    std::vector<int32_t> table(rtl_smoke ? 16384 : 16);

    int op_index = rtl_smoke && k == 3 ? 3 : 0;

    memcpy(table.data() + op_index * 16, &d, sizeof(d));

    run_r61(actual.data(), weights.data(), rq.data(), table.data(), op_index, 1);

    yolov5n_top_r5(old.data(), weights.data(), rq.data(), table.data(), op_index, 1);

    scalar_conv(initial, golden, weights, rq, d);

    if (!same(actual, golden, name) || !same(actual, old, name)) return false;

    printf("PASS scalar+R5: %s\n", name); fflush(stdout);

    return true;

}
/* 交接说明 函数 unit 结束后
 * 函数unit属于HLS计算及数据流。保留原实现，负责调用者所需的局部处理；输入输出及调用位置见本函数签名和正文。本次交接只新增说明，不改变活动语句。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */

static bool read_blob(const char *dir, const char *name, Bytes &out) {

    char path[2048]; snprintf(path, sizeof(path), "%s/%s", dir, name);

    FILE *f = fopen(path, "rb");

    if (!f) { printf("FAIL cannot open %s\n", path); return false; }

    fseek(f, 0, SEEK_END); long n = ftell(f); rewind(f);

    if (n <= 0) { fclose(f); return false; }

    out.resize((size_t)n);

    bool ok = fread(out.data(), 1, out.size(), f) == out.size(); fclose(f); return ok;

}
/* 交接说明 函数 read_blob 结束后
 * 函数read_blob属于HLS计算及数据流。保留原实现，负责调用者所需的局部处理；输入输出及调用位置见本函数签名和正文。本次交接只新增说明，不改变活动语句。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */

static bool model(const char *dir) {

    Bytes wb, rb, db;

    if (!read_blob(dir, "weights.bin", wb) || !read_blob(dir, "rqt.bin", rb) ||

        !read_blob(dir, "layers.bin", db)) return false;

    if (wb.size() != 724544 || rb.size() != 36096 || db.size() != 84 * 64) {

        printf("FAIL model blob sizes\n"); return false;

    }

    std::vector<int32_t> rq(rb.size() / 4), tbl(db.size() / 4);

    memcpy(rq.data(), rb.data(), rb.size()); memcpy(tbl.data(), db.data(), db.size());
    // Same RAM26 kernel: only runtime COPY descriptors use a64-column tile.
    for(int op=0;op<84;++op){
        layer_desc_t d;memcpy(&d,tbl.data()+op*16,sizeof(d));
        if(d.type==LT_COPY){d.tile_c=64;memcpy(tbl.data()+op*16,&d,sizeof(d));}
    }

    for (int frame = 0; frame < 2; ++frame) {

        Bytes actual(5745408, (int8_t)0x5a), old;

        for (int y = 0; y < 384; ++y) for (int x = 0; x < 512; ++x)

            for (int c = 0; c < 4; ++c)

                actual[c4(c, y, x, 384, 512)] = c == 3 ? 0 : (int8_t)(rnd() & 255);

        old = actual;

        Bytes batch = actual;

        for (int op = 0; op < 84; ++op) {

            run_r61(actual.data(), wb.data(), rq.data(), tbl.data(), op, 1);

            yolov5n_top_r5(old.data(), wb.data(), rq.data(), tbl.data(), op, 1);

            char label[100]; snprintf(label, sizeof(label), "model frame=%d op=%d", frame, op);

            if (!same(actual, old, label)) return false;

        }

        run_r61(batch.data(), wb.data(), rq.data(), tbl.data(), 0, 84);

        if (!same(batch, actual, "84-op batch versus 84 single calls")) return false;

        printf("PASS batch 0..83 and marker CALL_END\n");

        printf("PASS real model frame=%d: all 84 ops, entire 5745408-byte arena identical\n", frame);

        fflush(stdout);

    }

    return true;

}
/* 交接说明 函数 model 结束后
 * 函数model属于HLS计算及数据流。保留原实现，负责调用者所需的局部处理；输入输出及调用位置见本函数签名和正文。本次交接只新增说明，不改变活动语句。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */

static bool native64_nonconv(const char *name, int type, int up) {
    layer_desc_t d = {};
    d.src_off = 0; d.dst_off = 65536; d.add_off = -1;
    d.ih = 5; d.iw = 67; d.ic = 8; d.oc = 8; d.oc_real = 8;
    d.oh = d.ih * up; d.ow = d.iw * up;
    d.src_ch_off = 4; d.dst_ch_off = 8;
    d.k = 3; d.s = 1; d.pad = 1; d.act = ACT_NONE;
    d.up = up; d.type = type; d.tile_r = up == 2 ? 4 : 3; d.tile_c = type == LT_COPY ? 64 : 16;
    Bytes initial(2097152), weights(262144);
    for (size_t i = 0; i < initial.size(); ++i) initial[i] = (int8_t)(rnd() & 255);
    Bytes actual = initial, old = initial, golden = initial;
    std::vector<int32_t> rq(16384), table(16384);
    memcpy(table.data(), &d, sizeof(d));
    run_r61(actual.data(), weights.data(), rq.data(), table.data(), 0, 1);
    yolov5n_top_r5(old.data(), weights.data(), rq.data(), table.data(), 0, 1);
    for (int c = 0; c < d.ic; ++c) for (int y = 0; y < d.oh; ++y)
        for (int x = 0; x < d.ow; ++x) {
            int value = -128;
            if (type == LT_COPY) {
                value = initial[d.src_off + c4(d.src_ch_off+c,y/up,x/up,d.ih,d.iw)];
            } else {
                for (int ky = -1; ky <= 1; ++ky) for (int kx = -1; kx <= 1; ++kx) {
                    const int sy = y+ky, sx = x+kx;
                    if (sy >= 0 && sy < d.ih && sx >= 0 && sx < d.iw) {
                        const int v = initial[d.src_off + c4(d.src_ch_off+c,sy,sx,d.ih,d.iw)];
                        if (v > value) value = v;
                    }
                }
            }
            golden[d.dst_off + c4(d.dst_ch_off+c,y,x,d.oh,d.ow)] = (int8_t)value;
        }
    if (!same(actual, old, name) || !same(actual, golden, name)) return false;
    printf("PASS scalar+R5: %s\n", name); fflush(stdout);
    return true;
}
/* 交接说明 函数 native64_nonconv 结束后
 * 函数native64_nonconv属于HLS计算及数据流。保留原实现，负责调用者所需的局部处理；输入输出及调用位置见本函数签名和正文。本次交接只新增说明，不改变活动语句。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */

// Exercise sign boundaries in both the streamed1x1 and accumulator-bank3x3 paths.
// Independent int64 reference explicitly reproduces the EXISTING signed26 input
// to quantization; this also checks32-bit wrap because2^26 divides2^32.
static bool accumulator_boundary(int k) {
    layer_desc_t d = {};
    d.dst_off = 65536; d.add_off = -1;
    d.ih = d.oh = 3; d.iw = d.ow = 17;
    d.ic = d.oc = d.oc_real = 16;
    d.k = k; d.s = 1; d.pad = k / 2;
    d.type = LT_CONV; d.up = 1; d.tile_r = 2; d.tile_c = 16;
    Bytes input(rtl_smoke ? 2097152 : 262144, 127);
    Bytes weights(rtl_smoke ? 262144 : 16 * 16 * k * k);
    std::vector<int32_t> rq(rtl_smoke ? 16384 : 48);
    const int32_t edges[8] = {33554430,-33554430,67108860,-67108860,
                             2147483640,-2147483640,0,1};
    for (int co=0; co<16; ++co) {
        rq[co*3] = edges[co/2]; rq[co*3+1] = 1; rq[co*3+2] = 20;
        for (int ci=0; ci<16; ++ci) for(int ky=0;ky<k;++ky) for(int kx=0;kx<k;++kx) {
            size_t wi=((((ci/4*k+ky)*k+kx)*16+co)*4+ci%4);
            weights[wi] = (co&1) ? -128 : 127;
        }
    }
    Bytes actual=input, old=input, golden=input;
    std::vector<int32_t> table(rtl_smoke ? 16384 : 16);
    memcpy(table.data(), &d, sizeof(d));
    run_r61(actual.data(), weights.data(), rq.data(), table.data(), 0, 1);
    yolov5n_top_r5(old.data(), weights.data(), rq.data(), table.data(), 0, 1);
    for(int y=0;y<3;++y) for(int x=0;x<17;++x) for(int co=0;co<16;++co) {
        int64_t total=rq[co*3];
        for(int ci=0;ci<16;++ci) for(int ky=0;ky<k;++ky) for(int kx=0;kx<k;++kx) {
            int sy=y+ky-d.pad, sx=x+kx-d.pad;
            if(sy>=0&&sy<3&&sx>=0&&sx<17) total += 127*((co&1)?-128:127);
        }
        int64_t low=(int64_t)((uint64_t)total&0x3ffffffULL);
        if(low>=33554432LL) low-=67108864LL;
        int v=(int)((low+(low>=0?524288:-524288))>>20);
        golden[65536+c4(co,y,x,3,17)]=(int8_t)clip(v);
    }
    const char *name=k==1?"acc26 boundaries streamed1x1":"acc26 boundaries banked3x3";
    if(!same(actual,golden,name)||!same(actual,old,name)) return false;
    printf("PASS independent signed26 + frozen R5: %s\n",name); fflush(stdout);
    return true;
}
/* 交接说明 函数 accumulator_boundary 结束后
 * 函数accumulator_boundary属于HLS计算及数据流。保留原实现，负责调用者所需的局部处理；输入输出及调用位置见本函数签名和正文。本次交接只新增说明，不改变活动语句。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */

int main(int argc, char **argv) {

    if (argc == 2 && strcmp(argv[1], "--rtl-smoke") == 0) {

        rtl_smoke = true;

        bool ok = accumulator_boundary(1) && accumulator_boundary(3) && native64_nonconv("RTL native64 pool odd widths", LT_MAXPOOL, 1) && native64_nonconv("RTL native64 copy odd widths", LT_COPY, 1) && native64_nonconv("RTL native64 upsample odd source width", LT_COPY, 2) && unit("RTL wide64 tail multi-ob offsets", 2, 65, 4, 32, 24,

                       1, 1, 2, 16, false, true, true) &&

                  unit("RTL halo reuse and vertical transition residual", 5, 79, 4, 32, 24,

                       3, 1, 3, 16, true, true, false) &&

                  unit("RTL stride2 horizontal halo and tail", 9, 133, 4, 16, 16,

                       3, 2, 3, 16, false, true, true) &&

                  unit("RTL one block per row drain", 3, 9, 4, 16, 16,

                       1, 1, 2, 16, true, false, true) &&

                  unit("RTL pointwise paired64 IC16 OC16", 4, 128, 16, 16, 16,

                       1, 1, 2, 16, false, true, true) &&

                  unit("RTL pointwise multi-ob real24 tail", 3, 65, 32, 32, 24,

                       1, 1, 2, 16, false, true, false) &&

                  unit("RTL pointwise highIC192 tail", 2, 17, 192, 96, 96,

                       1, 1, 1, 16, false, false, true) &&

                  unit("RTL pointwise Detect real3", 3, 17, 32, 16, 3,

                       1, 1, 2, 16, false, true, false) &&

                  unit("RTL pointwise one block row", 3, 9, 4, 16, 16,

                       1, 1, 2, 16, false, false, true) &&

                  unit("RTL pointwise extra padded OB", 2, 9, 4, 64, 3,

                       1, 1, 1, 16, false, false, false);

        printf("R6.4 RTL SMOKE %s\n", ok ? "PASS" : "FAIL");

        return ok ? 0 : 1;

    }

    if (argc != 2) { printf("Usage: test <r5_testdata directory>\n"); return 2; }

    if (!accumulator_boundary(1) || !accumulator_boundary(3) || !unit("1x1 smoke", 4, 4, 4, 16, 16, 1, 1, 4, 4, false, false, true) ||

        !unit("1x1 padded24 offsets tail", 13, 19, 24, 32, 24, 1, 1, 6, 10, false, true, true) ||

        !unit("3x3 s1 residual in-place", 13, 19, 16, 32, 24, 3, 1, 6, 10, true, true, true) ||

        !unit("stem s2 odd halo tail", 17, 33, 4, 16, 16, 3, 2, 8, 16, false, false, true) ||

        !unit("1x1 Detect real3 output", 7, 17, 32, 16, 3, 1, 1, 5, 16, false, true, false) ||

        !unit("1x1 SPPF ic192", 12, 16, 192, 96, 96, 1, 1, 12, 16, false, false, true) ||

        !unit("3x3 max layer weights", 12, 16, 64, 128, 128, 3, 1, 12, 16, false, false, true) ||

        !unit("3x3 s2 partial tile", 25, 31, 64, 128, 128, 3, 2, 12, 16, false, false, true) ||

        !unit("wide64 tail multi-ob offsets", 3, 131, 16, 32, 24, 1, 1, 3, 16, false, true, true) ||

        !unit("wide64 residual in-place", 5, 79, 16, 32, 24, 3, 1, 5, 16, true, true, true) ||

        !unit("capacity fallback32 stride2 tail", 33, 69, 16, 32, 24, 3, 2, 16, 16, false, true, true) ||

        !unit("capacity fallback16", 17, 79, 64, 64, 64, 3, 1, 16, 16, false, false, true) ||

        !unit("wide64 full output cache", 2, 65, 4, 128, 128, 1, 1, 2, 16, false, false, true) ||

        !unit("custom width80 capped64", 2, 81, 4, 32, 24, 1, 1, 2, 80, false, true, false) ||

        !unit("horizontal reuse and vertical reset", 9, 133, 4, 32, 24,

              3, 1, 3, 16, true, true, true) ||

        !unit("stride2 overlap1 next tile", 17, 259, 4, 16, 16,

              3, 2, 4, 16, false, true, true) ||

        !unit("one block per row residual", 5, 9, 4, 16, 16,

              1, 1, 2, 16, true, false, true) ||

        !unit("prefetch drain with short custom tile", 7, 9, 64, 16, 16,

              3, 1, 7, 1, false, false, true) ||

        !unit("pointwise paired64 IC16 OC16", 4, 128, 16, 16, 16,

              1, 1, 2, 16, false, true, true) ||

        !unit("pointwise stride2 fallback", 9, 19, 16, 32, 24,

              1, 2, 3, 16, false, true, true) ||

        !unit("pointwise pad1 fallback", 5, 9, 16, 16, 16,

              1, 1, 3, 16, false, false, true, 1) ||

        !unit("pointwise one pixel custom tile", 3, 7, 32, 32, 24,

              1, 1, 1, 1, false, true, false) ||

        !unit("pointwise extra padded OB", 2, 9, 4, 64, 3,

              1, 1, 1, 16, false, false, false) ||

        !unit("pointwise full OC128 paired rows", 3, 129, 16, 128, 128,

              1, 1, 2, 16, false, true, true)) return 1;

    // Empty/clamped calls must not dereference any DDR pointer.

    run_r61(0, 0, 0, 0, 0, 0);

    run_r61(0, 0, 0, 0, 84, 10);

    run_r61(0, 0, 0, 0, -3, -1);

    layer_desc_t invalid = {}; invalid.type = 255;

    int32_t bad_table[16]; memcpy(bad_table, &invalid, sizeof(invalid));

    run_r61(0, 0, 0, bad_table, 0, 1);

    if (!model(argv[1])) return 1;

    printf("R6.4 REGRESSION PASS: 26 scalar/boundary cases + 2 real-model frames x 84 ops\n");

    return 0;

}
/* 交接说明 函数 main 结束后
 * 本核运行入口。CPU0负责硬件初始化、相机、预处理、调度与串口；CPU1负责输出失效、检测头后处理与三缓冲提交。必须配对启动两个核。
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

/* 交接补充
 * 本次仅补充中文职责和历史替换说明；活动表达式、寄存器、延时和默认返回值均保留。未删除的历史代码不伪造删除块。
 */
