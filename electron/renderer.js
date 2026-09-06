const status = document.getElementById('status');
const fileLabel = document.getElementById('file');
const metrics = document.getElementById('metrics');
const viewport = document.getElementById('editor');
const spacer = document.getElementById('virtual-spacer');
const rows = document.getElementById('visible-blocks');
const lute = Lute.New();

const ROW_HEIGHT = 66;
const OVERSCAN = 3;
const sample = '# Electron Markdown Editor\n\nEdit **Markdown** directly in the formatted document.\n\n- Open a .md file\n- Type normally\n- Scroll the document\n\n> The saved value is always Markdown source.\n';

let filePath = null;
let saved = '';
let blocks = [];
let characterCount = 0;
let dirty = false;
let activeIndex = 0;
let vditor = null;
let editorReady = Promise.resolve();
let renderScheduled = false;
let benchmarkMode = false;
const rowElements = new Map();

const blockPattern = /^(?:> |[-*] |#{1,6}\s)/;

function splitDocument(source) {
  const result = [];
  let current = [];
  let inCode = false;
  function flush() {
    if (current.length) result.push(current.join('\n'));
    current = [];
  }
  // Scan line boundaries directly. A 5MB stress document contains 100k
  // lines; avoiding source.split() keeps the transient line array out of the
  // startup path while preserving the existing block semantics.
  for (let lineStart = 0; lineStart <= source.length;) {
    const newline = source.indexOf('\n', lineStart);
    const lineEnd = newline < 0 ? source.length : newline;
    const line = source.slice(lineStart, lineEnd);
    const value = line.trim();
    if (value.startsWith('```')) {
      if (!inCode) flush();
      current.push(line);
      inCode = !inCode;
      if (!inCode) flush();
    } else if (inCode) {
      current.push(line);
    } else if (!value) {
      flush();
    } else if (blockPattern.test(value)) {
      flush();
      result.push(line);
    } else {
      current.push(line);
    }
    if (newline < 0) break;
    lineStart = newline + 1;
  }
  flush();
  return result.length ? result : [''];
}

function serializeDocument() {
  return `${blocks.join('\n\n')}\n`;
}

function renderStatus() {
  status.textContent = dirty ? 'Unsaved changes' : 'Saved';
  metrics.textContent = `${characterCount} chars | ${blocks.length} blocks | Electron Vditor WYSIWYG | 1280x800`;
}

function updateBlock(index, value) {
  if (blocks[index] === value) return;
  characterCount += value.length - blocks[index].length;
  blocks[index] = value;
  dirty = true;
  renderStatus();
}

function rowTop(index) {
  return `${index * ROW_HEIGHT}px`;
}

function removeRow(index) {
  const row = rowElements.get(index);
  if (!row) return;
  row.remove();
  rowElements.delete(index);
}

function previewRow(index) {
  const row = document.createElement('div');
  row.className = 'block-row preview';
  row.style.top = rowTop(index);
  row.dataset.index = String(index);
  const content = document.createElement('div');
  content.className = 'block-content vditor-reset';
  content.innerHTML = lute.Md2HTML(blocks[index]);
  row.appendChild(content);
  row.addEventListener('click', () => activateBlock(index));
  rows.appendChild(row);
  rowElements.set(index, row);
}

function activeRow(index) {
  const row = document.createElement('div');
  row.className = 'block-row active';
  row.style.top = rowTop(index);
  row.dataset.index = String(index);
  const host = document.createElement('div');
  row.appendChild(host);
  rows.appendChild(row);
  rowElements.set(index, row);

  editorReady = new Promise(resolve => {
    const mount = () => {
      if (!row.isConnected || rowElements.get(index) !== row) {
        resolve();
        return;
      }
      const instance = new Vditor(host, {
        mode: 'wysiwyg',
        value: blocks[index],
        cdn: './node_modules/vditor',
        minHeight: 50,
        height: 50,
        toolbar: [],
        cache: { enable: false },
        preview: { markdown: { toc: false, mark: true } },
        input(value) { updateBlock(index, value); },
        after() {
          vditor = instance;
          resolve();
        },
      });
    };
    if (benchmarkMode) {
      // Let the lightweight first frame become visible before Vditor creates
      // its editor DOM and performs its initial Markdown conversion.
      requestAnimationFrame(() => requestAnimationFrame(mount));
    } else {
      mount();
    }
  });
}

function renderVisibleRows() {
  const visibleRows = Math.ceil((viewport.clientHeight || 650) / ROW_HEIGHT);
  const first = Math.max(0, Math.floor(viewport.scrollTop / ROW_HEIGHT) - OVERSCAN);
  const last = Math.min(blocks.length, first + visibleRows + OVERSCAN * 2);
  const wanted = new Set([activeIndex]);
  for (let index = first; index < last; index += 1) wanted.add(index);

  for (const index of rowElements.keys()) {
    if (!wanted.has(index)) removeRow(index);
  }
  if (!rowElements.has(activeIndex)) activeRow(activeIndex);
  for (let index = first; index < last; index += 1) {
    if (!rowElements.has(index)) previewRow(index);
  }
}

function scheduleVisibleRows() {
  if (renderScheduled) return;
  renderScheduled = true;
  requestAnimationFrame(() => {
    renderScheduled = false;
    renderVisibleRows();
  });
}

async function activateBlock(index) {
  if (index === activeIndex) {
    vditor?.focus();
    return;
  }
  await editorReady;
  if (vditor) {
    vditor.destroy();
    vditor = null;
  }
  const previous = activeIndex;
  activeIndex = index;
  removeRow(previous);
  removeRow(index);
  renderVisibleRows();
  await editorReady;
  vditor.focus();
}

async function installDocument(source, path = null) {
  await editorReady;
  if (vditor) {
    vditor.destroy();
    vditor = null;
  }
  rows.replaceChildren();
  rowElements.clear();
  blocks = splitDocument(source);
  activeIndex = 0;
  characterCount = source.length;
  saved = source;
  dirty = false;
  filePath = path;
  viewport.scrollTop = 0;
  spacer.style.height = `${blocks.length * ROW_HEIGHT}px`;
  renderStatus();
  renderVisibleRows();
  if (!benchmarkMode) await editorReady;
}

function nextFrame() {
  return new Promise(resolve => requestAnimationFrame(resolve));
}

function mean(values) {
  return values.reduce((total, value) => total + value, 0) / values.length;
}

function summarize(
  scenario,
  workSamples,
  intervals,
  latencies,
  config,
  firstInteractiveMs,
  actionTimestampsEpochMs = [],
  actionWindowEndEpochMs = null,
) {
  const sorted = [...workSamples].sort((a, b) => a - b);
  const sortedIntervals = [...intervals].sort((a, b) => a - b);
  const sortedLatencies = [...latencies].sort((a, b) => a - b);
  const at = ratio => sorted[Math.round((sorted.length - 1) * ratio)];
  const dropped = intervals.reduce((total, value) => total + Math.max(0, Math.ceil(value / 16.667) - 1), 0);
  return {
    adapter: 'electron',
    measurement_scope: 'ui-frame',
    timing_source: 'chromium-requestAnimationFrame-interval',
    latency_source: 'action-to-next-animation-frame',
    window_mode: 'native-window',
    work_scope: 'dom-update-and-layout',
    display_timestamp_source: 'chromium-requestAnimationFrame-not-os-present',
    scenario,
    frame_work_samples_ms: workSamples,
    frame_interval_samples_ms: intervals,
    input_to_visible_samples_ms: scenario === 'input' ? latencies : [],
    // Null means that the stage was not instrumented; it is not a measured 0.
    offscreen_samples_ms: workSamples.map(() => null),
    readback_samples_ms: workSamples.map(() => null),
    offscreen_readback_samples_ms: workSamples.map(() => null),
    frame_work_ms: mean(workSamples),
    frame_interval_ms: intervals.length ? mean(intervals) : null,
    input_to_visible_ms: scenario === 'input' ? mean(latencies) : null,
    offscreen_ms: null,
    readback_ms: null,
    offscreen_readback_ms: null,
    frame_work_p95_ms: at(0.95),
    frame_interval_p95_ms: intervals.length ? sortedIntervals[Math.round((sortedIntervals.length - 1) * 0.95)] : null,
    input_to_visible_p95_ms: scenario === 'input' && latencies.length ? sortedLatencies[Math.round((sortedLatencies.length - 1) * 0.95)] : null,
    dropped_display_frames: dropped,
    action_count: scenario === 'open' ? 1 : (scenario === 'scroll' ? 120 : 10),
    frame_sample_count: intervals.length,
    warmup_action_count: scenario === 'open' ? 0 : 1,
    action_timestamps_epoch_ms: actionTimestampsEpochMs,
    action_window_start_epoch_ms: actionTimestampsEpochMs.length ? actionTimestampsEpochMs[0] : null,
    action_window_end_epoch_ms: actionWindowEndEpochMs,
    first_interactive_ms: firstInteractiveMs,
    document_load_ms: config.document_load_ms,
    viewport: { width: innerWidth, height: innerHeight },
    gpu_backend: config.gpu_backend || 'unknown',
    rendering_strategy: 'fixed-row-virtual-list-with-active-vditor-wysiwyg',
    font: 'system-ui 16px', line_height: 1.55, overscan: 3, virtual_row_height: 66,
  };
}

async function runUiBenchmark(config, initializedAt) {
  const firstFrame = await nextFrame();
  // Honest "first interactive": the editor for the first visible row has
  // mounted and finished its initial Markdown conversion — the same state
  // the interactive app requires before typing. Without this await the
  // open metric would report while Vditor's editor DOM (deferred behind a
  // double rAF in benchmark mode) does not even exist yet.
  await editorReady;
  const firstInteractiveMs = performance.now() - initializedAt;
  if (config.scenario === 'open') {
    window.benchmarkApi.report(
      summarize('open', [firstInteractiveMs], [], [], config, firstInteractiveMs),
    );
    return;
  }

  const count = config.scenario === 'scroll' ? 120 : 10;
  const workSamples = [];
  const samples = [];
  const latencies = [];
  const actionTimestampsEpochMs = [];
  let previousFrame = firstFrame;
  await editorReady;
  vditor.focus();
  if (config.scenario === 'scroll' && viewport.scrollHeight <= viewport.clientHeight) {
    throw new Error('Vditor benchmark document is not scrollable');
  }

  function driveAction(index) {
    if (config.scenario === 'input') {
      const before = vditor.getValue();
      vditor.insertValue(String.fromCharCode(97 + index % 26), true);
      if (vditor.getValue().length <= before.length) {
        throw new Error('Vditor benchmark input did not update the Markdown value');
      }
    } else {
      const maximum = Math.max(0, viewport.scrollHeight - viewport.clientHeight);
      const target = index % 2 === 0 ? Math.min(maximum, (index + 1) * 480) : 0;
      // On high-DPI displays Chromium rounds scrollTop to device pixels, so
      // a sub-pixel tolerance smaller than 1 CSS px reports false failures.
      const tolerance = Math.max(1, 2 / window.devicePixelRatio);
      if (Math.abs(target - viewport.scrollTop) < tolerance) {
        throw new Error('Vditor benchmark scroll offset did not change');
      }
      viewport.scrollTop = target;
      renderVisibleRows();
      if (Math.abs(viewport.scrollTop - target) >= tolerance) {
        throw new Error(
          `Vditor benchmark scroll target was not applied (index ${index}, target ${target}, ` +
          `scrollTop ${viewport.scrollTop}, max ${viewport.scrollHeight - viewport.clientHeight})`,
        );
      }
    }
  }

  driveAction(0);
  previousFrame = await nextFrame();
  for (let index = 0; index < count; index += 1) {
    window.benchmarkApi.action(index);
    actionTimestampsEpochMs.push(performance.timeOrigin + performance.now());
    const actionStarted = performance.now();
    const workStarted = performance.now();
    driveAction(index + 1);
    workSamples.push(Math.max(0, performance.now() - workStarted));
    const frame = await nextFrame();
    samples.push(Math.max(0, frame - previousFrame));
    latencies.push(Math.max(0, performance.now() - actionStarted));
    previousFrame = frame;
  }
  window.benchmarkApi.report(
    summarize(
      config.scenario,
      workSamples,
      samples,
      latencies,
      config,
      firstInteractiveMs,
      actionTimestampsEpochMs,
      performance.timeOrigin + performance.now(),
    ),
  );
}

function installDocumentCommands() {
  document.getElementById('new').onclick = async () => {
    fileLabel.textContent = 'Untitled.md';
    await installDocument('# Untitled\n\n');
  };
  document.getElementById('open').onclick = async () => {
    try {
      const opened = await window.documentApi.open();
      if (!opened) return;
      fileLabel.textContent = opened.name;
      await installDocument(opened.source, opened.path);
    } catch (error) {
      status.textContent = `Open failed: ${error.message}`;
    }
  };
  document.getElementById('save').onclick = async () => {
    try {
      const source = serializeDocument();
      const savedDocument = await window.documentApi.save({ path: filePath, source });
      if (!savedDocument) return;
      filePath = savedDocument.path;
      fileLabel.textContent = savedDocument.name;
      saved = source;
      dirty = false;
      renderStatus();
    } catch (error) {
      status.textContent = `Save failed: ${error.message}`;
    }
  };
}

async function bootstrap() {
  const config = await window.benchmarkApi.config();
  benchmarkMode = Boolean(config);
  const initialValue = config?.source ?? sample;
  const initializedAt = performance.now();
  await installDocument(initialValue);
  installDocumentCommands();
  viewport.addEventListener('scroll', scheduleVisibleRows, { passive: true });
  if (!config) return;
  runUiBenchmark(config, initializedAt).catch(error => {
    window.benchmarkApi.report({
      adapter: 'electron',
      measurement_scope: 'ui-frame',
      scenario: config.scenario,
      status: 'error',
      error: error.stack || error.message,
    });
  });
}

bootstrap();
