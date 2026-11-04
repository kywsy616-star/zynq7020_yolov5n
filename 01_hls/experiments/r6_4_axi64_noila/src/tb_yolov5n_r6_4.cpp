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
static void run_r61(const int8_t *a, const int8_t *w, const int32_t *r,
                    const int32_t *t, int start, int n) {
    yolov5n_top(a, w, r, t, start, n);
}
static size_t c4(int c, int y, int x, int h, int w) {
    return ((((size_t)c >> 2) * h + y) * w + x) * 4 + (c & 3);
}
static int clip(int v) { return v < -128 ? -128 : v > 127 ? 127 : v; }
static bool same(const Bytes &a, const Bytes &b, const char *where) {
    if (a == b) return true;
    for (size_t i = 0; i < a.size(); ++i) if (a[i] != b[i]) {
        printf("FAIL %s byte=%lu actual=%d expected=%d\n", where, (unsigned long)i, (int)a[i], (int)b[i]);
        break;
    }
    return false;
}
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
static bool read_blob(const char *dir, const char *name, Bytes &out) {
    char path[2048]; snprintf(path, sizeof(path), "%s/%s", dir, name);
    FILE *f = fopen(path, "rb");
    if (!f) { printf("FAIL cannot open %s\n", path); return false; }
    fseek(f, 0, SEEK_END); long n = ftell(f); rewind(f);
    if (n <= 0) { fclose(f); return false; }
    out.resize((size_t)n);
    bool ok = fread(out.data(), 1, out.size(), f) == out.size(); fclose(f); return ok;
}
static bool model(const char *dir) {
    Bytes wb, rb, db;
    if (!read_blob(dir, "weights.bin", wb) || !read_blob(dir, "rqt.bin", rb) ||
        !read_blob(dir, "layers.bin", db)) return false;
    if (wb.size() != 724544 || rb.size() != 36096 || db.size() != 84 * 64) {
        printf("FAIL model blob sizes\n"); return false;
    }
    std::vector<int32_t> rq(rb.size() / 4), tbl(db.size() / 4);
    memcpy(rq.data(), rb.data(), rb.size()); memcpy(tbl.data(), db.data(), db.size());
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
int main(int argc, char **argv) {
    if (argc == 2 && strcmp(argv[1], "--rtl-smoke") == 0) {
        rtl_smoke = true;
        bool ok = unit("RTL wide64 tail multi-ob offsets", 2, 65, 4, 32, 24,
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
    if (!unit("1x1 smoke", 4, 4, 4, 16, 16, 1, 1, 4, 4, false, false, true) ||
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
    printf("R6.4 REGRESSION PASS: 24 scalar cases + 2 real-model frames x 84 ops\n");
    return 0;
}
