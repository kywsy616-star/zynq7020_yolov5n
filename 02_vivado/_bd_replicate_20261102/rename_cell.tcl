# Rename the HLS accelerator BD cell from yolov5n_top_10 to yolov5n_top_11
set root "D:/02_workspace/02_vitis_projects/yolov5/yolov5n_speed_prj/yolov5n_speed_prj/02_vivado"
set proj "$root/yolov5n_ip/yolov5n_ip.xpr"
set bdf  "$root/yolov5n_ip/yolov5n_ip.srcs/sources_1/bd/zynq/zynq.bd"

open_project $proj
open_bd_design [get_files -quiet $bdf]

set old [get_bd_cells -quiet yolov5n_top_10]
if {[llength $old] != 1} {
    error "cell yolov5n_top_10 not found (count=[llength $old])"
}
puts "== BEFORE_NAME: [get_property NAME $old]"
set_property NAME yolov5n_top_11 $old
puts "== AFTER_NAME: [get_property NAME [get_bd_cells yolov5n_top_11]]"
puts "== YOLOV5N_VLNV: [get_property VLNV [get_bd_cells yolov5n_top_11]]"
puts "== IPS_AFTER_RENAME: [get_ips -quiet -all]"

validate_bd_design
puts "== VALIDATE_OK"

generate_target all [get_files -quiet $bdf]
puts "== GENERATE_TARGET_DONE"

save_bd_design
puts "== SAVE_BD_DONE"

update_compile_order -fileset sources_1
close_project
puts "== RENAME_DONE"
