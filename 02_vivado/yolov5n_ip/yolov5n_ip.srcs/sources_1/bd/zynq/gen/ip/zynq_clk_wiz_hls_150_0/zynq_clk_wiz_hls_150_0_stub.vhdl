-- Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
-- Date        : Fri Oct 16 20:06:44 2026
-- Host        : DESKTOP-IO7F7QJ running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub -rename_top zynq_clk_wiz_hls_150_0 -prefix
--               zynq_clk_wiz_hls_150_0_ zynq_clk_wiz_hls_150_0_stub.vhdl
-- Design      : zynq_clk_wiz_hls_150_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z020clg400-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity zynq_clk_wiz_hls_150_0 is
  Port ( 
    clk_out1 : out STD_LOGIC;
    resetn : in STD_LOGIC;
    locked : out STD_LOGIC;
    clk_in1 : in STD_LOGIC
  );

end zynq_clk_wiz_hls_150_0;

architecture stub of zynq_clk_wiz_hls_150_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk_out1,resetn,locked,clk_in1";
begin
end;
