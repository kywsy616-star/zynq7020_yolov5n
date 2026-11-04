/*
 * CPU1 AMP consumer: completed arena -> postprocess -> frozen frame -> display.
 * CPU0 owns PL Start/IsDone. CPU1 never touches AP_CTRL or the capture ring.
 *
 * boot.S and xil-crt0.S in THIS application select USE_AMP=1 for startup only,
 * preserving CPU0's L2 controller and global timer. Keep BSP cache range
 * routines enabled: our DDR/PL handoffs need both L1 and L2 maintenance.
 */
#include <string.h>

#include "xil_cache.h"
#include "xil_io.h"
#include "xparameters.h"
#include "xaxivdma_hw.h"
#include "xil_mmu.h"
#include "xil_types.h"
#include "xtime_l.h"
#include "yolov5n_speed_app.h"
#include "dual_core_shared.h"

#define C4_BYTES(ch, h, w) ((((ch) + 3) / 4) * (h) * (w) * 4)
#define OUT_P3_BYTES C4_BYTES(YOLO_OUT_P3_CH, YOLO_OUT_P3_H, YOLO_OUT_P3_W)
#define OUT_P4_BYTES C4_BYTES(YOLO_OUT_P4_CH, YOLO_OUT_P4_H, YOLO_OUT_P4_W)
#define OUT_P5_BYTES C4_BYTES(YOLO_OUT_P5_CH, YOLO_OUT_P5_H, YOLO_OUT_P5_W)
#define CONF_THR     0.50f
#define IOU_THR      0.45f
#define MAX_DET      32
#define FPS_WINDOW  16u

static int16_t boxes[MAX_DET][4];
static float bconf[MAX_DET];
static int16_t bcls[MAX_DET];

static u32 elapsed_us(XTime start, XTime end)
{
    return (u32)(((u64)(end - start) * 1000000ULL) / COUNTS_PER_SECOND);
}
/* 交接说明 函数 elapsed_us 结束后
 * 把两个全局计时器tick差转换成u32微秒，乘法用u64防止中间溢出；该函数只负责换算，字段边界由调用位置决定。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */

static u32 fps_milli(u32 intervals, XTime ticks)
{
    u64 numerator = (u64)intervals * (u64)COUNTS_PER_SECOND * 1000ULL;
    return ticks ? (u32)((numerator + ticks / 2u) / ticks) : 0u;
}
/* 交接说明 函数 fps_milli 结束后
 * 以窗口间隔数量和实际tick差计算千分FPS，使用64位分子并四舍五入；打印时除1000拆成整数和三位小数。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */

static void cpu1_halt(u32 error)
{
    DUAL_CTRL->cpu1_error = error;
    DUAL_CTRL->cpu1_state = error ? CPU1_STATE_DEADLOOP : CPU1_STATE_STOPPED;
    __asm__ volatile ("dsb sy\n\tsev" ::: "memory");
    while (1) { __asm__ volatile ("wfe"); }
}
/* 交接说明 函数 cpu1_halt 结束后
 * CPU1发布错误和停止状态后执行DSB与SEV，再WFE停驻；这是错误处理，不是正常采集等待路径，CPU0可据状态停止pipeline。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */

/* No ABI fields are moved. Private video diagnostics occupy unused OCM. */
typedef struct {
    u32 magic, submitted, confirmed, rendering, target, current;
    u32 violations, last_wait_us, max_wait_us, errors;
} video_probe_t;
#define VIDEO_PROBE ((volatile video_probe_t *)0xFFFF0200u)
#define VIDEO_COUNT 3u
#define VIDEO_VDMA XPAR_AXI_VDMA_0_BASEADDR

static u32 video_current(void)
{
    return (Xil_In32(VIDEO_VDMA + XAXIVDMA_PARKPTR_OFFSET) &
            XAXIVDMA_PARKPTR_READSTR_MASK) >> XAXIVDMA_READSTR_SHIFT;
}
/* 交接说明 函数 video_current 结束后
 * 从VDMA PARK_PTR当前READSTR位读实际显示store。它是硬件已生效状态，不等同于软件写入的下一帧请求索引。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */

static void video_fault(u32 reason)
{
    VIDEO_PROBE->violations++;
    VIDEO_PROBE->errors = reason;
    __asm__ volatile ("dsb sy" ::: "memory");
    cpu1_halt(DUAL_ERROR_CAPTURE);
}
/* 交接说明 函数 video_fault 结束后
 * 更新显示所有权诊断及错误状态，避免越界或重用当前front时悄悄继续。若此计数非0须先排查地址/ACK而非降低置信度。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */

static void video_present(u32 next)
{
    u32 park, waited, status;
    XTime begin, now;
    VIDEO_PROBE->target = next;
    VIDEO_PROBE->submitted++;
    /* Both cores modify PARK_PTR. Serialize its RMW with CPU0's capture
     * parking, but never hold the lock while waiting for a frame boundary. */
    dual_cache_enter(1);
    park = Xil_In32(VIDEO_VDMA + XAXIVDMA_PARKPTR_OFFSET);
    Xil_Out32(VIDEO_VDMA + XAXIVDMA_PARKPTR_OFFSET,
              (park & ~XAXIVDMA_PARKPTR_READREF_MASK) | next);
    __asm__ volatile ("dsb sy" ::: "memory");
    dual_cache_leave(1);
    XTime_GetTime(&begin);
    while (video_current() != next) {
        status = Xil_In32(VIDEO_VDMA + XAXIVDMA_SR_OFFSET);
        if (status & (XAXIVDMA_SR_ERR_ALL_MASK | XAXIVDMA_SR_HALTED_MASK))
            video_fault(status);
        if (DUAL_CTRL->stop_requested) cpu1_halt(DUAL_ERROR_NONE);
        XTime_GetTime(&now);
        if (elapsed_us(begin, now) >= 1000000u) video_fault(0x80000001u);
    }
    __asm__ volatile ("dsb sy" ::: "memory");
    XTime_GetTime(&now);
    waited = elapsed_us(begin, now);
    VIDEO_PROBE->last_wait_us = waited;
    if (waited > VIDEO_PROBE->max_wait_us) VIDEO_PROBE->max_wait_us = waited;
    VIDEO_PROBE->current = next;
    VIDEO_PROBE->rendering = 0xFFFFFFFFu;
    VIDEO_PROBE->confirmed++;
}
/* 交接说明 函数 video_present 结束后
 * 将已绘制并flush的非front显示buffer提交给VDMA，修改park读索引并等待READSTR确认。确认后才释放前一frame，保证扫描过程中CPU不覆盖front。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */

/* Non-cacheable OCM journal: 512 records, 16 words each, no UART traffic.
 * Host freezes only this journal, never the video pipeline or either CPU. */
#define TRACE_HEADER ((volatile u32 *)0xFFFF1000u)
#define TRACE_RECORD ((volatile u32 *)0xFFFF2000u)
static void trace_frame(const dual_perf_stats_t *s, XTime prepared, XTime end)
{
    volatile u32 *r;
    u32 n;
    if (TRACE_HEADER[3]) { TRACE_HEADER[4] = 1u; return; }
    n = TRACE_HEADER[2];
    r = TRACE_RECORD + (n % 512u) * 16u;
    r[0]=s->frame_id; r[1]=s->infer_us; r[2]=s->period_us;
    r[3]=s->pre_us; r[4]=s->capture_us; r[5]=s->capture_wait_us;
    r[6]=s->prepare_us; r[7]=s->pl_gap_us; r[8]=s->start_period_us;
    r[9]=s->post_total_us; r[10]=VIDEO_PROBE->last_wait_us;
    r[11]=s->draw_us; r[12]=(u32)prepared; r[13]=(u32)(prepared>>32);
    r[14]=(u32)end; r[15]=(u32)(end>>32);
    __asm__ volatile ("dmb sy" ::: "memory");
    TRACE_HEADER[2]=n+1u;
}
/* 交接说明 函数 trace_frame 结束后
 * 新增逐帧内存日志，不通过慢串口逐帧输出。512条16字环形记录，冻结请求只停止日志，视频继续；导出时避免干扰正在测量的CPU0。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */
int main(void)
{
    u32 completed = 0;
    u32 front = 0, back = 1;
    u32 window_intervals = 0, window_id = 0;
    u32 average_fps = 0, average_period_us = 0;
    int have_completion = 0;
    XTime previous_completion = 0, window_begin = 0;

    /* No shared access before this mapping; per-field cache operations could
     * otherwise overwrite the other CPU's flags on the same cache line.
     * CPU0 is waiting for cpu1_ready, so startup's full cache flush is safe.
     */
    Xil_SetTlbAttributes((INTPTR)OCM_CTRL_ADDR, NORM_NONCACHE);
    DUAL_CTRL->cpu1_state = CPU1_STATE_BOOT;
    DUAL_CTRL->cpu1_state = CPU1_STATE_WAIT_MAGIC;
    while (DUAL_CTRL->magic != DUAL_CORE_MAGIC) { }
    dual_core_barrier();
    if (DUAL_CTRL->version != DUAL_CORE_VERSION)
        cpu1_halt(DUAL_ERROR_PROTOCOL);

    DUAL_CTRL->cpu1_error = DUAL_ERROR_NONE;
    DUAL_CTRL->cpu1_state = CPU1_STATE_WAIT_CPU0;
    while (!DUAL_CTRL->cpu0_ready) {
        if (DUAL_CTRL->stop_requested) cpu1_halt(DUAL_ERROR_NONE);
    }
    dual_core_barrier();
    if (DUAL_CTRL->stop_requested) cpu1_halt(DUAL_ERROR_NONE);

    memset((void *)VIDEO_PROBE, 0, sizeof(*VIDEO_PROBE));
    VIDEO_PROBE->magic = 0x56494433u;
    TRACE_HEADER[0]=0x43545243u; TRACE_HEADER[1]=512u;
    TRACE_HEADER[2]=0u; TRACE_HEADER[3]=0u; TRACE_HEADER[4]=0u;
    VIDEO_PROBE->rendering = 0xFFFFFFFFu;
    if ((Xil_In32(VIDEO_VDMA + XAXIVDMA_CR_OFFSET) & XAXIVDMA_CR_TAIL_EN_MASK) || video_current() != 0u)
        video_fault(0x80000002u);
    DUAL_CTRL->cpu1_state = CPU1_STATE_READY;
    dual_core_barrier();
    DUAL_CTRL->cpu1_ready = 1u;

    while (1) {
        unsigned i;
        int slot = -1, ndet;
        const int8_t *arena;
        const uint8_t *snapshot;
        uint8_t *display;
        u32 frame_id;
        dual_perf_stats_t sample = {0};
        XTime begin, decoded_begin, decoded_end, end, prepared_begin;

        DUAL_CTRL->cpu1_state = CPU1_STATE_FIND_SLOT;
        while (slot < 0) {
            if (DUAL_CTRL->stop_requested) cpu1_halt(DUAL_ERROR_NONE);
            /* If both have completed, preserve submission order, even across
             * slot-number alternation or a wrapping 32-bit frame counter.
             */
            for (i = 0; i < DUAL_SLOT_COUNT; ++i) {
                if (DUAL_CTRL->slot_state[i] == SLOT_POST_READY) {
                    dual_core_barrier();
                    if (slot < 0 || (int32_t)(DUAL_CTRL->frame_id[i] -
                                             DUAL_CTRL->frame_id[slot]) < 0)
                        slot = (int)i;
                }
            }
            /* CPU0 publishes POST_READY with DSB/SEV. An event sent between
             * this scan and WFE remains latched, so no wakeup is lost.
             * Recheck both state and stop_requested after every wakeup.
             */
            if (slot < 0) __asm__ volatile ("wfe" ::: "memory");
        }

        dual_core_barrier();
        dual_publish_slot((unsigned)slot, SLOT_POSTING);
        frame_id = DUAL_CTRL->frame_id[slot];
        sample.frame_id = frame_id;
        sample.pre_us = DUAL_CTRL->timing[slot].pre_us;
        sample.capture_us = DUAL_CTRL->timing[slot].capture_us;
        sample.capture_wait_us = DUAL_CTRL->timing[slot].capture_wait_us;
        sample.prepare_us = DUAL_CTRL->timing[slot].prepare_us;
        sample.infer_us = DUAL_CTRL->timing[slot].infer_us;
        sample.pl_gap_us = DUAL_CTRL->timing[slot].pl_gap_us;
        sample.start_period_us = DUAL_CTRL->timing[slot].start_period_us;
        prepared_begin = ((XTime)DUAL_CTRL->timing[slot].begin_ticks_hi << 32) |
                         (XTime)DUAL_CTRL->timing[slot].begin_ticks_lo;
        arena = (const int8_t *)DUAL_CTRL->arena_addr[slot];
        snapshot = (const uint8_t *)DUAL_CTRL->snapshot_addr[slot];
        back = (front + 1u) % VIDEO_COUNT;
        if (video_current() != front || back == front) video_fault(0x80000003u);
        VIDEO_PROBE->rendering = back;
        display = (uint8_t *)(DUAL_CTRL->disp_base + back * FB_BYTES);

        XTime_GetTime(&begin);
        DUAL_CTRL->cpu1_state = CPU1_STATE_POSTING;
        dual_cache_enter(1);
        Xil_DCacheInvalidateRange((u32)(arena + YOLO_OUT_P3_OFF), OUT_P3_BYTES);
        Xil_DCacheInvalidateRange((u32)(arena + YOLO_OUT_P4_OFF), OUT_P4_BYTES);
        Xil_DCacheInvalidateRange((u32)(arena + YOLO_OUT_P5_OFF), OUT_P5_BYTES);
        Xil_DCacheInvalidateRange((u32)snapshot, FB_BYTES);
        dual_cache_leave(1);

        XTime_GetTime(&decoded_begin);
        ndet = app_postprocess(arena, CONF_THR, IOU_THR,
                              boxes, bconf, bcls, MAX_DET);
        XTime_GetTime(&decoded_end);

        /* This is the exact picture used for this slot's preprocessing.
         * A live VDMA frame index would be ~one inference (~378 ms) newer.
         */
        DUAL_CTRL->cpu1_state = CPU1_STATE_DRAWING;
        memcpy(display, snapshot, FB_BYTES);
        app_draw_boxes(display, boxes, bcls, bconf, ndet);
        dual_cache_enter(1);
        Xil_DCacheFlushRange((u32)display, FB_BYTES);
        dual_cache_leave(1);
        __asm__ volatile ("dsb sy" ::: "memory");
        video_present(back);
        front = back;
        XTime_GetTime(&end);
        sample.invalidate_us = elapsed_us(begin, decoded_begin);
        sample.post_us = elapsed_us(decoded_begin, decoded_end);
        sample.draw_us = elapsed_us(decoded_end, end);
        sample.post_total_us = elapsed_us(begin, end);
        sample.latency_us = elapsed_us(prepared_begin, end);

        /* Measure display COMPLETIONS on this CPU, not when CPU0 happens to
         * observe the counter. A 16-interval window excludes startup latency.
         * Neither fps nor average fps uses pre+infer+post (stages overlap).
         */
        if (!have_completion) {
            have_completion = 1;
            window_begin = end;
        } else {
            XTime interval = end - previous_completion;
            sample.period_us = elapsed_us(previous_completion, end);
            sample.fps_milli = fps_milli(1u, interval);
            if (++window_intervals == FPS_WINDOW) {
                average_fps = fps_milli(FPS_WINDOW, end - window_begin);
                average_period_us = elapsed_us(window_begin, end) / FPS_WINDOW;
                window_intervals = 0;
                window_begin = end;
                ++window_id;
            }
        }
        previous_completion = end;
        sample.avg_fps_milli = average_fps;
        sample.avg_period_us = average_period_us;
        sample.fps_window_id = window_id;
        sample.done_count = ++completed;
        trace_frame(&sample, prepared_begin, end);

        /* Sequence lock prevents mixed-frame statistics, including 64-bit
         * timestamp-derived measurements split across non-atomic reads.
         */
        DUAL_CTRL->stats_seq++;
        dual_core_barrier();
        DUAL_CTRL->perf = sample;
        DUAL_CTRL->post_ms[slot] = sample.post_us / 1000u;
        DUAL_CTRL->last_frame_id = frame_id;
        DUAL_CTRL->last_pre_ms = sample.pre_us / 1000u;
        DUAL_CTRL->last_infer_ms = sample.infer_us / 1000u;
        DUAL_CTRL->last_post_ms = sample.post_us / 1000u;
        DUAL_CTRL->cpu1_state = CPU1_STATE_FRAME_DONE;
        DUAL_CTRL->post_count = completed;
        dual_core_barrier();
        DUAL_CTRL->stats_seq++;

        /* Last access to this slot's payload/metadata: release to CPU0 only
         * after the display flush, all timing reads and all bookkeeping.
         */
        dual_publish_slot((unsigned)slot, SLOT_FREE);
    }
}
/* 交接说明 函数 main 结束后
 * 本核运行入口。CPU0负责硬件初始化、相机、预处理、调度与串口；CPU1负责输出失效、检测头后处理与三缓冲提交。必须配对启动两个核。
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

#if 0 /* 已删除或替换代码的交接存档，禁止参与编译 */
// 下面为真实前驱差异：减号行已被替换或删除，加号行为当前实现。
// --- C:\Users\Lenovo\Desktop\yolov5n_speed_prj\yolov5n_speed_prj\submission_2026\src\vitis_cpu1\main_1.c
// 
// +++ C:\Users\Lenovo\Desktop\yolov5n_speed_prj\yolov5n_speed_prj\03_vitis\FINAL_R66_20261027\cpu1\src\main_1.c
// 
// @@ -6,12 +6,15 @@
// 
//   * preserving CPU0's L2 controller and global timer. Keep BSP cache range
//   * routines enabled: our DDR/PL handoffs need both L1 and L2 maintenance.
//   */
//  #include <string.h>
//  
//  #include "xil_cache.h"
// +#include "xil_io.h"
// +#include "xparameters.h"
// +#include "xaxivdma_hw.h"
//  #include "xil_mmu.h"
//  #include "xil_types.h"
//  #include "xtime_l.h"
//  #include "yolov5n_speed_app.h"
//  #include "dual_core_shared.h"
//  
// @@ -44,15 +47,92 @@
// 
//      DUAL_CTRL->cpu1_error = error;
//      DUAL_CTRL->cpu1_state = error ? CPU1_STATE_DEADLOOP : CPU1_STATE_STOPPED;
//      __asm__ volatile ("dsb sy\n\tsev" ::: "memory");
//      while (1) { __asm__ volatile ("wfe"); }
//  }
//  
// +/* No ABI fields are moved. Private video diagnostics occupy unused OCM. */
// +typedef struct {
// +    u32 magic, submitted, confirmed, rendering, target, current;
// +    u32 violations, last_wait_us, max_wait_us, errors;
// +} video_probe_t;
// +#define VIDEO_PROBE ((volatile video_probe_t *)0xFFFF0200u)
// +#define VIDEO_COUNT 3u
// +#define VIDEO_VDMA XPAR_AXI_VDMA_0_BASEADDR
// +
// +static u32 video_current(void)
// +{
// +    return (Xil_In32(VIDEO_VDMA + XAXIVDMA_PARKPTR_OFFSET) &
// +            XAXIVDMA_PARKPTR_READSTR_MASK) >> XAXIVDMA_READSTR_SHIFT;
// +}
// +
// +static void video_fault(u32 reason)
// +{
// +    VIDEO_PROBE->violations++;
// +    VIDEO_PROBE->errors = reason;
// +    __asm__ volatile ("dsb sy" ::: "memory");
// +    cpu1_halt(DUAL_ERROR_CAPTURE);
// +}
// +
// +static void video_present(u32 next)
// +{
// +    u32 park, waited, status;
// +    XTime begin, now;
// +    VIDEO_PROBE->target = next;
// +    VIDEO_PROBE->submitted++;
// +    /* Both cores modify PARK_PTR. Serialize its RMW with CPU0's capture
// +     * parking, but never hold the lock while waiting for a frame boundary. */
// +    dual_cache_enter(1);
// +    park = Xil_In32(VIDEO_VDMA + XAXIVDMA_PARKPTR_OFFSET);
// +    Xil_Out32(VIDEO_VDMA + XAXIVDMA_PARKPTR_OFFSET,
// +              (park & ~XAXIVDMA_PARKPTR_READREF_MASK) | next);
// +    __asm__ volatile ("dsb sy" ::: "memory");
// +    dual_cache_leave(1);
// +    XTime_GetTime(&begin);
// +    while (video_current() != next) {
// +        status = Xil_In32(VIDEO_VDMA + XAXIVDMA_SR_OFFSET);
// +        if (status & (XAXIVDMA_SR_ERR_ALL_MASK | XAXIVDMA_SR_HALTED_MASK))
// +            video_fault(status);
// +        if (DUAL_CTRL->stop_requested) cpu1_halt(DUAL_ERROR_NONE);
// +        XTime_GetTime(&now);
// +        if (elapsed_us(begin, now) >= 1000000u) video_fault(0x80000001u);
// +    }
// +    __asm__ volatile ("dsb sy" ::: "memory");
// +    XTime_GetTime(&now);
// +    waited = elapsed_us(begin, now);
// +    VIDEO_PROBE->last_wait_us = waited;
// +    if (waited > VIDEO_PROBE->max_wait_us) VIDEO_PROBE->max_wait_us = waited;
// +    VIDEO_PROBE->current = next;
// +    VIDEO_PROBE->rendering = 0xFFFFFFFFu;
// +    VIDEO_PROBE->confirmed++;
// +}
// +
// +/* Non-cacheable OCM journal: 512 records, 16 words each, no UART traffic.
// + * Host freezes only this journal, never the video pipeline or either CPU. */
// +#define TRACE_HEADER ((volatile u32 *)0xFFFF1000u)
// +#define TRACE_RECORD ((volatile u32 *)0xFFFF2000u)
// +static void trace_frame(const dual_perf_stats_t *s, XTime prepared, XTime end)
// +{
// +    volatile u32 *r;
// +    u32 n;
// +    if (TRACE_HEADER[3]) { TRACE_HEADER[4] = 1u; return; }
// +    n = TRACE_HEADER[2];
// +    r = TRACE_RECORD + (n % 512u) * 16u;
// +    r[0]=s->frame_id; r[1]=s->infer_us; r[2]=s->period_us;
// +    r[3]=s->pre_us; r[4]=s->capture_us; r[5]=s->capture_wait_us;
// +    r[6]=s->prepare_us; r[7]=s->pl_gap_us; r[8]=s->start_period_us;
// +    r[9]=s->post_total_us; r[10]=VIDEO_PROBE->last_wait_us;
// +    r[11]=s->draw_us; r[12]=(u32)prepared; r[13]=(u32)(prepared>>32);
// +    r[14]=(u32)end; r[15]=(u32)(end>>32);
// +    __asm__ volatile ("dmb sy" ::: "memory");
// +    TRACE_HEADER[2]=n+1u;
// +}
//  int main(void)
//  {
//      u32 completed = 0;
// +    u32 front = 0, back = 1;
//      u32 window_intervals = 0, window_id = 0;
//      u32 average_fps = 0, average_period_us = 0;
//      int have_completion = 0;
//      XTime previous_completion = 0, window_begin = 0;
//  
//      /* No shared access before this mapping; per-field cache operations could
// @@ -72,12 +152,19 @@
// 
//      while (!DUAL_CTRL->cpu0_ready) {
//          if (DUAL_CTRL->stop_requested) cpu1_halt(DUAL_ERROR_NONE);
//      }
//      dual_core_barrier();
//      if (DUAL_CTRL->stop_requested) cpu1_halt(DUAL_ERROR_NONE);
//  
// +    memset((void *)VIDEO_PROBE, 0, sizeof(*VIDEO_PROBE));
// +    VIDEO_PROBE->magic = 0x56494433u;
// +    TRACE_HEADER[0]=0x43545243u; TRACE_HEADER[1]=512u;
// +    TRACE_HEADER[2]=0u; TRACE_HEADER[3]=0u; TRACE_HEADER[4]=0u;
// +    VIDEO_PROBE->rendering = 0xFFFFFFFFu;
// +    if ((Xil_In32(VIDEO_VDMA + XAXIVDMA_CR_OFFSET) & XAXIVDMA_CR_TAIL_EN_MASK) || video_current() != 0u)
// +        video_fault(0x80000002u);
//      DUAL_CTRL->cpu1_state = CPU1_STATE_READY;
//      dual_core_barrier();
//      DUAL_CTRL->cpu1_ready = 1u;
//  
//      while (1) {
//          unsigned i;
// @@ -122,13 +209,16 @@
// 
//          sample.pl_gap_us = DUAL_CTRL->timing[slot].pl_gap_us;
//          sample.start_period_us = DUAL_CTRL->timing[slot].start_period_us;
//          prepared_begin = ((XTime)DUAL_CTRL->timing[slot].begin_ticks_hi << 32) |
//                           (XTime)DUAL_CTRL->timing[slot].begin_ticks_lo;
//          arena = (const int8_t *)DUAL_CTRL->arena_addr[slot];
//          snapshot = (const uint8_t *)DUAL_CTRL->snapshot_addr[slot];
// -        display = (uint8_t *)DUAL_CTRL->disp_base;
// +        back = (front + 1u) % VIDEO_COUNT;
// +        if (video_current() != front || back == front) video_fault(0x80000003u);
// +        VIDEO_PROBE->rendering = back;
// +        display = (uint8_t *)(DUAL_CTRL->disp_base + back * FB_BYTES);
//  
//          XTime_GetTime(&begin);
//          DUAL_CTRL->cpu1_state = CPU1_STATE_POSTING;
//          dual_cache_enter(1);
//          Xil_DCacheInvalidateRange((u32)(arena + YOLO_OUT_P3_OFF), OUT_P3_BYTES);
//          Xil_DCacheInvalidateRange((u32)(arena + YOLO_OUT_P4_OFF), OUT_P4_BYTES);
// @@ -147,12 +237,15 @@
// 
//          DUAL_CTRL->cpu1_state = CPU1_STATE_DRAWING;
//          memcpy(display, snapshot, FB_BYTES);
//          app_draw_boxes(display, boxes, bcls, bconf, ndet);
//          dual_cache_enter(1);
//          Xil_DCacheFlushRange((u32)display, FB_BYTES);
//          dual_cache_leave(1);
// +        __asm__ volatile ("dsb sy" ::: "memory");
// +        video_present(back);
// +        front = back;
//          XTime_GetTime(&end);
//          sample.invalidate_us = elapsed_us(begin, decoded_begin);
//          sample.post_us = elapsed_us(decoded_begin, decoded_end);
//          sample.draw_us = elapsed_us(decoded_end, end);
//          sample.post_total_us = elapsed_us(begin, end);
//          sample.latency_us = elapsed_us(prepared_begin, end);
// @@ -178,12 +271,13 @@
// 
//          }
//          previous_completion = end;
//          sample.avg_fps_milli = average_fps;
//          sample.avg_period_us = average_period_us;
//          sample.fps_window_id = window_id;
//          sample.done_count = ++completed;
// +        trace_frame(&sample, prepared_begin, end);
//  
//          /* Sequence lock prevents mixed-frame statistics, including 64-bit
//           * timestamp-derived measurements split across non-atomic reads.
//           */
//          DUAL_CTRL->stats_seq++;
//          dual_core_barrier();
#endif

/* 交接补充
 * CPU1在POST_READY后失效输出cache，解码并画到非front显示buffer，提交后等READSTR确认。完成时间end在此流程后取得；period=end[n]-end[n-1]，lat=end-prepared_begin。
 */
