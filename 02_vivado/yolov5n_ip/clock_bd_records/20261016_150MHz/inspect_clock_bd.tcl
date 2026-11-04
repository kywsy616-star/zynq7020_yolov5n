# Run in the already-open Vivado 2020.2 Tcl Console. Read-only design inspection.
set clock_record_dir [file normalize [file dirname [info script]]]
if {[get_property NAME [current_project]] ne "yolov5n_ip"} { error "Wrong project" }
if {[current_bd_design] ne "zynq"} { error "Expected open zynq BD" }
write_bd_tcl -force [file join $clock_record_dir before_zynq.tcl]
set clock_report [open [file join $clock_record_dir before_properties.txt] w]
puts $clock_report "PROJECT=[get_property DIRECTORY [current_project]]"
puts $clock_report "BD=[current_bd_design]"
foreach clock_cell {processing_system7_0 proc_sys_reset_0 rst_ps7_0_100M ps7_0_axi_periph axi_smc_acc yolov5n_top_10} {
    puts $clock_report "CELL=$clock_cell"
    foreach clock_prop [list_property [get_bd_cells $clock_cell]] {
        if {[regexp {^CONFIG\.(PCW_(ACT_FPGA|FPGA[01]|FCLK[01]|CLK[01]|EN_CLK[01]|EN_RST[01])|C_(EXT|AUX)_RESET_HIGH|NUM_|M05_)} $clock_prop]} {
            puts $clock_report "$clock_prop=[get_property $clock_prop [get_bd_cells $clock_cell]]"
        }
    }
}
foreach clock_port {processing_system7_0/FCLK_CLK0 processing_system7_0/FCLK_CLK1 yolov5n_top_10/ap_clk} {
    puts $clock_report "PIN=$clock_port"
    foreach clock_prop {CONFIG.FREQ_HZ CONFIG.CLK_DOMAIN CONFIG.ASSOCIATED_BUSIF CONFIG.ASSOCIATED_RESET} {
        catch {puts $clock_report "$clock_prop=[get_property $clock_prop [get_bd_pins $clock_port]]"}
    }
}
puts $clock_report "ADDRESS_SEGMENTS"
foreach clock_segment [get_bd_addr_segs -hierarchical] {
    puts $clock_report "$clock_segment OFFSET=[get_property OFFSET $clock_segment] RANGE=[get_property RANGE $clock_segment]"
}
close $clock_report
puts "CLOCK_BD_INSPECTION_COMPLETE"
