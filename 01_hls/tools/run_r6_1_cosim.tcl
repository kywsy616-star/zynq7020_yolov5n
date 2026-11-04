# Run only two tiny cases in RTL; full 84-op numeric regression uses Csim.
set hls_root [file normalize [file join [file dirname [info script]] ..]]
cd $hls_root
open_project yolov5n_hls_r6_1_20261015
open_solution solution1
cosim_design -rtl verilog -tool xsim -trace_level all -argv {--rtl-smoke}
exit
