set root "D:/02_workspace/02_vitis_projects/yolov5/yolov5n_speed_prj/yolov5n_speed_prj/02_vivado"
set proj "$root/yolov5n_ip/yolov5n_ip.xpr"
set bdf  "$root/yolov5n_ip/yolov5n_ip.srcs/sources_1/bd/zynq/zynq.bd"

open_project $proj
set_property ip_repo_paths [list "$root/ip_repo"] [current_project]
update_ip_catalog -rebuild
open_bd_design [get_files -quiet $bdf]

puts "== GET_IPS_ALL: [get_ips -quiet -all]"
foreach ip [get_ips -quiet -all] {
    puts "== IP=$ip NAME=[get_property NAME $ip]"
    catch { puts "   IPDEF=[get_property IPDEF $ip]" }
    catch { puts "   IS_LOCKED=[get_property IS_LOCKED $ip]" }
    catch { puts "   IS_MANAGED=[get_property IS_MANAGED $ip]" }
    catch { puts "   VERSION=[get_property VERSION $ip]" }
    catch { puts "   UPGRADE_GUIDANCE=[get_property UPGRADE_GUIDANCE $ip]" }
    catch { puts "   LOCKED_REASON=[get_property LOCKED_REASON $ip]" }
    catch { puts "   IP_STATUS=[get_property IP_STATUS $ip]" }
}
report_ip_status -file "$root/_bd_replicate_20261102/logs/ip_status.rpt"
close_project
puts "== DIAG_DONE"
