# Validate the existing open BD. No build or hardware programming.
set clock_record_dir [file normalize [file dirname [info script]]]
# Use the actual Vivado 2020.2 parameter name; verify asynchronous mode explicitly.
foreach clock_converter {axi_cc_hls_ctrl axi_cc_hls_mem} {
    set_property CONFIG.ACLK_ASYNC {1} [get_bd_cells $clock_converter]
}
set clock_validate_code [catch {validate_bd_design} clock_validate_message clock_validate_options]
set clock_validate_file [open [file join $clock_record_dir validate_design.log] w]
puts $clock_validate_file "VIVADO=[version -short]"
puts $clock_validate_file "DATE=[clock format [clock seconds] -format {%Y-%m-%d %H:%M:%S %z}]"
puts $clock_validate_file "COMMAND=validate_bd_design"
puts $clock_validate_file "TCL_RETURN_CODE=$clock_validate_code"
puts $clock_validate_file "MESSAGE=$clock_validate_message"
puts $clock_validate_file "OPTIONS=$clock_validate_options"
close $clock_validate_file
if {$clock_validate_code} { return -options $clock_validate_options $clock_validate_message }
save_bd_design
write_bd_tcl -force [file join $clock_record_dir after_zynq.tcl]
set clock_report [open [file join $clock_record_dir after_properties.txt] w]
foreach clock_cell {clk_wiz_hls_150 axi_cc_hls_ctrl axi_cc_hls_mem proc_sys_reset_0} {
    puts $clock_report "CELL=$clock_cell"
    foreach clock_prop [list_property [get_bd_cells $clock_cell]] {
        if {[regexp {^CONFIG\.} $clock_prop]} {
            puts $clock_report "$clock_prop=[get_property $clock_prop [get_bd_cells $clock_cell]]"
        }
    }
}
foreach clock_pin {processing_system7_0/FCLK_CLK0 processing_system7_0/FCLK_CLK1 \
    clk_wiz_hls_150/clk_in1 clk_wiz_hls_150/clk_out1 yolov5n_top_10/ap_clk \
    ila_3/clk c_counter_binary_3/CLK proc_sys_reset_0/slowest_sync_clk \
    axi_cc_hls_ctrl/s_axi_aclk axi_cc_hls_ctrl/m_axi_aclk \
    axi_cc_hls_mem/s_axi_aclk axi_cc_hls_mem/m_axi_aclk \
    ps7_0_axi_periph/M05_ACLK axi_smc_acc/aclk processing_system7_0/S_AXI_HP1_ACLK} {
    puts $clock_report "PIN=$clock_pin NET=[get_bd_nets -quiet -of_objects [get_bd_pins $clock_pin]]"
    puts $clock_report "FREQ_HZ=[get_property CONFIG.FREQ_HZ [get_bd_pins $clock_pin]]"
    puts $clock_report "CLK_DOMAIN=[get_property CONFIG.CLK_DOMAIN [get_bd_pins $clock_pin]]"
}
puts $clock_report "ADDRESS_SEGMENTS"
foreach clock_segment [get_bd_addr_segs -hierarchical] {
    puts $clock_report "$clock_segment OFFSET=[get_property OFFSET $clock_segment] RANGE=[get_property RANGE $clock_segment]"
}
close $clock_report
puts "CLOCK_BD_VALIDATE_PASS_AND_SAVED"
