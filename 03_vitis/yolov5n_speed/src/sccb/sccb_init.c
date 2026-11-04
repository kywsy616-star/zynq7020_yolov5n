

#include"sccb_init.h"



#define  GPIOPS_ID  XPAR_XGPIOPS_0_DEVICE_ID



static  XGpioPs  Gpiops;



/*初始化sccb引脚*/

void SCCB_Init(void)

{



	XGpioPs_Config *Psgpio_ptr; 	//配置指针



	Psgpio_ptr = XGpioPs_LookupConfig(GPIOPS_ID);

	XGpioPs_CfgInitialize(&Gpiops, Psgpio_ptr, Psgpio_ptr->BaseAddr);



	/*输出模式*/

	XGpioPs_SetDirectionPin(&Gpiops, SCCB_SCL, 1);

	XGpioPs_SetDirectionPin(&Gpiops, SCCB_SDA, 1);



	/*设置输出模式使能*/

	XGpioPs_SetOutputEnablePin(&Gpiops, SCCB_SCL, 1);

	XGpioPs_SetOutputEnablePin(&Gpiops, SCCB_SDA, 1);



	/*初始值为高电平*/

	XGpioPs_WritePin(&Gpiops, SCCB_SCL, 1);

	XGpioPs_WritePin(&Gpiops, SCCB_SDA, 1);

}
/* 交接说明 函数 SCCB_Init 结束后
 * 初始化PS GPIO实现的SCCB时钟和数据管脚方向及默认电平，用于OV5640寄存器访问；不修改像素数据通路。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */



/*sccb起始信号*/

void SCCB_Start(void)

{

	XGpioPs_WritePin(&Gpiops, SCCB_SCL, 1);

	XGpioPs_WritePin(&Gpiops, SCCB_SDA, 1);



	usleep(4);



 	XGpioPs_WritePin(&Gpiops, SCCB_SDA, 0);



 	usleep(4);



 	XGpioPs_WritePin(&Gpiops, SCCB_SCL, 0);



}
/* 交接说明 函数 SCCB_Start 结束后
 * SCL为高期间让SDA由高变低生成起始条件，并保留微秒级延时，满足相机寄存器总线时序。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */



/*sccb停止信号*/

void SCCB_Stop(void)

{



	XGpioPs_WritePin(&Gpiops, SCCB_SCL, 0);



	usleep(4);



	XGpioPs_WritePin(&Gpiops,SCCB_SDA, 0);



 	usleep(4);



	XGpioPs_WritePin(&Gpiops, SCCB_SCL, 1);



	usleep(4);



	XGpioPs_WritePin(&Gpiops, SCCB_SDA, 1);



}
/* 交接说明 函数 SCCB_Stop 结束后
 * SCL高期间SDA由低变高生成停止条件，结束一次寄存器交易并释放总线。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */



/*sccb发送字节*/

void SCCB_Send_byte(u8 SendByte)

{

    u8 t = 8;



    while(t--)

    {

    	XGpioPs_WritePin(&Gpiops, SCCB_SCL, 0);

    	usleep(4);



    	 if(SendByte&0x80)

    		XGpioPs_WritePin(&Gpiops, SCCB_SDA, 1);

    	 else

    		XGpioPs_WritePin(&Gpiops, SCCB_SDA, 0);

		SendByte<<=1;

		usleep(4);

		XGpioPs_WritePin(&Gpiops, SCCB_SCL, 1);

		usleep(4);

    }

    XGpioPs_WritePin(&Gpiops, SCCB_SCL, 0);

}
/* 交接说明 函数 SCCB_Send_byte 结束后
 * 按最高位先发送8bit，逐位翻转GPIO时钟和数据并保持原延时；本函数只发字节，应答由ACK函数处理。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */



/*sccb接收一个字节*/

u8  SCCB_Rece_byte(void)

{

	unsigned char i=0 , rece=0;



	XGpioPs_SetOutputEnablePin(&Gpiops, SCCB_SDA, 0);

	XGpioPs_SetDirectionPin(&Gpiops, SCCB_SDA, 0);



	XGpioPs_WritePin(&Gpiops, SCCB_SDA, 1);



	for(i=0;i<8;i++ )

	{

		rece <<= 1;

        XGpioPs_WritePin(&Gpiops, SCCB_SCL, 0);

        usleep(4);

        XGpioPs_WritePin(&Gpiops, SCCB_SCL, 1);

        usleep(4);

        if( XGpioPs_ReadPin(&Gpiops, SCCB_SDA) ) {

        	rece = rece | 0x01;

        }

		XGpioPs_WritePin(&Gpiops, SCCB_SCL, 0);

    }



	XGpioPs_WritePin(&Gpiops, SCCB_SCL, 0);



	XGpioPs_SetDirectionPin(&Gpiops, SCCB_SDA, 1);

	XGpioPs_SetOutputEnablePin(&Gpiops, SCCB_SDA, 1);



    return rece;



}
/* 交接说明 函数 SCCB_Rece_byte 结束后
 * 把SDA设为输入并逐个时钟采样8bit后组合成返回字节，再交给调用方做ACK/NACK和停止序列。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */





void SCCB_Ack(void)

{

	XGpioPs_WritePin(&Gpiops, SCCB_SCL, 0);

	usleep(4);

	XGpioPs_WritePin(&Gpiops, SCCB_SDA, 0);

	usleep(4);

	XGpioPs_WritePin(&Gpiops, SCCB_SCL, 1);

	usleep(4);

	XGpioPs_WritePin(&Gpiops, SCCB_SCL, 0);

	usleep(4);

}
/* 交接说明 函数 SCCB_Ack 结束后
 * 在应答时隙驱动低电平，通知传感器继续；必须保持正确的GPIO方向与时钟顺序。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */



/*应答信号*/

void  SCCB_NoAck(void)

{

	XGpioPs_WritePin(&Gpiops, SCCB_SCL, 0);

	usleep(4);

	XGpioPs_WritePin(&Gpiops, SCCB_SDA, 1);

	usleep(4);

	XGpioPs_WritePin(&Gpiops, SCCB_SCL, 1);

	usleep(4);

	XGpioPs_WritePin(&Gpiops, SCCB_SCL, 0);

}
/* 交接说明 函数 SCCB_NoAck 结束后
 * 在最后读取字节后发送非应答，用于终止读取，不与器件失联错误标志混淆。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */





void sccb_write_reg16(u16 addr , u8 data)

{

	SCCB_Start();



	SCCB_Send_byte(OV5640_Addr);

	SCCB_NoAck();



	SCCB_Send_byte(addr >> 8);

	SCCB_NoAck();



	SCCB_Send_byte(addr & 0x00FF);

	SCCB_NoAck();



	SCCB_Send_byte(data);

	SCCB_NoAck();



  	SCCB_Stop();

}
/* 交接说明 函数 sccb_write_reg16 结束后
 * 向OV5640发送设备地址、16位寄存器地址高低字节和8位值；高级AWB在初始化阶段调用它，不逐像素操作。
 * 变更属性：历史功能原样保留；本次仅增补注释。
 */





u8 sccb_read_reg16(u16 addr )

{

	u8 date;



	SCCB_Start();



	SCCB_Send_byte(OV5640_Addr);

	SCCB_NoAck();



	SCCB_Send_byte(addr >> 8);

	SCCB_NoAck();



	SCCB_Send_byte(addr & 0x00FF);

	SCCB_NoAck();



  	SCCB_Stop();



  	SCCB_Start();



	SCCB_Send_byte(OV5640_Addr | 0x01);

	SCCB_NoAck();



	date = SCCB_Rece_byte();

	SCCB_Ack();



  	SCCB_Stop();



  	return  date ;

}
/* 交接说明 函数 sccb_read_reg16 结束后
 * 先写16位寄存器地址，再读取8位寄存器值；用于ID5640、格式、AWB和测试图关闭状态的硬件读回验证。
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
