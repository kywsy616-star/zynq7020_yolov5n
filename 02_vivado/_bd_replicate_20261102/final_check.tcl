set root "D:/02_workspace/02_vitis_projects/yolov5/yolov5n_speed_prj/yolov5n_speed_prj/02_vivado"
set proj "$root/yolov5n_ip/yolov5n_ip.xpr"
set bdf  "$root/yolov5n_ip/yolov5n_ip.srcs/sources_1/bd/zynq/zynq.bd"

open_project $proj
puts "== REOPEN_OK"
puts "== IP_REPO_PATHS: [get_property ip_repo_paths [current_project]]"

set bad 0
foreach ip [get_ips -quiet -all] {
    set lk [get_property IS_LOCKED $ip]
    if {$lk} {
        puts "== LOCKED_IP: $ip"
        incr bad
    }
}
puts "== LOCKED_IP_COUNT: $bad"

open_bd_design [get_files -quiet $bdf]
puts "== YOLOV5N_VLNV: [get_property VLNV [get_bd_cells yolov5n_top_11]]"
puts "== BD_CELL_COUNT: [llength [get_bd_cells -quiet]]"
validate_bd_design
puts "== VALIDATE_OK"
report_ip_status -file "$root/_bd_replicate_20261102/logs/final_ip_status.rpt"
close_bd_design [current_bd_design]
close_project
puts "== FINAL_CHECK_OK"
