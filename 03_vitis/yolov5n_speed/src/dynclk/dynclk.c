/******************************************************************************

 * @file dynclk.c

 * Dynamic frequency generation for the axi_dynclk core

 *

 * @author Sam Bobrowicz

 *

 * @date 2015-Nov-25

 *

 * @copyright

 * (c) 2015 Copyright Digilent Incorporated

 * All Rights Reserved

 *

 * This program is free software; distributed under the terms of BSD 3-clause

 * license ("Revised BSD License", "New BSD License", or "Modified BSD License")

 *

 * Redistribution and use in source and binary forms, with or without modification,

 * are permitted provided that the following conditions are met:

 *

 * 1. Redistributions of source code must retain the above copyright notice, this

 *    list of conditions and the following disclaimer.

 * 2. Redistributions in binary form must reproduce the above copyright notice,

 *    this list of conditions and the following disclaimer in the documentation

 *    and/or other materials provided with the distribution.

 * 3. Neither the name(s) of the above-listed copyright holder(s) nor the names

 *    of its contributors may be used to endorse or promote products derived

 *    from this software without specific prior written permission.

 *

 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"

 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE

 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE

 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE

 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL

 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR

 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER

 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,

 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE

 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.



 * @desciption

 * Contains a driver for the Digilent axi_dynclk core. To use this driver:

 *

 * 1) Find the ClkMode struct for the frequency closest to your desired

 *    frequency using ClkFindParams.

 * 2) Pass the ClkMode struct to ClkFindReg to obtain the ClkConfig struct

 *    that contains the necessary register writes that need to be made.

 * 3) Call ClkWriteReg with the ClkConfig struct and the base address of the

 *    axi_dynclk core to configure the hardware to generate the desired

 *    frequency.

 * 4) Call ClkStart to start the clock.

 * 5) If you want to change the frequency, call ClkStop and then repeat steps

 *    1-4.

 *

 * Xilinx XAPP888 was referenced for information on reconfiguring the MMCM or PLL.

 *

 * <pre>

 * MODIFICATION HISTORY:

 *

 * Ver   Who          Date         Changes

 * ----- ------------ -----------  -----------------------------------------------

 * 1.00  Sam Bobrowicz 2015-Nov-25 First Release, separated from display_ctrl

 *

 * </pre>

 *

 *****************************************************************************/

/*

 * TODO: Functionality needs to be added to automatically take advantage of the

 *       MMCM's fractional divide. This will allow a far greater number of

 *       frequencies to be synthesized.

 * TODO: Add proper comments to functions. For now the description in the header

 *       file should provide enough info for users to use this.

 */



#include "dynclk.h"

#include "xil_io.h"

#include "math.h"



u32 ClkCountCalc(u32 divide)

{

	u32 output = 0;

	u32 divCalc = 0;



	divCalc = ClkDivider(divide);

	if (divCalc == ERR_CLKDIVIDER)

		output = ERR_CLKCOUNTCALC;

	else

		output = (0xFFF & divCalc) | ((divCalc << 10) & 0x00C00000);

	return output;

}
/* 交接说明 函数 ClkCountCalc 结束后
 * 将分频计数转换为MMCM寄存器字段，保留奇偶分频的高低计数与边沿位编码；服务像素时钟，不是HLS计算时钟。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */



u32 ClkDivider(u32 divide)

{

	u32 output = 0;

	u32 highTime = 0;

	u32 lowTime = 0;



	if ((divide < 1) || (divide > 128))

		return ERR_CLKDIVIDER;



	if (divide == 1)

		return 0x1041;



	highTime = divide / 2;

	if (divide & 0b1) //if divide is odd

	{

		lowTime = highTime + 1;

		output = 1 << CLK_BIT_WEDGE;

	}

	else

	{

		lowTime = highTime;

	}



	output |= 0x03F & lowTime;

	output |= 0xFC0 & (highTime << 6);

	return output;

}
/* 交接说明 函数 ClkDivider 结束后
 * 把分频值转换成动态时钟核要求的编码，包含边界处理；不可用简单整数写入替换该器件相关编码。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */



u32 ClkFindReg (ClkConfig *regValues, ClkMode *clkParams)

{

	if ((clkParams->fbmult < 2) || clkParams->fbmult > 64 )

		return 0;



	regValues->clk0L = ClkCountCalc(clkParams->clkdiv);

	if (regValues->clk0L == ERR_CLKCOUNTCALC)

		return 0;



	regValues->clkFBL = ClkCountCalc(clkParams->fbmult);

	if (regValues->clkFBL == ERR_CLKCOUNTCALC)

		return 0;



	regValues->clkFBH_clk0H = 0;



	regValues->divclk = ClkDivider(clkParams->maindiv);

	if (regValues->divclk == ERR_CLKDIVIDER)

		return 0;



	regValues->lockL = (u32) (lock_lookup[clkParams->fbmult - 1] & 0xFFFFFFFF);



	regValues->fltr_lockH = (u32) ((lock_lookup[clkParams->fbmult - 1] >> 32) & 0x000000FF);

	regValues->fltr_lockH |= ((filter_lookup_low[clkParams->fbmult - 1] << 16) & 0x03FF0000);



	return 1;

}
/* 交接说明 函数 ClkFindReg 结束后
 * 依据计算出的时钟参数形成实际动态时钟寄存器结构，供写入函数使用。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */



void ClkWriteReg (ClkConfig *regValues, u32 dynClkAddr)

{

	Xil_Out32(dynClkAddr + OFST_DYNCLK_CLK_L, regValues->clk0L);

	Xil_Out32(dynClkAddr + OFST_DYNCLK_FB_L, regValues->clkFBL);

	Xil_Out32(dynClkAddr + OFST_DYNCLK_FB_H_CLK_H, regValues->clkFBH_clk0H);

	Xil_Out32(dynClkAddr + OFST_DYNCLK_DIV, regValues->divclk);

	Xil_Out32(dynClkAddr + OFST_DYNCLK_LOCK_L, regValues->lockL);

	Xil_Out32(dynClkAddr + OFST_DYNCLK_FLTR_LOCK_H, regValues->fltr_lockH);

}
/* 交接说明 函数 ClkWriteReg 结束后
 * 通过AXI动态时钟IP寄存器写入MMCM参数；本函数不修改compute150和HP1时钟网。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */



/*

 * TODO:This function currently requires that the reference clock is 100MHz.

 * 		This should be changed so that the ref. clock can be specified, or read directly

 * 		out of hardware. This has been done in the linux driver, it just needs to be

 * 		ported here.

 */

double ClkFindParams(double freq, ClkMode *bestPick)

{

	double bestError = 2000.0;

	double curError;

	double curClkMult;

	double curFreq;

	u32 curDiv, curFb, curClkDiv;

	u32 minFb = 0;

	u32 maxFb = 0;



	/*

	 * This is necessary because the MMCM actual is generating 5x the desired pixel clock, and that

	 * clock is then run through a BUFR that divides it by 5 to generate the pixel clock. Note this

	 * means the pixel clock is on the Regional clock network, not the global clock network. In the

	 * future if options like these are parameterized in the axi_dynclk core, then this function will

	 * need to change.

	 */

	freq = freq * 5.0;



	bestPick->freq = 0.0;

/*

 * TODO: replace with a smarter algorithm that doesn't doesn't check every possible combination

 */

	for (curDiv = 1; curDiv <= 10; curDiv++)

	{

		minFb = curDiv * 6; //This accounts for the 100MHz input and the 600MHz minimum VCO

		maxFb = curDiv * 12; //This accounts for the 100MHz input and the 1200MHz maximum VCO

		if (maxFb > 64)

			maxFb = 64;



		curClkMult = (100.0 / (double) curDiv) / freq; //This multiplier is used to find the best clkDiv value for each FB value



		curFb = minFb;

		while (curFb <= maxFb)

		{

			curClkDiv = (u32) ((curClkMult * (double)curFb) + 0.5);

			curFreq = ((100.0 / (double) curDiv) / (double) curClkDiv) * (double) curFb;

			curError = fabs(curFreq - freq);

			if (curError < bestError)

			{

				bestError = curError;

				bestPick->clkdiv = curClkDiv;

				bestPick->fbmult = curFb;

				bestPick->maindiv = curDiv;

				bestPick->freq = curFreq;

			}



			curFb++;

		}

	}



	/*

	 * We want the ClkMode struct and errors to be based on the desired frequency. Need to check this doesn't introduce

	 * rounding errors.

	 */

	bestPick->freq = bestPick->freq / 5.0;

	bestError = bestError / 5.0;

	return bestError;

}
/* 交接说明 函数 ClkFindParams 结束后
 * 搜索满足像素目标频率及MMCM限制的输入/反馈/输出分频组合，选择误差合适的配置。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */





void ClkStart(u32 dynClkAddr)

{

	Xil_Out32(dynClkAddr + OFST_DYNCLK_CTRL, (1 << BIT_DYNCLK_START));

	while(!(Xil_In32(dynClkAddr + OFST_DYNCLK_STATUS) & (1 << BIT_DYNCLK_RUNNING)));



	return;

}
/* 交接说明 函数 ClkStart 结束后
 * 使能动态像素时钟并检查锁定状态，显示链路需稳定像素时钟；不可省略锁定处理直接读屏。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */



void ClkStop(u32 dynClkAddr)

{

	Xil_Out32(dynClkAddr + OFST_DYNCLK_CTRL, 0);

	while((Xil_In32(dynClkAddr + OFST_DYNCLK_STATUS) & (1 << BIT_DYNCLK_RUNNING)));



	return;

}
/* 交接说明 函数 ClkStop 结束后
 * 停用动态像素时钟以安全改参数，正常视频处理不应周期性调用造成屏幕停顿。
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
