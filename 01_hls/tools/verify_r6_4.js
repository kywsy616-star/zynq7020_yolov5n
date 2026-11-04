// R6.4: verify final numeric/RTL evidence, fixed ABI and actual task overlap.
const fs = require('fs'), path = require('path'), crypto = require('crypto');
const root = path.resolve(__dirname, '..');
const project = path.join(root, 'yolov5n_hls_r6_4_20261016');
const reference = path.join(root, 'yolov5n_hls_r6_4_reference_20261016');
const frozen = path.join(root, 'archive/pre_R6_4_20261016');
const read = p => fs.readFileSync(p, 'utf8').replaceAll('\r\n', '\n');
const hash = p => crypto.createHash('sha256').update(fs.readFileSync(p)).digest('hex');
const check = (ok, message) => { if (!ok) throw Error(message); };
for (const item of JSON.parse(read(path.join(frozen, 'manifest.json')).replace(/^\uFEFF/, '')))
    check(hash(path.join(frozen, item.path)) === item.sha256, 'Frozen R6.3 changed: ' + item.path);
check(read(path.join(root, 'r6_4_csynth_20261016.log')).includes('24 scalar cases + 2 real-model frames x 84 ops'), 'Full Csim absent');
for (const file of ['r6_4_cosim_20261016.log', 'r6_4_reference_20261016.log'])
    check(read(path.join(root, file)).includes('C/RTL co-simulation finished: PASS'), 'Cosim failed: ' + file);
const vectorEvidence = {};
for (const name of ['gmem','p_act','p_wgt','p_rqt','p_tbl','start_op','n_ops']) {
    const suffix = `solution1/sim/tv/cdatafile/c.yolov5n_top.autotvin_${name}.dat`;
    const actualHash = hash(path.join(project, suffix)), referenceHash = hash(path.join(reference, suffix));
    check(actualHash === referenceHash, 'RTL input vectors differ: ' + name);
    vectorEvidence[name] = actualHash;
}
const rtlDir = path.join(project, 'solution1/syn/verilog');
const top = read(path.join(rtlDir, 'yolov5n_top.v'));
check(/C_M_AXI_GMEM_DATA_WIDTH = 32/.test(top), 'AXI data width changed');
check(/output\s+\[15:0\] profile_event_o;/.test(top) && /output\s+profile_event_o_ap_vld;/.test(top), 'Event ports changed');
check(!/profile_event_i_ap_vld|profile_event.*ap_ack/.test(top), 'Unwanted input handshake');
const addresses = text => [...text.matchAll(/ADDR_\w+\s*=\s*7'h[0-9a-f]+/g)].map(m => m[0]);
const control = 'solution1/syn/verilog/yolov5n_top_control_s_axi.v';
check(JSON.stringify(addresses(read(path.join(project, control)))) ===
      JSON.stringify(addresses(read(path.join(reference, control)))), 'AXI-Lite register map changed');
const wave = read(path.join(rtlDir, 'yolov5n_top_r64_wave.v'));
check((wave.match(/yolov5n_top_r64_mac\s+r64_mac_U0\(/g) || []).length === 1, 'MAC task not unique');
check(fs.readdirSync(rtlDir).filter(f => /^yolov5n_top_r64_wave(?:\d+|_\d+)?\.v$/.test(f)).length === 1, 'Wave cloned');
const xml = read(path.join(project, 'solution1/syn/report/yolov5n_top_csynth.xml'));
const resources = Object.fromEntries([...xml.match(/<Resources>([\s\S]*?)<\/Resources>/)[1]
    .matchAll(/<(\w+)>(\d+)<\/\1>/g)].map(m => [m[1], +m[2]]));
check(resources.DSP <= 220 && resources.LUT <= 53200 && resources.BRAM_18K <= 280, 'Pure HLS exceeds device');
const loops = {};
for (const [module, marker] of [['r64_mac', 'R64_MAC_PIXELS'], ['r64_quant', 'R64_QUANT_PIXELS'],
    ['r64_memory', 'R64_STAGE_VALID'], ['r64_memory', 'R64_OUTPUT_ROW'],
    ['r64_pair_read','R64_PAIRED_READ'],['r64_pair_write','R64_PAIRED_WRITE']]) {
    const report = read(path.join(project, `solution1/syn/report/${module}_csynth.xml`));
    const match = report.match(new RegExp(`<([^<>]*${marker}[^<>]*)>\\s*([\\s\\S]*?)<\\/\\1>`));
    check(match && /<PipelineII>1<\/PipelineII>/.test(match[2]), 'II != 1: ' + marker);
    loops[marker] = {II: 1};
}
function waveform(dir, prefix) {
    const vcd = read(path.join(dir, 'solution1/sim/verilog/r6_4_events.vcd'));
    check(/\$timescale\s+1ps/.test(vcd), 'Unexpected VCD units');
    const ids = {}, scopes = [];
    for (const line of vcd.split('\n')) {
        if (line.startsWith('$scope')) scopes.push(line.split(/\s+/)[2]);
        else if (line.startsWith('$upscope')) scopes.pop();
        else if (line.startsWith('$var')) {
            const words = line.split(/\s+/);
            ids['/' + scopes.join('/') + '/' + words[4]] = words[3];
        }
    }
    const dut = '/apatb_yolov5n_top_top/AESL_inst_yolov5n_top/';
    const signal = name => {
        const id = ids[dut + name]; check(id, 'Missing signal ' + name); return id;
    };
    const taskSignal = name => {
        const pair = Object.entries(ids).find(([p]) => p.endsWith('/' + name + '/ap_idle'));
        check(pair, 'Missing task ' + name); return pair[1];
    };
    const taskIds = [`${prefix}_mac_U0`, `${prefix}_quant_U0`, `${prefix}_memory_U0`].map(taskSignal);
    const localSignal = suffix => Object.entries(ids).find(([p])=>p.endsWith('/'+suffix))?.[1];
    const fifo = prefix==='r64' ? {
        write:localSignal('r64_mac_U0_packets_write'),full:localSignal('packets_full_n'),
        read:Object.entries(ids).find(([p])=>/\/r64_quant_U0_packets\d*_read$/.test(p))?.[1],empty:localSignal('packets_empty_n')
    } : null;
    if(fifo)check(Object.values(fifo).every(Boolean),'Missing FIFO probes: '+JSON.stringify(fifo));
    const names = ['ap_clk','profile_event_o','profile_event_o_ap_vld',
        'm_axi_gmem_AWVALID','m_axi_gmem_AWREADY','m_axi_gmem_AWLEN','m_axi_gmem_AWADDR',
        'm_axi_gmem_WVALID','m_axi_gmem_WREADY','m_axi_gmem_WLAST','m_axi_gmem_BVALID','m_axi_gmem_BREADY',
        'm_axi_gmem_ARVALID','m_axi_gmem_ARREADY','m_axi_gmem_ARLEN','m_axi_gmem_ARADDR',
        'm_axi_gmem_RVALID','m_axi_gmem_RREADY','m_axi_gmem_RLAST'];
    const sig = Object.fromEntries(names.map(name => [name,signal(name)]));
    const values = {}, events = [], calls = [];
    let pending = [], time = 0, current = null;
    const total = {aw:0,awWords:0,w:0,wlast:0,b:0,ar:0,arWords:0,r:0,rlast:0};
    function flush() {
        const before = {...values};
        for (const [id,value] of pending) values[id] = value;
        pending = [];
        if (!(before[sig.ap_clk] === '0' && values[sig.ap_clk] === '1')) return;
        const cycle = time / 10000;
        const bit = name => before[sig[name]] === '1';
        const number = name => { const value=before[sig[name]]; check(value && /^[01]+$/.test(value), 'Unknown '+name); return parseInt(value,2); };
        if (bit('profile_event_o_ap_vld')) {
            const value = number('profile_event_o');
            const event = {cycle, value, op:value >>> 8, phase:value & 255};
            events.push(event);
            if (value === 0xff00) {
                check(!current, 'Nested call');
                current={start:cycle, phases:{}, aw:[], ar:[], macQuantOverlap:0, macMemoryOverlap:0,
                    tripleOverlap:0, inputReadWhileMacActive:0, writeBeatWhileMacActive:0,simultaneousReadWriteBeats:0,
                    packetWrites:0,packetReads:0,packetOccupancy:0,maxPacketOccupancy:0};
            }
            check(current, 'Event outside call');
            current.phases[event.phase] = (current.phases[event.phase] || 0)+1;
            if (value === 0xff0f) { current.end=cycle; current.cycles=cycle-current.start; calls.push(current); current=null; }
        }
        const active = taskIds.map(id => before[id] === '0');
        if(current&&fifo){
            const write=before[fifo.write]==='1'&&before[fifo.full]==='1';
            const read=before[fifo.read]==='1'&&before[fifo.empty]==='1';
            current.packetWrites+=+write;current.packetReads+=+read;current.packetOccupancy+=+write-+read;
            current.maxPacketOccupancy=Math.max(current.maxPacketOccupancy,current.packetOccupancy);
            check(current.packetOccupancy>=0&&current.packetOccupancy<=16,'FIFO occupancy outside depth16');
        }
        if (current) {
            if(active[0] && active[1]) current.macQuantOverlap++;
            if(active[0] && active[2]) current.macMemoryOverlap++;
            if(active.every(Boolean)) current.tripleOverlap++;
        }
        if (bit('m_axi_gmem_AWVALID') && bit('m_axi_gmem_AWREADY')) {
            const words=number('m_axi_gmem_AWLEN')+1, address=number('m_axi_gmem_AWADDR');
            total.aw++;total.awWords+=words;if(current)current.aw.push({cycle,words,address});
        }
        if (bit('m_axi_gmem_ARVALID') && bit('m_axi_gmem_ARREADY')) {
            const words=number('m_axi_gmem_ARLEN')+1, address=number('m_axi_gmem_ARADDR');
            total.ar++;total.arWords+=words;if(current) {
                current.ar.push({cycle,words,address});
                if(active[0] && address<65536)current.inputReadWhileMacActive++;
            }
        }
        if (bit('m_axi_gmem_WVALID') && bit('m_axi_gmem_WREADY')) {
            total.w++;if(bit('m_axi_gmem_WLAST'))total.wlast++;
            if(current && active[0])current.writeBeatWhileMacActive++;
            if(current && bit('m_axi_gmem_RVALID') && bit('m_axi_gmem_RREADY'))current.simultaneousReadWriteBeats++;
        }
        if (bit('m_axi_gmem_BVALID') && bit('m_axi_gmem_BREADY'))total.b++;
        if (bit('m_axi_gmem_RVALID') && bit('m_axi_gmem_RREADY')) {total.r++;if(bit('m_axi_gmem_RLAST'))total.rlast++;}
    }
    for (const line of vcd.split('\n')) {
        if(line.startsWith('#')){flush();time=+line.slice(1);}
        else if(/^b[01xz]+\s/.test(line)){const [value,id]=line.split(/\s+/);pending.push([id,value.slice(1)]);}
        else if(/^[01xz]\S+$/.test(line))pending.push([line.slice(1),line[0]]);
    }
    flush();
    check(total.awWords===total.w && total.aw===total.wlast && total.aw===total.b,'AW/W/B payload or completion mismatch');
    check(total.arWords===total.r && total.ar===total.rlast,'AR/R payload mismatch');
    check(calls.length===10 && !current,'Expected ten completed calls');
    return {calls,total,events};
}
const actual=waveform(project,'r64'), old=waveform(reference,'r63');
const expectedPackets=[260,0,0,0,512,390,204,51,27,18];
function footprint(transactions){const m=new Map();for(const t of transactions)for(let i=0;i<t.words;i++){
 const a=t.address+4*i;m.set(a,(m.get(a)||0)+1);}
 return JSON.stringify([...m].sort((a,b)=>a[0]-b[0]));}
const comparisons=actual.calls.map((call,i)=>{
    const before=old.calls[i], sum=(list)=>list.reduce((n,x)=>n+x.words,0);
    check(sum(call.aw)===sum(before.aw),'Output payload changed');
    check(sum(before.ar)===sum(call.ar), 'DDR read payload changed at case '+i);
    check(footprint(before.ar)===footprint(call.ar),'Read address footprint changed at case '+i);
    check(footprint(before.aw)===footprint(call.aw),'Write address footprint changed at case '+i);
    check(call.packetWrites===expectedPackets[i]&&call.packetReads===expectedPackets[i]&&call.packetOccupancy===0,
        'FIFO token balance mismatch at case '+i);
    check(call.macQuantOverlap>0 && call.macMemoryOverlap>0,'No actual task overlap');
    return {case:i+1,beforeCycles:before.cycles,afterCycles:call.cycles,
        savedCycles:before.cycles-call.cycles,timeReductionPercent:100*(1-call.cycles/before.cycles),
        beforeARWords:sum(before.ar),afterARWords:sum(call.ar),
        beforeAR:before.ar.length,afterAR:call.ar.length,
        beforeAW:before.aw.length,afterAW:call.aw.length,outputWords:sum(call.aw),
        writeBurstLengths:[...new Set(call.aw.map(t=>t.words))].sort((a,b)=>a-b),
        macQuantOverlapCycles:call.macQuantOverlap,macMemoryOverlapCycles:call.macMemoryOverlap,
        tripleTaskOverlapCycles:call.tripleOverlap,inputReadBurstsWhileMacActive:call.inputReadWhileMacActive,
        writeBeatsWhileMacActive:call.writeBeatWhileMacActive,
        beforeSimultaneousReadWriteBeats:before.simultaneousReadWriteBeats,
        simultaneousReadWriteBeats:call.simultaneousReadWriteBeats,
        packetWrites:call.packetWrites,packetReads:call.packetReads,maxPacketOccupancy:call.maxPacketOccupancy};
});
const summary={version:'R6.4 / 10.xsa',kind:'same-input small RTL cases; not board or whole-model latency',
    part:'xc7z020-clg400-2',targetClockNs:10,
    estimatedClockNs:+xml.match(/<EstimatedClockPeriod>([^<]+)/)[1],resources,loops,
    checks:{scalarCases:24,realModelFrames:2,fullArenaAfterEveryOp:true,tenRTLCases:true,
        frozenR63SameInputs:true,singleMAC:true,AXILiteUnchanged:true,gmem32:true,
        actualTaskOverlap:true,actualAXIPayloadUnchanged:true,AXIAddressFootprintsUnchanged:true,
        FIFOHandshakesBalanced:true,FIFODepth16Verified:true},
    ipExported:false,xsaGenerated:false,boardMeasured:false,comparisons,identicalInputVectorHashes:vectorEvidence,
    sources:Object.fromEntries(['src/yolov5n_top.cpp','src/yolov5n_hls.h','src/yolov5n_r6_4_schedule.h',
        'src/tb_yolov5n_r6_4.cpp','tools/verify_r6_4.js'].map(p=>[p,hash(path.join(root,p))]))};
fs.writeFileSync(path.join(project,'r6_4_summary.json'),JSON.stringify(summary,null,2)+'\n');
fs.writeFileSync(path.join(project,'r6_4_event_trace.json'),JSON.stringify(actual,null,2)+'\n');
fs.writeFileSync(path.join(reference,'r6_4_reference_trace.json'),JSON.stringify(old,null,2)+'\n');
// Preserve dated implementation evidence separately from later board measurements.
const evidence=[...Object.keys(summary.sources),'HLS_R6_调度访存优化与综合记录_20261015.md',
    'tools/run_r6_4_csynth.tcl','tools/run_r6_4_cosim.tcl','tools/run_r6_4_reference.tcl',
    'tools/prepare_r6_4_trace.js','tools/trace_r6_4_events.tcl','tools/trace_r6_4_reference.tcl',
    'tools/analyze_r6_4_geometry.js'];
evidence.push('src/tb_r5_reference.cpp','tools/r5_testdata/layers.bin','tools/r5_testdata/weights.bin',
    'tools/r5_testdata/rqt.bin','archive/pre_R6_4_20261016/manifest.json',
    'r6_4_csynth_20261016.log','r6_4_cosim_20261016.log','r6_4_reference_20261016.log');
for(const dir of [project,reference]){
 for(const file of ['solution1/syn/report/yolov5n_top_csynth.xml','solution1/syn/report/yolov5n_top_csynth.rpt',
    'solution1/sim/report/yolov5n_top_cosim.rpt','solution1/sim/verilog/r6_4_events.vcd'])
    evidence.push(path.relative(root,path.join(dir,file)));
 for(const name of ['gmem','p_act','p_wgt','p_rqt','p_tbl','start_op','n_ops'])evidence.push(path.relative(root,
    path.join(dir,`solution1/sim/tv/cdatafile/c.yolov5n_top.autotvin_${name}.dat`)));
 for(const file of fs.readdirSync(path.join(dir,'solution1/syn/verilog')).filter(f=>f.endsWith('.v')))
    evidence.push(path.relative(root,path.join(dir,'solution1/syn/verilog',file)));
}
evidence.push(path.relative(root,path.join(project,'r6_4_summary.json')),
    path.relative(root,path.join(project,'r6_4_geometry.json')),
    path.relative(root,path.join(project,'r6_4_event_trace.json')),
    path.relative(root,path.join(reference,'r6_4_reference_trace.json')));
fs.writeFileSync(path.join(project,'r6_4_evidence_manifest.json'),JSON.stringify({version:summary.version,
    generatedAt:new Date().toISOString(),ipExported:false,xsaGenerated:false,boardMeasured:false,
    files:[...new Set(evidence)].map(p=>({path:p.replaceAll('\\','/'),bytes:fs.statSync(path.join(root,p)).size,
        sha256:hash(path.join(root,p))}))},null,2)+'\n');
const record=read(path.join(root,'HLS_R6_调度访存优化与综合记录_20261015.md'));
const recordLines=record.split('\n');
check(recordLines.filter(l=>l.startsWith(String.fromCharCode(96).repeat(3))).length%2===0,
    'Unbalanced Markdown code fences');
for(const [,id,relative] of record.matchAll(/^\[([^\]]+)\]:\n\s+(.+)$/gm)){
    if(/^https?:/.test(relative))continue;
    check(fs.existsSync(path.resolve(root,relative.trim())),'Missing Markdown target: '+id);
}
const chapter=recordLines.findIndex(l=>l.startsWith('## R6.4'));
check(chapter>=0,'R6.4 record missing');
for(const [i,line] of recordLines.slice(chapter).entries()){
    const width=[...line].reduce((n,c)=>n+(c.codePointAt(0)>255?2:1),0);
    check(width<=110,'R6.4 Markdown line too wide: '+(chapter+i+1));
}
console.log(JSON.stringify(summary,null,2));
