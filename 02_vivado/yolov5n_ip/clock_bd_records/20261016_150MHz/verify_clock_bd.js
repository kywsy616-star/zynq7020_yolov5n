// Offline structural audit of the saved BD and the native Vivado validation evidence.
// This script does not edit the design, build hardware, or touch a running app.
const fs = require('fs');
const path = require('path');
const crypto = require('crypto');
const record = __dirname;
const project = path.resolve(record, '../..');
const workspace = path.resolve(project, '../..');
const bdPath = path.join(project, 'yolov5n_ip.srcs/sources_1/bd/zynq/zynq.bd');
const read = p => fs.readFileSync(p, 'utf8').replaceAll('\r\n', '\n');
const before = JSON.parse(read(path.join(record, 'before_zynq.bd'))).design;
const after = JSON.parse(read(bdPath)).design;
function check(ok, message) { if (!ok) throw Error(message); }
function canonical(value) {
  if (Array.isArray(value)) return value.map(canonical);
  if (value && typeof value === 'object') return Object.fromEntries(
    Object.keys(value).sort().map(key => [key, canonical(value[key])])
  );
  return value;
}
const equal = (a, b) => JSON.stringify(canonical(a)) === JSON.stringify(canonical(b));
function netOf(pin) {
  const found = Object.entries(after.nets).filter(([, net]) => net.ports?.includes(pin));
  check(found.length === 1, 'Expected exactly one net for ' + pin);
  return found[0][0];
}
function sameNet(pins) {
  const net = netOf(pins[0]);
  check(pins.every(pin => netOf(pin) === net), 'Net mismatch: ' + pins.join(', '));
  return net;
}
function sameInterface(pins) {
  const matches = Object.entries(after.interface_nets).filter(([, net]) =>
    pins.every(pin => net.interface_ports?.includes(pin)));
  check(matches.length === 1, 'Interface mismatch: ' + pins.join(', '));
  return matches[0][0];
}
const highClockPins = [
  'clk_wiz_hls_150/clk_out1', 'yolov5n_top_10/ap_clk', 'ila_3/clk',
  'c_counter_binary_3/CLK', 'proc_sys_reset_0/slowest_sync_clk',
  'axi_cc_hls_ctrl/m_axi_aclk', 'axi_cc_hls_mem/s_axi_aclk'
];
const highClockNet = sameNet(highClockPins);
const lowClockNet = sameNet([
  'processing_system7_0/FCLK_CLK0', 'clk_wiz_hls_150/clk_in1',
  'axi_cc_hls_ctrl/s_axi_aclk', 'axi_cc_hls_mem/m_axi_aclk',
  'axi_smc_acc/aclk', 'ps7_0_axi_periph/M05_ACLK',
  'processing_system7_0/S_AXI_HP1_ACLK'
]);
check(highClockNet !== lowClockNet, 'The 150 MHz output was shorted to its 100 MHz input');
sameNet(['proc_sys_reset_0/peripheral_aresetn', 'yolov5n_top_10/ap_rst_n',
  'axi_cc_hls_ctrl/m_axi_aresetn', 'axi_cc_hls_mem/s_axi_aresetn']);
sameNet(['rst_ps7_0_100M/peripheral_aresetn',
  'axi_cc_hls_ctrl/s_axi_aresetn', 'axi_cc_hls_mem/m_axi_aresetn']);
sameNet(['processing_system7_0/FCLK_RESET0_N',
  'clk_wiz_hls_150/resetn', 'proc_sys_reset_0/ext_reset_in']);
sameNet(['clk_wiz_hls_150/locked', 'proc_sys_reset_0/dcm_locked']);
sameNet(['hls_reset_zero/dout', 'proc_sys_reset_0/aux_reset_in', 'proc_sys_reset_0/mb_debug_sys_rst']);
const interfaceLinks = [
  ['ps7_0_axi_periph/M05_AXI', 'axi_cc_hls_ctrl/S_AXI'],
  ['axi_cc_hls_ctrl/M_AXI', 'yolov5n_top_10/s_axi_control'],
  ['yolov5n_top_10/m_axi_gmem', 'axi_cc_hls_mem/S_AXI'],
  ['axi_cc_hls_mem/M_AXI', 'axi_smc_acc/S00_AXI'],
  ['axi_smc_acc/M00_AXI', 'processing_system7_0/S_AXI_HP1']
].map(pins => ({pins, net: sameInterface(pins)}));
check(equal(before.addressing, after.addressing), 'Address mapping changed');
check(equal(before.components.processing_system7_0.parameters,
  after.components.processing_system7_0.parameters), 'PS parameters changed');
const electricalShape = port => Object.fromEntries(Object.entries(port).filter(([key]) => key !== 'parameters'));
check(equal(Object.keys(before.interface_ports).sort(), Object.keys(after.interface_ports).sort()),
  'External interface ports changed');
for (const [name, port] of Object.entries(before.interface_ports)) {
  check(equal(electricalShape(port), electricalShape(after.interface_ports[name])),
    'External interface shape changed: ' + name);
  const attached = design => Object.values(design.interface_nets)
    .filter(net => net.interface_ports?.includes(name)).map(net => net.interface_ports.slice().sort());
  check(equal(attached(before), attached(after)), 'External interface connection changed: ' + name);
}
check(equal(Object.keys(before.ports).sort(), Object.keys(after.ports).sort()), 'External ports changed');
for (const [name, port] of Object.entries(before.ports)) {
  // Validation may append inferred clock/reset metadata; electrical port shape is invariant.
  check(equal(electricalShape(port), electricalShape(after.ports[name])), 'External port shape changed: ' + name);
  const attached = design => Object.values(design.nets)
    .filter(net => net.ports?.includes(name)).map(net => net.ports.slice().sort());
  check(equal(attached(before), attached(after)), 'External port connection changed: ' + name);
}
for (const [name, cell] of Object.entries(before.components)) {
  if (name !== 'proc_sys_reset_0') check(equal(cell, after.components[name]), 'Existing IP changed: ' + name);
}
const beforeLow = before.nets.processing_system7_0_FCLK_CLK0.ports;
for (const pin of beforeLow.filter(pin => !highClockPins.includes(pin))) {
  check(netOf(pin) === lowClockNet, 'Existing 100 MHz endpoint moved: ' + pin);
}
const props = read(path.join(record, 'after_properties.txt'));
const clockPins = [...props.matchAll(/^PIN=(\S+) NET=(.*)\nFREQ_HZ=(.*)\nCLK_DOMAIN=(.*)$/gm)]
  .map(m => ({pin: m[1], net: m[2], hz: m[3] ? Number(m[3]) : null, domain: m[4]}));
for (const pin of highClockPins) check(clockPins.find(p => p.pin === pin)?.hz === 150000000,
  'Expected 150 MHz metadata on ' + pin);
check(props.includes('CONFIG.ACLK_ASYNC=1'), 'Missing asynchronous converter configuration');
check(props.includes('CONFIG.C_EXT_RESET_HIGH=0') && props.includes('CONFIG.C_AUX_RESET_HIGH=1'),
  'Reset polarity mismatch');
const validate = read(path.join(record, 'validate_design.log'));
check(validate.includes('TCL_RETURN_CODE=0'), 'Native BD validation failed');
// Preserve only the final validation operation from the native application log.
const appLog = read(path.join(project, 'vivado.log'));
const marker = 'source {D:/02_workspace/02_vitis_projects/yolov5n_speed_prj/02_vivado/yolov5n_ip/' +
  'clock_bd_records/20261016_150MHz/validate_hls_150mhz_bd.tcl}';
const start = appLog.lastIndexOf(marker);
check(start >= 0, 'Final validation invocation not found');
const tail = appLog.slice(start);
const end = tail.indexOf('\nCLOCK_BD_VALIDATE_PASS_AND_SAVED');
check(end >= 0, 'Final validation completion not found');
const excerpt = tail.slice(0, end + '\nCLOCK_BD_VALIDATE_PASS_AND_SAVED'.length) + '\n';
check(!/^ERROR:|^CRITICAL WARNING:/m.test(excerpt), 'Final validation contains errors/critical warnings');
fs.writeFileSync(path.join(record, 'validate_console_excerpt.log'), excerpt);
const warnings = excerpt.split('\n').filter(line => line.startsWith('WARNING:'));
const hlsRoot = path.join(workspace, '01_hls');
const hlsSummary = JSON.parse(read(path.join(hlsRoot, 'yolov5n_hls_r6_4_20261016/r6_4_summary.json')));
const sha256 = file => crypto.createHash('sha256').update(fs.readFileSync(file)).digest('hex');
for (const [file, expected] of Object.entries(hlsSummary.sources)) {
  check(sha256(path.join(hlsRoot, file)) === expected, 'Validated HLS implementation changed: ' + file);
}
const report = {
  validation: 'PASS; native validate_bd_design returned 0',
  validationTime: validate.match(/^DATE=(.*)$/m)[1],
  hardwareBuildPerformed: false, fpgaProgrammed: false,
  highClockNet, highClockHz: 150000000, lowClockNet, lowClockHz: 100000000,
  psParametersUnchanged: true, addressMappingUnchanged: true,
  originalExternalPortShapesAndConnectionsPreserved: true,
  hlsImplementationHashesUnchanged: true,
  addedCells: Object.keys(after.components).filter(name => !before.components[name]),
  interfaceLinks, clockPins, warnings,
  notes: [
    'BD validation is not routed timing closure or board measurement.',
    'FCLK1 remains unused; its actual 142857132 Hz is not the accelerator clock.',
    'Validation appended inferred metadata to some existing external ports.'
  ]
};
fs.writeFileSync(path.join(record, 'connection_audit.json'), JSON.stringify(report, null, 2) + '\n');
fs.copyFileSync(bdPath, path.join(record, 'after_zynq.bd'));
const doc = path.join(project, 'BD_HLS时钟与跨时钟接线记录_20261016.md');
const tracked = [...fs.readdirSync(record).filter(name => name !== 'evidence_manifest.json')
  .map(name => path.join(record, name)), bdPath, doc];
const manifest = tracked.map(file => ({path: path.relative(project, file).replaceAll('\\', '/'),
  bytes: fs.statSync(file).size, sha256: sha256(file)}));
fs.writeFileSync(path.join(record, 'evidence_manifest.json'), JSON.stringify({
  generatedAt: new Date().toISOString(), files: manifest
}, null, 2) + '\n');
console.log(JSON.stringify({validation: report.validation, clockHz: report.highClockHz,
  addressesUnchanged: true, psUnchanged: true, hlsUnchanged: true, warnings, files: manifest.length}, null, 2));
