// Refresh only the trace's internal hierarchy after HLS resynthesis.
const fs = require('fs'), path = require('path');
const root = path.resolve(__dirname, '..');
const rtl = path.join(root, 'yolov5n_hls_r6_3_20261016/solution1/syn/verilog');
const instance = (file, module) => {
    const m = fs.readFileSync(path.join(rtl, file), 'utf8')
        .match(new RegExp(`\\b${module}\\s+(\\w+)\\s*\\(`));
    if (!m) throw Error('Missing module ' + module);
    return m[1];
};
const conv = instance('yolov5n_top.v', 'yolov5n_top_conv_kernel');
const wave = instance('yolov5n_top_conv_kernel.v', 'yolov5n_top_r63_wave');
const file = path.join(__dirname, 'trace_r6_3_events.tcl');
const text = fs.readFileSync(file, 'utf8');
fs.writeFileSync(file, text.replace(/^set wave .*$/m, `set wave $dut/${conv}/${wave}`));
console.log(`Trace hierarchy: ${conv}/${wave}`);
