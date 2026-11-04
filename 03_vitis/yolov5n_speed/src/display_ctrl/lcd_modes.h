/************************************************************************/

/*																		*/

/*	lcd_modes.h	--	VideoMode definitions		 						*/

/*																		*/

/************************************************************************/

/*	Author: Sam Bobrowicz												*/

/*	Copyright 2014, Digilent Inc.										*/

/************************************************************************/

/*  Module Description: 												*/

/*																		*/

/*		This file contains the definition of the VideoMode type, and	*/

/*		also defines several common video modes							*/

/*																		*/

/************************************************************************/

/*  Revision History:													*/

/* 																		*/

/*		2/17/2014(SamB): Created										*/

/*																		*/

/************************************************************************/



#ifndef LCD_MODES_H_

#define LCD_MODES_H_



typedef struct {

	char label[64]; /* Label describing the resolution */

	u32 width; /*Width of the active video frame*/

	u32 height; /*Height of the active video frame*/

	u32 hps; /*Start time of Horizontal sync pulse, in pixel clocks (active width + H. front porch)*/

	u32 hpe; /*End time of Horizontal sync pulse, in pixel clocks (active width + H. front porch + H. sync width)*/

	u32 hmax; /*Total number of pixel clocks per line (active width + H. front porch + H. sync width + H. back porch) */

	u32 hpol; /*hsync pulse polarity*/

	u32 vps; /*Start time of Vertical sync pulse, in lines (active height + V. front porch)*/

	u32 vpe; /*End time of Vertical sync pulse, in lines (active height + V. front porch + V. sync width)*/

	u32 vmax; /*Total number of lines per frame (active height + V. front porch + V. sync width + V. back porch) */

	u32 vpol; /*vsync pulse polarity*/

	double freq; /*Pixel Clock frequency*/

} VideoMode;



static const VideoMode VMODE_480x272 = {

	.label = "480x272@60Hz",

	.width = 480,

	.height = 272,

	.hps = 482,

	.hpe = 523,

	.hmax = 525,

	.hpol = 0,

	.vps = 274,

	.vpe = 284,

	.vmax = 286,

	.vpol = 0,

	.freq = 9

};







static const VideoMode VMODE_800x480 = {

	.label = "800x480@60Hz",

	.width = 800,

	.height= 480,

	.hps   = 840,

	.hpe   = 968,

	.hmax  = 1056,

	.hpol  = 0,

	.vps   = 490,

	.vpe   = 492,

	.vmax  = 525,

	.vpol  = 0,

	.freq  = 33.0

};



static const VideoMode VMODE_1920x1080 = {

	.label = "1920x1080@60Hz",

	.width = 1920,

	.height = 1080,

	.hps = 2008,

	.hpe = 2052,

	.hmax = 2199,

	.hpol = 1,

	.vps = 1084,

	.vpe = 1089,

	.vmax = 1124,

	.vpol = 1,

	.freq = 148.5 //148.57 is close enough

};





static const VideoMode VMODE_1024x600 = {

	.label = "1024x600@60Hz",

	.width = 1024,

	.height = 600,

	.hps = 1164,

	.hpe = 1184,

	.hmax = 1344,

	.hpol = 0,

	.vps = 620,

	.vpe = 623,

	.vmax = 635,

	.vpol = 0,

	.freq = 50.0

};





static const VideoMode VMODE_1280x800 = {

	.label = "1280x800@60Hz",

	.width = 1280,

	.height = 800,

	.hps = 1360,

	.hpe = 1370,

	.hmax = 1440,

	.hpol = 0,

	.vps = 810,

	.vpe = 813,

	.vmax = 823,

	.vpol = 0,

	.freq = 70.0

};





static const VideoMode VMODE_1280x1024 = {

	.label = "1280x1024@60Hz",

	.width = 1280,

	.height = 1024,

	.hps = 1328,

	.hpe = 1440,

	.hmax = 1687,

	.hpol = 1,

	.vps = 1025,

	.vpe = 1028,

	.vmax = 1065,

	.vpol = 1,

	.freq = 108.0

};



static const VideoMode VMODE_1280x720 = {

	.label = "1280x720@60Hz",

	.width = 1280,

	.height = 720,

	.hps = 1390,

	.hpe = 1430,

	.hmax = 1649,

	.hpol = 1,

	.vps = 725,

	.vpe = 730,

	.vmax = 749,

	.vpol = 1,

	.freq = 74.25, //74.2424 is close enough

};



#endif /* LCD_MODES_H_ */


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
