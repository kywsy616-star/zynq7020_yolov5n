# Frozen R6.1 RTL with EXACTLY the R6.2 smoke inputs. Historical R6.1 project
# and traces remain intact. This comparison is an AXI simulation, not board FPS.
set hls_root [file normalize [file join [file dirname [info script]] ..]]
set src_dir [file join $hls_root archive pre_R6_2_20261015]
cd $hls_root
open_project -reset yolov5n_hls_r6_2_reference_20261015
set_top yolov5n_top
add_files [file join $src_dir yolov5n_top.cpp]
add_files [file join $src_dir yolov5n_hls.h]
add_files -tb [file join $hls_root src tb_yolov5n_r6_2.cpp] -cflags "-O2"
add_files -tb [file join $hls_root src tb_r5_reference.cpp] -cflags "-O2"
open_solution solution1 -flow_target vivado
set_part xc7z020-clg400-2
create_clock -period 10 -name default
csynth_design
cosim_design -rtl verilog -tool xsim -trace_level all -argv {--rtl-smoke}
exit
