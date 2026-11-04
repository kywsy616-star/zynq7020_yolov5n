/* Zynq-7000 BootROM AMP handoff: publish entry, DSB, SEV.
 * CPU1 is parked by BootROM until CPU0 wakes it. Its ELF must already have
 * been loaded by FSBL/JTAG. Do not reset CPU1 or reconfigure the shared GIC.
 * In particular 0xF8F00200 is not a separately addressable CPU1 interface.
 */
#include "dual_core_shared.h"
#include "xil_cache.h"
#include "xil_io.h"
#include "xil_printf.h"

int cpu0_wakeup_cpu1(uint32_t cpu1_entry_addr)
{
    u32 first_word;

    if (cpu1_entry_addr != CPU1_ENTRY_ADDR ||
        (cpu1_entry_addr & 31u) != 0u) {
        return -1;
    }

    Xil_DCacheInvalidateRange(cpu1_entry_addr, 32u);
    first_word = Xil_In32(cpu1_entry_addr);
    if (first_word == 0u || first_word == 0xFFFFFFFFu) {
        xil_printf("[CPU0] CPU1 image missing at 0x%08lX; load both ELFs\r\n",
                   (unsigned long)cpu1_entry_addr);
        return -1;
    }

    /* The entire high OCM section, including the handoff word, is already
     * non-cacheable. No range operation near the 32-bit wrap is needed.
     */
    Xil_Out32(CPU1_RESET_VECT_ADDR, cpu1_entry_addr);
    __asm__ volatile ("dsb sy\n\tsev" ::: "memory");
    xil_printf("[CPU0] CPU1 wakeup: entry=0x%08lX vector=0x%08lX\r\n",
               (unsigned long)cpu1_entry_addr, (unsigned long)first_word);
    return 0;
}
/* 交接说明 函数 cpu0_wakeup_cpu1 结束后
 * 发布CPU1的0x1F000000入口并通过屏障/事件唤醒。保持已修复的唤醒顺序，不恢复旧park_cpu1清向量路径，也不替代CPU1 ELF的下载。
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
