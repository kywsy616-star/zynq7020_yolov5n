# Vivado 2020.2 native BD edit only: no synthesis, implementation, IP export or XSA.
# Run once in the open yolov5n_ip / zynq design after inspect_clock_bd.tcl.
set clock_record_dir [file normalize [file dirname [info script]]]
if {[get_property NAME [current_project]] ne "yolov5n_ip" || [current_bd_design] ne "zynq"} {
    error "Expected yolov5n_ip project with zynq BD open"
}
foreach clock_new_cell {clk_wiz_hls_150 axi_cc_hls_ctrl axi_cc_hls_mem hls_reset_zero} {
    if {[llength [get_bd_cells -quiet $clock_new_cell]]} { error "Already exists: $clock_new_cell; inspect before retry" }
}
proc clock_move_pin {pin_name source_name} {
    set pin [get_bd_pins $pin_name]
    set old_net [get_bd_nets -quiet -of_objects $pin]
    if {[llength $old_net]} { disconnect_bd_net $old_net $pin }
    connect_bd_net [get_bd_pins $source_name] $pin
}
create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_hls_150
set_property -dict [list \
    CONFIG.PRIM_SOURCE {No_buffer} \
    CONFIG.PRIM_IN_FREQ {100.000} \
    CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {150.000} \
    CONFIG.USE_RESET {true} CONFIG.RESET_TYPE {ACTIVE_LOW} \
    CONFIG.USE_LOCKED {true}] [get_bd_cells clk_wiz_hls_150]

# Explicit asynchronous converters keep every existing interconnect/PS AXI clock at 100 MHz.
# 150:100 is not an integer clock ratio supported by the synchronous AXI conversion mode.
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_clock_converter:2.1 axi_cc_hls_ctrl
set_property -dict [list CONFIG.PROTOCOL {AXI4LITE} CONFIG.ACLK_ASYNC {1}] \
    [get_bd_cells axi_cc_hls_ctrl]
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_clock_converter:2.1 axi_cc_hls_mem
set_property -dict [list CONFIG.PROTOCOL {AXI4} CONFIG.ACLK_ASYNC {1}] \
    [get_bd_cells axi_cc_hls_mem]

create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 hls_reset_zero
set_property -dict [list CONFIG.CONST_WIDTH {1} CONFIG.CONST_VAL {0}] [get_bd_cells hls_reset_zero]
# Reuse the unconnected reset IP already added by the user.
# External reset polarity is inferred from FCLK_RESET0_N in Vivado 2020.2;
# C_EXT_RESET_HIGH is read-only here. The final propagated value is checked below.
set_property CONFIG.C_AUX_RESET_HIGH {1} [get_bd_cells proc_sys_reset_0]

connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins clk_wiz_hls_150/clk_in1]
connect_bd_net [get_bd_pins processing_system7_0/FCLK_RESET0_N] \
    [get_bd_pins clk_wiz_hls_150/resetn] [get_bd_pins proc_sys_reset_0/ext_reset_in]
connect_bd_net [get_bd_pins clk_wiz_hls_150/locked] [get_bd_pins proc_sys_reset_0/dcm_locked]
connect_bd_net [get_bd_pins hls_reset_zero/dout] \
    [get_bd_pins proc_sys_reset_0/aux_reset_in] [get_bd_pins proc_sys_reset_0/mb_debug_sys_rst]
foreach clock_pin {yolov5n_top_10/ap_clk ila_3/clk c_counter_binary_3/CLK} {
    clock_move_pin $clock_pin clk_wiz_hls_150/clk_out1
}
connect_bd_net [get_bd_pins clk_wiz_hls_150/clk_out1] \
    [get_bd_pins proc_sys_reset_0/slowest_sync_clk] \
    [get_bd_pins axi_cc_hls_ctrl/m_axi_aclk] [get_bd_pins axi_cc_hls_mem/s_axi_aclk]
connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK0] \
    [get_bd_pins axi_cc_hls_ctrl/s_axi_aclk] [get_bd_pins axi_cc_hls_mem/m_axi_aclk]

clock_move_pin yolov5n_top_10/ap_rst_n proc_sys_reset_0/peripheral_aresetn
connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] \
    [get_bd_pins axi_cc_hls_ctrl/m_axi_aresetn] [get_bd_pins axi_cc_hls_mem/s_axi_aresetn]
connect_bd_net [get_bd_pins rst_ps7_0_100M/peripheral_aresetn] \
    [get_bd_pins axi_cc_hls_ctrl/s_axi_aresetn] [get_bd_pins axi_cc_hls_mem/m_axi_aresetn]

set clock_ctrl_net [get_bd_intf_nets -of_objects [get_bd_intf_pins yolov5n_top_10/s_axi_control]]
disconnect_bd_intf_net $clock_ctrl_net [get_bd_intf_pins yolov5n_top_10/s_axi_control]
connect_bd_intf_net [get_bd_intf_pins ps7_0_axi_periph/M05_AXI] [get_bd_intf_pins axi_cc_hls_ctrl/S_AXI]
connect_bd_intf_net [get_bd_intf_pins axi_cc_hls_ctrl/M_AXI] [get_bd_intf_pins yolov5n_top_10/s_axi_control]

set clock_mem_net [get_bd_intf_nets -of_objects [get_bd_intf_pins axi_smc_acc/S00_AXI]]
disconnect_bd_intf_net $clock_mem_net [get_bd_intf_pins axi_smc_acc/S00_AXI]
connect_bd_intf_net [get_bd_intf_pins yolov5n_top_10/m_axi_gmem] [get_bd_intf_pins axi_cc_hls_mem/S_AXI]
connect_bd_intf_net [get_bd_intf_pins axi_cc_hls_mem/M_AXI] [get_bd_intf_pins axi_smc_acc/S00_AXI]

save_bd_design
puts "CLOCK_BD_WIRING_APPLIED; VALIDATION_START"
source [file join $clock_record_dir validate_hls_150mhz_bd.tcl]
save_bd_design
write_bd_tcl -force [file join $clock_record_dir after_zynq.tcl]
puts "CLOCK_BD_VALIDATE_PASS"
