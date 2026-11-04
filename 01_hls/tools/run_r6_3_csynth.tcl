# R6.3 / 9.xsa. Validate and synthesize only; do not export an IP or XSA.
set hls_root [file normalize [file join [file dirname [info script]] ..]]
# R6.4: preserve R6.3 reproduction after the active source moves to 10.xsa.
set src_dir [file join $hls_root archive pre_R6_4_20261016 src]
cd $hls_root
open_project -reset yolov5n_hls_r6_3_20261016
set_top yolov5n_top
add_files [file join $src_dir yolov5n_top.cpp]
add_files [file join $src_dir yolov5n_hls.h]
add_files [file join $src_dir yolov5n_r6_3_schedule.h]
add_files -tb [file join $src_dir tb_yolov5n_r6_3.cpp] -cflags "-O2"
add_files -tb [file join $src_dir tb_r5_reference.cpp] -cflags "-O2"
open_solution solution1 -flow_target vivado
set_part xc7z020-clg400-2
create_clock -period 10 -name default
csim_design -O -argv [list [file join $hls_root tools r5_testdata]]
csynth_design
exit
