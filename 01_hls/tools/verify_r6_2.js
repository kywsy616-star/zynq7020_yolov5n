// Verify R6.2 numeric runs, unchanged math/ABI, actual sampled RTL events and
// AXI write bursts. Compare against frozen R6.1 using the SAME smoke testbench.
const fs = require('fs'), path = require('path'), crypto = require('crypto');
const root = path.resolve(__dirname, '..');
const frozen = path.join(root, 'archive/pre_R6_2_20261015');
const project = path.join(root, 'yolov5n_hls_r6_2_20261015');
const reference = path.join(root, 'yolov5n_hls_r6_2_reference_20261015');
const read = p => fs.readFileSync(p, 'utf8').replaceAll('\r\n', '\n');
const hash = p => crypto.createHash('sha256').update(fs.readFileSync(p)).digest('hex');
const check = (ok, why) => { if (!ok) throw new Error(why); };
const strip = s => s.replace(/\/\*[\s\S]*?\*\//g, '').replace(/\/\/[^\n]*/g, '').replace(/\s+/g, '');
// R6.3: verify the frozen R6.2 implementation, not the new live src.
const r62Source = path.join(root, 'archive/pre_R6_3_20261016');
const now = read(path.join(r62Source, 'yolov5n_top.cpp'));
const old = read(path.join(frozen, 'yolov5n_top.cpp'));
const newHeader = read(path.join(r62Source, 'yolov5n_hls.h'));
const oldHeader = read(path.join(frozen, 'yolov5n_hls.h'));
for (const name of ['HW_CO', 'HW_CI', 'HW_NX', 'HW_IFM_WORDS', 'HW_WGT_BYTES', 'HW_MAX_OC', 'HW_N_OPS', 'HW_DESC_WORDS']) {
    const macro = new RegExp(`^#define\\s+${name}\\s+(\\d+)`, 'm');
    check(newHeader.match(macro)[1] === oldHeader.match(macro)[1], 'Hardware constant changed: ' + name);
}
const region = (s, a, b) => s.slice(s.indexOf(a), s.indexOf(b, s.indexOf(a)));
for (const [a, b] of [['const int ob_offset =', '/* ---- 4.5'],
    ['uint32_t word = 0;', '// 结果先存片上'],
    ['static void copy_op(', '/* ------------------------------------------------------------------- pool'],
    ['static void pool_op(', '/* ------------------------------------------------------------------- conv']])
    check(strip(region(now, a, b)) === strip(region(old, a, b)), 'Math/helper changed: ' + a);
for (const item of JSON.parse(read(path.join(frozen, 'manifest.json')).replace(/^\uFEFF/, '')))
    check(hash(path.join(frozen, path.basename(item.path))) === item.sha256, 'Frozen baseline changed: ' + item.path);
check(read(path.join(project, 'solution1/csim/report/yolov5n_top_csim.log')).includes('R6.2 REGRESSION PASS'), 'Full Csim failed');
for (const p of ['r6_2_cosim_20261015.log', 'r6_2_reference_20261015.log'])
    check(read(path.join(root, p)).includes('C/RTL co-simulation finished: PASS'), 'RTL cosim failed: ' + p);

const rtlDir = path.join(project, 'solution1/syn/verilog');
const top = read(path.join(rtlDir, 'yolov5n_top.v'));
const conv = read(path.join(rtlDir, 'yolov5n_top_conv_kernel.v'));
check(/C_M_AXI_GMEM_DATA_WIDTH = 32/.test(top), 'gmem width changed');
check(/output\s+\[15:0\] profile_event_o;/.test(top) && /output\s+profile_event_o_ap_vld;/.test(top), 'Marker outputs changed');
check(!/profile_event_i_ap_vld|profile_event.*ap_ack|profile_event.*ap_ready/.test(top + conv), 'Input handshake introduced');
check((conv.match(/\bprofile_event_i\b/g) || []).length === 2, 'Dummy marker input used');
const addresses = s => [...s.matchAll(/ADDR_\w+\s*=\s*7'h[0-9a-f]+/g)].map(m => m[0]);
const control = 'yolov5n_top_control_s_axi.v';
check(JSON.stringify(addresses(read(path.join(rtlDir, control)))) === JSON.stringify(addresses(read(
    path.join(root, 'yolov5n_hls_r6_1_20261015/solution1/syn/verilog', control)))), 'AXI-Lite map changed');
const xml = read(path.join(project, 'solution1/syn/report/yolov5n_top_csynth.xml'));
const convXml = read(path.join(project, 'solution1/syn/report/conv_kernel_csynth.xml'));
for (const name of ['MAC_PIXELS', 'OUTPUT_ROW_WRITE', 'STAGE_VALID', 'RESIDUAL_READ'])
    check(new RegExp(`<[^>]*${name}>\\s*[\\s\\S]*?<PipelineII>1</PipelineII>`).test(convXml), 'II != 1: ' + name);
check(read(path.join(root, 'r6_2_csynth_20261015.log')).includes("loop 'OUTPUT_ROW_WRITE'"), 'Output loop absent');
const area = xml.match(/<Resources>([\s\S]*?)<\/Resources>/)[1];
const resources = Object.fromEntries([...area.matchAll(/<(\w+)>(\d+)<\/\1>/g)].map(m => [m[1], +m[2]]));

function waveform(projectDir) {
    const file = path.join(projectDir, 'solution1/sim/verilog/r6_2_events.vcd');
    const vcd = read(file), ids = {}, state = {}, events = [], aw = [], ar = [], w = [], b = [];
    check(/\$timescale\s+1ps\s+\$end/.test(vcd), 'Unexpected VCD units');
    for (const m of vcd.matchAll(/\$var\s+\w+\s+\d+\s+(\S+)\s+(\w+)/g)) ids[m[2]] = m[1];
    for (const key of ['ap_clk', 'profile_event_o', 'profile_event_o_ap_vld', 'm_axi_gmem_AWLEN',
        'm_axi_gmem_AWVALID', 'm_axi_gmem_AWREADY', 'm_axi_gmem_WVALID', 'm_axi_gmem_WREADY', 'm_axi_gmem_WLAST'])
        check(ids[key], 'Missing VCD signal: ' + key);
    let time = 0, changes = [];
    function flush() {
        const prior = {...state};
        for (const [id, val] of changes) state[id] = val;
        if (prior[ids.ap_clk] === '0' && state[ids.ap_clk] === '1') {
            const cycle = time / 10000;
            const bit = name => prior[ids[name]] === '1';
            const num = name => {
                const val = prior[ids[name]];
                check(val && /^[01]+$/.test(val), 'Unknown sampled signal: ' + name);
                return parseInt(val, 2);
            };
            if (bit('profile_event_o_ap_vld')) {
                const value = num('profile_event_o');
                events.push({cycle, value, op: value >>> 8, phase: value & 255});
            }
            for (const [ch, list] of [['AW', aw], ['AR', ar]])
                if (bit(`m_axi_gmem_${ch}VALID`) && bit(`m_axi_gmem_${ch}READY`))
                    list.push({cycle, words: num(`m_axi_gmem_${ch}LEN`) + 1,
                        ...(ch === 'AW' ? {address: num('m_axi_gmem_AWADDR')} : {})});
            if (bit('m_axi_gmem_WVALID') && bit('m_axi_gmem_WREADY'))
                w.push({cycle, last: bit('m_axi_gmem_WLAST')});
            if (bit('m_axi_gmem_BVALID') && bit('m_axi_gmem_BREADY')) b.push({cycle});
        }
        changes = [];
    }
    for (const line of vcd.split('\n')) {
        if (line.startsWith('#')) { flush(); time = +line.slice(1); }
        else if (/^b[01xz]+\s/.test(line)) { const [val, id] = line.split(/\s+/); changes.push([id, val.slice(1)]); }
        else if (/^[01xz]\S+$/.test(line)) changes.push([line.slice(1), line[0]]);
    }
    flush();
    check(aw.reduce((s, t) => s + t.words, 0) === w.length, 'AW/W total payload mismatch');
    check(aw.length === w.filter(t => t.last).length && aw.length === b.length, 'AW/WLAST/B transaction mismatch');
    const calls = [];
    let current;
    for (let i = 0; i < events.length; i++) {
        const e = events[i];
        if (e.value === 0xff00) current = {beginCycle: e.cycle, eventCount: 0, phases: {}, phaseCycles: {}};
        check(current, 'Event outside call');
        current.eventCount++;
        current.phases[e.phase] = (current.phases[e.phase] || 0) + 1;
        if (e.op !== 255) current.op = e.op;
        if (e.phase !== 15 && e.phase !== 14 && e.op !== 255)
            current.phaseCycles[e.phase] = (current.phaseCycles[e.phase] || 0) + events[i + 1].cycle - e.cycle;
        if (e.value === 0xff0f) {
            current.endCycle = e.cycle;
            current.callCycles = e.cycle - current.beginCycle;
            const a = aw.filter(t => t.cycle >= current.beginCycle && t.cycle <= current.endCycle);
            current.writeBursts = a.length;
            current.writeWords = a.reduce((s, t) => s + t.words, 0);
            current.writeLengthHistogram = {};
            for (const t of a) current.writeLengthHistogram[t.words] = (current.writeLengthHistogram[t.words] || 0) + 1;
            current.writeAddressTransactions = a;
            current.readBursts = ar.filter(t => t.cycle >= current.beginCycle && t.cycle <= current.endCycle).length;
            calls.push(current); current = null;
        }
    }
    return {file: path.relative(root, file), sha256: hash(file), events, calls,
        totalWriteBursts: aw.length, totalWriteWords: w.length, allWriteResponsesComplete: true};
}
const cases = [{op: 0, oh: 2, ow: 65, tr: 2, ocb: 2, residual: false, name: 'synthetic 2x65 1x1 4->24, offsets'},
    {op: 3, oh: 3, ow: 35, tr: 3, ocb: 2, residual: true, name: 'synthetic 3x35 3x3 4->24, same-address residual, offsets'}];
function expectedEvents(widen) {
    const out = [];
    for (const d of cases) {
        const push = (...p) => out.push(...p.map(v => d.op * 256 + v));
        out.push(0xff00); push(1, 2, 3, 4);
        const width = widen ? Math.min(d.ow, 64) : 16;
        for (let tr = 0; tr < d.oh; tr += d.tr) for (let tc = 0; tc < d.ow; tc += width) {
            push(5);
            for (let y = 0; y < Math.min(d.tr, d.oh - tr); y++) {
                for (let x0 = 0; x0 < Math.min(width, d.ow - tc); x0 += 16)
                    for (let ob = 0; ob < d.ocb; ob++)
                        if (widen) push(6, 7, ...(d.residual ? [8] : []), 17, 11);
                        else push(6, 7, ...(d.residual ? [8] : []), 9, 10, 11);
                if (widen) push(10, 11);
            }
        }
        push(14); out.push(0xff0f);
    }
    return out;
}
const trace = waveform(project), baselineTrace = waveform(reference);
for (const [data, widened] of [[trace, true], [baselineTrace, false]])
    check(JSON.stringify(data.events.map(e => e.value)) === JSON.stringify(expectedEvents(widened)), 'Actual RTL event order/count mismatch');
const comparisons = cases.map((d, i) => {
    const before = baselineTrace.calls[i], after = trace.calls[i];
    check(before.writeWords === d.oh * d.ow * 6 && after.writeWords === before.writeWords, 'Write payload changed');
    check(after.writeBursts < before.writeBursts && after.callCycles < before.callCycles, 'Smoke case failed to improve');
    check(after.writeLengthHistogram[Math.min(d.ow, 64)] > 0, 'Long write bursts not observed');
    return {test: d.name, baseline: before, r62: after,
        savedCycles: before.callCycles - after.callCycles, savedPercent: (1 - after.callCycles / before.callCycles) * 100};
});

const blob = fs.readFileSync(path.join(root, 'tools/r5_testdata/layers.bin'));
const geometry = [];
let sourceOverlap = false, shiftedResidualOverlap = false;
for (let op = 0; op < 84; op++) {
    const p = op * 64, s = o => blob.readInt16LE(p + o), w = o => blob.readInt32LE(p + o);
    if (blob[p + 55] !== 0) continue;
    const ih = s(28), iw = s(30), oh = s(32), ow = s(34), ic = s(36), oc = s(38), real = s(40);
    const tr = s(46), tc = s(48), k = blob[p + 50], stride = blob[p + 51];
    let width = Math.min(tc, 64);
    const inputRows = (Math.min(tr, oh) - 1) * stride + k;
    if (tc === 16 && ow > tc) for (const c of [64, 32]) {
        const n = Math.min(ow, c);
        if (ic / 4 * inputRows * ((n - 1) * stride + k) <= 13248) { width = n; break; }
    }
    const footprint = ic / 4 * inputRows * ((Math.min(width, ow) - 1) * stride + k);
    check(footprint <= 13248 && real <= 128 && width <= 64, 'Cache capacity exceeded at op' + op);
    const src = w(0) + s(42) * ih * iw, srcEnd = src + ic * ih * iw;
    const dst = w(4) + s(44) * oh * ow, dstEnd = dst + Math.ceil(real / 4) * 4 * oh * ow;
    sourceOverlap ||= src < dstEnd && dst < srcEnd;
    if (w(16) >= 0) {
        const add = w(16) + w(20) * oh * ow, addEnd = add + Math.ceil(real / 4) * 4 * oh * ow;
        shiftedResidualOverlap ||= add < dstEnd && dst < addEnd && add !== dst;
    }
    geometry.push({op, ic, oc, real, oh, ow, tileR: tr, descriptorTileC: tc, physicalTileC: width, ifmWords: footprint,
        oldOutputSegments: oh * Math.ceil(ow / 16) * Math.ceil(real / 4),
        newOutputSegments: oh * Math.ceil(ow / width) * Math.ceil(real / 4)});
}
check(!sourceOverlap && !shiftedResidualOverlap, 'Real model aliases violate row-cache assumptions');
const sourceFiles = ['src/yolov5n_top.cpp', 'src/yolov5n_hls.h', 'src/tb_yolov5n_r6_2.cpp',
    'tools/run_r6_2_csynth.tcl', 'tools/run_r6_2_cosim.tcl', 'tools/run_r6_2_reference.tcl',
    'tools/trace_r6_2_events.tcl', 'tools/verify_r6_2.js'];
const summary = {version: 'R6.2', purpose: 'capacity-checked Conv tiles and per-row output aggregation',
    ipExported: false, xsaGenerated: false, boardMeasured: false,
    targetPart: 'xc7z020-clg400-2', targetClockNs: 10, estimatedClockNs: +xml.match(/<EstimatedClockPeriod>([^<]+)/)[1],
    resources, checks: {fullCsimPass: true, scalarCases: 14, realModelFrames: 2, fullArenaAfterEveryOp: true,
        smallRTLCosimPass: true, identicalInputReferenceCosimPass: true, actualRTLEventSequencePass: true,
        actualAXIBurstsAndPayloadPass: true, mathAndPoolCopyUnchanged: true, axiLiteOffsetsUnchanged: true,
        gmemWidthUnchanged: true, allModelCacheFootprintsFit: true, modelAliasPreconditionsPass: true},
    comparisons, geometry,
    sourceSHA256: Object.fromEntries(sourceFiles.map(p => [p, hash(path.join(root, p))])),
    rtlSHA256: Object.fromEntries(['yolov5n_top.v', 'yolov5n_top_conv_kernel.v', control].map(p => [p, hash(path.join(rtlDir, p))]))};
fs.writeFileSync(path.join(project, 'r6_2_summary.json'), JSON.stringify(summary, null, 2) + '\n');
fs.writeFileSync(path.join(project, 'r6_2_event_trace.json'), JSON.stringify(trace, null, 2) + '\n');
fs.writeFileSync(path.join(reference, 'r6_2_reference_trace.json'), JSON.stringify(baselineTrace, null, 2) + '\n');
console.log(JSON.stringify({checks: summary.checks, resources, comparisons,
    widenedConvOps: geometry.filter(d => d.physicalTileC > d.descriptorTileC).length,
    oldOutputSegments: geometry.reduce((s, d) => s + d.oldOutputSegments, 0),
    newOutputSegments: geometry.reduce((s, d) => s + d.newOutputSegments, 0)}, null, 2));
