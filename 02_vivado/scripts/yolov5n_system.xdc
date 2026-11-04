#=============================================================================
# yolov5n_system.xdc -- Yehuo Haoyue 7020 (xc7z020clg400-2)
#   camera (AN5640 / OV5640 DVP) + HDMI out + the HLS accelerator's clock
#
# Pin sources:
#   * wildfire 25_ov5640_hdmi  (vdma_lcd_char.xdc)  -- same board pinout
#   * user's own 2026fpga_prj_1/src/xdc/cam_hdmi.xdc -- J9 camera header,
#     J17 HDMI connector, "yehuo ov5640 pin table.docx" / "yehuo HDMI pin table"
#
# ASCII ONLY: Vivado parses XDC as GBK on cn-Windows, Chinese comments break it.
#=============================================================================

#-----------------------------------------------------------------------------
# Camera DVP 8-bit
#-----------------------------------------------------------------------------
set_property PACKAGE_PIN N15 [get_ports {ov5640_data[0]}]
set_property PACKAGE_PIN N16 [get_ports {ov5640_data[1]}]
set_property PACKAGE_PIN L14 [get_ports {ov5640_data[2]}]
set_property PACKAGE_PIN L15 [get_ports {ov5640_data[3]}]
set_property PACKAGE_PIN M14 [get_ports {ov5640_data[4]}]
set_property PACKAGE_PIN M15 [get_ports {ov5640_data[5]}]
set_property PACKAGE_PIN L16 [get_ports {ov5640_data[6]}]
set_property PACKAGE_PIN L17 [get_ports {ov5640_data[7]}]
set_property PACKAGE_PIN L19 [get_ports ov5640_pclk]
set_property PACKAGE_PIN L20 [get_ports cam_xclk_0]
set_property PACKAGE_PIN M20 [get_ports ov5640_href]
set_property PACKAGE_PIN M19 [get_ports ov5640_vsync]
set_property PACKAGE_PIN M18 [get_ports cam_rst_n]
set_property PACKAGE_PIN M17 [get_ports cam_pdn_0]

set_property IOSTANDARD LVCMOS33 [get_ports {ov5640_data[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports ov5640_pclk]
set_property IOSTANDARD LVCMOS33 [get_ports cam_xclk_0]
set_property IOSTANDARD LVCMOS33 [get_ports ov5640_href]
set_property IOSTANDARD LVCMOS33 [get_ports ov5640_vsync]
set_property IOSTANDARD LVCMOS33 [get_ports cam_rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports cam_pdn_0]

set_property IOB TRUE [get_ports {ov5640_data[*]}]
set_property IOB TRUE [get_ports ov5640_href]
set_property IOB TRUE [get_ports ov5640_vsync]

# The camera pixel clock arrives on a regular IO pin, so it cannot drive a
# clock-capable route; the wildfire reference does the same thing.
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets ov5640_pclk_IBUF]
create_clock -period 13.888 -name ov5640_pclk [get_ports ov5640_pclk]

#-----------------------------------------------------------------------------
# Camera SCCB (bit-banged from PS EMIO GPIO)
#-----------------------------------------------------------------------------
set_property PACKAGE_PIN T17 [get_ports {cam_sccb_tri_io[0]}]
set_property PACKAGE_PIN R18 [get_ports {cam_sccb_tri_io[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cam_sccb_tri_io[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cam_sccb_tri_io[1]}]
set_property PULLUP TRUE [get_ports {cam_sccb_tri_io[0]}]
set_property PULLUP TRUE [get_ports {cam_sccb_tri_io[1]}]

#-----------------------------------------------------------------------------
# HDMI (J17) -- direct TMDS, 4 differential pairs
#-----------------------------------------------------------------------------
set_property PACKAGE_PIN W14 [get_ports tmds_data_p[0]]
set_property PACKAGE_PIN Y14 [get_ports tmds_data_n[0]]
set_property PACKAGE_PIN Y16 [get_ports tmds_data_p[1]]
set_property PACKAGE_PIN Y17 [get_ports tmds_data_n[1]]
set_property PACKAGE_PIN Y18 [get_ports tmds_data_p[2]]
set_property PACKAGE_PIN Y19 [get_ports tmds_data_n[2]]
set_property PACKAGE_PIN V20 [get_ports tmds_clk_p]
set_property PACKAGE_PIN W20 [get_ports tmds_clk_n]

set_property IOSTANDARD TMDS_33 [get_ports tmds_data_p[0]]
set_property IOSTANDARD TMDS_33 [get_ports tmds_data_n[0]]
set_property IOSTANDARD TMDS_33 [get_ports tmds_data_p[1]]
set_property IOSTANDARD TMDS_33 [get_ports tmds_data_n[1]]
set_property IOSTANDARD TMDS_33 [get_ports tmds_data_p[2]]
set_property IOSTANDARD TMDS_33 [get_ports tmds_data_n[2]]
set_property IOSTANDARD TMDS_33 [get_ports tmds_clk_p]
set_property IOSTANDARD TMDS_33 [get_ports tmds_clk_n]

set_property PACKAGE_PIN T20 [get_ports tmds_oen]
set_property IOSTANDARD LVCMOS33 [get_ports tmds_oen]

#-----------------------------------------------------------------------------
# Accelerator / video clocks.
# Everything (AXI, VDMA, the HLS IP) runs on FCLK_CLK0 = 100 MHz.  The HLS
# accelerator was synthesised with a 10 ns target; HLS estimated ~44 MHz for
# the current PE configuration, so it will be *timed* by this constraint and
# any failing path shows up in the WNS report rather than silently.
#-----------------------------------------------------------------------------
create_clock -period 10.000 -name clk_fpga_0 [get_pins i_processing_system7_0/inst/PS7_i/FCLKCLK[0]]
set_clock_groups -asynchronous -group [get_clocks ov5640_pclk] -group [get_clocks clk_fpga_0]
