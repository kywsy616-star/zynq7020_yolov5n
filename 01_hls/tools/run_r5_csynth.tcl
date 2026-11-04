# Isolated R5 C simulation and synthesis. Deliberately no export_design.
# R6.1: replay frozen R5 inputs; src/ now contains the instrumented interface.
set hls_root [file normalize [file join [file dirname [info script]] ..]]
set src_dir [file join $hls_root archive pre_R6_1_20261015]
set baseline_dir [file join $hls_root archive pre_R5_20261015]
cd $hls_root
open_project -reset yolov5n_hls_r5_20261015
set_top yolov5n_top
add_files [file join $src_dir yolov5n_top.cpp]
add_files [file join $src_dir yolov5n_hls.h]
add_files -tb [file join $src_dir tb_yolov5n_r5.cpp] -cflags "-O2"
add_files -tb [file join $hls_root src tb_r42_reference.cpp] -cflags "-O2"
open_solution solution1 -flow_target vivado
set_part xc7z020-clg400-2
create_clock -period 10 -name default
csim_design -O -argv [list [file join $hls_root tools r5_testdata]]
csynth_design
exit
