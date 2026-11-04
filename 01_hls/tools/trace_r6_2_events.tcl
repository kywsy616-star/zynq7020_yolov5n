open_vcd r6_2_events.vcd
log_vcd /apatb_yolov5n_top_top/AESL_inst_yolov5n_top/ap_clk
log_vcd /apatb_yolov5n_top_top/AESL_inst_yolov5n_top/profile_event_o
log_vcd /apatb_yolov5n_top_top/AESL_inst_yolov5n_top/profile_event_o_ap_vld
foreach signal {AWLEN AWADDR AWVALID AWREADY WVALID WREADY WLAST BVALID BREADY ARLEN ARVALID ARREADY RVALID RREADY RLAST} {
    log_vcd /apatb_yolov5n_top_top/AESL_inst_yolov5n_top/m_axi_gmem_$signal
}
run all
close_vcd
quit
