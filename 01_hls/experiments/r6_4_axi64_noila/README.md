# R6.4 AXI64 / no-ILA candidate

This trial is derived from the current R6.4 HLS source. The AXI64/no-ILA source is promoted to the shared `01_hls/src` files referenced by the R6.4 HLS app. Pre-change HLS sources are preserved under `backup_before_hls_source_update`; pre-change Vivado BD/XPR/UI files are under `backup_before_vivado_update`. The R6.5 candidate is untouched.

## Applied changes

- HLS `m_axi` pointers use a 64-bit memory data bus. Vitis HLS uses 8-byte base alignment and a 64-bit maximum width.
- Removed HLS `profile_event` ports and event markers, plus the Vivado ILA, counter, and constant used only by that debug path.
- Updated the Vivado HLS IP instance to VLNV `xilinx.com:hls:yolov5n_top:1.1`, explicitly set `C_M_AXI_GMEM_DATA_WIDTH=64`, and set `axi_cc_hls_mem` to 64 bits.
- Updated the Vivado project IP repository path to the generated AXI64 IP.
- AXI-Lite control remains 32-bit; the HLS memory master and its memory-side converter are 64-bit.

## Verification

- Vitis HLS C simulation passed: 24 scalar/reference cases plus two real-model frames, each with all 84 ops; full output arena comparison passed against the frozen R5 kernel.
- HLS synthesis passed. `component.xml` sets `C_M_AXI_GMEM_DATA_WIDTH=64`; the report shows 64-bit AXI bursts.
- HLS estimates: 128 DSP, 160 BRAM, 52,194 LUT. `r64_mac` pixel loop has II=1; the top descriptor loop has II=1; one scheduler loop has II=3 because of local-memory port limits.
- Vivado block design validation passed. The active BD has no ILA/counter/profile-event cells or nets.
- Vivado implementation, routing, DRC, bitstream and XSA export completed. DRC reported 0 errors and routing reported 0 unrouted nets.
- Exported XSA: `02_vivado/yolov5n_speed_wrapper_r6_4_axi64_noila.xsa`. Bitstream: `02_vivado/yolov5n_ip/yolov5n_ip.runs/impl_1/zynq_wrapper.bit`.

## Routed results

Device: XC7Z020-CLG400-2.

- Placed utilization: 36,665 LUT (68.92%), 47,174 FF (44.34%), 120 BRAM tiles (85.71%), 203 DSP (92.27%). DSP and BRAM headroom are limited.
- HLS clock `clk_out1_zynq_clk_wiz_hls_150_0` is 150 MHz (6.667 ns). Routed WNS is -1.003 ns with 3,444 failing endpoints. Overall WNS is -1.003 ns, so the 150 MHz target is not met.
- The internal 500 MHz clock `I` has WNS -0.939 ns with 23 failing endpoints.
- The XDC also reported an unmatched PS FCLK pin at synthesis. Verify the PS FCLK constraint before interpreting system-level clock paths.

Reports:

- `02_vivado/yolov5n_ip/yolov5n_ip.runs/impl_1/zynq_wrapper_timing_summary_routed.rpt`
- `02_vivado/yolov5n_ip/yolov5n_ip.runs/impl_1/zynq_wrapper_utilization_placed.rpt`

## Build and board test

Run `vitis_hls -f tools/run_r6_4_axi64_noila.tcl` from this directory. If the HLS IP export fails because Vivado 2020.2 creates an unparsable 10-digit date-based `Revision`, run `powershell -ExecutionPolicy Bypass -File tools/repack_ip_after_hls.ps1`; it sets the core revision to `1` while keeping IP version `1.1`.

Before board testing, recreate the Vitis platform and application from the exported AXI64 XSA. The current Vitis app aligns the arena to 4096 bytes and weights, requantization data, and layer table to 64 bytes, meeting the 8-byte HLS alignment assumption. The bitstream was generated successfully, but timing is not closed at 150 MHz.
