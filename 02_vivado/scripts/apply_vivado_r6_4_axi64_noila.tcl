# Run from Vivado Tcl after the HLS AXI64/no-ILA candidate has completed export.
# This updates the existing 02_vivado design in place. Save a project copy first if you need a pristine baseline.
set project_file [file normalize [file join [file dirname [info script]] .. yolov5n_ip yolov5n_ip.xpr]]
set candidate_ip_repo [file normalize [file join [file dirname [info script]] .. .. 01_hls experiments r6_4_axi64_noila build yolov5n_hls_r6_4_axi64_noila solution1 impl ip]]
open_project $project_file
set repos [get_property ip_repo_paths [current_project]]
if {[lsearch -exact $repos $candidate_ip_repo] < 0} { lappend repos $candidate_ip_repo }
set_property ip_repo_paths $repos [current_project]
update_ip_catalog -rebuild
open_bd_design [get_files [file join [get_property DIRECTORY [current_project]] yolov5n_ip.srcs sources_1 bd zynq zynq.bd]]
# Delete all ILA-only hardware and its counter/constant.
foreach cell_name {ila_3 c_counter_binary_3 xlconstant_3} {
    set cell [get_bd_cells -quiet $cell_name]
    if {[llength $cell]} { delete_bd_objs $cell }
}
# Replace the old 32-bit HLS block with the freshly exported 64-bit 1.1 IP.
set hls_cell [get_bd_cells -quiet yolov5n_top_10]
if {[llength $hls_cell]} {
    upgrade_bd_cells $hls_cell
    set_property -dict [list CONFIG.C_M_AXI_GMEM_DATA_WIDTH {64}] $hls_cell
}
# The clock converter must match the new HLS master width.
set cc [get_bd_cells -quiet axi_cc_hls_mem]
if {[llength $cc]} { set_property -dict [list CONFIG.DATA_WIDTH {64}] $cc }
validate_bd_design
save_bd_design
puts "R6.4 AXI64/no-ILA block design updated. Confirm m_axi_gmem and axi_cc_hls_mem are 64-bit before implementation."
