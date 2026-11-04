// Verify the measurement contract against generated RTL and sampled waveforms.
// Run after csynth, cosim and trace_r6_1_events.tcl; no source mutation.
const fs = require('fs');
const path = require('path');
const crypto = require('crypto');
const root = path.resolve(__dirname, '..');
const project = path.join(root, 'yolov5n_hls_r6_1_20261015');
const baseline = path.join(root, 'archive/pre_R6_1_20261015');
const frozenR61 = path.join(root, 'archive/pre_R6_2_20261015');
const read = p => fs.readFileSync(p, 'utf8').replaceAll('\r\n', '\n');
const hash = p => crypto.createHash('sha256').update(fs.readFileSync(p)).digest('hex');
const check = (ok, why) => { if (!ok) throw new Error(why); };
const rtlDir = path.join(project, 'solution1/syn/verilog');
const top = read(path.join(rtlDir, 'yolov5n_top.v'));
const conv = read(path.join(rtlDir, 'yolov5n_top_conv_kernel.v'));
check(/output\s+\[15:0\] profile_event_o;/.test(top), 'Missing event output');
check(/output\s+profile_event_o_ap_vld;/.test(top), 'Missing output valid');
check(!/profile_event_i_ap_vld|profile_event.*ap_ack|profile_event.*ap_ready/.test(top + conv), 'Marker has an input handshake');
check((conv.match(/\bprofile_event_i\b/g) || []).length === 2, 'Dummy input participates in conv logic');
for (let phase = 3; phase <= 11; phase++)
    check(new RegExp(`assign or_.*= .*\\| 16'd${phase}\\);`).test(conv), `Missing conv phase ${phase}`);

// The unmodified datapath, loops, accesses and pragmas must be recoverable.
let source = read(path.join(frozenR61, 'yolov5n_top.cpp'));
let restored = source.replace(/\/\* Volatile keeps[\s\S]*?\n}\n\n/, '')
    .replace('int tile_r, int tile_c,\n                        int profile_op, volatile uint16_t *profile_event)', 'int tile_r, int tile_c)')
    .replace('int n_ops,\n                 volatile uint16_t *profile_event)', 'int n_ops)')
    .replace(/^.*profile_mark\(.*\n/gm, '')
    .replace(/^.*#pragma HLS INTERFACE ap_ovld port=profile_event\n/gm, '')
    .replace('            if (bad) {\n                continue;\n            }', '            if (bad) continue;')
    .replaceAll('tile_r, tile_c, op, profile_event);', 'tile_r, tile_c);');
const strip = s => s.replace(/\/\*[\s\S]*?\*\//g, '').replace(/\/\/[^\n]*/g, '').replace(/\s+/g, '');
check(strip(restored) === strip(read(path.join(baseline, 'yolov5n_top.cpp'))), 'Non-marker algorithm/access change');
const macros = s => [...s.matchAll(/^#define\s+\w+[^\n]*/gm)].map(m => m[0]);
check(JSON.stringify(macros(read(path.join(frozenR61, 'yolov5n_hls.h')))) ===
      JSON.stringify(macros(read(path.join(baseline, 'yolov5n_hls.h')))), 'Hardware/model macros changed');
const addresses = s => [...s.matchAll(/ADDR_\w+\s*=\s*7'h[0-9a-f]+/g)].map(m => m[0]);
const control = 'yolov5n_top_control_s_axi.v';
const currentAddresses = addresses(read(path.join(rtlDir, control)));
const baselineAddresses = addresses(read(path.join(root,
    'yolov5n_hls_r5_20261015/solution1/syn/verilog', control)));
check(JSON.stringify(currentAddresses) === JSON.stringify(baselineAddresses), 'AXI-Lite offsets changed');

const csim = read(path.join(project, 'solution1/csim/report/yolov5n_top_csim.log'));
check(csim.includes('R6.1 REGRESSION PASS'), 'Full Csim regression did not pass');
check(read(path.join(root, 'r6_1_cosim_20261015.log')).includes('C/RTL co-simulation finished: PASS'), 'RTL cosim did not pass');

// VCD changes at an active edge include the next FSM state's combinational
// outputs. A synchronous receiver samples the PRE-edge settled values.
const vcdPath = path.join(project, 'solution1/sim/verilog/r6_1_events.vcd');
const vcd = read(vcdPath);
check(/\$timescale\s+1ps\s+\$end/.test(vcd), 'Unexpected VCD time unit');
const ids = {};
for (const m of vcd.matchAll(/\$var\s+\w+\s+\d+\s+(\S+)\s+(\w+)/g)) ids[m[2]] = m[1];
const state = {}, events = [];
let stamp = 0, changes = [];
function flush() {
    const prior = {...state};
    for (const [id, val] of changes) state[id] = val;
    if (prior[ids.ap_clk] === '0' && state[ids.ap_clk] === '1' && prior[ids.profile_event_o_ap_vld] === '1') {
        const bits = prior[ids.profile_event_o];
        check(bits && /^[01]+$/.test(bits), 'Unknown event at sampling edge');
        const value = parseInt(bits, 2);
        events.push({cycle: stamp / 10000, op: value >>> 8, phase: value & 255, value});
    }
    changes = [];
}
for (const line of vcd.split('\n')) {
    if (line.startsWith('#')) { flush(); stamp = Number(line.slice(1)); }
    else if (/^b[01xz]+\s/.test(line)) { const [val, id] = line.split(/\s+/); changes.push([id, val.slice(1)]); }
    else if (/^[01xz]\S+$/.test(line)) changes.push([line.slice(1), line[0]]);
}
flush();
const expected = [];
for (const [op, rows, residual] of [[0, 4, false], [3, 3, true]]) {
    expected.push(0xff00, ...[1, 2, 3, 4, 5].map(p => op * 256 + p));
    for (let row = 0; row < rows; row++)
        expected.push(...[6, 7, ...(residual ? [8] : []), 9, 10, 11].map(p => op * 256 + p));
    expected.push(op * 256 + 14, 0xff0f);
}
check(JSON.stringify(events.map(e => e.value)) === JSON.stringify(expected),
      'RTL event order/count mismatch: ' + JSON.stringify(events.map(e => e.value.toString(16))));
const traces = [];
let current;
for (let i = 0; i < events.length; i++) {
    const e = events[i];
    if (e.phase === 0 && e.op === 255) current = {op: events[i + 1].op, eventCount: 0, phaseCycles: {}};
    current.eventCount++;
    if (e.phase !== 15 && e.phase !== 14 && e.op !== 255) {
        const cycles = events[i + 1].cycle - e.cycle;
        current.phaseCycles[e.phase] = (current.phaseCycles[e.phase] || 0) + cycles;
    }
    if (e.phase === 14) current.opEndToNextEventCycles = events[i + 1].cycle - e.cycle;
    if (e.phase === 15) traces.push(current);
}
traces[0].testCase = 'synthetic 4x4 1x1, descriptor slot 0; not real model op0';
traces[1].testCase = 'synthetic 3x5 3x3 residual, descriptor slot 3; not real model op3';
const xml = read(path.join(project, 'solution1/syn/report/yolov5n_top_csynth.xml'));
const area = xml.match(/<Resources>([\s\S]*?)<\/Resources>/)[1];
const resources = Object.fromEntries([...area.matchAll(/<(\w+)>(\d+)<\/\1>/g)].map(m => [m[1], Number(m[2])]));
const convXML = read(path.join(project, 'solution1/syn/report/conv_kernel_csynth.xml'));
check(/<[^>]*MAC_PIXELS>\s*[\s\S]*?<PipelineII>1<\/PipelineII>/.test(convXML), 'MAC II is no longer 1');
const sourceFiles = ['src/yolov5n_top.cpp', 'src/yolov5n_hls.h', 'src/tb_yolov5n_r6_1.cpp', 'src/tb_r5_reference.cpp',
    'tools/run_r6_1_csynth.tcl', 'tools/run_r6_1_cosim.tcl', 'tools/trace_r6_1_events.tcl', 'tools/verify_r6_1.js'];
const rtlFiles = ['yolov5n_top.v', 'yolov5n_top_conv_kernel.v', control];
const summary = {
    version: 'R6.1', purpose: 'measurement markers only; no acceleration claim', futureXsa: 'yolov5n_speed_wrapper_7_1.xsa',
    xsaGenerated: false, boardMeasured: false, targetPart: 'xc7z020-clg400-2', targetClockNs: 10,
    estimatedClockNs: Number(xml.match(/<EstimatedClockPeriod>([^<]+)/)[1]), resources, macII: 1,
    checks: {R5DatapathUnchanged: true, macrosUnchanged: true, axiLiteOffsetsUnchanged: true,
        fullCsimPass: true, smallRTLCosimPass: true, actualRTLEventSequencePass: true},
    markerInterface: {mode: 'ap_ovld', inputTieZero: 'profile_event_i[15:0]',
        dataOut: 'profile_event_o[15:0]', validOut: 'profile_event_o_ap_vld', inputHandshake: false},
    smallRTLTraces: traces, totalTraceEvents: events.length,
    sourceSHA256: Object.fromEntries(sourceFiles.map(p => [p, hash(
        ['src/yolov5n_top.cpp', 'src/yolov5n_hls.h', 'src/tb_yolov5n_r6_1.cpp'].includes(p)
            ? path.join(frozenR61, path.basename(p)) : path.join(root, p))])),
    rtlSHA256: Object.fromEntries(rtlFiles.map(p => [p, hash(path.join(rtlDir, p))]))
};
fs.writeFileSync(path.join(project, 'r6_1_summary.json'), JSON.stringify(summary, null, 2) + '\n');
fs.writeFileSync(path.join(project, 'r6_1_event_trace.json'), JSON.stringify(events, null, 2) + '\n');
console.log(JSON.stringify({checks: summary.checks, resources, traces, totalEvents: events.length}, null, 2));
