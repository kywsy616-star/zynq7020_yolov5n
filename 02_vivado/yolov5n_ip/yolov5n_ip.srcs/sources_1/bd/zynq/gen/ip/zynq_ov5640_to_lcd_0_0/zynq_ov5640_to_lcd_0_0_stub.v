// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
// Date        : Thu Oct  8 17:30:42 2026
// Host        : DESKTOP-IO7F7QJ running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top zynq_ov5640_to_lcd_0_0 -prefix
//               zynq_ov5640_to_lcd_0_0_ zynq_ov5640_to_lcd_0_0_stub.v
// Design      : zynq_ov5640_to_lcd_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg400-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "ov5640_to_lcd_v1_0,Vivado 2020.2" *)
module zynq_ov5640_to_lcd_0_0(sys_rst_n, ov5640_pclk, ov5640_href, 
  ov5640_vsync, ov5640_data, cam_rst_n, cam_pdn, cam_xclk, tft_clk, tft_ce, vsync, tft_de, tft_data, 
  s00_axi_awaddr, s00_axi_awprot, s00_axi_awvalid, s00_axi_awready, s00_axi_wdata, 
  s00_axi_wstrb, s00_axi_wvalid, s00_axi_wready, s00_axi_bresp, s00_axi_bvalid, 
  s00_axi_bready, s00_axi_araddr, s00_axi_arprot, s00_axi_arvalid, s00_axi_arready, 
  s00_axi_rdata, s00_axi_rresp, s00_axi_rvalid, s00_axi_rready, s00_axi_aclk, 
  s00_axi_aresetn)
/* synthesis syn_black_box black_box_pad_pin="sys_rst_n,ov5640_pclk,ov5640_href,ov5640_vsync,ov5640_data[7:0],cam_rst_n,cam_pdn,cam_xclk,tft_clk,tft_ce,vsync,tft_de,tft_data[23:0],s00_axi_awaddr[3:0],s00_axi_awprot[2:0],s00_axi_awvalid,s00_axi_awready,s00_axi_wdata[31:0],s00_axi_wstrb[3:0],s00_axi_wvalid,s00_axi_wready,s00_axi_bresp[1:0],s00_axi_bvalid,s00_axi_bready,s00_axi_araddr[3:0],s00_axi_arprot[2:0],s00_axi_arvalid,s00_axi_arready,s00_axi_rdata[31:0],s00_axi_rresp[1:0],s00_axi_rvalid,s00_axi_rready,s00_axi_aclk,s00_axi_aresetn" */;
  input sys_rst_n;
  input ov5640_pclk;
  input ov5640_href;
  input ov5640_vsync;
  input [7:0]ov5640_data;
  output cam_rst_n;
  output cam_pdn;
  output cam_xclk;
  output tft_clk;
  output tft_ce;
  output vsync;
  output tft_de;
  output [23:0]tft_data;
  input [3:0]s00_axi_awaddr;
  input [2:0]s00_axi_awprot;
  input s00_axi_awvalid;
  output s00_axi_awready;
  input [31:0]s00_axi_wdata;
  input [3:0]s00_axi_wstrb;
  input s00_axi_wvalid;
  output s00_axi_wready;
  output [1:0]s00_axi_bresp;
  output s00_axi_bvalid;
  input s00_axi_bready;
  input [3:0]s00_axi_araddr;
  input [2:0]s00_axi_arprot;
  input s00_axi_arvalid;
  output s00_axi_arready;
  output [31:0]s00_axi_rdata;
  output [1:0]s00_axi_rresp;
  output s00_axi_rvalid;
  input s00_axi_rready;
  input s00_axi_aclk;
  input s00_axi_aresetn;
endmodule
