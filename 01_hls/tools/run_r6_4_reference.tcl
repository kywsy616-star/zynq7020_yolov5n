# Frozen R6.3 with identical R6.4 RTL inputs; no implementation export.
set hls_root [file normalize [file join [file dirname [info script]] ..]]
set src_dir [file join $hls_root archive pre_R6_4_20261016 src]
cd $hls_root
open_project -reset yolov5n_hls_r6_4_reference_20261016
set_top yolov5n_top
foreach name {yolov5n_top.cpp yolov5n_hls.h yolov5n_r6_3_schedule.h} {
    add_files [file join $src_dir $name]
}
add_files -tb [file join $hls_root src tb_yolov5n_r6_4.cpp] -cflags "-O2"
add_files -tb [file join $hls_root src tb_r5_reference.cpp] -cflags "-O2"
open_solution solution1 -flow_target vivado
set_part xc7z020-clg400-2
create_clock -period 10 -name default
csynth_design
cosim_design -rtl verilog -tool xsim -trace_level all -argv {--rtl-smoke}
exit
