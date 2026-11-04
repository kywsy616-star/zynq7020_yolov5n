# R6.4 / 10.xsa: C regression and pure HLS synthesis. No IP export.
set hls_root [file normalize [file join [file dirname [info script]] ..]]
set src_dir [file join $hls_root src]
cd $hls_root
open_project -reset yolov5n_hls_r6_4_20261016
set_top yolov5n_top
foreach name {yolov5n_top.cpp yolov5n_hls.h yolov5n_r6_4_schedule.h} {
    add_files [file join $src_dir $name]
}
add_files -tb [file join $src_dir tb_yolov5n_r6_4.cpp] -cflags "-O2"
add_files -tb [file join $src_dir tb_r5_reference.cpp] -cflags "-O2"
open_solution solution1 -flow_target vivado
set_part xc7z020-clg400-2
create_clock -period 10 -name default
csim_design -O -argv [list [file join $hls_root tools r5_testdata]]
csynth_design
exit
