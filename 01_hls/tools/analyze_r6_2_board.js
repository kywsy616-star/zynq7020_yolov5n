// Offline R6.2 / 8.xsa (physical filename 7_2.xsa) board-evidence analysis.
// Does not modify HLS/Vitis/Vivado implementation or acquire new data.
const fs = require('fs'), path = require('path'), crypto = require('crypto');
const root = path.resolve(__dirname, '..');
const dir = path.join(root, 'measurements/R6_2_8xsa_20261016');
const read = p => fs.readFileSync(p, 'utf8').replaceAll('\r\n', '\n');
const hash = p => crypto.createHash('sha256').update(fs.readFileSync(p)).digest('hex');
const check = (ok, why) => { if (!ok) throw new Error(why); };
const sum = a => a.reduce((s, n) => s + n, 0);
function profile(file) {
    const text = read(file);
    const ops = [...text.matchAll(/^\s*(\d+)\s+(\d+)\s+(\d+)x(\d+)\s+(\d+)>\s*(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s*$/gm)]
        .map(m => ({op:+m[1],type:+m[2],oh:+m[3],ow:+m[4],ic:+m[5],oc:+m[6],k:+m[7],
            displayedMacMillions:+m[8],realUs:+m[9],displayedIdealUs:+m[10],displayedRatioPercent:+m[11]}));
    check(ops.length === 84 && ops.every((d,i) => d.op === i), '84-op UART profile missing');
    const wholeUs = +text.match(/whole network\s*=\s*(\d+) us/)[1];
    const sumUs = +text.match(/per-op sum\s*=\s*(\d+) us/)[1];
    check(sum(ops.map(d=>d.realUs)) === sumUs, 'UART per-op sum mismatch');
    return {wholeUs,sumUs,ops};
}
const baseline = profile(path.join(dir, 'uart_R5_7xsa_baseline.txt'));
const current = profile(path.join(dir, 'uart_7_2_as_8xsa.txt'));
const geometry = JSON.parse(read(path.join(root, 'yolov5n_hls_r6_2_20261015/r6_2_summary.json'))).geometry;
const layers = current.ops.map((d,i) => ({...d, baselineUs:baseline.ops[i].realUs,
    savedUs:baseline.ops[i].realUs-d.realUs,
    savedPercent:(1-d.realUs/baseline.ops[i].realUs)*100,
    sharePercent:d.realUs/current.wholeUs*100,
    ...(d.type===0 ? {macs:d.oh*d.ow*d.oc*d.ic*d.k*d.k,
        idealMacUs:d.oh*d.ow*d.oc*d.ic*d.k*d.k/6400,
        geometry:geometry.find(g=>g.op===i)} : {})}));
const categories = [['conv3x3',d=>d.type===0&&d.k===3],['conv1x1',d=>d.type===0&&d.k===1],
    ['copy',d=>d.type===2],['pool',d=>d.type===1]]
    .map(([name,accept])=>{const a=layers.filter(accept);return {name,count:a.length,
        baselineUs:sum(a.map(d=>d.baselineUs)),realUs:sum(a.map(d=>d.realUs)),
        savedUs:sum(a.map(d=>d.savedUs)),idealMacUs:sum(a.map(d=>d.idealMacUs||0)),
        sharePercent:sum(a.map(d=>d.realUs))/current.wholeUs*100};});
const groups = [['backbone',0,31],['neck',32,65],['detect',66,83]].map(([name,lo,hi])=>{
    const a=layers.slice(lo,hi+1);return{name,ops:[lo,hi],baselineUs:sum(a.map(d=>d.baselineUs)),
        realUs:sum(a.map(d=>d.realUs)),savedUs:sum(a.map(d=>d.savedUs)),
        sharePercent:sum(a.map(d=>d.realUs))/current.wholeUs*100};});
const uart = read(path.join(dir, 'uart_7_2_as_8xsa.txt'));
const frames = uart.split('\n').filter(s=>/^f\d+ done=/.test(s)).map(line=>{
    const value=name=>{const m=line.match(new RegExp(`\\b${name}=([0-9.]+)`));return m?+m[1]:null;};
    return {frame:+line.match(/^f(\d+)/)[1],fps:value('fps'),avg16:value('avg16'),
        inferMs:value('infer'),prepMs:value('prep'),latMs:value('lat'),complete:/lat=\d+ms$/.test(line)};
});
const steady=frames.filter(d=>d.frame>0&&d.complete);
const avg16=steady.map(d=>d.avg16).filter(x=>x!==null);
function stats(a,totalCycles) {
    const cycles=sum(a);
    return {count:a.length,cycles,meanCycles:cycles/a.length,minCycles:Math.min(...a),
        maxCycles:Math.max(...a),us:cycles/100,percent:cycles/totalCycles*100};
}
function analyzeCapture(file,op) {
    const lines=read(path.join(dir,file)).trim().split('\n'), header=lines[0].split(',');
    const eventCol=header.findIndex(s=>/profile_event_o\[/.test(s));
    const validCol=header.findIndex(s=>/profile_event_o_ap_vld/.test(s));
    const tickCol=header.findIndex(s=>/_Q\[63:0\]/.test(s));
    check(eventCol>=0&&validCol>=0&&tickCol>=0,'Missing probes');
    const all=lines.slice(2).map(line=>{
        const a=line.split(','),v=parseInt(a[eventCol],16);
        return {sample:+a[0],trigger:+a[2],event:v,op:v>>>8,phase:v&255,valid:parseInt(a[validCol],16),
            ticks:BigInt('0x'+a[tickCol])};
    });
    const valid=all.filter(e=>e.valid===1);
    const start=valid.findIndex(e=>e.op===op&&e.phase===1);
    const foundEnd=start<0?-1:valid.findIndex((e,i)=>i>start&&e.op===op&&e.phase===14);
    const e=start<0?valid.filter(e=>e.op===op):valid.slice(start,foundEnd<0?undefined:foundEnd+1);
    check(e.length>1&&e.every(e=>e.op===op),'Target capture crosses operators before OP_END');
    const totalCycles=Number(e.at(-1).ticks-e[0].ticks), intervals={};
    for(let i=0;i+1<e.length;i++){
        const n=Number(e[i+1].ticks-e[i].ticks);check(n>0,'Timestamp order');
        (intervals[e[i].phase]||=[]).push(n);
        if(e[i].phase===11){
            const kind=e[i-1]?.phase===10?'row':'block';
            (intervals['11_'+kind]||=[]).push(n);
        }
    }
    const phases=Object.fromEntries(Object.entries(intervals).map(([p,a])=>[p,stats(a,totalCycles)]));
    check(sum(Object.entries(phases).filter(([p])=>/^\d+$/.test(p)).map(([,s])=>s.cycles))===totalCycles,
        'Phase totals do not cover the measured interval');
    const d=layers[op],g=d.geometry;
    const expected={tiles:Math.ceil(d.oh/g.tileR)*Math.ceil(d.ow/g.physicalTileC),
        blocks:d.oh*Math.ceil(d.ow/16)*(d.oc/16),rows:d.oh*Math.ceil(d.ow/g.physicalTileC)};
    const fullCounts={1:1,2:1,3:1,4:1,5:expected.tiles,6:expected.blocks,7:expected.blocks,
        ...(d.op===4||d.op===10||d.op===24?{8:expected.blocks}:{}),17:expected.blocks,
        10:expected.rows,'11_block':expected.blocks,'11_row':expected.rows};
    const estimate={};
    for(const [p,count]of Object.entries(fullCounts))if(phases[p])estimate[p]=phases[p].meanCycles*count/100000;
    if(foundEnd>=0)for(const [p,count]of Object.entries(fullCounts))
        check(phases[p]?.count===count,'Complete-op stage count mismatch: op '+op+' phase '+p);
    const estimateMs=sum(Object.values(estimate));
    const trace=e.map((x,i)=>({...x,ticks:x.ticks.toString(),hex:x.event.toString(16).padStart(4,'0'),
        ...(i+1<e.length?{cyclesUntilNext:Number(e[i+1].ticks-x.ticks)}:{})}));
    const result={file,requestedOp:op,bufferSamples:all.length,validSamples:valid.length,targetEvents:e.length,
        firstEvent:e[0].event.toString(16).padStart(4,'0'),lastEvent:e.at(-1).event.toString(16).padStart(4,'0'),
        triggerSamples:all.filter(e=>e.trigger).map(e=>e.sample),
        completeOp:foundEnd>=0,startsAtDescriptor:start===0,totalCycles,windowMs:totalCycles/100000,
        measuredOpMs:foundEnd>=0?totalCycles/100000:null,phases,expectedFullCounts:expected,
        projectedStageMs:start>=0?estimate:null,projectedOpMs:start>=0?estimateMs:null,uartOpMs:d.realUs/1000,
        differenceFromUartPercent:start<0?null:((foundEnd>=0?totalCycles/100000:estimateMs)/(d.realUs/1000)-1)*100,
        sha256:hash(path.join(dir,file))};
    fs.writeFileSync(path.join(dir,file.replace('.csv','_decoded.json')),JSON.stringify(trace,null,2)+'\n');
    fs.writeFileSync(path.join(dir,file.replace('.csv','_analysis.json')),JSON.stringify(result,null,2)+'\n');
    return result;
}
const captures=[0,3,6,67].map(op=>analyzeCapture(`op${op}_events.csv`,op));
const initial=analyzeCapture('initial_waveform_084211.csv',47);
const oldOp0=JSON.parse(read(path.join(root,'measurements/R6_1_ILA_20261015_recapture_01/analysis_calculations.json')));
const newOp0=captures[0].projectedStageMs;
const op0StageComparison=[['input',oldOp0.predictedStageMs[5],newOp0[5]],
    ['MAC',oldOp0.predictedStageMs[7],newOp0[7]],
    ['requant',oldOp0.predictedStageMs[9],newOp0[17]],
    ['output',oldOp0.predictedStageMs[10],newOp0[10]],
    ['control',oldOp0.predictedStageMs[11],newOp0['11_block']+newOp0['11_row']]]
    .map(([name,beforeMs,afterMs])=>({name,beforeMs,afterMs,savedMs:beforeMs-afterMs,
        savedPercent:(1-afterMs/beforeMs)*100}));
const bd=JSON.parse(read(path.join(dir,'zynq_bd_clock_evidence.json')));
function findKey(o,key) {
    if(!o||typeof o!=='object')return null;
    if(Object.hasOwn(o,key))return o[key];
    for(const x of Object.values(o)){const v=findKey(x,key);if(v!==null)return v;}
    return null;
}
check(+findKey(bd,'PCW_FPGA0_PERIPHERAL_FREQMHZ').value===100,'Unexpected FCLK0 frequency');
const clockPorts=findKey(bd,'processing_system7_0_FCLK_CLK0').ports;
for(const port of ['yolov5n_top_7_2/ap_clk','ila_1/clk','c_counter_binary_1/CLK'])
    check(clockPorts.includes(port),'Measurement clock mismatch '+port);
const bitConsistency=JSON.parse(read(path.join(dir,'platform_bit_consistency.json')).replace(/^\uFEFF/,''));
check(bitConsistency.embeddedBitMatchesImplementation,'XSA bit differs from implementation');
const macs=sum(layers.map(d=>d.macs||0)),idealMs=macs/6400000;
const rpt=read(path.join(dir,'zynq_wrapper_utilization_placed_083332.rpt'));
const use=name=>{const m=rpt.match(new RegExp(`\\| ${name}\\s+\\|\\s+([\\d.]+)\\s+\\|\\s+\\d+\\s+\\|\\s+([\\d.]+)\\s+\\|\\s+([\\d.]+)`));
    check(m,'Missing utilization '+name);return{used:+m[1],available:+m[2],percent:+m[3]};};
const result={version:'R6.2',majorVersion:'8.xsa',physicalXsa:'yolov5n_speed_wrapper_7_2.xsa',
    evidenceDate:'2026-10-16',boardMeasured:true,hardwareBuildPerformedByAgent:false,
    nextMajorVersion:'9.xsa',clockHz:100000000,
    clockEvidence:{BDClockMHz:100,sameNet:clockPorts.filter(p=>/yolov5n_top|ila_1|c_counter/.test(p))},
    bitConsistency,op0StageComparison,baselineWholeUs:baseline.wholeUs,
    currentWholeUs:current.wholeUs,currentPerOpSumUs:current.sumUs,
    savedUs:baseline.wholeUs-current.wholeUs,savedPercent:(1-current.wholeUs/baseline.wholeUs)*100,
    speedup:baseline.wholeUs/current.wholeUs,fpsFromWhole:1000000/current.wholeUs,
    throughputGainPercent:(baseline.wholeUs/current.wholeUs-1)*100,macs,idealMacMs:idealMs,
    nonIdealDifferenceMs:current.wholeUs/1000-idealMs,effectiveGmacPerSecond:macs/(current.wholeUs*1000),
    macPeakFraction:idealMs/(current.wholeUs/1000),categories,groups,
    frames,steadyAvg16:{count:avg16.length,min:Math.min(...avg16),max:Math.max(...avg16),mean:sum(avg16)/avg16.length},
    topByCurrentTime:[...layers].sort((a,b)=>b.realUs-a.realUs).slice(0,12),
    topBySavings:[...layers].sort((a,b)=>b.savedUs-a.savedUs).slice(0,12),
    conditionalTargets:[180,170,160].map(ms=>({networkMs:ms,fps:1000/ms,
        requiredSavingMs:current.wholeUs/1000-ms,performancePromise:false})),
    worsenedOps:layers.filter(d=>d.savedUs<0),layers,captures,initialCapture:initial,
    actualPlacedResources:{LUT:use('Slice LUTs'),FF:use('Slice Registers'),BRAMTile:use('Block RAM Tile'),DSP:use('DSPs')},
    timing:{overallWnsNs:-0.748,overallTnsNs:-2.660,failingSetupEndpoints:4,
        acceleratorClockMHz:100,acceleratorClockWnsNs:0.178,acceleratorClockWhsNs:0.036,
        failingClock:'I',failingClockMHz:500,failingHierarchy:'hdmi_transmitter_0/par_to_ser_*/ODDR'},
    caveats:['UART startup per-op mode runs before CPU1 wakeup; live ILA is later AMP execution.',
        'op0/op6 are prefix estimates; op3/op67 have complete DESCRIPTOR-to-OP_END measurements.',
        'Current hardware probes contain event, valid and time only; no board AXI handshake/burst-length capture.',
        'Throughput matches log; camera/HDMI visual accuracy was not independently verified this analysis.']};
fs.writeFileSync(path.join(dir,'board_analysis.json'),JSON.stringify(result,null,2)+'\n');
fs.writeFileSync(path.join(dir,'per_op_comparison.csv'),'op,type,k,baseline_us,current_us,saved_us,saved_percent,ideal_mac_us\n'+
    layers.map(d=>[d.op,d.type,d.k,d.baselineUs,d.realUs,d.savedUs,d.savedPercent.toFixed(4),d.idealMacUs??''].join(',')).join('\n')+'\n');
const files=fs.readdirSync(dir).filter(p=>fs.statSync(path.join(dir,p)).isFile()&&p!=='evidence_manifest.json');
const manifest={version:'R6.2 / 8.xsa (original 7_2.xsa)',files:Object.fromEntries(files.map(p=>[p,
    {bytes:fs.statSync(path.join(dir,p)).size,sha256:hash(path.join(dir,p))}])),
    externalFiles:Object.fromEntries(['01_hls/tools/analyze_r6_2_board.js',
        '01_hls/src/yolov5n_top.cpp','01_hls/src/yolov5n_hls.h',
        '01_hls/yolov5n_hls_r6_2_20261015/r6_2_summary.json',
        '01_hls/measurements/R6_1_ILA_20261015_recapture_01/analysis_calculations.json',
        '02_vivado/yolov5n_speed_wrapper_7_2.xsa',
        '02_vivado/yolov5n_ip/yolov5n_ip.runs/impl_1/zynq_wrapper.bit',
        '02_vivado/yolov5n_ip/yolov5n_ip.runs/impl_1/zynq_wrapper.ltx'].map(p=>[p,
            {bytes:fs.statSync(path.join(root,'..',p)).size,sha256:hash(path.join(root,'..',p))}]))};
fs.writeFileSync(path.join(dir,'evidence_manifest.json'),JSON.stringify(manifest,null,2)+'\n');
console.log(JSON.stringify({savedUs:result.savedUs,savedPercent:result.savedPercent,fps:result.fpsFromWhole,
    steadyAvg16:result.steadyAvg16,categories,groups,topBySavings:result.topBySavings.slice(0,8),
    captures:captures.map(c=>({op:c.requestedOp,complete:c.completeOp,events:c.targetEvents,windowMs:c.windowMs,
        projectedMs:c.projectedOpMs,uartMs:c.uartOpMs,phases:c.phases})),
    actualPlacedResources:result.actualPlacedResources},null,2));
