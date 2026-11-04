// Freeze the firmware's exact model inputs for C simulation. No firmware edits.
const fs = require('fs'), path = require('path'), crypto = require('crypto');
const root = path.resolve(__dirname, '../..');
const src = path.join(root, '03_vitis/yolov5n_speed/src');
const out = path.join(__dirname, 'r5_testdata');
fs.mkdirSync(out, {recursive: true});
const sha = b => crypto.createHash('sha256').update(b).digest('hex');
const manifest = {};
for (const [file, input] of [['weights.bin', 'weights_speed_blob.c'], ['rqt.bin', 'rqt_speed_blob.c']]) {
  const text = fs.readFileSync(path.join(src, input), 'utf8');
  const body = text.slice(text.indexOf('{') + 1, text.indexOf('}'));
  const data = Buffer.from([...body.matchAll(/0x([0-9a-fA-F]{2})/g)].map(m => parseInt(m[1], 16)));
  if (!data.length) throw new Error('Empty blob: ' + input);
  fs.writeFileSync(path.join(out, file), data);
  manifest[file] = {source: input, bytes: data.length, sha256: sha(data)};
}
const text = fs.readFileSync(path.join(src, 'yolov5n_speed_layers.h'), 'utf8');
const rows = [...text.matchAll(/\/\*\s*(\d+)\s+(\S+)\s*\*\/\s*\{([^}]*)\}/g)];
if (rows.length !== 84) throw new Error('Expected 84 descriptors');
const data = Buffer.alloc(rows.length * 64);
for (let i = 0; i < rows.length; i++) {
  const v = rows[i][3].split(',').map(Number), base = i * 64;
  if (+rows[i][1] !== i || v.length !== 28 || v.some(x => !Number.isFinite(x))) throw new Error('Bad descriptor');
  for (let j = 0; j < 7; j++) data.writeInt32LE(v[j], base + j * 4);
  for (let j = 7; j < 18; j++) data.writeInt16LE(v[j], base + 28 + (j - 7) * 2);
  for (let j = 18; j < 26; j++) data.writeUInt8(v[j], base + 50 + j - 18);
  data.writeInt16LE(v[26], base + 58); data.writeInt32LE(v[27], base + 60);
}
fs.writeFileSync(path.join(out, 'layers.bin'), data);
manifest['layers.bin'] = {source: 'yolov5n_speed_layers.h', bytes: data.length, sha256: sha(data)};
fs.writeFileSync(path.join(out, 'manifest.json'), JSON.stringify(manifest, null, 2) + '\n');
console.log(JSON.stringify(manifest, null, 2));
