

#include"xgpiops.h"

#include"sleep.h"



#ifndef SCCB_INIT_H_

#define SCCB_INIT_H_



#define SCCB_SCL 54

#define SCCB_SDA 55



#define  OV7725_Addr    0x42   //OV7725器件地址

#define  OV5640_Addr    0x78   //OV5640器件地址



void SCCB_Init(void);

void SCCB_Start(void);

void SCCB_Stop(void);

void SCCB_Ack(void);

void SCCB_WaitAck(void);

void SCCB_Send_byte(u8 SendByte);

void sccb_write_reg16(u16 addr , u8 data);

u8  SCCB_Rece_byte(void);

u8 sccb_read_reg16(u16 addr );



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
