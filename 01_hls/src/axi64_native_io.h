#ifndef YOLOV5N_AXI64_NATIVE_IO_H
#define YOLOV5N_AXI64_NATIVE_IO_H

// Offsets/counts below are C4 words (32 bits), preserving the model ABI.
// Aligned interiors issue native 64-bit transfers. A 32-bit head/tail keeps
// odd feature widths safe without reading or modifying adjacent allocation.
template<int N>
static void axi64_read_words(const int8_t *memory, int first_word,
                             uint32_t local[N], int local_first, int count) {
#pragma HLS INLINE off
    if (count <= 0) return;
    const uint32_t *m32 = (const uint32_t *)memory;
    const uint64_t *m64 = (const uint64_t *)memory;
    const int head = first_word & 1;
    if (head) local[local_first] = m32[first_word];
    const int pairs = (count - head) >> 1;
    const int base = (first_word + head) >> 1;
AXI64_READ_PAIRS:
    for (int i = 0; i < pairs; ++i) {
#pragma HLS PIPELINE II=1
        const uint64_t data = m64[base + i];
        local[local_first + head + 2*i] = (uint32_t)data;
        local[local_first + head + 2*i + 1] = (uint32_t)(data >> 32);
    }
    const int tail = head + 2*pairs;
    if (tail < count) local[local_first + tail] = m32[first_word + tail];
}
/* 交接说明 函数 axi64_read_words 结束后
 * 函数axi64_read_words属于HLS计算及数据流。包含HLS流水线指示，修改循环边界后必须复核II与启动开销。本次交接只新增说明，不改变活动语句。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */

static void axi64_write_row(const int8_t *memory, int first_word,
                            const uint32_t local[HW_MAX_OC/HW_CI][HW_ROW_PIXELS],
                            int q, int count) {
#pragma HLS INLINE off
    if (count <= 0) return;
    uint32_t *m32 = (uint32_t *)memory;
    uint64_t *m64 = (uint64_t *)memory;
    const int head = first_word & 1;
    if (head) m32[first_word] = local[q][0];
    const int pairs = (count - head) >> 1;
    const int base = (first_word + head) >> 1;
AXI64_WRITE_ROW_PAIRS:
    for (int i = 0; i < pairs; ++i) {
#pragma HLS PIPELINE II=1
        const int x = head + 2*i;
        m64[base + i] = (uint64_t)local[q][x]
                      | ((uint64_t)local[q][x+1] << 32);
    }
    const int tail = head + 2*pairs;
    if (tail < count) m32[first_word + tail] = local[q][tail];
}
/* 交接说明 函数 axi64_write_row 结束后
 * 函数axi64_write_row属于HLS计算及数据流。包含HLS流水线指示，修改循环边界后必须复核II与启动开销。本次交接只新增说明，不改变活动语句。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */

static void axi64_write_line(const int8_t *memory, int first_word,
                             const uint32_t local[HW_ROW_PIXELS], int count) {
#pragma HLS INLINE off
    if (count <= 0) return;
    uint32_t *m32 = (uint32_t *)memory;
    uint64_t *m64 = (uint64_t *)memory;
    const int head = first_word & 1;
    if (head) m32[first_word] = local[0];
    const int pairs = (count - head) >> 1;
    const int base = (first_word + head) >> 1;
AXI64_WRITE_LINE_PAIRS:
    for (int i = 0; i < pairs; ++i) {
#pragma HLS PIPELINE II=1
        const int x = head + 2*i;
        m64[base + i] = (uint64_t)local[x] | ((uint64_t)local[x+1] << 32);
    }
    const int tail = head + 2*pairs;
    if (tail < count) m32[first_word + tail] = local[tail];
}
/* 交接说明 函数 axi64_write_line 结束后
 * 函数axi64_write_line属于HLS计算及数据流。包含HLS流水线指示，修改循环边界后必须复核II与启动开销。本次交接只新增说明，不改变活动语句。
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

/* 交接补充
 * 本次仅补充中文职责和历史替换说明；活动表达式、寄存器、延时和默认返回值均保留。未删除的历史代码不伪造删除块。
 */
