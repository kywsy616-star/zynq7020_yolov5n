/* CPU0/CPU1 AMP protocol. Keep the two application copies identical.
 *
 * CPU0 owns ALL accelerator registers, including clear-on-read ap_done.
 * CPU1 consumes completed slots and never accesses accelerator registers.
 * Both CPUs map the high OCM section non-cacheable before accessing this block.
 * 0xFFFF0000..0xFFFFFFFF is the high 64 KB OCM bank, not a 256 KB range.
 */
#ifndef DUAL_CORE_SHARED_H
#define DUAL_CORE_SHARED_H

#include <stdint.h>

#define OCM_CTRL_ADDR          0xFFFF0000u
#define OCM_CTRL_SIZE          0x00001000u
#define DUAL_CORE_MAGIC        0x5A5A5A5Au
#define DUAL_CORE_VERSION      3u
#define DUAL_SLOT_COUNT        2u

/* Fits in the first 512 MB, even if the XSA advertises 1 GB.
 * CPU0 ELF: 0x00100000..0x0FFFFFFF
 * Video:    0x10000000..0x106977FF (3 capture frames + 3 display frames)
 * CPU1 ELF: 0x1F000000..0x1FFFFFFF
 * Both lscript.ld files enforce the ELF ranges; rebuild BOTH applications.
 */
#define CPU1_ENTRY_ADDR        0x1F000000u
#define CPU1_IMAGE_LIMIT       0x20000000u
#define CPU1_RESET_VECT_ADDR   0xFFFFFFF0u
#define VIDEO_FB_BASE          0x10000000u

/* Each slot carries one complete arena AND a frozen camera frame.
 * CPU0: FREE -> PREPARING -> PREPARED -> PL_RUNNING -> POST_READY
 * CPU1: POST_READY -> POSTING -> FREE
 * Only one slot may be PL_RUNNING. PREPARED waits for that run to finish.
 * FREE is published after CPU1's display flush and statistics are done.
 */
enum {
    SLOT_FREE = 0,
    SLOT_PREPARING,
    SLOT_PREPARED,
    SLOT_PL_RUNNING,
    SLOT_POST_READY,
    SLOT_POSTING
};

#define CPU1_STATE_BOOT          0x00000001u
#define CPU1_STATE_WAIT_MAGIC    0x00000004u
#define CPU1_STATE_WAIT_CPU0     0x00000005u
#define CPU1_STATE_READY         0x00000006u
#define CPU1_STATE_FIND_SLOT     0x00000007u
#define CPU1_STATE_POSTING       0x0000000Au
#define CPU1_STATE_DRAWING       0x0000000Bu
#define CPU1_STATE_FRAME_DONE    0x0000000Cu
#define CPU1_STATE_STOPPED       0x0000000Du
#define CPU1_STATE_DEADLOOP      0xDEADDEADu

#define DUAL_ERROR_NONE          0u
#define DUAL_ERROR_PROTOCOL      1u
#define DUAL_ERROR_CPU1_TIMEOUT  2u
#define DUAL_ERROR_PL_TIMEOUT    3u
#define DUAL_ERROR_POST_TIMEOUT  4u
#define DUAL_ERROR_CAPTURE       5u
#define DUAL_ERROR_CPU1_IMAGE    6u
#define DUAL_ERROR_CPU1_FAILED   7u

/* Slot-owned timestamps/measurements, valid until CPU1 publishes FREE.
 * pre_us matches the original pre boundary: preprocess + input flush.
 * capture_us covers capture/copy + snapshot flush; prepare_us covers both.
 */
typedef struct {
    uint32_t pre_us;
    uint32_t capture_us;
    uint32_t capture_wait_us;
    uint32_t prepare_us;
    uint32_t infer_us;
    uint32_t pl_gap_us;
    uint32_t start_period_us;
    uint32_t begin_ticks_lo;
    uint32_t begin_ticks_hi;
} dual_slot_timing_t;

/* CPU1 publishes a complete sample under stats_seq after display flush.
 * FPS uses raw completion timestamps, independent of CPU0's UART/poll timing.
 */
typedef struct {
    uint32_t frame_id;
    uint32_t done_count;
    uint32_t pre_us;
    uint32_t capture_us;
    uint32_t capture_wait_us;
    uint32_t prepare_us;
    uint32_t infer_us;
    uint32_t pl_gap_us;
    uint32_t start_period_us;
    uint32_t post_us;
    uint32_t invalidate_us;
    uint32_t draw_us;
    uint32_t post_total_us;
    uint32_t latency_us;
    uint32_t period_us;
    uint32_t fps_milli;
    uint32_t avg_fps_milli;
    uint32_t avg_period_us;
    uint32_t fps_window_id;
} dual_perf_stats_t;

typedef struct {
    uint32_t magic;
    uint32_t version;
    uint32_t cpu0_ready;
    uint32_t cpu1_ready;
    uint32_t stop_requested;
    uint32_t cpu0_error;
    uint32_t cpu1_state;
    uint32_t cpu1_error;

    uint32_t slot_state[DUAL_SLOT_COUNT];
    uint32_t frame_id[DUAL_SLOT_COUNT];
    uint32_t arena_addr[DUAL_SLOT_COUNT];
    uint32_t snapshot_addr[DUAL_SLOT_COUNT];
    uint32_t pre_ms[DUAL_SLOT_COUNT];
    uint32_t infer_ms[DUAL_SLOT_COUNT];
    uint32_t post_ms[DUAL_SLOT_COUNT];
    uint32_t disp_base;

    uint32_t frame_count;       /* CPU0: submitted to PL */
    uint32_t post_count;        /* CPU1: displayed frames */
    uint32_t last_frame_id;     /* CPU1: all last_* times match this ID */
    uint32_t last_pre_ms;
    uint32_t last_infer_ms;
    uint32_t last_post_ms;

    /* Xilinx 2020.2 cache range routines manipulate shared L2 controller/debug
     * registers. Serialize these routines across both cores.
     * Two-party Peterson lock; no exclusive accesses to OCM are needed.
     * Interrupt handlers must not acquire this lock.
     */
    uint32_t cache_want[2];
    uint32_t cache_turn;

    /* Keep the v2 prefix/debug offsets above intact; v3 adds precise timing.
     * stats_seq: odd while CPU1 writes; even when a sample can be acquired.
     */
    dual_slot_timing_t timing[DUAL_SLOT_COUNT];
    uint32_t stats_seq;
    dual_perf_stats_t perf;
} dual_core_ctrl_t;

typedef char dual_ctrl_fits_in_ocm[
    (sizeof(dual_core_ctrl_t) <= OCM_CTRL_SIZE) ? 1 : -1];

#define DUAL_CTRL ((volatile dual_core_ctrl_t *)OCM_CTRL_ADDR)

static inline void dual_core_barrier(void)
{
    __asm__ volatile ("dmb sy" ::: "memory");
}
/* 交接说明 函数 dual_core_barrier 结束后
 * 函数dual_core_barrier属于Vitis双核固件与视频外设。保留原实现，负责调用者所需的局部处理；输入输出及调用位置见本函数签名和正文。本次交接只新增说明，不改变活动语句。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */

/* Release a slot after its payload/metadata is visible. Readers call
 * dual_core_barrier() after observing the state they are waiting for.
 */
static inline void dual_publish_slot(unsigned slot, uint32_t state)
{
    dual_core_barrier();
    DUAL_CTRL->slot_state[slot] = state;
}
/* 交接说明 函数 dual_publish_slot 结束后
 * 函数dual_publish_slot属于Vitis双核固件与视频外设。保留原实现，负责调用者所需的局部处理；输入输出及调用位置见本函数签名和正文。本次交接只新增说明，不改变活动语句。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */

static inline void dual_cache_enter(unsigned core)
{
    unsigned other = 1u - core;
    DUAL_CTRL->cache_want[core] = 1u;
    DUAL_CTRL->cache_turn = other;
    dual_core_barrier();
    while (DUAL_CTRL->cache_want[other] &&
           DUAL_CTRL->cache_turn == other) { }
    dual_core_barrier();
}
/* 交接说明 函数 dual_cache_enter 结束后
 * 函数dual_cache_enter属于Vitis双核固件与视频外设。涉及缓存可见性，须保留CPU与DMA所有权交接。本次交接只新增说明，不改变活动语句。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */

static inline void dual_cache_leave(unsigned core)
{
    dual_core_barrier();
    DUAL_CTRL->cache_want[core] = 0u;
    dual_core_barrier();
}
/* 交接说明 函数 dual_cache_leave 结束后
 * 函数dual_cache_leave属于Vitis双核固件与视频外设。涉及缓存可见性，须保留CPU与DMA所有权交接。本次交接只新增说明，不改变活动语句。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */

/* CPU0 only; called after OCM is mapped non-cacheable. */
int cpu0_wakeup_cpu1(uint32_t cpu1_entry_addr);

#endif

/*
 * 最终版交接说明 2026年10月27日
 * 文件角色：Vitis双核固件与视频外设
 * 本文件活动代码对应已验证R6.6 IP1.16 COLOR_AWB，交接阶段不增加算法。
 * 依赖：HLS2020.2或Vitis2020.2，具体目录和构建顺序见根目录上板运行操作步骤。
 * 修改要求：保持C4布局、64B描述符、量化截断顺序、双核共享内存和缓冲所有权。
 * 删除/替换记录：下方仅在确有前驱差异时保存禁用旧代码；不虚构曾删除的代码。
 */

/* 交接补充
 * 所有共享结构偏移必须保持；OCM控制区非缓存，DDR张量用范围cache维护。slot状态由各自所有者按协议转移；不可用volatile替代内存屏障。
 */
