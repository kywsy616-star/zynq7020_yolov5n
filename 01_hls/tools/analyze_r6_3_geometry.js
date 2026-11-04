// R6.3: descriptor geometry and DDR word budget, not a board timing predictor.
const fs = require('fs'), path = require('path');
const root = path.resolve(__dirname, '..');
const blob = fs.readFileSync(path.join(root, 'tools/r5_testdata/layers.bin'));
const ops = [];
for (let op = 0; op < 84; ++op) {
    const d = Array.from({length: 16}, (_, j) => blob.readInt32LE(op * 64 + j * 4));
    const type = d[13] >>> 24;
    if (type !== 0) continue; // LT_CONV=0; Pool/Copy retain their original code.
    const ih = d[7] & 65535, iw = d[7] >>> 16;
    const oh = d[8] & 65535, ow = d[8] >>> 16;
    const ic = d[9] & 65535, oc = d[9] >>> 16, real = d[10] & 65535;
    const tr = d[11] >>> 16, tc = d[12] & 65535;
    const k = (d[12] >>> 16) & 255, s = d[12] >>> 24, pad = d[13] & 255;
    const icb = ic / 4, ocb = oc / 16;
    let width = Math.min(tc, 64);
    if (tc === 16 && ow > tc) {
        const rows = (Math.min(tr, oh) - 1) * s + k;
        for (const candidate of [Math.min(ow, 64), Math.min(ow, 32)])
            if (icb * rows * ((candidate - 1) * s + k) <= 13248) { width = candidate; break; }
    }
    let beforeWords = 0, afterWords = 0, reusedWords = 0, tiles = 0, blocks = 0;
    let initialRows = 0, prefetchedRows = 0, drainRows = 0;
    const tileList = [];
    for (let y = 0; y < oh; y += tr) for (let x = 0; x < ow; x += width) {
        const nr = Math.min(tr, oh - y), nc = Math.min(width, ow - x);
        const rows = (nr - 1) * s + k, cols = (nc - 1) * s + k;
        if (rows * cols * icb > 13248) throw Error(`IFM overflow op${op}`);
        const overlap = Math.max(k - s, 0);
        const keep = x > 0 && overlap <= 2 && rows * icb * overlap <= 2048 ? overlap : 0;
        for (let r = 0; r < rows; ++r) {
            const sy = y * s - pad + r;
            if (sy < 0 || sy >= ih) continue;
            for (let col = 0; col < cols; ++col) {
                const sx = x * s - pad + col;
                if (sx < 0 || sx >= iw) continue;
                beforeWords += icb;
                if (col < keep) reusedWords += icb;
                else afterWords += icb;
            }
        }
        const n = nr * Math.ceil(nc / 16) * ocb;
        tileList.push({rows: icb * rows, blocks: n});
        blocks += n; tiles++;
    }
    initialRows = tileList[0].rows;
    for (let i = 0; i + 1 < tileList.length; ++i) {
        const n = tileList[i].blocks, nextRows = tileList[i + 1].rows;
        let q = 1;
        for (const candidate of [2, 4, 8, 16]) if (nextRows > n * (candidate / 2)) q = candidate;
        prefetchedRows += Math.min(nextRows, n * q);
        drainRows += Math.max(0, nextRows - (n + 2) * q);
    }
    if (beforeWords !== afterWords + reusedWords) throw Error('Read budget mismatch');
    ops.push({op, k, s, ih, iw, oh, ow, ic, oc, real, descriptorWidth: tc,
        internalWidth: width, tiles, blocks, beforeWords, afterWords, reusedWords,
        initialRows, prefetchedRows, drainRows});
}
const sum = key => ops.reduce((n, op) => n + op[key], 0);
const result = {version: 'R6.3 / 9.xsa', kind: 'geometry, not measured bus traffic',
    convCount: ops.length, beforeWords: sum('beforeWords'), afterWords: sum('afterWords'),
    reusedWords: sum('reusedWords'), savedBytes: sum('reusedWords') * 4,
    initialRows: sum('initialRows'), prefetchedRows: sum('prefetchedRows'),
    drainRows: sum('drainRows'), ops};
fs.mkdirSync(path.join(root, 'yolov5n_hls_r6_3_20261016'), {recursive: true});
fs.writeFileSync(path.join(root, 'yolov5n_hls_r6_3_20261016/r6_3_geometry.json'),
    JSON.stringify(result, null, 2) + '\n');
console.log(JSON.stringify({...result, ops: undefined}));
