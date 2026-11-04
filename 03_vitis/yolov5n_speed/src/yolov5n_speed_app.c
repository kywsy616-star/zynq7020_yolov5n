/*

 * yolov5n_speed_app.c -- everything the PS does around the accelerator.

 *

 *   1. preprocess : 800x480 RGB888 frame -> centre crop 640x480 -> bilinear

 *      down to 512x384 -> int8 with the model's input quantisation

 *      (q = round(v*255) - 128, i.e. simply  pixel - 128) written as the

 *      c4 packed input tensor [1][384][512][4] (4th lane left at 0)

 *   2. postprocess: the detection head, exactly as quantize.py's numpy

 *      reference (refsim + detect_decode) does it -- DFL 16-bin softmax +

 *      expectation, class sigmoid, threshold, per-class NMS

 *   3. overlay    : rectangles drawn straight into the display frame buffer

 *

 * Every deviation from the Python reference here must be a *bug*: the numpy

 * model is the golden reference for the whole chain.

 */

#include <string.h>



#include "yolov5n_speed_app.h"



/* NOTE: this file deliberately does NOT include <math.h> and never calls

   expf().  Vitis links the application with

       -Wl,--start-group,-lxil,-lgcc,-lc,--end-group

   i.e. WITHOUT libm, so any libm call is an undefined reference at link time.

   The detection head needs exp() in exactly two places, and a self-contained

   float approximation is both sufficient (the logits are int8-quantised with

   a step of ~0.2, so 1e-5 of relative error is far below the quantisation

   noise) and several times faster on the Cortex-A9 than the library version. */



/* exp(x) as 2^(x*log2e) = 2^n * 2^f, n = floor, f in [0,1).

   Accuracy: |relative error| < 2e-6 over the range we use; the callers clamp

   the argument so the exponent never overflows a float. */

static float exp_approx(float x)

{

    const float LOG2E = 1.4426950408889634f;

    union { float f; int32_t i; } bits;

    float t, n, f, p;



    t = x * LOG2E;

    n = (float)(int)(t >= 0.0f ? t : t - 0.9999999f);   /* floor(t) */

    f = t - n;                                          /* [0,1) */



    /* 2^f, degree-6 series of exp(f*ln2); coefficients are (ln2)^k / k! */

    p = 1.0f

      + f * (0.6931472f

      + f * (0.2402265f

      + f * (0.0555041f

      + f * (0.0096181f

      + f * (0.0013334f

      + f *  0.0001540f)))));



    /* multiply by 2^n by writing the exponent field directly */

    bits.i = (int32_t)((n + 127.0f) * 8388608.0f);      /* (n + 127) << 23 */

    return p * bits.f;

}
/* 交接说明 函数 exp_approx 结束后
 * 后处理指数近似，供sigmoid和DFL概率计算；按原近似保留以确保现有数值一致，不在交接时换成不同数学库实现。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */



/* --------------------------------------------------------------- helpers --- */

static inline int clampi(int v, int lo, int hi)

{

    return v < lo ? lo : (v > hi ? hi : v);

}
/* 交接说明 函数 clampi 结束后
 * 将坐标或像素限制在给定整数边界，防止缩放、NMS和画框访问越过当前帧范围；不改变模型输出张量。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */



/* ---------------------------------------------------------- 1. preprocess --- */

/* The camera writes 24-bit RGB into DDR with a 2400 byte stride, but the

   **byte order inside a pixel is B, G, R** (byte0 = B) -- see the long

   comment above put_px().  The model was trained on RGB (R = channel 0), so

   the channel index has to be reversed here as well: model channel c reads

   framebuffer byte (2 - c).



   Centre-cropping 640 of the 800 columns keeps the 4:3 field the model was

   trained on.  The crop is free -- it is just the CROP_X0 offset added to the

   row pointer, nothing is copied.  640x480 is then scaled down by 0.8 to

   512x384 (scale_q = 1.25 source pixels per output pixel), the same factor on

   both axes so nothing is distorted; app_postprocess() undoes it with

   x/0.8 + CROP_X0.  Those two constants must stay reciprocal. */

void app_preprocess(const uint8_t *fb, int8_t *dst)

{

    /* 每走一个输出像素，源坐标前进 640/512 = 1.25 个像素（即整体缩小 0.8）。

       ★ 这里以前写的是 65536*4/5 = 0.8，方向反了：那样 `sx = 0.8*ox` 只会

         取到源的第 0..409 列、第 0..306 行，也就是模型只看到左上角

         409x307 的一小块被拉伸成 512x384；而 app_postprocess 用的反变换

         是 x/0.8 = 1.25x（那个是对的），两者差 1.5625 倍，框会越往右越偏。

         改成 1.25 之后前向 / 后向才自洽，模型看到的是完整的 640x480 裁剪区。 */

    const int scale_q = 65536 * 5 / 4;         /* 640/512 = 1.25 in Q16 */

    int oy, ox, c;

    int8_t *p = dst;                            /* walks the c4 packed image */



    for (oy = 0; oy < YOLO_IN_H; oy++) {

        int sy_q = oy * scale_q;

        int sy = sy_q >> 16;

        int fy = sy_q & 0xFFFF;

        const uint8_t *r0 = fb + (sy * CAM_W + CROP_X0) * 3;

        const uint8_t *r1 = r0 + CAM_W * 3;     /* next source row */

        if (sy >= CROP_H - 1) r1 = r0;



        for (ox = 0; ox < YOLO_IN_W; ox++) {

            int sx_q = ox * scale_q;

            int sx = sx_q >> 16;

            int fx = sx_q & 0xFFFF;

            const uint8_t *a = r0 + sx * 3;

            const uint8_t *b = r1 + sx * 3;

            for (c = 0; c < 3; c++) {

                /* 帧缓存是 B,G,R 字节序（见 put_px 上方的说明）：

                   模型通道 0 = R = 第 2 字节，通道 2 = B = 第 0 字节。

                   不换的话模型吃到的是 BGR，和训练时的 RGB 对不上。 */

                const int s = 2 - c;

                /* bilinear in 16.16 fixed point */

                int top = a[s] + (((int)a[s + 3] - (int)a[s]) * fx >> 16);

                int bot = b[s] + (((int)b[s + 3] - (int)b[s]) * fx >> 16);

                int v = top + ((bot - top) * fy >> 16);

                /* input quantisation: v is 0..255, q = v - 128 covers the

                   whole 8-bit range symmetrically (quantize.py forces the

                   input scale to 1/255 and folds the +128 offset into the

                   first conv's bias) */

                p[c] = (int8_t)(v - 128);

            }

            p[3] = 0;                            /* c4 padding lane */

            p += 4;

        }

    }

}
/* 交接说明 函数 app_preprocess 结束后
 * 摄像头800x480中间裁640x480，再缩为512x384；读取BGR字节并按RGB形成模型INT8 C4布局，保留训练/标定通道语义。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */



/* --------------------------------------------------------- 2. postprocess --- */

typedef struct { float x1, y1, x2, y2, conf; int cls; } det_t;



static float iou_xyxy(const det_t *a, const det_t *b)

{

    float x1 = a->x1 > b->x1 ? a->x1 : b->x1;

    float y1 = a->y1 > b->y1 ? a->y1 : b->y1;

    float x2 = a->x2 < b->x2 ? a->x2 : b->x2;

    float y2 = a->y2 < b->y2 ? a->y2 : b->y2;

    float iw = x2 - x1, ih = y2 - y1, inter, ua;

    if (iw <= 0.0f || ih <= 0.0f) return 0.0f;

    inter = iw * ih;

    ua = (a->x2 - a->x1) * (a->y2 - a->y1) + (b->x2 - b->x1) * (b->y2 - b->y1) - inter;

    return ua > 0.0f ? inter / ua : 0.0f;

}
/* 交接说明 函数 iou_xyxy 结束后
 * 计算两轴对齐检测框交并比，用于同类别NMS；处理无交集和无效面积，避免除零。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */



static float sigmoidf(float x)

{

    /* the clamp also keeps exp_approx's exponent in range: exp(30) = 1.07e13

       is still a perfectly normal float */

    if (x < -30.0f) return 0.0f;

    if (x >  30.0f) return 1.0f;

    return 1.0f / (1.0f + exp_approx(-x));

}
/* 交接说明 函数 sigmoidf 结束后
 * 把分类logit转为置信度，沿用exp近似与原数值范围；CONF_THR属于CPU1后处理，不是HLS量化激活。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */



/* Channel `c` of pixel (y,x) inside a c4 packed plane.

   The layout is [C/4][H][W][4], so consecutive CHANNELS of one pixel live

   H*W words apart -- they are NOT contiguous bytes.  Getting this wrong reads

   a neighbouring channel group and silently destroys the decode. */

static inline const int8_t *c4_px(const int8_t *plane, int c, int y, int x,

                                  int h, int w)

{

    return plane + (((size_t)(c >> 2) * h + y) * w + x) * 4 + (c & 3);

}



/* decode one pyramid level into `cand`, returns how many anchors passed */

static int decode_level(const int8_t *plane, int h, int w,

                        int stride, float scale, float conf_thr,

                        det_t *cand, int max_cand)

{

    int n = 0, y, x, s, side, bin;

    for (y = 0; y < h; y++) {

        for (x = 0; x < w; x++) {

            /* cls = channels 64..66 of this plane (64/4 = group 16, lanes 0..2) */

            float best = 0.0f;

            int bestc = 0;

            for (s = 0; s < YOLO_NC; s++) {

                float p = sigmoidf((float)*c4_px(plane, 64 + s, y, x, h, w) * scale);

                if (p > best) { best = p; bestc = s; }

            }

            if (best >= conf_thr && n < max_cand) {

                float ax = (x + 0.5f) * stride;

                float ay = (y + 0.5f) * stride;

                float d[4];

                for (side = 0; side < 4; side++) {

                    /* DFL: softmax over the 16 bins of this side */

                    float mx = -1e30f, sum = 0.0f, acc = 0.0f;

                    for (bin = 0; bin < YOLO_REG_MAX; bin++) {

                        float v = (float)*c4_px(plane, side * YOLO_REG_MAX + bin,

                                                y, x, h, w) * scale;

                        if (v > mx) mx = v;

                    }

                    for (bin = 0; bin < YOLO_REG_MAX; bin++) {

                        float v = (float)*c4_px(plane, side * YOLO_REG_MAX + bin,

                                                y, x, h, w) * scale;

                        float e = exp_approx(v - mx);   /* v - mx <= 0 always */

                        sum += e;

                        acc += e * (float)bin;

                    }

                    d[side] = (acc / sum) * stride;

                }

                cand[n].x1 = ax - d[0];

                cand[n].y1 = ay - d[1];

                cand[n].x2 = ax + d[2];

                cand[n].y2 = ay + d[3];

                cand[n].conf = best;

                cand[n].cls = bestc;

                n++;

            }

        }

    }

    return n;

}
/* 交接说明 函数 decode_level 结束后
 * 解码某一P3/P4/P5尺度的C4特征，读取分类和4x16个DFL通道，结合stride恢复框坐标，筛选阈值后写候选数组。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */



static void nms_per_class(det_t *d, int n, float iou_thr, int keep[], int *nk, int max_out)

{

    static uint8_t used[4096];

    int i, k;

    *nk = 0;

    for (i = 0; i < n; i++) used[i] = 0;

    /* simple O(n^2) selection by descending confidence */

    while (*nk < max_out) {

        int best = -1;

        for (i = 0; i < n; i++)

            if (!used[i] && (best < 0 || d[i].conf > d[best].conf)) best = i;

        if (best < 0) break;

        keep[(*nk)++] = best;

        for (k = 0; k < n; k++)

            if (!used[k] && k != best && d[k].cls == d[best].cls &&

                iou_xyxy(&d[best], &d[k]) > iou_thr)

                used[k] = 1;

    }

}
/* 交接说明 函数 nms_per_class 结束后
 * 按类别和置信度抑制高IoU重复框，写保留索引，限制max_out；不能跨类无条件删框。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */



/* Arena offsets come from the generated header.  The planes are channel padded

   to a multiple of 4 (67 -> 68), which is why the class channels are sliced

   64..66 and never [64:]. */

int app_postprocess(const int8_t *arena, float conf_thr, float iou_thr,

                    int16_t out[][4], float *out_conf, int16_t *out_cls, int max_out)

{

    static det_t cand[4096];

    static int keep[64];

    const int8_t *pb = arena + YOLO_OUT_P3_OFF;

    const int8_t *pc = arena + YOLO_OUT_P4_OFF;

    const int8_t *pd = arena + YOLO_OUT_P5_OFF;

    int n = 0, nk = 0, i;



    n += decode_level(pb, YOLO_OUT_P3_H, YOLO_OUT_P3_W,

                      YOLO_STRIDE_P3, YOLO_OUT_P3_SCALE, conf_thr, &cand[n], 4096 - n);

    n += decode_level(pc, YOLO_OUT_P4_H, YOLO_OUT_P4_W,

                      YOLO_STRIDE_P4, YOLO_OUT_P4_SCALE, conf_thr, &cand[n], 4096 - n);

    n += decode_level(pd, YOLO_OUT_P5_H, YOLO_OUT_P5_W,

                      YOLO_STRIDE_P5, YOLO_OUT_P5_SCALE, conf_thr, &cand[n], 4096 - n);



    nms_per_class(cand, n, iou_thr, keep, &nk, max_out);

    if (nk > max_out) nk = max_out;



    for (i = 0; i < nk; i++) {

        det_t *d = &cand[keep[i]];

        /* model space (512x384) -> camera/display space; the crop removed

           CROP_X0 columns on each side, before the 0.8 scale */

        out[i][0] = (int16_t)clampi((int)(d->x1 / 0.8f) + CROP_X0, 0, DISP_W - 1);

        out[i][1] = (int16_t)clampi((int)(d->y1 / 0.8f), 0, DISP_H - 1);

        out[i][2] = (int16_t)clampi((int)(d->x2 / 0.8f) + CROP_X0, 0, DISP_W - 1);

        out[i][3] = (int16_t)clampi((int)(d->y2 / 0.8f), 0, DISP_H - 1);

        out_conf[i] = d->conf;

        out_cls[i] = (int16_t)d->cls;

    }

    return nk;

}
/* 交接说明 函数 app_postprocess 结束后
 * CPU端执行检测头解码、DFL16、分类置信度及NMS；不属于PL infer纯计算，阈值见CPU1主程序。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */



/* ------------------------------------------------------------- 3. overlay --- */

/* 类别的颜色，按**逻辑 RGB** 写（c[0]=R, c[1]=G, c[2]=B）。

   落到帧缓存时的字节序转换在 put_px() 里做，这里不要自己倒着写。 */

static const uint8_t kClsColor[3][3] = {

    {255,   0,   0},     /* crack            - red   */

    {  0,   0, 255},     /* alligator crack  - blue  */

    {  0, 255,   0},     /* pothole          - green */

};

static const char *kClsName[3] = { "crack", "alligator crack", "pothole" };



/* --- 8x8 bitmap font --------------------------------------------------------

   Rows run top to bottom, and **bit 7 is the LEFTMOST pixel** of that row

   (the usual 8x8 ROM-font convention: the MSB is painted first, i.e. on the

   left).  Sanity check: 'h' row 1 is 0x60 = 0b01100000 -> the two pixels at

   columns 1..2, which is the left stem of the 'h'.  With the opposite bit

   order that stem would land on the right and every glyph would come out

   mirrored.



   draw_char() therefore walks columns with (0x80u >> b), NOT (1u << b).

   Only the glyphs the labels below can produce are kept, so the table stays

   small and every entry is auditable.  Add a character here if you change the

   class names. */

typedef struct { char ch; uint8_t row[8]; } glyph_t;

static const glyph_t kFont[] = {

    { ' ', {0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00} },

    { '.', {0x00,0x00,0x00,0x00,0x00,0x0C,0x0C,0x00} },

    { '0', {0x3C,0x66,0x6E,0x76,0x66,0x66,0x3C,0x00} },

    { '1', {0x18,0x18,0x38,0x18,0x18,0x18,0x7E,0x00} },

    { '2', {0x3C,0x66,0x06,0x0C,0x30,0x60,0x7E,0x00} },

    { '3', {0x3C,0x66,0x06,0x1C,0x06,0x66,0x3C,0x00} },

    { '4', {0x06,0x0E,0x1E,0x66,0x7F,0x06,0x06,0x00} },

    { '5', {0x7E,0x60,0x7C,0x06,0x06,0x66,0x3C,0x00} },

    { '6', {0x3C,0x66,0x60,0x7C,0x66,0x66,0x3C,0x00} },

    { '7', {0x7E,0x66,0x0C,0x18,0x18,0x18,0x18,0x00} },

    { '8', {0x3C,0x66,0x66,0x3C,0x66,0x66,0x3C,0x00} },

    { '9', {0x3C,0x66,0x66,0x3E,0x06,0x66,0x3C,0x00} },

    { 'a', {0x00,0x00,0x3C,0x06,0x3E,0x66,0x3E,0x00} },

    { 'c', {0x00,0x00,0x3C,0x66,0x60,0x66,0x3C,0x00} },

    { 'e', {0x00,0x00,0x3C,0x66,0x7E,0x60,0x3C,0x00} },

    { 'g', {0x00,0x00,0x3E,0x66,0x66,0x3E,0x06,0x3C} },

    { 'h', {0x00,0x60,0x60,0x7C,0x66,0x66,0x66,0x00} },

    { 'i', {0x18,0x00,0x38,0x18,0x18,0x18,0x3C,0x00} },

    { 'k', {0x00,0x60,0x66,0x6C,0x78,0x6C,0x66,0x00} },

    { 'l', {0x00,0x38,0x18,0x18,0x18,0x18,0x3C,0x00} },

    { 'o', {0x00,0x00,0x3C,0x66,0x66,0x66,0x3C,0x00} },

    { 'p', {0x00,0x00,0x7C,0x66,0x66,0x7C,0x60,0x60} },

    { 'r', {0x00,0x00,0x6E,0x76,0x60,0x60,0x60,0x00} },

    { 't', {0x00,0x10,0x7C,0x10,0x10,0x14,0x18,0x00} },

};

#define NFONT ((int)(sizeof(kFont) / sizeof(kFont[0])))

#define FONT_W 8

#define FONT_H 8

#define TEXT_SCALE 2                  /* 16x16 px per character */



static const uint8_t *glyph_of(char ch)

{

    int i;

    for (i = 0; i < NFONT; i++)

        if (kFont[i].ch == ch) return kFont[i].row;

    return 0;                         /* unknown character -> nothing drawn */

}



/* --- 帧缓存的字节序：B, G, R ------------------------------------------------

   DDR 里的一个像素是 3 个字节，但顺序是 byte0=B, byte1=G, byte2=R，

   不是直觉上的 RGB。整条链路是自洽的（所以画面本身颜色是对的）：



     ov5640_to_lcd.v : tft_data = {R[7:0], G[7:0], B[7:0]}   (R 在最高字节)

         -> v_vid_in_axi4s + VDMA S2MM 按小端落进 DDR

         -> byte0 = tft_data[7:0]  = B

            byte1 = tft_data[15:8] = G

            byte2 = tft_data[23:16]= R

     hdmi_transmitter.v :

            .data_in(video_din[7:0])   -> blue_10bit    <<< byte0 是蓝

            .data_in(video_din[15:8])  -> green_10bit

            .data_in(video_din[23:16]) -> red_10bit



   所以往帧缓存里画东西时，**必须倒着写**。之前这里按 RGB 顺序写，

   结果 kClsColor 里的红 {255,64,64} 进了蓝通道，画出来是纯蓝的框。



   注意 app_preprocess() 读摄像头那一侧也吃同一个字节序（见那里的注释）。

   ------------------------------------------------------------------------ */

static void put_px(uint8_t *fb, int x, int y, const uint8_t *c)

{

    uint8_t *p;

    if (x < 0 || x >= DISP_W || y < 0 || y >= DISP_H) return;

    p = fb + (y * DISP_W + x) * 3;

    p[0] = c[2];                 /* byte0 -> TMDS blue  */

    p[1] = c[1];                 /* byte1 -> TMDS green */

    p[2] = c[0];                 /* byte2 -> TMDS red   */

}
/* 交接说明 函数 put_px 结束后
 * 将一个RGB定义颜色转为DDR中BGR字节次序写入指定像素，并检查显示边界；这是早期红蓝反色修复的具体位置。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */



static void fill_rect(uint8_t *fb, int x, int y, int w, int h, const uint8_t *c)

{

    int i, j;

    for (j = 0; j < h; j++)

        for (i = 0; i < w; i++)

            put_px(fb, x + i, y + j, c);

}
/* 交接说明 函数 fill_rect 结束后
 * 在目标帧内填充矩形，用于标签底色等，最终仍由put_px做颜色和边界处理；只能对已取得所有权的非frontbuffer调用。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */



static void draw_char(uint8_t *fb, int x, int y, char ch, const uint8_t *c, int s)

{

    const uint8_t *g = glyph_of(ch);

    int r, b, dx, dy;

    if (g == 0) return;

    for (r = 0; r < FONT_H; r++)

        for (b = 0; b < FONT_W; b++)

            /* bit 7 is the leftmost column (see the kFont comment), and `b`

               walks left->right, so the mask has to shift DOWN, not up.

               `1u << b` here mirrored every glyph horizontally -- the labels

               rendered as imageable-but-unreadable text on the HDMI output. */

            if (g[r] & (0x80u >> b))

                for (dy = 0; dy < s; dy++)

                    for (dx = 0; dx < s; dx++)

                        put_px(fb, x + b * s + dx, y + r * s + dy, c);

}
/* 交接说明 函数 draw_char 结束后
 * 按字模正确位序绘制单字符并支持缩放；旧把bit0当最左会镜像，最终按现有字库真实方向访问。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */



static void draw_text(uint8_t *fb, int x, int y, const char *s, const uint8_t *c, int sc)

{

    while (*s) {

        draw_char(fb, x, y, *s++, c, sc);

        x += FONT_W * sc;

    }

}
/* 交接说明 函数 draw_text 结束后
 * 逐字符调用字模绘制，移动笔位置实现标签；源文本和目标buffer必须有效，不修改正在扫描的front。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */



/* 0.8734 -> "0.87"  (integer arithmetic only: no libm on this target) */

static void fmt_conf(char *buf, float conf)

{

    int v = (int)(conf * 100.0f + 0.5f);

    if (v < 0)  v = 0;

    if (v > 99) v = 99;

    buf[0] = '0';

    buf[1] = '.';

    buf[2] = (char)('0' + v / 10);

    buf[3] = (char)('0' + v % 10);

    buf[4] = '\0';

}
/* 交接说明 函数 fmt_conf 结束后
 * 把置信度转换为标签短文本，控制缓冲长度与小数显示；不负责串口性能日志，也不参与推理计时。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */



void app_draw_boxes(uint8_t *fb, const int16_t boxes[][4], const int16_t *cls,

                    const float *conf, int n)

{

    static const uint8_t kWhite[3] = {255, 255, 255};

    int i, t, x, y;

    const int sc = TEXT_SCALE;

    const int barH = FONT_H * sc + 4;



    for (i = 0; i < n; i++) {

        int x1 = boxes[i][0], y1 = boxes[i][1];

        int x2 = boxes[i][2], y2 = boxes[i][3];

        int ci = ((int)cls[i] % 3 + 3) % 3;       /* clamp negative class ids */

        const uint8_t *c = kClsColor[ci];

        char label[48], cb[8];

        int lx, ly, lw, k;

        const char *nm;



        if (x2 <= x1 || y2 <= y1) continue;



        /* ---- 3-pixel thick frame ---- */

        for (t = 0; t < 3; t++) {

            for (x = x1; x <= x2; x++) {

                put_px(fb, x, y1 + t, c);

                put_px(fb, x, y2 - t, c);

            }

            for (y = y1; y <= y2; y++) {

                put_px(fb, x1 + t, y, c);

                put_px(fb, x2 - t, y, c);

            }

        }



        /* ---- label bar: "<class> <conf>" ---- */

        fmt_conf(cb, conf[i]);

        nm = kClsName[ci];

        for (k = 0; nm[k] && k < 34; k++) label[k] = nm[k];

        label[k++] = ' ';

        label[k++] = cb[0];

        label[k++] = cb[1];

        label[k++] = cb[2];

        label[k++] = cb[3];

        label[k] = '\0';



        lw = k * FONT_W * sc + 4;                  /* + 2 px padding each side */

        lx = x1;

        if (lx + lw > DISP_W - 1) lx = DISP_W - 1 - lw;

        if (lx < 0) lx = 0;



        ly = y1 - barH - 2;                        /* above the box ... */

        if (ly < 0) ly = y1 + 4;                   /* ... or inside it */

        if (ly + barH > DISP_H) ly = DISP_H - barH - 1;

        if (ly < 0) ly = 0;



        fill_rect(fb, lx, ly, lw, barH, c);

        draw_text(fb, lx + 2, ly + 2, label, kWhite, sc);

    }

}
/* 交接说明 函数 app_draw_boxes 结束后
 * 对非显示front缓存绘制检测框和标签，像素按DDR的BGR字节顺序写；修正镜像字模和通道顺序。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */


/*
 * 最终版交接说明 2026年10月27日
 * 文件角色：Vitis双核固件与视频外设
 * 本文件活动代码对应已验证R6.6 IP1.16 COLOR_AWB，交接阶段不增加算法。
 * 依赖：HLS2020.2或Vitis2020.2，具体目录和构建顺序见根目录上板运行操作步骤。
 * 修改要求：保持C4布局、64B描述符、量化截断顺序、双核共享内存和缓冲所有权。
 * 删除/替换记录：下方仅在确有前驱差异时保存禁用旧代码；不虚构曾删除的代码。
 */

/* 交接补充
 * 本次仅补充中文职责和历史替换说明；活动表达式、寄存器、延时和默认返回值均保留。未删除的历史代码不伪造删除块。
 */

/* 指针返回辅助函数交接
 * c4_px：按通道组、行列和lane算C4像素地址；使用同一布局解码P3/P4/P5。
 * glyph_of：按字符查找字库，返回字模指针；未知字符采用既定回退，不能反转字模位序。
 */
