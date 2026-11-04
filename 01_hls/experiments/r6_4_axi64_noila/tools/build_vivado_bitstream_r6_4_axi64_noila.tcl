set project_file "C:/Users/Lenovo/Desktop/yolov5n_speed_prj/yolov5n_speed_prj/02_vivado/yolov5n_ip/yolov5n_ip.xpr"
open_project $project_file
set bd [get_files [file join [get_property DIRECTORY [current_project]] yolov5n_ip.srcs sources_1 bd zynq zynq.bd]]
open_bd_design $bd
validate_bd_design
save_bd_design
generate_target all $bd
update_compile_order -fileset sources_1
reset_run synth_1
reset_run impl_1
launch_runs synth_1 -jobs 8
wait_on_run synth_1
set synth_status [get_property STATUS [get_runs synth_1]]
puts "SYNTH_STATUS=$synth_status"
if {![string match *Complete* $synth_status]} { error "Synthesis did not complete: $synth_status" }
launch_runs impl_1 -to_step write_bitstream -jobs 8
wait_on_run impl_1
set impl_status [get_property STATUS [get_runs impl_1]]
puts "IMPL_STATUS=$impl_status"
if {![string match *Complete* $impl_status]} { error "Implementation did not complete: $impl_status" }
close_project
