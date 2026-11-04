# Generated from final RTL; native simulator commands only.
open_vcd r6_4_events.vcd
set dut /apatb_yolov5n_top_top/AESL_inst_yolov5n_top
foreach signal {ap_clk profile_event_o profile_event_o_ap_vld} { log_vcd $dut/$signal }
foreach signal {AWLEN AWADDR AWVALID AWREADY WVALID WREADY WLAST BVALID BREADY ARLEN ARADDR ARVALID ARREADY RVALID RREADY RLAST} {
    log_vcd $dut/m_axi_gmem_$signal
}
set wave $dut/grp_conv_kernel_fu_373/grp_r64_wave_fu_2205
foreach task {r64_memory_U0 r64_mac_U0 r64_quant_U0} {
    foreach signal {ap_start ap_done ap_idle ap_ready} { log_vcd $wave/$task/$signal }
}
log_vcd $wave/r64_mac_U0_packets_write
log_vcd $wave/r64_quant_U0_packets101_read
log_vcd $wave/packets_full_n
log_vcd $wave/packets_empty_n
run all
close_vcd
quit
