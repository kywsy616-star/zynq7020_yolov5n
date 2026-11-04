#ifndef COLOR_CAMERA_H
#define COLOR_CAMERA_H
/* Bounded commissioning mailbox in unused non-cacheable OCM. No SCCB
 * transaction is made unless explicitly requested, between PL runs. */
#define COLOR_MB ((volatile u32 *)0xFFFF0300u)
static const u16 color_regs[] = {
    0x3400,0x3401,0x3402,0x3403,0x3404,0x3405,0x3406,
    0x5000,0x5001,0x501f,0x4300,0x503d,0x5580,0x5583,0x5584,
    0x5180,0x5181,0x5182,0x5183,0x5184,0x5186,0x5187,0x5188,
    0x5189,0x518a,0x518b,0x518c,0x518d,0x518e,0x518f,
    0x5190,0x5191,0x5192,0x300a,0x300b
};
static const struct {u16 reg;u8 value;} color_advanced_awb[] = {
    /* Digilent Pcam5C OV5640 advanced-AWB profile; preserve other ISP bits. */
    {0x3406,0x00},{0x5192,0x04},{0x5191,0xf8},{0x518d,0x26},
    {0x518f,0x42},{0x518e,0x2b},{0x5190,0x42},{0x518b,0xd0},
    {0x518c,0xbd},{0x5187,0x18},{0x5188,0x18},{0x5189,0x56},
    {0x518a,0x5c},{0x5186,0x1c},{0x5181,0x50},{0x5184,0x20},
    {0x5182,0x11},{0x5183,0x00}
};
static void color_dump(void)
{
    unsigned i;
    for(i=0;i<sizeof(color_regs)/sizeof(color_regs[0]);i++)
        COLOR_MB[16u+i]=((u32)color_regs[i]<<16)|sccb_read_reg16(color_regs[i]);
}
/* 交接说明 函数 color_dump 结束后
 * 采集35个相机寄存器，按高16位地址加低8位值编码到OCM；用于实际读回验证，不能仅凭源码表认定硬件已生效。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */
static void color_apply_advanced_awb(void)
{
    unsigned i;
    for(i=0;i<sizeof(color_advanced_awb)/sizeof(color_advanced_awb[0]);i++)
        sccb_write_reg16(color_advanced_awb[i].reg,color_advanced_awb[i].value);
    sccb_write_reg16(0x5001,sccb_read_reg16(0x5001)|0x03u);
}
/* 交接说明 函数 color_apply_advanced_awb 结束后
 * 最终新增相机高级自动白平衡设置。写18项已确认参数并保留5001其他位；不改HLS、权重或量化，不使用每帧CPU图像滤镜。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */
static void color_init(void)
{
    memset((void *)COLOR_MB,0,256u);
    COLOR_MB[0]=0x434F4C52u;
    color_dump();
}
/* 交接说明 函数 color_init 结束后
 * 初始化非缓存OCM调试邮箱并采集初始相机寄存器，供人工调试追溯。最终main随后显式应用高级AWB以在每次运行固化。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */
static void color_service(void)
{
    u32 seq=COLOR_MB[1],op;
    if(seq==COLOR_MB[2] || active_slot>=0) return;
    dual_core_barrier();
    op=COLOR_MB[3];
    COLOR_MB[6]=0u;
    if(op==2u) {
        /* Test-pattern and color-only register whitelist; no clock/timing. */
        u16 reg=(u16)COLOR_MB[4];
        if(reg==0x503d || reg==0x5583 || reg==0x5584 || reg==0x3406 ||
           (reg>=0x3400 && reg<=0x3405))
            sccb_write_reg16(reg,(u8)COLOR_MB[5]);
        else COLOR_MB[6]=1u;
    } else if(op==3u) {
        color_apply_advanced_awb();
        COLOR_MB[7]=1u;
    } else if(op!=1u) COLOR_MB[6]=2u;
    color_dump();
    dual_core_barrier();
    COLOR_MB[2]=seq;
}
/* 交接说明 函数 color_service 结束后
 * 只在请求序号改变且PL空闲时执行白名单SCCB命令；默认无持续总线交易，避免运行期额外开销或误改时钟。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */
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
 * 本次仅补充中文职责和历史替换说明；活动表达式、寄存器、延时和默认返回值均保留。未删除的历史代码不伪造删除块。
 */
