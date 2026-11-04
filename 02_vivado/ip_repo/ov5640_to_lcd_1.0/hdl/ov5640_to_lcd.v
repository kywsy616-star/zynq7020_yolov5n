`timescale  1ns/1ns
////////////////////////////////////////////////////////////////////////
// Author        : EmbedFire
// 实验平台: 野火FPGA系列开发板
// 公司    : http://www.embedfire.com
// 论坛    : http://www.firebbs.cn
// 淘宝    : https://fire-stm32.taobao.com
////////////////////////////////////////////////////////////////////////

module  ov5640_to_lcd
(
    input   wire            sys_rst_n       ,   //复位信号
// ov5640
    input   wire            ov5640_pclk     ,   //摄像头像素时钟
    input   wire            ov5640_href     ,   //摄像头行同步信号
    input   wire            ov5640_vsync    ,   //摄像头场同步信号
    input   wire    [ 7:0]  ov5640_data     ,   //摄像头图像数据
    
    output                cam_rst_n       ,  //cmos 复位信号，低电平有效
    output                cam_pdn         ,  //电源模式选择
    output                cam_xclk,
       
	//RGB888接口
    output                tft_clk,    //时钟信号
    output                tft_ce,     //时钟使能信号

	output                vsync,        //场同步信号    
    output                tft_de ,//数据有效信号
    output       [23:0]   tft_data          //有效数据   
);

//********************************************************************//
//****************** Parameter and Internal Signal *******************//
//********************************************************************//

//parameter define
parameter   PIC_WAIT    =   4'd10;  //图像稳定前等待帧图像个数

//wire  define
wire            pic_flag    ;   //帧图像标志信号,每拉高一次,代表一帧完整图像

//reg   define
reg             ov5640_vsync_dly1    ;   //摄像头输入场同步信号打拍
reg             ov5640_vsync_dly2;
reg             ov5640_href_dly1    ;   //摄像头输入场同步信号打拍
reg             ov5640_href_dly2;
reg     [3:0]   cnt_pic             ;   //图像帧计数器
reg             pic_valid           ;   //帧有效标志信号
reg     [7:0]   pic_data_reg        ;   //输入8位图像数据缓存
reg     [15:0]  data_out_reg        ;   //输出16位图像数据缓存
reg             data_flag           ;   //输入8位图像数据缓存
reg             data_flag_dly1      ;   //图像数据拼接标志信号打拍

//********************************************************************//
//***************************** Main Code ****************************//
//********************************************************************//

//不对摄像头硬件复位,固定高电平
assign  cam_rst_n = 1'b1;  
assign  cam_pdn = 1'b0;
assign  cam_xclk = 1'b1;
  
assign  tft_clk   = ov5640_pclk; 

//ov5640_vsync_dly:摄像头输入场同步信号打拍
always@(posedge ov5640_pclk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0) begin
        ov5640_vsync_dly1    <=  1'b0;
        ov5640_vsync_dly2    <=  1'b0;
        
        ov5640_href_dly1    <=  1'b0;
        ov5640_href_dly2    <=  1'b0;
        end
    else
        begin
        ov5640_vsync_dly1    <=  ov5640_vsync;
        ov5640_vsync_dly2    <=  ov5640_vsync_dly1;
        
        ov5640_href_dly1    <=  ov5640_href;
        ov5640_href_dly2    <=  ov5640_href_dly1;
        end

//pic_flag:帧图像标志信号,每拉高一次,代表一帧完整图像
assign  pic_flag = ((ov5640_vsync_dly1 == 1'b0)
                    && (ov5640_vsync == 1'b1)) ? 1'b1 : 1'b0;

//cnt_pic:图像帧计数器
always@(posedge ov5640_pclk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        cnt_pic <=  4'd0;
    else    if(cnt_pic < PIC_WAIT)
        cnt_pic <=  cnt_pic + 1'b1;
    else
        cnt_pic <=  cnt_pic;

//pic_valid:真有效标志
always@(posedge ov5640_pclk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        pic_valid   <=  1'b0;
    else    if((cnt_pic == PIC_WAIT) && (pic_flag == 1'b1))
        pic_valid   <=  1'b1;
    else
        pic_valid   <=  pic_valid;

//data_out_reg,pic_data_reg,data_flag:输出16位图像数据缓冲
//输入8位图像数据缓存输入8位,图像数据缓存
always@(posedge ov5640_pclk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        begin
            data_out_reg    <=  16'd0;
            pic_data_reg    <=  8'd0;
            data_flag       <=  1'b0;
        end
    else    if(ov5640_href == 1'b1)
        begin
            data_flag       <=  ~data_flag;
            pic_data_reg    <=  ov5640_data;
            data_out_reg    <=  data_out_reg;
        if(data_flag == 1'b1)
            data_out_reg    <=  {pic_data_reg,ov5640_data};
        else
            data_out_reg    <=  data_out_reg;
        end
    else
        begin
            data_flag       <=  1'b0;
            pic_data_reg    <=  8'd0;
            data_out_reg    <=  data_out_reg;
        end

//data_flag_dly1:图像数据缓存打拍
always@(posedge ov5640_pclk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        data_flag_dly1  <=  1'b0;
    else
        data_flag_dly1  <=  data_flag;

//ov5640_data_out:输出16位图像数据
assign  tft_data = (pic_valid == 1'b1) ? {data_out_reg[15:11],3'd0,data_out_reg[10:5],2'd0,data_out_reg[4:0],3'd0} : 24'd0;

//ov5640_wr_en:输出16位图像数据使能
assign  tft_de = (pic_valid == 1'b1) ? ov5640_href_dly2 : 1'b0;

assign  tft_ce    = pic_valid  ?  (data_flag_dly1 & tft_de) 
                           || (!tft_de) : 1'b0; 
assign  vsync = (pic_valid == 1'b1)  ?  ov5640_vsync_dly2  :  1'b0;          //输出帧有效信号

endmodule
