# Verified final RTL hierarchy; rerun preparation if synthesis renames instances.
open_vcd r6_3_events.vcd
set dut /apatb_yolov5n_top_top/AESL_inst_yolov5n_top
log_vcd $dut/ap_clk
log_vcd $dut/profile_event_o
log_vcd $dut/profile_event_o_ap_vld
foreach signal {AWLEN AWADDR AWVALID AWREADY WVALID WREADY WLAST BVALID BREADY ARLEN ARADDR ARVALID ARREADY RVALID RREADY RLAST} {
    log_vcd $dut/m_axi_gmem_$signal
}
set wave $dut/grp_conv_kernel_fu_373/grp_r63_wave_fu_2199
foreach task {r63_memory_U0 r63_mac_U0 r63_quant_U0} {
    foreach signal {ap_start ap_done ap_idle ap_ready} {
        log_vcd $wave/$task/$signal
    }
}
run all
close_vcd
quit
