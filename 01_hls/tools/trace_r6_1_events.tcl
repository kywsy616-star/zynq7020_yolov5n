# After successful run_r6_1_cosim.tcl, run xsim from solution1/sim/verilog:
# xsim yolov5n_top -tclbatch ../../../../tools/trace_r6_1_events.tcl
open_vcd r6_1_events.vcd
log_vcd /apatb_yolov5n_top_top/AESL_inst_yolov5n_top/ap_clk
log_vcd /apatb_yolov5n_top_top/AESL_inst_yolov5n_top/profile_event_o
log_vcd /apatb_yolov5n_top_top/AESL_inst_yolov5n_top/profile_event_o_ap_vld
run all
close_vcd
quit
