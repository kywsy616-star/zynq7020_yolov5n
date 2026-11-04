// Derive task paths from the actual generated RTL, never from guessed hierarchy.
const fs=require('fs'),path=require('path');
const root=path.resolve(__dirname,'..');
for(const [suffix,prefix,name] of [['','r64','events'],['_reference','r63','reference']]){
 if(process.argv[2]&&process.argv[2]!==name)continue;
 const rtl=path.join(root,`yolov5n_hls_r6_4${suffix}_20261016/solution1/syn/verilog`);
 const instance=(file,module)=>{const m=fs.readFileSync(path.join(rtl,file),'utf8')
  .match(new RegExp(`\\b${module}\\s+(\\w+)\\s*\\(`));if(!m)throw Error('Missing '+module);return m[1];};
 const conv=instance('yolov5n_top.v','yolov5n_top_conv_kernel');
 const wave=instance('yolov5n_top_conv_kernel.v',`yolov5n_top_${prefix}_wave`);
 const lines=['# Generated from final RTL; native simulator commands only.',
  'open_vcd r6_4_events.vcd','set dut /apatb_yolov5n_top_top/AESL_inst_yolov5n_top',
  'foreach signal {ap_clk profile_event_o profile_event_o_ap_vld} { log_vcd $dut/$signal }',
  'foreach signal {AWLEN AWADDR AWVALID AWREADY WVALID WREADY WLAST BVALID BREADY ARLEN ARADDR ARVALID ARREADY RVALID RREADY RLAST} {',
  '    log_vcd $dut/m_axi_gmem_$signal','}',`set wave $dut/${conv}/${wave}`,
  `foreach task {${prefix}_memory_U0 ${prefix}_mac_U0 ${prefix}_quant_U0} {`,
  '    foreach signal {ap_start ap_done ap_idle ap_ready} { log_vcd $wave/$task/$signal }','}'];
 if(prefix==='r64'){
  // Full wave-local signal names are discovered after synthesis for FIFO checks.
  const text=fs.readFileSync(path.join(rtl,`yolov5n_top_${prefix}_wave.v`),'utf8');
  const fifo=[...text.matchAll(/^wire\s+(?:\[[^\]]+\]\s+)?(\w+);/gm)].map(m=>m[1]);
  for(const signal of fifo)if(/packets/.test(signal)&&/empty_n$|full_n$|_read$|_write$/.test(signal))
   lines.push(`log_vcd $wave/${signal}`);
 }
 lines.push('run all','close_vcd','quit');
 fs.writeFileSync(path.join(__dirname,`trace_r6_4_${name}.tcl`),lines.join('\n')+'\n');
 console.log(`${name}: ${conv}/${wave}`);
}
