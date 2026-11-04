/************************************************************************/

/*																		*/

/*	display_ctrl.h	--	Digilent Display Controller Driver				*/

/*																		*/

/************************************************************************/

/*	Author: Sam Bobrowicz												*/

/*	Copyright 2014, Digilent Inc.										*/

/************************************************************************/

/*  Module Description: 												*/

/*																		*/

/*		This module provides an easy to use API for controlling a    	*/

/*		Display attached to a Digilent system board via VGA or HDMI. 	*/

/*		run-time resolution setting and seamless framebuffer-swapping 	*/

/*		for tear-free animation. 										*/

/*																		*/

/*		To use this driver, you must have a Xilinx Video Timing 		*/

/* 		Controller core (vtc), Xilinx axi_vdma core, a Digilent 		*/

/*		axi_dynclk core, a Xilinx AXI Stream to Video core, and either  */

/*		a Digilent RGB2VGA or RGB2DVI core all present in your design.  */

/*		See the Video in or Display out reference projects for your     */

/*		system board to see how they need to be connected. Digilent     */

/*		reference projects and IP cores can be found at 				*/

/*		www.github.com/Digilent.			 							*/

/*																		*/

/*		The following steps should be followed to use this driver:		*/

/*		1) Create a DisplayCtrl object and pass a pointer to it to 		*/

/*		   DisplayInitialize.											*/

/*		2) Call DisplaySetMode to set the desired mode					*/

/*		3) Call DisplayStart to begin outputting data to the display	*/

/*		4) To create a seamless animation, draw the next image to a		*/

/*		   framebuffer currently not being displayed. Then call 		*/

/*		   DisplayChangeFrame to begin displaying that frame.			*/

/*		   Repeat as needed, only ever modifying inactive frames.		*/

/*		5) To change the resolution, call DisplaySetMode, followed by	*/

/*		   DisplayStart again.											*/

/*																		*/

/*																		*/

/************************************************************************/

/*  Revision History:													*/

/* 																		*/

/*		2/20/2014(SamB): Created										*/

/*		11/25/2015(SamB): Changed from axi_dispctrl to Xilinx cores		*/

/*						  Separated Clock functions into dynclk library */

/*																		*/

/************************************************************************/



#ifndef DISPLAY_CTRL_H_

#define DISPLAY_CTRL_H_



/* ------------------------------------------------------------ */

/*				Include File Definitions						*/

/* ------------------------------------------------------------ */



#include "xil_types.h"

#include "xaxivdma.h"

#include "xvtc.h"

#include "../dynclk/dynclk.h"

#include "lcd_modes.h"





/* ------------------------------------------------------------ */

/*					Miscellaneous Declarations					*/

/* ------------------------------------------------------------ */



#define BIT_DISPLAY_RED 16

#define BIT_DISPLAY_GREEN 8

#define BIT_DISPLAY_BLUE 0



/*

 * This driver currently supports frames.

 */

#define DISPLAY_NUM_FRAMES 1



/* ------------------------------------------------------------ */

/*					General Type Declarations					*/

/* ------------------------------------------------------------ */



typedef enum {

	DISPLAY_STOPPED = 0,

	DISPLAY_RUNNING = 1

} DisplayState;



typedef struct {

		u32 	 dynClkAddr;/*Physical Base address of the dynclk core*/

		XVtc vtc;		 	/*VTC driver struct*/

		VideoMode vMode; 	/*Current Video mode*/

		double pxlFreq;		/* Frequency of clock currently being generated */

		DisplayState state; /* Indicates if the Display is currently running */

} DisplayCtrl;



/* ------------------------------------------------------------ */

/*					Procedure Declarations						*/

/* ------------------------------------------------------------ */



int DisplayStop(DisplayCtrl *dispPtr);

int DisplayStart(DisplayCtrl *dispPtr);

int DisplayInitialize(DisplayCtrl *dispPtr,                 u16 vtcId, u32 dynClkAddr);

int DisplaySetMode(DisplayCtrl *dispPtr, const VideoMode *newMode);

int DisplayChangeFrame(DisplayCtrl *dispPtr, u32 frameIndex);





/* ------------------------------------------------------------ */



/************************************************************************/



#endif /* DISPLAY_CTRL_H_ */












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
