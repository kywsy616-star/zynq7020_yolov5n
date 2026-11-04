# ---------------------------------------------------------------------------
# 04_build_bitstream.tcl -- synthesis -> place&route -> bitstream -> XSA
#
# WHY THIS IS A ONE-SHOT FLOW RATHER THAN launch_runs:
#   Vivado's run system synthesises every IP as its own out-of-context run,
#   and each of those spawns a helper vivado.exe.  On this machine those
#   helpers abort right after startup with
#       TclStackFree: incorrect freePtr.  Call out of sequence?
#   (a bare `synth_design -mode out_of_context` in a single process works
#   fine -- verified -- so it is the spawned helper, not the tools themselves).
#   Driving synth_design/opt_design/place_design/route_design directly keeps
#   everything in one process and sidesteps the problem entirely.
#
#   cd 02_vivado/yolov5n_ip
#   vivado -mode batch -source ../scripts/04_build_bitstream.tcl
# ---------------------------------------------------------------------------
set sd [file normalize [file dirname [info script]]]
open_project [file join $sd .. yolov5n_ip yolov5n_ip.xpr]

set part xc7z020clg400-2

puts "==================== GENERATE BD TARGETS =============="
# Synthesise every IP *inside the top-level run*.  The default is one
# out-of-context run per IP, and each of those spawns a helper vivado.exe that
# dies immediately on this machine (see the note above).  Hierarchical mode
# keeps everything in one process and needs no per-IP .dcp.
foreach f [get_files -all *.xci] {
    catch { set_property generate_synth_checkpoint 0 $f }
    catch { set_property synth_checkpoint_mode None $f }
}
catch { set_property synth_checkpoint_mode None [get_files zynq.bd] }
generate_target all [get_files zynq.bd]

puts "==================== SYNTHESIS ========================"
synth_design -top zynq_wrapper -part $part -directive Default
write_checkpoint -force ../reports/post_synth.dcp

puts "==================== IMPLEMENTATION ==================="
# The accelerator's longest paths land ~1 ns short of the 10 ns budget with
# the default directives, so spend the extra runtime on timing-driven
# placement/routing and post-route physical optimisation.
opt_design
place_design -directive ExtraTimingOpt
phys_opt_design -directive AggressiveExplore
route_design -directive AggressiveExplore
phys_opt_design -directive AggressiveExplore
route_design

puts "==================== BITSTREAM ========================"
write_checkpoint -force ../reports/post_route.dcp
write_bitstream -force ../yolov5n_system.bit

puts "==================== REPORTS =========================="
report_timing_summary -file ../reports/timing_summary.rpt -warn_on_violation
report_utilization    -file ../reports/utilization.rpt
report_clocks         -file ../reports/clocks.rpt
report_drc            -file ../reports/drc.rpt

puts "==================== EXPORT XSA ======================="
write_hw_platform -fixed -include_bit -force [file join $sd .. yolov5n_system.xsa]

puts "==> BITSTREAM DONE"
