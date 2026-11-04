// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
// Date        : Fri Oct 16 20:06:44 2026
// Host        : DESKTOP-IO7F7QJ running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top zynq_clk_wiz_hls_150_0 -prefix
//               zynq_clk_wiz_hls_150_0_ zynq_clk_wiz_hls_150_0_stub.v
// Design      : zynq_clk_wiz_hls_150_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg400-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module zynq_clk_wiz_hls_150_0(clk_out1, resetn, locked, clk_in1)
/* synthesis syn_black_box black_box_pad_pin="clk_out1,resetn,locked,clk_in1" */;
  output clk_out1;
  input resetn;
  output locked;
  input clk_in1;
endmodule
