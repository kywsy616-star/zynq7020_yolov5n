# R6.4 AXI64/no-ILA candidate. Run with Vitis HLS 2020.2: vitis_hls -f tools/run_r6_4_axi64_noila.tcl
set exp_root [file normalize [file join [file dirname [info script]] ..]]
set hls_root [file normalize [file join $exp_root .. ..]]
set src_dir [file join $exp_root src]
set build_dir [file join $exp_root build]
file mkdir $build_dir
cd $build_dir
open_project -reset yolov5n_hls_r6_4_axi64_noila
set_top yolov5n_top
foreach name {yolov5n_top.cpp yolov5n_hls.h yolov5n_r6_4_schedule.h} {
    add_files [file join $src_dir $name]
}
add_files -tb [file join $src_dir tb_yolov5n_r6_4.cpp] -cflags "-O2"
add_files -tb [file join $src_dir tb_r5_reference.cpp] -cflags "-O2 -I$src_dir"
open_solution solution1 -flow_target vivado
set_part xc7z020clg400-2
create_clock -period 10 -name default
# Widen m_axi bursts to 64 bits. Runtime base pointers must be 8-byte aligned.
config_interface -m_axi_alignment_byte_size 8 -m_axi_max_widen_bitwidth 64
csim_design -O -argv [list [file join $hls_root tools r5_testdata]]
csynth_design
export_design -rtl verilog -format ip_catalog -vendor xilinx.com -library hls -ipname yolov5n_top -version 1.1
exit
