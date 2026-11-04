-- Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
-- Date        : Thu Oct  8 17:30:42 2026
-- Host        : DESKTOP-IO7F7QJ running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub -rename_top zynq_ov5640_to_lcd_0_0 -prefix
--               zynq_ov5640_to_lcd_0_0_ zynq_ov5640_to_lcd_0_0_stub.vhdl
-- Design      : zynq_ov5640_to_lcd_0_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z020clg400-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity zynq_ov5640_to_lcd_0_0 is
  Port ( 
    sys_rst_n : in STD_LOGIC;
    ov5640_pclk : in STD_LOGIC;
    ov5640_href : in STD_LOGIC;
    ov5640_vsync : in STD_LOGIC;
    ov5640_data : in STD_LOGIC_VECTOR ( 7 downto 0 );
    cam_rst_n : out STD_LOGIC;
    cam_pdn : out STD_LOGIC;
    cam_xclk : out STD_LOGIC;
    tft_clk : out STD_LOGIC;
    tft_ce : out STD_LOGIC;
    vsync : out STD_LOGIC;
    tft_de : out STD_LOGIC;
    tft_data : out STD_LOGIC_VECTOR ( 23 downto 0 );
    s00_axi_awaddr : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s00_axi_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s00_axi_awvalid : in STD_LOGIC;
    s00_axi_awready : out STD_LOGIC;
    s00_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s00_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s00_axi_wvalid : in STD_LOGIC;
    s00_axi_wready : out STD_LOGIC;
    s00_axi_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s00_axi_bvalid : out STD_LOGIC;
    s00_axi_bready : in STD_LOGIC;
    s00_axi_araddr : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s00_axi_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s00_axi_arvalid : in STD_LOGIC;
    s00_axi_arready : out STD_LOGIC;
    s00_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s00_axi_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s00_axi_rvalid : out STD_LOGIC;
    s00_axi_rready : in STD_LOGIC;
    s00_axi_aclk : in STD_LOGIC;
    s00_axi_aresetn : in STD_LOGIC
  );

end zynq_ov5640_to_lcd_0_0;

architecture stub of zynq_ov5640_to_lcd_0_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "sys_rst_n,ov5640_pclk,ov5640_href,ov5640_vsync,ov5640_data[7:0],cam_rst_n,cam_pdn,cam_xclk,tft_clk,tft_ce,vsync,tft_de,tft_data[23:0],s00_axi_awaddr[3:0],s00_axi_awprot[2:0],s00_axi_awvalid,s00_axi_awready,s00_axi_wdata[31:0],s00_axi_wstrb[3:0],s00_axi_wvalid,s00_axi_wready,s00_axi_bresp[1:0],s00_axi_bvalid,s00_axi_bready,s00_axi_araddr[3:0],s00_axi_arprot[2:0],s00_axi_arvalid,s00_axi_arready,s00_axi_rdata[31:0],s00_axi_rresp[1:0],s00_axi_rvalid,s00_axi_rready,s00_axi_aclk,s00_axi_aresetn";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "ov5640_to_lcd_v1_0,Vivado 2020.2";
begin
end;
