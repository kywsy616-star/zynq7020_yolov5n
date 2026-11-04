/*
 * CPU0: camera/HDMI initialization, frozen-frame preprocessing and PL scheduling.
 * CPU1: postprocessing and display. Two slots provide backpressure:
 *
 *   FREE -> PREPARING -> PREPARED -> PL_RUNNING -> POST_READY
 *        <-               CPU1: POSTING <-
 *
 * CPU0 is the sole owner of AP_CTRL (ap_done is clear-on-read). The next input
 * may be prepared while PL runs, but p_act/Start are written only after the
 * previous run has completed. A slot is never reused until CPU1 releases it.
 */
#include <stdio.h>
#include <string.h>

#include "xil_printf.h"
#include "xuartps_hw.h"
#include "xil_cache.h"
#include "xil_mmu.h"
#include "xil_types.h"
#include "xtime_l.h"
#include "xparameters.h"
#include "xaxivdma.h"

#include "display_ctrl/display_ctrl.h"
#include "sccb/sccb_init.h"
#include "ov5640/ov5640_init.h"
#include "yolov5n_speed_app.h"
#include "xyolov5n_top.h"
#include "dual_core_shared.h"

extern const uint8_t  yolov5n_weights[];
extern const uint32_t yolov5n_weights_len;
extern const uint8_t  yolov5n_rqt[];
extern const uint32_t yolov5n_rqt_len;

#define CLOCK_ADDR        XPAR_AXI_DYNCLK_0_BASEADDR
#define VDMA_ID           XPAR_AXIVDMA_0_DEVICE_ID
#define XVTC_DEVICE_ID    XPAR_VTC_0_DEVICE_ID
#define ACC_DEVICE_ID     XPAR_XYOLOV5N_TOP_0_DEVICE_ID
#define CAPTURE_COUNT     3u
#define CAP(n)            (VIDEO_FB_BASE + (n) * FB_BYTES)
#define DISP_BASE         (VIDEO_FB_BASE + CAPTURE_COUNT * FB_BYTES)
#define DISPLAY_COUNT     3u
/* Video buffers end before either ELF's reserved memory. */
typedef char video_memory_fits[(DISP_BASE + DISPLAY_COUNT * FB_BYTES <= CPU1_ENTRY_ADDR) ? 1 : -1];

#define C4_BYTES(ch, h, w) ((((ch) + 3) / 4) * (h) * (w) * 4)
#define IN_BYTES          C4_BYTES(YOLO_INPUT_CH, YOLO_INPUT_H, YOLO_INPUT_W)
#define CPU1_WAIT_MS      5000u
#define CAPTURE_WAIT_MS   1000u
#define PL_WAIT_MS        10000u
#define POST_WAIT_MS      5000u

#if XPAR_PS7_DDR_0_S_AXI_HIGHADDR < (CPU1_IMAGE_LIMIT - 1u)
#error "The DDR map must include the CPU1 image at 0x1F000000..0x1FFFFFFF"
#endif

static int8_t yolo_arena_0[YOLO_ARENA_BYTES] __attribute__((aligned(4096)));
static int8_t yolo_arena_1[YOLO_ARENA_BYTES] __attribute__((aligned(4096)));
static int8_t * const yolo_arena[2] = { yolo_arena_0, yolo_arena_1 };

/* These belong to the slot, not to the continuously overwritten VDMA ring.
 * CPU0 preprocesses this exact picture; CPU1 later displays the same picture.
 */
static uint8_t frame_snapshot[2][FB_BYTES] __attribute__((aligned(64)));

static XAxiVdma vdma;
static DisplayCtrl Dispctrl;
static XYolov5n_top acc;
static int active_slot = -1;
static XTime pl_started_at;
static XTime pl_finished_at[2];
static XTime last_pl_finished_at;
static int have_pl_start;
static int have_pl_finish;
#include "color_camera.h"

static u32 elapsed_ms(XTime start, XTime end)
{
    return (u32)(((u64)(end - start) * 1000ULL) / COUNTS_PER_SECOND);
}
/* 交接说明 函数 elapsed_ms 结束后
 * 把两个XTime tick差转换为毫秒，使用COUNTS_PER_SECOND，不写死CPU主频；超时保护使用此函数，统计精细值使用微秒版本。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */

static u32 elapsed_us(XTime start, XTime end)
{
    return (u32)(((u64)(end - start) * 1000000ULL) / COUNTS_PER_SECOND);
}
/* 交接说明 函数 elapsed_us 结束后
 * 把两个全局计时器tick差转换成u32微秒，乘法用u64防止中间溢出；该函数只负责换算，字段边界由调用位置决定。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */

static void pipeline_halt(u32 error)
{
    DUAL_CTRL->cpu0_error = error;
    dual_core_barrier();
    DUAL_CTRL->stop_requested = 1u;
    __asm__ volatile ("dsb sy\n\tsev" ::: "memory");
    xil_printf("[CPU0] pipeline halted: error=%lu CPU1=0x%08lX/%lu slots=%lu,%lu\r\n",
               (unsigned long)error, (unsigned long)DUAL_CTRL->cpu1_state,
               (unsigned long)DUAL_CTRL->cpu1_error,
               (unsigned long)DUAL_CTRL->slot_state[0],
               (unsigned long)DUAL_CTRL->slot_state[1]);
    /* Leave shared caches and the display running for debugger inspection.
     * Do not return through BSP exit(), which may tear down shared resources.
     */
    while (1) { __asm__ volatile ("wfe"); }
}
/* 交接说明 函数 pipeline_halt 结束后
 * CPU0发布停止原因、记录两核及slot状态，输出一次错误后停驻，避免故障时继续覆盖在用arena或显示buffer。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */

static int setup_vdma(void)
{
    XAxiVdma_DmaSetup cfg;
    XAxiVdma_Config *hwcfg;
    UINTPTR addrs[3];
    unsigned i;
    int st;

    hwcfg = XAxiVdma_LookupConfig(VDMA_ID);
    if (hwcfg == NULL) return XST_FAILURE;
    st = XAxiVdma_CfgInitialize(&vdma, hwcfg, hwcfg->BaseAddress);
    if (st != XST_SUCCESS) return st;
    if (!vdma.HasS2Mm || !vdma.HasMm2S || vdma.MaxNumFrames != 3 ||
        vdma.HasSG) return XST_FAILURE;

    /* Capture keeps three stores in a circular ring. */
    memset(&cfg, 0, sizeof(cfg));
    cfg.VertSizeInput = CAM_H;
    cfg.HoriSizeInput = CAM_W * 3;
    cfg.Stride = CAM_W * 3;
    cfg.EnableCircularBuf = 1;
    st = XAxiVdma_DmaConfig(&vdma, XAXIVDMA_WRITE, &cfg);
    if (st != XST_SUCCESS) return st;
    for (i = 0; i < CAPTURE_COUNT; ++i) addrs[i] = CAP(i);
    st = XAxiVdma_DmaSetBufferAddr(&vdma, XAXIVDMA_WRITE, addrs);
    if (st != XST_SUCCESS) return st;

    /* Three distinct display stores: MM2S parks on a completed front frame. */
    memset(&cfg, 0, sizeof(cfg));
    cfg.VertSizeInput = DISP_H;
    cfg.HoriSizeInput = DISP_W * 3;
    cfg.Stride = DISP_W * 3;
    cfg.EnableCircularBuf = 0;
    cfg.FixedFrameStoreAddr = 0;
    st = XAxiVdma_DmaConfig(&vdma, XAXIVDMA_READ, &cfg);
    if (st != XST_SUCCESS) return st;
    for (i = 0; i < DISPLAY_COUNT; ++i) addrs[i] = DISP_BASE + i * FB_BYTES;
    st = XAxiVdma_DmaSetBufferAddr(&vdma, XAXIVDMA_READ, addrs);
    if (st != XST_SUCCESS) return st;

    st = XAxiVdma_DmaStart(&vdma, XAXIVDMA_WRITE);
    if (st != XST_SUCCESS) return st;
    return XAxiVdma_DmaStart(&vdma, XAXIVDMA_READ);
}
/* 交接说明 函数 setup_vdma 结束后
 * 初始化800x480采集写通路和三个不同显示读地址；MM2S使用park确认，S2MM保持连续循环，两个方向不能误用同一套store地址。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */

/* Retained optional startup profiler. CPU1 has not been awakened yet. */
#define PROFILE_OPS   0     /* 1 = 开机打印剖析表；0 = 关掉。
                               双核版默认关闭，因为剖析会阻塞流水线。
                               需要调试时改回1，但此时CPU1应保持空闲。 */

#if PROFILE_OPS
static u32 ticks_to_us(XTime a, XTime b)
{
    return (u32)((u64)(b - a) * 1000000ULL / COUNTS_PER_SECOND);
}
/* 交接说明 函数 ticks_to_us 结束后
 * 把独立逐算子计时换成微秒，用于profile；不能把profile固件的结果和正常流水固件直接混为同一统计集合。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */

static void profile_ops(XYolov5n_top *acc)
{
    XTime ta, tb;
    u64 sum_us = 0;
    u32 base_us, whole_us;
    int i;

    xil_printf("\r\n");
    xil_printf("=====================================================\r\n");
    xil_printf(" infer profile -- per-op timing\r\n");
    xil_printf("=====================================================\r\n");

    /* ---- ① 基线 ---- */
    XYolov5n_top_Set_start_op(acc, 0);
    XYolov5n_top_Set_n_ops(acc, 0);
    XTime_GetTime(&ta);
    XYolov5n_top_Start(acc);
    while (!XYolov5n_top_IsDone(acc)) { }
    XTime_GetTime(&tb);
    base_us = ticks_to_us(ta, tb);
    xil_printf(" baseline (n_ops=0, Start+IsDone) = %lu us\r\n", (unsigned long)base_us);
    xil_printf(" -> 'real' below is RAW; subtract baseline for the op's own time\r\n");
    xil_printf("-----------------------------------------------------\r\n");
    xil_printf(" op type    out      ic>  oc  k  MACs(M)    real  ideal    r%%\r\n");
    xil_printf("-----------------------------------------------------\r\n");

    /* ---- ② 逐算子 ---- */
    for (i = 0; i < YOLO_N_OPS; i++) {
        layer_desc_t *d = &yolo_layers[i];
        u32 macs = (u32)d->oh * d->ow * d->oc * d->ic * d->k * d->k;
        u32 ideal_us = macs / 6400;

        XYolov5n_top_Set_start_op(acc, i);
        XYolov5n_top_Set_n_ops(acc, 1);
        XTime_GetTime(&ta);
        XYolov5n_top_Start(acc);
        while (!XYolov5n_top_IsDone(acc)) { }
        XTime_GetTime(&tb);
        u32 real_us = ticks_to_us(ta, tb);
        sum_us += real_us;

        u32 r_pct = ideal_us > 0 ? (real_us * 100U) / ideal_us : 0;
        xil_printf("%3d %4d %4dx%-4d %3d>%3d %2d %8lu %7lu %6lu %5lu\r\n",
                   i, d->type, d->oh, d->ow, d->ic, d->oc, d->k,
                   (unsigned long)(macs / 1000000U),
                   (unsigned long)real_us, (unsigned long)ideal_us,
                   (unsigned long)r_pct);
    }

    /* ---- ③ 整网 ---- */
    XYolov5n_top_Set_start_op(acc, 0);
    XYolov5n_top_Set_n_ops(acc, YOLO_N_OPS);
    XTime_GetTime(&ta);
    XYolov5n_top_Start(acc);
    while (!XYolov5n_top_IsDone(acc)) { }
    XTime_GetTime(&tb);
    whole_us = ticks_to_us(ta, tb);

    xil_printf("-----------------------------------------------------\r\n");
    xil_printf(" per-op sum         = %lu us = %lu ms\r\n",
               (unsigned long)sum_us, (unsigned long)(sum_us / 1000U));
    xil_printf(" whole network      = %lu us = %lu ms\r\n",
               (unsigned long)whole_us, (unsigned long)(whole_us / 1000U));
    xil_printf(" whole - per-op sum = %ld us\r\n",
               (long)(whole_us - sum_us));
    xil_printf("=====================================================\r\n");
}
/* 交接说明 函数 profile_ops 结束后
 * 受编译开关PROFILE_OPS控制的逐层诊断，每次记录各描述符耗时并与整网比较；正常最终固件关闭此诊断，不在运行期逐层打印。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */
#endif

static void init_shared_ctrl(void)
{
    unsigned i;

    /* This changes the 1 MB translation-table section covering high OCM.
     * Do it before the first shared access, on BOTH cores. No per-field
     * flush/invalidate is permitted: different writers share cache lines.
     */
    Xil_SetTlbAttributes((INTPTR)OCM_CTRL_ADDR, NORM_NONCACHE);
    memset((void *)OCM_CTRL_ADDR, 0, OCM_CTRL_SIZE);
    DUAL_CTRL->version = DUAL_CORE_VERSION;
    DUAL_CTRL->disp_base = DISP_BASE;
    for (i = 0; i < DUAL_SLOT_COUNT; ++i) {
        DUAL_CTRL->slot_state[i] = SLOT_FREE;
        DUAL_CTRL->arena_addr[i] = (u32)yolo_arena[i];
        DUAL_CTRL->snapshot_addr[i] = (u32)frame_snapshot[i];
    }
    dual_core_barrier();
    DUAL_CTRL->magic = DUAL_CORE_MAGIC;
}
/* 交接说明 函数 init_shared_ctrl 结束后
 * 在CPU1开始消费前清零控制区，设置协议magic/version、slot与地址；非缓存映射及发布屏障确保双方看到同一份结构。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */

/* Nonblocking completion service: CPU1 never reads AP_CTRL. */
static void perf_uart_service(void);

static void service_pl(void)
{
    XTime now;
    unsigned i;
    perf_uart_service();

    if (DUAL_CTRL->cpu1_error != DUAL_ERROR_NONE)
        pipeline_halt(DUAL_ERROR_CPU1_FAILED);

    XTime_GetTime(&now);
    if (active_slot >= 0) {
        if (XYolov5n_top_IsDone(&acc)) {
            int finished = active_slot;
            XTime_GetTime(&now);
            DUAL_CTRL->infer_ms[finished] = elapsed_ms(pl_started_at, now);
            DUAL_CTRL->timing[finished].infer_us = elapsed_us(pl_started_at, now);
            pl_finished_at[finished] = now;
            last_pl_finished_at = now;
            have_pl_finish = 1;
            active_slot = -1;
            dual_publish_slot((unsigned)finished, SLOT_POST_READY);
            /* CPU1 sleeps while no result is ready. Complete the state store
             * before sending the event; WFE's event latch closes the race
             * between CPU1's last state check and its sleep instruction.
             */
            __asm__ volatile ("dsb sy\n\tsev" ::: "memory");
        } else if (elapsed_ms(pl_started_at, now) >= PL_WAIT_MS) {
            pipeline_halt(DUAL_ERROR_PL_TIMEOUT);
        }
    }
    for (i = 0; i < DUAL_SLOT_COUNT; ++i) {
        u32 state = DUAL_CTRL->slot_state[i];
        if ((state == SLOT_POST_READY || state == SLOT_POSTING) &&
            elapsed_ms(pl_finished_at[i], now) >= POST_WAIT_MS)
            pipeline_halt(DUAL_ERROR_POST_TIMEOUT);
    }
}
/* 交接说明 函数 service_pl 结束后
 * CPU0独占PL控制寄存器轮询、清done与slot发布；ap_done为读清，CPU1不得并行读取。每次也有限量服务UART，不应加入阻塞打印。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */

static void start_prepared_slot(void)
{
    unsigned i;
    int next = -1;
    XTime started;

    if (active_slot >= 0) return;
    for (i = 0; i < DUAL_SLOT_COUNT; ++i) {
        if (DUAL_CTRL->slot_state[i] == SLOT_PREPARED &&
            (next < 0 || (int32_t)(DUAL_CTRL->frame_id[i] -
                                  DUAL_CTRL->frame_id[next]) < 0))
            next = (int)i;
    }
    if (next < 0) return;

    /* No accelerator register is changed while another inference is active. */
    XYolov5n_top_Set_p_act(&acc, (u32)yolo_arena[next]);
    __asm__ volatile ("dsb sy" ::: "memory");
    XTime_GetTime(&started);
    XYolov5n_top_Start(&acc);
    DUAL_CTRL->timing[next].start_period_us = have_pl_start ?
        elapsed_us(pl_started_at, started) : 0u;
    DUAL_CTRL->timing[next].pl_gap_us = have_pl_finish ?
        elapsed_us(last_pl_finished_at, started) : 0u;
    pl_started_at = started;
    have_pl_start = 1;
    active_slot = next;
    dual_publish_slot((unsigned)next, SLOT_PL_RUNNING);
    DUAL_CTRL->frame_count++;
}
/* 交接说明 函数 start_prepared_slot 结束后
 * 只有上一PL结束且存在PREPARED槽时才写输入地址并Start，保证准备、推理与后处理按slot所有权交接。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */

static u32 capture_store(void)
{
    u32 current = XAxiVdma_CurrFrameStore(&vdma, XAXIVDMA_WRITE);
    u32 errors = (u32)XAxiVdma_GetDmaChannelErrors(&vdma, XAXIVDMA_WRITE);
    /* PARK_PTR stops tracking the active store when a frame error is latched. */
    if (current >= CAPTURE_COUNT || errors != 0u) {
        xil_printf("[CPU0] capture status: store=%lu errors=0x%08lX\r\n",
                   (unsigned long)current, (unsigned long)errors);
        pipeline_halt(DUAL_ERROR_CAPTURE);
    }
    return current;
}
/* 交接说明 函数 capture_store 结束后
 * 查询VDMA当前摄像头写store，用于选取已完成buffer与分块守卫；不要把当前写store直接交给显示或预处理。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */

static void prime_capture(void)
{
    u32 initial = capture_store();
    XTime begin, now;

    /* Only startup waits for a new frame: the previous store must contain
     * a complete picture before the first snapshot. Never do this per frame.
     */
    XTime_GetTime(&begin);
    while (capture_store() == initial) {
        XTime_GetTime(&now);
        if (elapsed_ms(begin, now) >= CAPTURE_WAIT_MS)
            pipeline_halt(DUAL_ERROR_CAPTURE);
    }
}
/* 交接说明 函数 prime_capture 结束后
 * 等待连续摄像头环至少有可用已完成帧，初始化store跟踪；不通过临时停车来获得快照，避免周期性停顿。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */

/* Capture remains in circular mode. Copy the most recent completed store;
 * the writer must cross two frame boundaries before reaching it. Guard
 * every 16-row chunk (38,400 bytes) and discard any threatened snapshot.
 * No stop/park operation, camera-frame wait, or change of read pointer. */
#define CAP_PROBE ((volatile u32 *)0xFFFF0280u)
static void capture_snapshot(unsigned slot)
{
    XTime begin, now, attempt_begin;
    u32 source_index, row, waited = 0u;
    const u8 *source;
    XTime_GetTime(&begin);
    CAP_PROBE[0] = 0x43415033u;
    for (;;) {
        XTime_GetTime(&attempt_begin);
        source_index = (capture_store() + CAPTURE_COUNT - 1u) % CAPTURE_COUNT;
        source = (const u8 *)CAP(source_index);
        CAP_PROBE[1]++;
        dual_cache_enter(0);
        Xil_DCacheInvalidateRange((u32)source, FB_BYTES);
        dual_cache_leave(0);
        for (row = 0u; row < CAM_H; row += 16u) {
            u32 rows = CAM_H - row;
            u32 offset = row * CAM_W * 3u;
            if (rows > 16u) rows = 16u;
            if (capture_store() == source_index) break;
            memcpy(frame_snapshot[slot] + offset, source + offset,
                   rows * CAM_W * 3u);
            if (capture_store() == source_index) break;
            service_pl();
        }
        XTime_GetTime(&now);
        if (row >= CAM_H) {
            u32 duration = elapsed_us(begin, now);
            CAP_PROBE[3]++;
            CAP_PROBE[4] = duration;
            if (duration > CAP_PROBE[5]) CAP_PROBE[5] = duration;
            DUAL_CTRL->timing[slot].capture_wait_us = waited;
            return;
        }
        /* Never publish a partial or possibly mixed camera frame. */
        CAP_PROBE[2]++;
        waited += elapsed_us(attempt_begin, now);
        service_pl();
        if (elapsed_ms(begin, now) >= CAPTURE_WAIT_MS)
            pipeline_halt(DUAL_ERROR_CAPTURE);
    }
}
/* 交接说明 函数 capture_snapshot 结束后
 * 连续采集修复：不停车S2MM，复制上一完成store，每16行前后核查写store，发现追写即重试，禁止提交混帧。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */
static void prepare_slot(unsigned slot, u32 frame_id)
{
    XTime begin, captured, pre_end, end;

    /* Acquire the FREE published by CPU1, then reserve it before writing. */
    dual_core_barrier();
    dual_publish_slot(slot, SLOT_PREPARING);
    XTime_GetTime(&begin);
    DUAL_CTRL->timing[slot].begin_ticks_lo = (u32)begin;
    DUAL_CTRL->timing[slot].begin_ticks_hi = (u32)(begin >> 32);
    capture_snapshot(slot);
    XTime_GetTime(&captured);
    app_preprocess(frame_snapshot[slot], yolo_arena[slot] + YOLO_INPUT_OFF);

    dual_cache_enter(0);
    Xil_DCacheFlushRange((u32)(yolo_arena[slot] + YOLO_INPUT_OFF), IN_BYTES);
    dual_cache_leave(0);
    XTime_GetTime(&pre_end);

    /* Snapshot handoff is extra capture work; keep it out of the original
     * preprocess+input-flush timer so the single-core comparison is honest.
     */
    dual_cache_enter(0);
    Xil_DCacheFlushRange((u32)frame_snapshot[slot], FB_BYTES);
    dual_cache_leave(0);

    XTime_GetTime(&end);
    DUAL_CTRL->frame_id[slot] = frame_id;
    DUAL_CTRL->pre_ms[slot] = elapsed_ms(captured, pre_end);
    DUAL_CTRL->timing[slot].pre_us = elapsed_us(captured, pre_end);
    DUAL_CTRL->timing[slot].capture_us = elapsed_us(begin, captured) +
        elapsed_us(pre_end, end);
    DUAL_CTRL->timing[slot].prepare_us = elapsed_us(begin, end);
    dual_publish_slot(slot, SLOT_PREPARED);
}
/* 交接说明 函数 prepare_slot 结束后
 * 将已完成摄像头帧安全复制到该slot快照，再预处理成512x384 INT8 C4输入并维护缓存；CPU1后续显示同一快照，保证框与图同源。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */

/* Runtime telemetry never waits for UART FIFO space. An entire line is
 * queued before emission, so records cannot interleave or be half replaced.
 * Eight writes per service call bound its effect on accelerator polling. */
static char perf_uart_line[384];
static u32 perf_uart_length, perf_uart_position;
#define UART_PROBE ((volatile u32 *)0xFFFF02A0u)
static void perf_uart_service(void)
{
    unsigned budget = 8u;
    while (budget-- && perf_uart_position < perf_uart_length) {
        if (XUartPs_IsTransmitFull(STDOUT_BASEADDRESS)) break;
        XUartPs_WriteReg(STDOUT_BASEADDRESS, XUARTPS_FIFO_OFFSET,
                        (u32)(u8)perf_uart_line[perf_uart_position++]);
    }
    UART_PROBE[2] = perf_uart_length - perf_uart_position;
}
/* 交接说明 函数 perf_uart_service 结束后
 * 非阻塞性能日志FIFO服务。限定每次最多8字节，硬件FIFO满立即返回；不得加等待循环，否则会恢复周期性卡顿。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */

static void report_performance(u32 *reported, u32 *window)
{
    dual_perf_stats_t sample;
    u32 before, after;
    int n;
    perf_uart_service();
    if (DUAL_CTRL->post_count == *reported) return;
    before = DUAL_CTRL->stats_seq;
    if (before & 1u) return;
    dual_core_barrier();
    sample = DUAL_CTRL->perf;
    dual_core_barrier();
    after = DUAL_CTRL->stats_seq;
    if (before != after || (after & 1u) || sample.done_count == *reported)
        return;
    *reported = sample.done_count;
    if (sample.done_count != 1u && sample.fps_window_id == *window) return;
    *window = sample.fps_window_id;
    if (perf_uart_position != perf_uart_length) {
        /* Drop only a whole new telemetry sample; never delay video. */
        UART_PROBE[1]++;
        return;
    }
    n = snprintf(perf_uart_line, sizeof(perf_uart_line),
        "f%lu done=%lu fps=%lu.%03lu avg16=%lu.%03lu period=%lu.%03lums "
        "start=%lums gap=%luus | ms: pre=%lu cap=%lu(wait=%lu) prep=%lu "
        "infer=%lu.%03lu post=%lu inv=%lu draw=%lu postall=%lu lat=%lums\r\n",
        (unsigned long)sample.frame_id, (unsigned long)sample.done_count,
        (unsigned long)(sample.fps_milli/1000u), (unsigned long)(sample.fps_milli%1000u),
        (unsigned long)(sample.avg_fps_milli/1000u), (unsigned long)(sample.avg_fps_milli%1000u),
        (unsigned long)(sample.period_us/1000u), (unsigned long)(sample.period_us%1000u),
        (unsigned long)(sample.start_period_us/1000u), (unsigned long)sample.pl_gap_us,
        (unsigned long)(sample.pre_us/1000u), (unsigned long)(sample.capture_us/1000u),
        (unsigned long)(sample.capture_wait_us/1000u), (unsigned long)(sample.prepare_us/1000u),
        (unsigned long)(sample.infer_us/1000u), (unsigned long)(sample.infer_us%1000u),
        (unsigned long)(sample.post_us/1000u), (unsigned long)(sample.invalidate_us/1000u),
        (unsigned long)(sample.draw_us/1000u), (unsigned long)(sample.post_total_us/1000u),
        (unsigned long)(sample.latency_us/1000u));
    if (n < 0 || (unsigned)n >= sizeof(perf_uart_line)) {
        UART_PROBE[1]++;
        return;
    }
    perf_uart_position = 0u;
    perf_uart_length = (u32)n;
    UART_PROBE[0]++;
    perf_uart_service();
}
/* 交接说明 函数 report_performance 结束后
 * 使用共享seqlock一致快照读取性能；infer、period和start各有不同时间边界。运行期整行排队，避免115200串口阻塞PL调度。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */
int main(void)
{
    unsigned i, write_slot = 0;
    u32 frame_id = 0, reported = 0, reported_window = 0;
    XTime wait_start, now;
    u32 last_wait_log = 0;
    int st;

    init_shared_ctrl();
    xil_printf("\r\nYOLOv5n dual-core AMP v%lu: CPU0 pre/PL, CPU1 post/display\r\n",
               (unsigned long)DUAL_CORE_VERSION);
    xil_printf("[CPU0] arena=%d x2, frozen frame=%d x2, ops=%d, CPU1=0x%08lX\r\n",
               YOLO_ARENA_BYTES, FB_BYTES, YOLO_N_OPS,
               (unsigned long)CPU1_ENTRY_ADDR);
    xil_printf("[CPU0] weights=%lu bytes, requant=%lu bytes\r\n",
               (unsigned long)yolov5n_weights_len,
               (unsigned long)yolov5n_rqt_len);

    SCCB_Init();
    OV5640_Init();
    color_init();
    color_apply_advanced_awb();
    COLOR_MB[7]=1u;

    memset((void *)DISP_BASE, 0, DISPLAY_COUNT * FB_BYTES);
    Xil_DCacheFlushRange(DISP_BASE, DISPLAY_COUNT * FB_BYTES);
    xil_printf("[VIDEO3 CONTINUOUS] guarded completed-frame copy; capture never parked; display park ACK\r\n");
    st = setup_vdma();
    if (st != XST_SUCCESS) {
        xil_printf("[CPU0] VDMA setup failed: %d\r\n", st);
        pipeline_halt(DUAL_ERROR_CAPTURE);
    }

    st = DisplayInitialize(&Dispctrl, XVTC_DEVICE_ID, CLOCK_ADDR);
    if (st == XST_SUCCESS)
        st = DisplaySetMode(&Dispctrl, &VMODE_800x480);
    if (st == XST_SUCCESS) st = DisplayStart(&Dispctrl);
    if (st != XST_SUCCESS) {
        xil_printf("[CPU0] HDMI setup failed: %d\r\n", st);
        pipeline_halt(DUAL_ERROR_CAPTURE);
    }

    Xil_DCacheFlushRange((u32)yolov5n_weights, yolov5n_weights_len);
    Xil_DCacheFlushRange((u32)yolov5n_rqt, yolov5n_rqt_len);
    xil_printf("[RAM26 COPY64] 10 COPY descriptors use tile_c64; normal dual-core firmware, profile disabled\r\n");
    Xil_DCacheFlushRange((u32)yolo_layers, sizeof(yolo_layers));
    /* Startup cleared .bss, making arena lines dirty. Clean them ONCE before
     * PL owns them, so a later dirty eviction cannot overwrite PL results.
     */
    for (i = 0; i < DUAL_SLOT_COUNT; ++i)
        Xil_DCacheFlushRange((u32)yolo_arena[i], YOLO_ARENA_BYTES);

    st = XYolov5n_top_Initialize(&acc, ACC_DEVICE_ID);
    if (st != XST_SUCCESS) {
        xil_printf("[CPU0] accelerator init failed: %d\r\n", st);
        pipeline_halt(DUAL_ERROR_PL_TIMEOUT);
    }
    XYolov5n_top_DisableAutoRestart(&acc);
    XYolov5n_top_Set_p_wgt(&acc, (u32)yolov5n_weights);
    XYolov5n_top_Set_p_rqt(&acc, (u32)yolov5n_rqt);
    XYolov5n_top_Set_p_tbl(&acc, (u32)yolo_layers);
    XYolov5n_top_Set_start_op(&acc, 0);
    XYolov5n_top_Set_n_ops(&acc, YOLO_N_OPS);
    XYolov5n_top_Set_p_act(&acc, (u32)yolo_arena[0]);
#if PROFILE_OPS
    profile_ops(&acc);
#endif

    dual_core_barrier();
    DUAL_CTRL->cpu0_ready = 1u;
    if (cpu0_wakeup_cpu1(CPU1_ENTRY_ADDR) != 0)
        pipeline_halt(DUAL_ERROR_CPU1_IMAGE);

    XTime_GetTime(&wait_start);
    while (!DUAL_CTRL->cpu1_ready) {
        u32 waited;
        XTime_GetTime(&now);
        waited = elapsed_ms(wait_start, now);
        if (DUAL_CTRL->cpu1_error) pipeline_halt(DUAL_ERROR_CPU1_FAILED);
        if (waited >= CPU1_WAIT_MS) pipeline_halt(DUAL_ERROR_CPU1_TIMEOUT);
        if (waited - last_wait_log >= 1000u) {
            last_wait_log = waited;
            xil_printf("[CPU0] waiting CPU1: state=0x%08lX error=%lu\r\n",
                       (unsigned long)DUAL_CTRL->cpu1_state,
                       (unsigned long)DUAL_CTRL->cpu1_error);
        }
    }
    dual_core_barrier();
    prime_capture();
    xil_printf("[CPU0] CPU1 ready; cooperative pipeline started\r\n");

    while (1) {
        service_pl();
        color_service();
        start_prepared_slot();

        report_performance(&reported, &reported_window);

        if (DUAL_CTRL->slot_state[write_slot] == SLOT_FREE) {
            prepare_slot(write_slot, frame_id++);
            write_slot = 1u - write_slot;
            /* Account for a PL completion during capture/pre before Start. */
            service_pl();
            start_prepared_slot();
        }
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
// --- C:\Users\Lenovo\Desktop\yolov5n_speed_prj\yolov5n_speed_prj\submission_2026\src\candidate_r6_6_video3\main.c
// 
// +++ C:\Users\Lenovo\Desktop\yolov5n_speed_prj\yolov5n_speed_prj\03_vitis\FINAL_R66_20261027\cpu0\src\main.c
// 
// @@ -10,12 +10,13 @@
// 
//   * previous run has completed. A slot is never reused until CPU1 releases it.
//   */
//  #include <stdio.h>
//  #include <string.h>
//  
//  #include "xil_printf.h"
// +#include "xuartps_hw.h"
//  #include "xil_cache.h"
//  #include "xil_mmu.h"
//  #include "xil_types.h"
//  #include "xtime_l.h"
//  #include "xparameters.h"
//  #include "xaxivdma.h"
// @@ -69,12 +70,13 @@
// 
//  static int active_slot = -1;
//  static XTime pl_started_at;
//  static XTime pl_finished_at[2];
//  static XTime last_pl_finished_at;
//  static int have_pl_start;
//  static int have_pl_finish;
// +#include "color_camera.h"
//  
//  static u32 elapsed_ms(XTime start, XTime end)
//  {
//      return (u32)(((u64)(end - start) * 1000ULL) / COUNTS_PER_SECOND);
//  }
//  
// @@ -244,16 +246,19 @@
// 
//      }
//      dual_core_barrier();
//      DUAL_CTRL->magic = DUAL_CORE_MAGIC;
//  }
//  
//  /* Nonblocking completion service: CPU1 never reads AP_CTRL. */
// +static void perf_uart_service(void);
// +
//  static void service_pl(void)
//  {
//      XTime now;
//      unsigned i;
// +    perf_uart_service();
//  
//      if (DUAL_CTRL->cpu1_error != DUAL_ERROR_NONE)
//          pipeline_halt(DUAL_ERROR_CPU1_FAILED);
//  
//      XTime_GetTime(&now);
//      if (active_slot >= 0) {
// @@ -341,55 +346,59 @@
// 
//          XTime_GetTime(&now);
//          if (elapsed_ms(begin, now) >= CAPTURE_WAIT_MS)
//              pipeline_halt(DUAL_ERROR_CAPTURE);
//      }
//  }
//  
// +/* Capture remains in circular mode. Copy the most recent completed store;
// + * the writer must cross two frame boundaries before reaching it. Guard
// + * every 16-row chunk (38,400 bytes) and discard any threatened snapshot.
// + * No stop/park operation, camera-frame wait, or change of read pointer. */
// +#define CAP_PROBE ((volatile u32 *)0xFFFF0280u)
//  static void capture_snapshot(unsigned slot)
//  {
// -    u32 current, parked;
// -    UINTPTR source;
// -    XTime started, now;
// -    int st;
// -
// -    current = capture_store();
// -    parked = current;
// -
// -    /* Park on the CURRENT writer, protecting the already-completed previous
// -     * store immediately in the common case. The v2 NEXT-store parking forced
// -     * a fresh camera-frame wait on EVERY inference input (up to one period).
// -     * If the writer changed during register programming, wait only for that
// -     * rare race to settle. Do not copy a possibly active store speculatively.
// -     */
// -    /* PARK_PTR read/write references share a register across both cores. */
// -    dual_cache_enter(0);
// -    st = XAxiVdma_StartParking(&vdma, (int)parked, XAXIVDMA_WRITE);
// -    __asm__ volatile ("dsb sy" ::: "memory");
// -    dual_cache_leave(0);
// -    if (st != XST_SUCCESS) pipeline_halt(DUAL_ERROR_CAPTURE);
// -    __asm__ volatile ("dsb sy" ::: "memory");
// -    XTime_GetTime(&started);
// -    while (capture_store() != parked) {
// +    XTime begin, now, attempt_begin;
// +    u32 source_index, row, waited = 0u;
// +    const u8 *source;
// +    XTime_GetTime(&begin);
// +    CAP_PROBE[0] = 0x43415033u;
// +    for (;;) {
// +        XTime_GetTime(&attempt_begin);
// +        source_index = (capture_store() + CAPTURE_COUNT - 1u) % CAPTURE_COUNT;
// +        source = (const u8 *)CAP(source_index);
// +        CAP_PROBE[1]++;
// +        dual_cache_enter(0);
// +        Xil_DCacheInvalidateRange((u32)source, FB_BYTES);
// +        dual_cache_leave(0);
// +        for (row = 0u; row < CAM_H; row += 16u) {
// +            u32 rows = CAM_H - row;
// +            u32 offset = row * CAM_W * 3u;
// +            if (rows > 16u) rows = 16u;
// +            if (capture_store() == source_index) break;
// +            memcpy(frame_snapshot[slot] + offset, source + offset,
// +                   rows * CAM_W * 3u);
// +            if (capture_store() == source_index) break;
// +            service_pl();
// +        }
// +        XTime_GetTime(&now);
// +        if (row >= CAM_H) {
// +            u32 duration = elapsed_us(begin, now);
// +            CAP_PROBE[3]++;
// +            CAP_PROBE[4] = duration;
// +            if (duration > CAP_PROBE[5]) CAP_PROBE[5] = duration;
// +            DUAL_CTRL->timing[slot].capture_wait_us = waited;
// +            return;
// +        }
// +        /* Never publish a partial or possibly mixed camera frame. */
// +        CAP_PROBE[2]++;
// +        waited += elapsed_us(attempt_begin, now);
//          service_pl();
// -        XTime_GetTime(&now);
// -        if (elapsed_ms(started, now) >= CAPTURE_WAIT_MS) {
// -            XAxiVdma_StopParking(&vdma, XAXIVDMA_WRITE);
// +        if (elapsed_ms(begin, now) >= CAPTURE_WAIT_MS)
//              pipeline_halt(DUAL_ERROR_CAPTURE);
// -        }
// -    }
// -    XTime_GetTime(&now);
// -    DUAL_CTRL->timing[slot].capture_wait_us = elapsed_us(started, now);
// -
// -    source = CAP((parked + CAPTURE_COUNT - 1u) % CAPTURE_COUNT);
// -    dual_cache_enter(0);
// -    Xil_DCacheInvalidateRange((u32)source, FB_BYTES);
// -    dual_cache_leave(0);
// -    memcpy(frame_snapshot[slot], (const void *)source, FB_BYTES);
// -    XAxiVdma_StopParking(&vdma, XAXIVDMA_WRITE);
// -}
// -
// +    }
// +}
//  static void prepare_slot(unsigned slot, u32 frame_id)
//  {
//      XTime begin, captured, pre_end, end;
//  
//      /* Acquire the FREE published by CPU1, then reserve it before writing. */
//      dual_core_barrier();
// @@ -420,60 +429,76 @@
// 
//      DUAL_CTRL->timing[slot].capture_us = elapsed_us(begin, captured) +
//          elapsed_us(pre_end, end);
//      DUAL_CTRL->timing[slot].prepare_us = elapsed_us(begin, end);
//      dual_publish_slot(slot, SLOT_PREPARED);
//  }
//  
// +/* Runtime telemetry never waits for UART FIFO space. An entire line is
// + * queued before emission, so records cannot interleave or be half replaced.
// + * Eight writes per service call bound its effect on accelerator polling. */
// +static char perf_uart_line[384];
// +static u32 perf_uart_length, perf_uart_position;
// +#define UART_PROBE ((volatile u32 *)0xFFFF02A0u)
// +static void perf_uart_service(void)
// +{
// +    unsigned budget = 8u;
// +    while (budget-- && perf_uart_position < perf_uart_length) {
// +        if (XUartPs_IsTransmitFull(STDOUT_BASEADDRESS)) break;
// +        XUartPs_WriteReg(STDOUT_BASEADDRESS, XUARTPS_FIFO_OFFSET,
// +                        (u32)(u8)perf_uart_line[perf_uart_position++]);
// +    }
// +    UART_PROBE[2] = perf_uart_length - perf_uart_position;
// +}
// +
//  static void report_performance(u32 *reported, u32 *window)
//  {
//      dual_perf_stats_t sample;
//      u32 before, after;
// -
// +    int n;
// +    perf_uart_service();
//      if (DUAL_CTRL->post_count == *reported) return;
//      before = DUAL_CTRL->stats_seq;
//      if (before & 1u) return;
//      dual_core_barrier();
//      sample = DUAL_CTRL->perf;
//      dual_core_barrier();
//      after = DUAL_CTRL->stats_seq;
//      if (before != after || (after & 1u) || sample.done_count == *reported)
//          return;
//      *reported = sample.done_count;
//      if (sample.done_count != 1u && sample.fps_window_id == *window) return;
//      *window = sample.fps_window_id;
// -
// -    xil_printf("f%lu done=%lu ", (unsigned long)sample.frame_id,
// -               (unsigned long)sample.done_count);
// -    if (sample.period_us == 0u) {
// -        xil_printf("fps=warmup avg16=warmup ");
// -    } else {
// -        xil_printf("fps=%lu.%03lu avg16=%lu.%03lu period=%lu.%03lums ",
// -                   (unsigned long)(sample.fps_milli / 1000u),
// -                   (unsigned long)(sample.fps_milli % 1000u),
// -                   (unsigned long)(sample.avg_fps_milli / 1000u),
// -                   (unsigned long)(sample.avg_fps_milli % 1000u),
// -                   (unsigned long)(sample.period_us / 1000u),
// -                   (unsigned long)(sample.period_us % 1000u));
// -    }
// -    xil_printf("start=%lums gap=%luus | ms: pre=%lu cap=%lu(wait=%lu) prep=%lu "
// -               "infer=%lu.%03lu post=%lu inv=%lu draw=%lu postall=%lu lat=%lums\r\n",
// -               (unsigned long)(sample.start_period_us / 1000u),
// -               (unsigned long)sample.pl_gap_us,
// -               (unsigned long)(sample.pre_us / 1000u),
// -               (unsigned long)(sample.capture_us / 1000u),
// -               (unsigned long)(sample.capture_wait_us / 1000u),
// -               (unsigned long)(sample.prepare_us / 1000u),
// -               (unsigned long)(sample.infer_us / 1000u),
// -               (unsigned long)(sample.infer_us % 1000u),
// -               (unsigned long)(sample.post_us / 1000u),
// -               (unsigned long)(sample.invalidate_us / 1000u),
// -               (unsigned long)(sample.draw_us / 1000u),
// -               (unsigned long)(sample.post_total_us / 1000u),
// -               (unsigned long)(sample.latency_us / 1000u));
// -}
// -
// +    if (perf_uart_position != perf_uart_length) {
// +        /* Drop only a whole new telemetry sample; never delay video. */
// +        UART_PROBE[1]++;
// +        return;
// +    }
// +    n = snprintf(perf_uart_line, sizeof(perf_uart_line),
// +        "f%lu done=%lu fps=%lu.%03lu avg16=%lu.%03lu period=%lu.%03lums "
// +        "start=%lums gap=%luus | ms: pre=%lu cap=%lu(wait=%lu) prep=%lu "
// +        "infer=%lu.%03lu post=%lu inv=%lu draw=%lu postall=%lu lat=%lums\r\n",
// +        (unsigned long)sample.frame_id, (unsigned long)sample.done_count,
// +        (unsigned long)(sample.fps_milli/1000u), (unsigned long)(sample.fps_milli%1000u),
// +        (unsigned long)(sample.avg_fps_milli/1000u), (unsigned long)(sample.avg_fps_milli%1000u),
// +        (unsigned long)(sample.period_us/1000u), (unsigned long)(sample.period_us%1000u),
// +        (unsigned long)(sample.start_period_us/1000u), (unsigned long)sample.pl_gap_us,
// +        (unsigned long)(sample.pre_us/1000u), (unsigned long)(sample.capture_us/1000u),
// +        (unsigned long)(sample.capture_wait_us/1000u), (unsigned long)(sample.prepare_us/1000u),
// +        (unsigned long)(sample.infer_us/1000u), (unsigned long)(sample.infer_us%1000u),
// +        (unsigned long)(sample.post_us/1000u), (unsigned long)(sample.invalidate_us/1000u),
// +        (unsigned long)(sample.draw_us/1000u), (unsigned long)(sample.post_total_us/1000u),
// +        (unsigned long)(sample.latency_us/1000u));
// +    if (n < 0 || (unsigned)n >= sizeof(perf_uart_line)) {
// +        UART_PROBE[1]++;
// +        return;
// +    }
// +    perf_uart_position = 0u;
// +    perf_uart_length = (u32)n;
// +    UART_PROBE[0]++;
// +    perf_uart_service();
// +}
//  int main(void)
//  {
//      unsigned i, write_slot = 0;
//      u32 frame_id = 0, reported = 0, reported_window = 0;
//      XTime wait_start, now;
//      u32 last_wait_log = 0;
// @@ -488,16 +513,19 @@
// 
//      xil_printf("[CPU0] weights=%lu bytes, requant=%lu bytes\r\n",
//                 (unsigned long)yolov5n_weights_len,
//                 (unsigned long)yolov5n_rqt_len);
//  
//      SCCB_Init();
//      OV5640_Init();
// +    color_init();
// +    color_apply_advanced_awb();
// +    COLOR_MB[7]=1u;
//  
//      memset((void *)DISP_BASE, 0, DISPLAY_COUNT * FB_BYTES);
//      Xil_DCacheFlushRange(DISP_BASE, DISPLAY_COUNT * FB_BYTES);
// -    xil_printf("[VIDEO3] separate front/back buffers, frame-boundary park ACK, shared PARK_PTR serialized\r\n");
// +    xil_printf("[VIDEO3 CONTINUOUS] guarded completed-frame copy; capture never parked; display park ACK\r\n");
//      st = setup_vdma();
//      if (st != XST_SUCCESS) {
//          xil_printf("[CPU0] VDMA setup failed: %d\r\n", st);
//          pipeline_halt(DUAL_ERROR_CAPTURE);
//      }
//  
// @@ -558,12 +586,13 @@
// 
//      dual_core_barrier();
//      prime_capture();
//      xil_printf("[CPU0] CPU1 ready; cooperative pipeline started\r\n");
//  
//      while (1) {
//          service_pl();
// +        color_service();
//          start_prepared_slot();
//  
//          report_performance(&reported, &reported_window);
//  
//          if (DUAL_CTRL->slot_state[write_slot] == SLOT_FREE) {
//              prepare_slot(write_slot, frame_id++);
#endif

/* 交接补充
 * CPU0主循环依次service_pl、白平衡显式请求服务、启动已准备槽、排队性能日志、准备空槽。不恢复阻塞串口打印或S2MM停车；所有状态发布均配合屏障。
 */
