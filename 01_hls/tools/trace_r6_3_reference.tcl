open_vcd r6_3_events.vcd
set dut /apatb_yolov5n_top_top/AESL_inst_yolov5n_top
log_vcd $dut/ap_clk
log_vcd $dut/profile_event_o
log_vcd $dut/profile_event_o_ap_vld
foreach signal {AWLEN AWADDR AWVALID AWREADY WVALID WREADY WLAST BVALID BREADY ARLEN ARADDR ARVALID ARREADY RVALID RREADY RLAST} {
    log_vcd $dut/m_axi_gmem_$signal
}
run all
close_vcd
quit
