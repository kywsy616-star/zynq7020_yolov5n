# Rebuild the zynq BD copied from FINAL_R66 in project yolov5n_ip
# Uses only the consolidated IP repo at 02_vivado/ip_repo
# (contains xilinx_com_hls_yolov5n_top_11_0 -> xilinx.com:hls:yolov5n_top:1.0)
set root "D:/02_workspace/02_vitis_projects/yolov5/yolov5n_speed_prj/yolov5n_speed_prj/02_vivado"
set proj "$root/yolov5n_ip/yolov5n_ip.xpr"
set bdf  "$root/yolov5n_ip/yolov5n_ip.srcs/sources_1/bd/zynq/zynq.bd"

open_project $proj
puts "== PROJECT OPENED: [current_project]"

set_property ip_repo_paths [list "$root/ip_repo"] [current_project]
update_ip_catalog -rebuild
puts "== IP_REPO_PATHS: [get_property ip_repo_paths [current_project]]"

set fl [get_files -quiet $bdf]
if {[llength $fl] != 1} {
    set fl [get_files -quiet -all zynq.bd]
}
puts "== BD_FILE_OBJECTS: $fl"
if {[llength $fl] == 0} {
    error "BD file zynq.bd not found in project"
}

# Upgrade the HLS IP to the freshly exported 1.0 definition
set yip [get_ips -quiet zynq_yolov5n_top_10_0]
puts "== YOLOV5N_IP_OBJECT: $yip"
if {[llength $yip] != 1} {
    error "IP zynq_yolov5n_top_10_0 not found in project"
}
upgrade_ip $yip
puts "== AFTER_UPGRADE IS_LOCKED: [get_property IS_LOCKED $yip]"
if {[get_property IS_LOCKED $yip]} {
    error "IP zynq_yolov5n_top_10_0 is still locked after upgrade"
}

reset_target all $fl
open_bd_design $fl
puts "== BD_OPENED: [current_bd_design]"

validate_bd_design
puts "== VALIDATE_BD_DONE"

puts "== YOLOV5N_VLNV: [get_property VLNV [get_bd_cells yolov5n_top_10]]"
puts "== YOLOV5N_DATA_WIDTH: [get_property CONFIG.C_M_AXI_GMEM_DATA_WIDTH [get_bd_cells yolov5n_top_10]]"
puts "== ADDR_SEGS:"
foreach s [get_bd_addr_segs -quiet] {
    puts "   $s"
}

generate_target all $fl
puts "== GENERATE_TARGET_DONE"

save_bd_design
puts "== SAVE_BD_DONE"

update_compile_order -fileset sources_1
close_project
puts "== PROJECT_CLOSED_OK"
