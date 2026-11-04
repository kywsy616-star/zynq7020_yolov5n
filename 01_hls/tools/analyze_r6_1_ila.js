// Recompute the R6.1 board capture. No HLS, Vivado or Vitis source mutation.
const fs = require('fs'), path = require('path'), crypto = require('crypto');
const root = path.resolve(__dirname, '..');
const dir = path.join(root, 'measurements/R6_1_ILA_20261015_recapture_01');
const sha = p => crypto.createHash('sha256').update(fs.readFileSync(p)).digest('hex');
const assert = (ok, why) => { if (!ok) throw new Error(why); };
const rows = fs.readFileSync(path.join(dir, 'waveform.csv'), 'utf8').trim().split(/\r?\n/).slice(2);
const events = rows.map(row => {
    const v = row.split(',');
    const event = parseInt(v[3], 16);
    return {sample: +v[0], trigger: +v[2], event, op: event >>> 8,
        phase: event & 255, valid: parseInt(v[4], 16), ticks: BigInt('0x' + v[5])};
});
assert(events.length === 1024 && events.every(e => e.op === 0 && e.valid === 1), 'Unexpected capture');
const stages = {};
for (let i = 0; i + 1 < events.length; i++) {
    const phase = events[i].phase, n = Number(events[i + 1].ticks - events[i].ticks);
    assert(n > 0, 'Non-monotonic timestamps');
    (stages[phase] ||= []).push(n);
}
const totalCycles = Number(events.at(-1).ticks - events[0].ticks);
const stats = Object.fromEntries(Object.entries(stages).map(([phase, a]) => {
    const cycles = a.reduce((s, n) => s + n, 0);
    return [phase, {count: a.length, cycles, meanCycles: cycles / a.length,
        minCycles: Math.min(...a), maxCycles: Math.max(...a), us: cycles / 100,
        percent: cycles / totalCycles * 100}];
}));
let blocks = 0;
for (let i = 0; i + 4 < events.length; i++)
    if ([6, 7, 9, 10, 11].every((p, j) => events[i + j].phase === p)) blocks++;
const b = fs.readFileSync(path.join(root, 'tools/r5_testdata/layers.bin'));
const d = {ih: b.readInt16LE(28), iw: b.readInt16LE(30), oh: b.readInt16LE(32), ow: b.readInt16LE(34),
    ic: b.readInt16LE(36), oc: b.readInt16LE(38), tileR: b.readInt16LE(46), tileC: b.readInt16LE(48),
    k: b[50], s: b[51]};
const tileCount = Math.ceil(d.oh / d.tileR) * Math.ceil(d.ow / d.tileC);
const blockCount = d.oh * Math.ceil(d.ow / 16) * (d.oc / 16);
const predictedStageMs = {};
for (const p of [1, 2, 3, 4]) predictedStageMs[p] = stats[p].meanCycles / 100000;
predictedStageMs[5] = stats[5].meanCycles * tileCount / 100000;
for (const p of [6, 7, 9, 10, 11]) predictedStageMs[p] = stats[p].meanCycles * blockCount / 100000;
const predictedOpMs = Object.values(predictedStageMs).reduce((s, n) => s + n, 0);
const baselineOpMs = 18.816, baselineNetworkMs = 237.185;
const result = {
    source: 'R6.1 board event capture; only op0 prefix; NOT a complete-op measurement',
    clockHz: 100000000, validEvents: events.length, totalCycles, totalMs: totalCycles / 100000,
    firstEvent: events[0].event, lastEvent: events.at(-1).event,
    completeOp: events.some(e => e.phase === 14), completeBlockSequences: blocks, stats,
    descriptor: d, tileCount, blockCount, predictedStageMs, predictedOpMs,
    baselineOpMs, differencePercent: (predictedOpMs / baselineOpMs - 1) * 100,
    rgbMAC: d.oh * d.ow * d.oc * 3 * d.k * d.k,
    paddedMAC: d.oh * d.ow * d.oc * d.ic * d.k * d.k,
    macIdealMs: d.oh * d.ow * d.oc * d.ic * d.k * d.k / 6400000,
    macRegionExtraMs: (stats[7].meanCycles - 16 * d.k * d.k * d.ic / 4) * blockCount / 100000,
    fpsOnlyOp0Changed: [12, 10, baselineOpMs / 2].map(opMs => ({opMs,
        networkMs: baselineNetworkMs - baselineOpMs + opMs,
        fps: 1000 / (baselineNetworkMs - baselineOpMs + opMs)})),
    caveats: ['First 13 input tiles at top edge; final MAC interval is censored.',
        'Scheduled marker intervals are not AXI completion fences or pure DDR stall counters.',
        'R5 CPU profile and R6.1 capture can differ in runtime DDR contention.'],
    files: Object.fromEntries(['waveform.csv', 'capture.ila', 'analysis.json', 'events_decoded.json'].map(p => [p, sha(path.join(dir, p))]))
};
assert(blocks === 201 && totalCycles === 124048 && tileCount === 192 && blockCount === 3072, 'Capture/model mismatch');
fs.writeFileSync(path.join(dir, 'analysis_calculations.json'), JSON.stringify(result, null, 2) + '\n');
console.log(JSON.stringify(result, null, 2));
