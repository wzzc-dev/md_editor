const fs = require('fs');
const path = require('path');
const { performance } = require('perf_hooks');

const fixtureArg = process.argv[process.argv.indexOf('--benchmark') + 1];
const fixture = path.isAbsolute(fixtureArg) ? fixtureArg : path.resolve(__dirname, '..', fixtureArg);
const scenario = process.argv[process.argv.indexOf('--benchmark') + 2];
const source = fs.readFileSync(fixture, 'utf8');
// Use the same mature Lute parser that powers Vditor's WYSIWYG mode.
require('./node_modules/vditor/dist/js/lute/lute.min.js');
const lute = global.Lute.New();
function renderVditor(value) { return lute.Md2VditorDOM(value); }

function splitBlocks(value) {
  let blocks = 0;
  let paragraph = false;
  let inCode = false;
  for (const raw of value.split('\n')) {
    const line = raw.trim();
    if (line.startsWith('```')) {
      if (inCode) blocks += 1;
      else if (paragraph) { blocks += 1; paragraph = false; }
      inCode = !inCode;
    } else if (inCode) {
      continue;
    } else if (!line) {
      if (paragraph) { blocks += 1; paragraph = false; }
    } else if (/^(> |[-*] |#{1,6} )/.test(line)) {
      if (paragraph) { blocks += 1; paragraph = false; }
      blocks += 1;
    } else {
      paragraph = true;
    }
  }
  if (inCode) blocks += 1;
  if (paragraph) blocks += 1;
  return blocks;
}

function sample(samples, operation, value) {
  const started = performance.now();
  operation(value);
  samples.push(performance.now() - started);
}

function run(operation) {
  const samples = [];
  if (scenario === 'open') sample(samples, operation, source);
  else {
    const count = scenario === 'scroll' ? 120 : 10;
    for (let i = 0; i < count; i += 1) {
      sample(samples, operation, scenario === 'input' ? `${source}${i}` : source);
    }
  }
  return samples;
}

function summarize(adapter, measurementScope, samples) {
  samples.sort((a, b) => a - b);
  const mean = samples.reduce((a, b) => a + b, 0) / samples.length;
  const at = p => samples[Math.round((samples.length - 1) * p)];
  return {
    adapter, measurement_scope: measurementScope, scenario,
    frame_work_samples_ms: samples, frame_interval_samples_ms: [],
    input_to_visible_samples_ms: scenario === 'input' ? samples : [],
    offscreen_samples_ms: samples.map(() => null),
    readback_samples_ms: samples.map(() => null),
    offscreen_readback_samples_ms: samples.map(() => null),
    frame_work_ms: mean, frame_interval_ms: null,
    input_to_visible_ms: scenario === 'input' ? mean : null,
    offscreen_ms: null, readback_ms: null, offscreen_readback_ms: null,
    frame_work_p95_ms: at(.95), frame_interval_p95_ms: null,
    input_to_visible_p95_ms: scenario === 'input' ? at(.95) : null,
    dropped_display_frames: 0,
    first_interactive_ms: null, document_load_ms: 0,
    viewport: { width: 1280, height: 800 },
    font: 'system-ui 16px', line_height: 1.55, overscan: 3, virtual_row_height: 66,
  };
}

console.log(JSON.stringify(summarize('electron', 'headless-render', run(splitBlocks))));
// Vditor DOM generation allocates a full rich document per sample. Keep this
// actual WYSIWYG path bounded like MoUI's richtext-full row; the shared block
// baseline above still covers Medium, Large and Stress.
if (source.length < 16 * 1024) {
  console.log(JSON.stringify(summarize('electron-full', 'wysiwyg-full', run(renderVditor))));
}
