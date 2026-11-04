// R6.3: verify final numeric/RTL evidence, fixed ABI and actual task overlap.
const fs = require('fs'), path = require('path'), crypto = require('crypto');
const root = path.resolve(__dirname, '..');
const project = path.join(root, 'yolov5n_hls_r6_3_20261016');
const reference = path.join(root, 'yolov5n_hls_r6_3_reference_20261016');
const frozen = path.join(root, 'archive/pre_R6_3_20261016');
const read = p => fs.readFileSync(p, 'utf8').replaceAll('\r\n', '\n');
const hash = p => crypto.createHash('sha256').update(fs.readFileSync(p)).digest('hex');
const check = (ok, message) => { if (!ok) throw Error(message); };
for (const item of JSON.parse(read(path.join(frozen, 'manifest.json')).replace(/^\uFEFF/, '')))
    check(hash(path.join(frozen, item.path)) === item.sha256, 'Frozen R6.2 changed: ' + item.path);
check(read(path.join(root, 'r6_3_csynth_20261016.log')).includes('18 scalar cases + 2 real-model frames x 84 ops'), 'Full Csim absent');
for (const file of ['r6_3_cosim_20261016.log', 'r6_3_reference_20261016.log'])
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
const wave = read(path.join(rtlDir, 'yolov5n_top_r63_wave.v'));
check((wave.match(/yolov5n_top_r63_mac\s+r63_mac_U0\(/g) || []).length === 1, 'MAC task not unique');
check(fs.readdirSync(rtlDir).filter(f => /^yolov5n_top_r63_wave(?:\d+|_\d+)?\.v$/.test(f)).length === 1, 'Wave cloned');
const xml = read(path.join(project, 'solution1/syn/report/yolov5n_top_csynth.xml'));
const resources = Object.fromEntries([...xml.match(/<Resources>([\s\S]*?)<\/Resources>/)[1]
    .matchAll(/<(\w+)>(\d+)<\/\1>/g)].map(m => [m[1], +m[2]]));
check(resources.DSP <= 220 && resources.LUT <= 53200 && resources.BRAM_18K <= 280, 'Pure HLS exceeds device');
const loops = {};
for (const [module, marker] of [['r63_mac', 'R63_MAC_PIXELS'], ['r63_quant', 'R63_QUANT_PIXELS'],
    ['r63_memory', 'R63_STAGE_VALID'], ['r63_memory', 'R63_OUTPUT_ROW']]) {
    const report = read(path.join(project, `solution1/syn/report/${module}_csynth.xml`));
    const match = report.match(new RegExp(`<([^<>]*${marker}[^<>]*)>\\s*([\\s\\S]*?)<\\/\\1>`));
    check(match && /<PipelineII>1<\/PipelineII>/.test(match[2]), 'II != 1: ' + marker);
    loops[marker] = {II: 1};
}
function waveform(dir, hasTasks) {
    const vcd = read(path.join(dir, 'solution1/sim/verilog/r6_3_events.vcd'));
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
    const taskIds = hasTasks ? ['r63_mac_U0', 'r63_quant_U0', 'r63_memory_U0'].map(taskSignal) : [];
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
                    tripleOverlap:0, inputReadWhileMacActive:0, writeBeatWhileMacActive:0};
            }
            check(current, 'Event outside call');
            current.phases[event.phase] = (current.phases[event.phase] || 0)+1;
            if (value === 0xff0f) { current.end=cycle; current.cycles=cycle-current.start; calls.push(current); current=null; }
        }
        const active = taskIds.map(id => before[id] === '0');
        if (current && hasTasks) {
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
                if(hasTasks && active[0] && address<65536)current.inputReadWhileMacActive++;
            }
        }
        if (bit('m_axi_gmem_WVALID') && bit('m_axi_gmem_WREADY')) {
            total.w++;if(bit('m_axi_gmem_WLAST'))total.wlast++;
            if(current && hasTasks && active[0])current.writeBeatWhileMacActive++;
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
    check(calls.length===4 && !current,'Expected four completed calls');
    return {calls,total,events};
}
const actual=waveform(project,true), old=waveform(reference,false);
const expectedReadSavings=[0,14,10,0];
const comparisons=actual.calls.map((call,i)=>{
    const before=old.calls[i], sum=(list)=>list.reduce((n,x)=>n+x.words,0);
    check(sum(call.aw)===sum(before.aw),'Output payload changed');
    check(sum(before.ar)-sum(call.ar)===expectedReadSavings[i], 'Unexpected DDR input reuse saving at case '+i);
    check(call.macQuantOverlap>0 && call.macMemoryOverlap>0,'No actual task overlap');
    return {case:i+1,beforeCycles:before.cycles,afterCycles:call.cycles,
        savedCycles:before.cycles-call.cycles,timeReductionPercent:100*(1-call.cycles/before.cycles),
        beforeARWords:sum(before.ar),afterARWords:sum(call.ar),savedInputWords:expectedReadSavings[i],
        beforeAW:before.aw.length,afterAW:call.aw.length,outputWords:sum(call.aw),
        macQuantOverlapCycles:call.macQuantOverlap,macMemoryOverlapCycles:call.macMemoryOverlap,
        tripleTaskOverlapCycles:call.tripleOverlap,inputReadBurstsWhileMacActive:call.inputReadWhileMacActive,
        writeBeatsWhileMacActive:call.writeBeatWhileMacActive};
});
const summary={version:'R6.3 / 9.xsa',part:'xc7z020-clg400-2',targetClockNs:10,
    estimatedClockNs:+xml.match(/<EstimatedClockPeriod>([^<]+)/)[1],resources,loops,
    checks:{scalarCases:18,realModelFrames:2,fullArenaAfterEveryOp:true,fourRTLCases:true,
        frozenR62SameInputs:true,singleMAC:true,AXILiteUnchanged:true,gmem32:true,
        actualTaskOverlap:true,actualAXIPayloadAndReadReuse:true},
    ipExported:false,xsaGenerated:false,boardMeasured:false,comparisons,identicalInputVectorHashes:vectorEvidence,
    // R6.4: historical reproduction must identify R6.3's frozen source, not current 10.xsa.
    sourceRoot:'archive/pre_R6_4_20261016',
    sources:Object.fromEntries(['src/yolov5n_top.cpp','src/yolov5n_hls.h','src/yolov5n_r6_3_schedule.h',
        'src/tb_yolov5n_r6_3.cpp','tools/verify_r6_3.js'].map(p=>[p,
            hash(path.join(root,'archive/pre_R6_4_20261016',p))]))};
fs.writeFileSync(path.join(project,'r6_3_summary.json'),JSON.stringify(summary,null,2)+'\n');
fs.writeFileSync(path.join(project,'r6_3_event_trace.json'),JSON.stringify(actual,null,2)+'\n');
fs.writeFileSync(path.join(reference,'r6_3_reference_trace.json'),JSON.stringify(old,null,2)+'\n');
console.log(JSON.stringify(summary,null,2));
