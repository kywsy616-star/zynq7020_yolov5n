# ---------------------------------------------------------------------------
# 05_export_xsa.tcl -- turn an already-built design into the handoff Vitis needs.
#
# 04_build_bitstream.tcl writes ../yolov5n_system.bit.  write_hw_platform then
# refuses to run on a design that was driven by raw synth/place/route calls
# ("only supported for synthesized, implemented, or checkpoint designs"), so
# this script re-opens the routed checkpoint first.
#
#   cd 02_vivado/yolov5n_ip
#   vivado -mode batch -source ../scripts/05_export_xsa.tcl
# ---------------------------------------------------------------------------
set sd [file normalize [file dirname [info script]]]
set dcp [file join $sd .. reports post_route.dcp]
set xsa [file normalize [file join $sd .. yolov5n_system.xsa]]
set bit [file normalize [file join $sd .. yolov5n_system.bit]]
set hwh [file normalize [file join $sd .. yolov5n_system.hwh]]

open_checkpoint $dcp

# .hwh + .bit is the classic pair Vitis 2020.2 accepts when no XSA is wanted
write_hwdef -force $hwh

if {[catch {
    write_hw_platform -fixed -include_bit -force $xsa
    puts "==> XSA written: $xsa"
} err]} {
    puts "write_hw_platform failed ($err)"
    puts "==> fall back to the bitstream + hwh pair:"
    puts "      $bit"
    puts "      $hwh"
    puts "    In Vitis 2020.2 use File > New > Platform Project and point the"
    puts "    hardware specification at $hwh (the bitstream is picked up"
    puts "    alongside it), or rebuild through the GUI."
}

puts "==> EXPORT DONE"
