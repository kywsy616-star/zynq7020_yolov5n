// R6.3 / 9.xsa board evidence. Read-only to implementation and historical evidence.
const fs=require('fs'),path=require('path'),crypto=require('crypto');
const root=path.resolve(__dirname,'..'),dir=path.join(root,'measurements/R6_3_9xsa_20261016');
const read=p=>fs.readFileSync(p,'utf8').replace(/^\uFEFF/,'').replaceAll('\r\n','\n');
const check=(ok,m)=>{if(!ok)throw Error(m);},sum=a=>a.reduce((n,x)=>n+x,0);
function profile(file){const t=read(file),ops=[...t.matchAll(/^\s*(\d+)\s+(\d+)\s+(\d+)x(\d+)\s+(\d+)>\s*(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s*$/gm)]
 .map(m=>({op:+m[1],type:+m[2],oh:+m[3],ow:+m[4],ic:+m[5],oc:+m[6],k:+m[7],realUs:+m[9],displayedIdealUs:+m[10]}));
 check(ops.length===84&&ops.every((d,i)=>d.op===i),'84 ops missing');
 const wholeUs=+t.match(/whole network\s*=\s*(\d+) us/)[1],sumUs=+t.match(/per-op sum\s*=\s*(\d+) us/)[1];
 check(sum(ops.map(o=>o.realUs))===sumUs,'UART sum mismatch');return{wholeUs,sumUs,ops};}
const old=profile(path.join(root,'measurements/R6_2_8xsa_20261016/uart_7_2_as_8xsa.txt'));
const baseline=profile(path.join(root,'measurements/R6_2_8xsa_20261016/uart_R5_7xsa_baseline.txt'));
const now=profile(path.join(dir,'uart_9xsa.txt'));
const geometry=JSON.parse(read(path.join(root,'yolov5n_hls_r6_3_20261016/r6_3_geometry.json')));
const ops=now.ops.map((o,i)=>({...o,oldUs:old.ops[i].realUs,savedUs:old.ops[i].realUs-o.realUs,
 savedPercent:100*(1-o.realUs/old.ops[i].realUs),sharePercent:o.realUs/now.wholeUs*100,
 idealMacUs:o.type===0?o.oh*o.ow*o.ic*o.oc*o.k*o.k/6400:null}));
const categories=[['conv3x3',o=>o.type===0&&o.k===3],['conv1x1',o=>o.type===0&&o.k===1],['copy',o=>o.type===2],['pool',o=>o.type===1]]
 .map(([name,f])=>{const a=ops.filter(f),realUs=sum(a.map(o=>o.realUs)),oldUs=sum(a.map(o=>o.oldUs)),idealMacUs=sum(a.map(o=>o.idealMacUs||0));
 return{name,count:a.length,realUs,oldUs,savedUs:oldUs-realUs,savedPercent:100*(1-realUs/oldUs),sharePercent:realUs/now.wholeUs*100,
 idealMacUs:name.startsWith('conv')?idealMacUs:null,nonPureMacUs:name.startsWith('conv')?realUs-idealMacUs:null};});
const regions=[['backbone',0,31],['neck',32,65],['detect',66,83]].map(([name,lo,hi])=>{
 const a=ops.slice(lo,hi+1);return{name,oldUs:sum(a.map(o=>o.oldUs)),realUs:sum(a.map(o=>o.realUs)),savedUs:sum(a.map(o=>o.savedUs))};});
const frames=[];let segment=0;
for(const line of read(path.join(dir,'uart_9xsa.txt')).split('\n')){
 if(line.startsWith('YOLOv5n dual-core'))segment++;
 if(!/^f\d+ done=/.test(line))continue;
 const v=k=>{const m=line.match(new RegExp(`\\b${k}=([0-9.]+)`));return m?+m[1]:null;};
 frames.push({segment,frame:+line.match(/^f(\d+)/)[1],fps:v('fps'),avg16:v('avg16'),periodMs:v('period'),startMs:v('start'),gapUs:v('gap'),
 prepMs:v('prep'),inferMs:v('infer'),postallMs:v('postall'),latencyMs:v('lat'),complete:/lat=\d+ms$/.test(line)});
}
function stats(a){if(!a.length)return null;return{count:a.length,sum:sum(a),mean:sum(a)/a.length,min:Math.min(...a),max:Math.max(...a)};}
function csv(file){const lines=read(path.join(dir,file)).trim().split('\n'),h=lines[0].split(','),ic=h.findIndex(s=>s.includes('profile_event_o[')),iv=h.findIndex(s=>s.includes('profile_event_o_ap_vld')),it=h.findIndex(s=>s.includes('_Q[63:0]'));
 check(ic>=0&&iv>=0&&it>=0,'Missing ILA probes');
 return lines.slice(2).map(line=>{const a=line.split(','),event=parseInt(a[ic],16);return{sample:+a[0],event,op:event>>>8,phase:event&255,valid:parseInt(a[iv],16),ticks:BigInt('0x'+a[it])};});}
const cycleDiff=(a,b)=>Number(b.ticks-a.ticks);
const serializable=e=>({...e,ticks:e.ticks.toString()});
function schedule(op){const o=ops[op],g=geometry.ops.find(g=>g.op===op),blob=fs.readFileSync(path.join(root,'tools/r5_testdata/layers.bin'));
 const tileR=blob.readUInt32LE(op*64+44)>>>16,waves=[];let tiles=0;
 for(let y=0;y<o.oh;y+=tileR)for(let x=0;x<o.ow;x+=g.internalWidth){
  const nr=Math.min(tileR,o.oh-y),nc=Math.min(g.internalWidth,o.ow-x),perRow=Math.ceil(nc/16)*(o.oc/16),blocks=nr*perRow;
  const nx=x+g.internalWidth<o.ow?x+g.internalWidth:0,ny=x+g.internalWidth<o.ow?y:y+tileR;
  const nextRows=ny<o.oh?(o.ic/4)*((Math.min(tileR,o.oh-ny)-1)*g.s+g.k):0;let q=1;
  for(const candidate of[2,4,8,16])if(nextRows>blocks*candidate/2)q=candidate;
  let remaining=nextRows;
  for(let step=0;step<blocks+2;step++){const prefetchRows=Math.min(q,remaining);remaining-=prefetchRows;
   waves.push({tile:tiles,step,compute:step<blocks,quant:step>0&&step<=blocks,store:step>=2&&(step-2)%perRow===perRow-1,prefetchRows});}
  if(remaining)waves.push({tile:tiles,drain:true,compute:false,quant:false,store:false,prefetchRows:remaining});tiles++;
 }
 return{tiles,waves};}
function analyze(file,op){const all=csv(file),valid=all.filter(e=>e.valid===1),start=valid.findIndex(e=>e.op===op&&e.phase===1);
 const end=start<0?-1:valid.findIndex((e,i)=>i>start&&e.op===op&&e.phase===14),events=start<0?valid.filter(e=>e.op===op):valid.slice(start,end<0?undefined:end+1);
 check(events.length>1&&events.every(e=>e.op===op),'Cross-op or empty capture');
 const phases={},intervals={};for(let i=0;i<events.length;i++){const e=events[i];phases[e.phase]=(phases[e.phase]||0)+1;
  if(i+1<events.length)(intervals[e.phase]||=[]).push(cycleDiff(e,events[i+1]));}
 const waveCycles=[];for(let i=0;i+1<events.length;i++)if(events[i].phase===18){check(events[i+1].phase===19,'Unclosed wave inside window');waveCycles.push(cycleDiff(events[i],events[i+1]));}
 const plan=schedule(op),waveGroups={};waveCycles.forEach((cycles,i)=>{const w=plan.waves[i];check(w,'Extra wave');const key=`mac${+w.compute}_quant${+w.quant}_store${+w.store}_prefetch${+(w.prefetchRows>0)}`;(waveGroups[key]||=[]).push(cycles);});
 if(end>=0){check(waveCycles.length===plan.waves.length,'Wave count versus source mismatch');check(phases[19]===phases[18]+1,'Initial fill/wave count mismatch');}
 const totalCycles=cycleDiff(events[0],events.at(-1));
 const out={op,file,rawSamples:all.length,validSamples:valid.length,targetSamples:events.length,startsAtDescriptor:start>=0,complete:end>=0,
  cycles:totalCycles,ms:totalCycles/100000,uartMs:ops[op].realUs/1000,phases,expectedWaves:plan.waves.length,expectedTiles:plan.tiles,
  waveCycles:stats(waveCycles),phaseIntervals:Object.fromEntries(Object.entries(intervals).map(([p,a])=>[p,stats(a)])),
  waveGroups:Object.fromEntries(Object.entries(waveGroups).map(([k,a])=>[k,stats(a)])),
  missingWaveCount:plan.waves.length-waveCycles.length};
 if(end>=0)out.differenceFromUARTPercent=100*(out.ms*1000/ops[op].realUs-1);
 fs.writeFileSync(path.join(dir,`op${op}_decoded.json`),JSON.stringify(events.map(serializable),null,2)+'\n');
 fs.writeFileSync(path.join(dir,`op${op}_analysis.json`),JSON.stringify(out,null,2)+'\n');return out;}
const initialRaw=csv('initial_export.csv'),initialValid=initialRaw.filter(e=>e.valid===1);
const initial={rawSamples:initialRaw.length,validSamples:initialValid.length,ops:[...new Set(initialValid.map(e=>e.op))],phases:[...new Set(initialValid.map(e=>e.phase))],
 windowCycles:cycleDiff(initialRaw[0],initialRaw.at(-1)),firstToLastValidCycles:cycleDiff(initialValid[0],initialValid.at(-1))};
const captures=[0,1,3,6,67].map(op=>analyze(`op${op}_events.csv`,op));
const headers=csv('network_headers.csv').filter(e=>e.valid===1),headerOps=[],calls=[];let begin=null,call=null;
for(const e of headers){check(e.phase<16,'Header mask failed');
 if(e.event===0xff00)call=e;
 if(e.event===0xff0f&&call){calls.push({cycles:cycleDiff(call,e),ms:cycleDiff(call,e)/100000});call=null;}
 if(e.op<84&&e.phase===1)begin=e;
 if(e.op<84&&e.phase===14&&begin){check(begin.op===e.op,'Header op mismatch');headerOps.push({op:e.op,cycles:cycleDiff(begin,e),ms:cycleDiff(begin,e)/100000});begin=null;}
}
const networkStarts=headers.filter(e=>e.op===0&&e.phase===1);
const network={samples:headers.length,calls,startIntervalsMs:networkStarts.slice(1).map((e,i)=>cycleDiff(networkStarts[i],e)/100000),
 ops:ops.map(o=>({op:o.op,uartMs:o.realUs/1000,measuredMs:stats(headerOps.filter(e=>e.op===o.op).map(e=>e.ms))}))};
check(network.calls.length>0&&network.ops.every(o=>o.measuredMs),'Missing complete network/ops');
fs.writeFileSync(path.join(dir,'network_headers_decoded.json'),JSON.stringify(headers.map(serializable),null,2)+'\n');
const pureMacUs=sum(ops.map(o=>o.idealMacUs||0));
// Freeze the report scope/units separately from the HLS synthesis estimate.
const utilization=read(path.join(dir,'zynq_wrapper_utilization_placed.rpt'));
function resource(label){const line=utilization.split('\n').find(s=>s.startsWith('|')&&s.split('|')[1].trim()===label);
 check(line,'Resource row missing: '+label);const a=line.split('|').map(s=>s.trim());
 return{used:+a[2],available:+a[4],percent:+a[5]};}
const timing=read(path.join(dir,'zynq_wrapper_timing_summary_routed.rpt'));
check(timing.includes('Timing constraints are not met.'),'Unexpected whole-design timing status');
check(/clk_fpga_0\s+0\.107\s+0\.000\s+0\s+116719\s+0\.036/.test(timing),'100MHz timing row changed');
check(/I\s+-0\.533\s+-2\.568\s+7\s+63/.test(timing),'HDMI timing row changed');
const bd=JSON.parse(read(path.join(dir,'zynq_bd_clock_evidence.json')));
const clockNet=Object.entries(bd.design.nets).find(([,v])=>v.ports?.includes('yolov5n_top_9/ap_clk'));
check(clockNet&&['ila_2/clk','c_counter_binary_2/CLK','processing_system7_0/FCLK_CLK0'].every(p=>clockNet[1].ports.includes(p)),
 'Probe/counter/accelerator clocks differ');
const platform={bitConsistency:JSON.parse(read(path.join(dir,'platform_bit_consistency.json'))),
 resourceScope:'Vivado whole design, Fully Placed; not HLS estimates',
 resources:{lut:resource('Slice LUTs'),ff:resource('Slice Registers'),slice:resource('Slice'),
 bramTile:resource('Block RAM Tile'),dsp:resource('DSPs')},clockNet:clockNet[0],clockMHz:100,
 timing:{whole:{wnsNs:-.533,tnsNs:-2.586,setupFailingEndpoints:7},
 acceleratorClock:{wnsNs:.107,tnsNs:0,whsNs:.036},hdmiClockI:{wnsNs:-.533,tnsNs:-2.568,setupFailingEndpoints:7}}};
const result={version:'R6.3 / 9.xsa',boardMeasured:true,hardwareBuildPerformedByAgent:false,
 wholeUs:now.wholeUs,perOpUs:now.sumUs,wholeMinusPerOpUs:now.wholeUs-now.sumUs,reciprocalFPS:1e6/now.wholeUs,
 previousWholeUs:old.wholeUs,savedUs:old.wholeUs-now.wholeUs,timeReductionPercent:100*(1-now.wholeUs/old.wholeUs),throughputIncreasePercent:100*(old.wholeUs/now.wholeUs-1),
 r5WholeUs:baseline.wholeUs,r5TimeReductionPercent:100*(1-now.wholeUs/baseline.wholeUs),r5ThroughputIncreasePercent:100*(baseline.wholeUs/now.wholeUs-1),
 pureMacUs,nonPureMacUs:now.wholeUs-pureMacUs,pureMacBudgetFraction:pureMacUs/now.wholeUs,effectiveGMACPerSecond:pureMacUs*6400/(now.wholeUs*1000),
 categories,regions,ops,frames,steadyAvg16:stats(frames.filter(f=>f.frame>0&&f.complete).map(f=>f.avg16)),initial,captures,network,platform,
 conditional1x1Targets:[.2,.3,.5].map(f=>{const ms=(now.wholeUs-categories.find(c=>c.name==='conv1x1').realUs*f)/1000;return{oneByOneTimeReduction:f,wholeMs:ms,fps:1000/ms};})};
fs.writeFileSync(path.join(dir,'board_analysis.json'),JSON.stringify(result,null,2)+'\n');
fs.writeFileSync(path.join(dir,'per_op_comparison.csv'),'op,type,k,R6_2_us,R6_3_us,saved_us,saved_percent,share_percent,ideal_mac_us\n'+ops.map(o=>[o.op,o.type,o.k,o.oldUs,o.realUs,o.savedUs,o.savedPercent,o.sharePercent,o.idealMacUs??''].join(',')).join('\n')+'\n');
// This dated board manifest does not replace the original implementation manifest.
const externals=['src/yolov5n_top.cpp','src/yolov5n_hls.h','src/yolov5n_r6_3_schedule.h',
 'tools/analyze_r6_3_board.js','tools/r5_testdata/layers.bin','HLS_R6_调度访存优化与综合记录_20261015.md',
 '../02_vivado/yolov5n_speed_wrapper_9.xsa',
 '../02_vivado/yolov5n_ip/yolov5n_ip.runs/impl_1/zynq_wrapper.bit',
 '../02_vivado/yolov5n_ip/yolov5n_ip.runs/impl_1/zynq_wrapper.ltx',
 'measurements/R6_2_8xsa_20261016/uart_7_2_as_8xsa.txt',
 'measurements/R6_2_8xsa_20261016/uart_R5_7xsa_baseline.txt'];
const files=[...fs.readdirSync(dir).filter(f=>f!=='evidence_manifest.json').map(f=>path.join(dir,f)),
 ...externals.map(f=>path.resolve(root,f))].map(file=>{const b=fs.readFileSync(file);return{
 path:path.relative(root,file).replaceAll('\\','/'),bytes:b.length,sha256:crypto.createHash('sha256').update(b).digest('hex')};});
fs.writeFileSync(path.join(dir,'evidence_manifest.json'),JSON.stringify({version:'R6.3 / 9.xsa',
 generatedAt:new Date().toISOString(),implementationChanged:false,fpgaReprogrammed:false,
 notes:['ILA runtime capture settings changed; initial capture/config saved first.',
 'Bit comparison is file consistency, not FPGA configuration readback.',
 'Board probes are event/valid/counter; task labels inferred from source schedule.'],files},null,2)+'\n');
console.log(JSON.stringify({...result,ops:undefined,frames:undefined,network:{calls:network.calls,startIntervalsMs:network.startIntervalsMs},captures:captures.map(c=>({...c,phaseIntervals:undefined,waveGroups:undefined}))},null,2));
