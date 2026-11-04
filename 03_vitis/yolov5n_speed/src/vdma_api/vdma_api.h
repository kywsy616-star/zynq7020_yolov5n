/******************************************************************************

*

* Copyright (C) 2014 - 2015 Xilinx, Inc.  All rights reserved.

*

* Permission is hereby granted, free of charge, to any person obtaining a copy

* of this software and associated documentation files (the "Software"), to deal

* in the Software without restriction, including without limitation the rights

* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell

* copies of the Software, and to permit persons to whom the Software is

* furnished to do so, subject to the following conditions:

*

* The above copyright notice and this permission notice shall be included in

* all copies or substantial portions of the Software.

*

* Use of the Software is limited solely to applications:

* (a) running on a Xilinx device, or

* (b) that interact with a Xilinx device through a bus or interconnect.

*

* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR

* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,

* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL

* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,

* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF

* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE

* SOFTWARE.

*

* Except as contained in this notice, the name of the Xilinx shall not be used

* in advertising or otherwise to promote the sale, use or other dealings in

* this Software without prior written authorization from Xilinx.

*

******************************************************************************/



#ifndef VDMA_API_H_

#define VDMA_API_H_



/* ------------------------------------------------------------ */

/*				Include File Definitions						*/

/* ------------------------------------------------------------ */



#include "xaxivdma.h"

#include "xparameters.h"

#include "xil_exception.h"



/* ------------------------------------------------------------ */

/*					General Type Declarations					*/

/* ------------------------------------------------------------ */



typedef enum

{

	ONLY_READ=1,    //VDMA只开启读通道

	ONLY_WRITE,     //VDMA只开启写通道

	BOTH            //同时开启VDMA写通道和读通道

}vdma_run_mode;



/* ------------------------------------------------------------ */

/*					Procedure Declarations						*/

/* ------------------------------------------------------------ */

int run_vdma_frame_buffer(XAxiVdma* InstancePtr, int DeviceId, int hsize,

		int vsize, int buf_base_addr, int number_frame_count,

		int enable_frm_cnt_intr,vdma_run_mode mode);

/* ------------------------------------------------------------ */



/************************************************************************/



#endif /* VDMA_API_H_ */












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
