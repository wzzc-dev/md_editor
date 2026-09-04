const { app, BrowserWindow, dialog, ipcMain } = require('electron');
const { spawn } = require('child_process');
const fs = require('fs/promises');
const path = require('path');
const { performance } = require('perf_hooks');

const markdownFilter = [{ name: 'Markdown', extensions: ['md', 'markdown'] }];

// Keep Electron on the same native GPU path as MoUI and GPUI on macOS. The
// switch is applied before app.ready so Chromium cannot initialize a software
// ANGLE device first.
if (process.platform === 'darwin') {
  app.commandLine.appendSwitch('use-angle', 'metal');
  app.commandLine.appendSwitch('enable-gpu-rasterization');
}
// The ui-benchmark action loop awaits requestAnimationFrame after every
// action. Chromium's native window-occlusion tracking marks a fully covered
// window hidden and stops delivering rAF callbacks, so a benchmark window
// that is not frontmost would stall forever. Keep the animation clock
// running; rAF stays vsync-paced, so interval semantics are unchanged.
if (process.argv.includes('--ui-benchmark')) {
  app.commandLine.appendSwitch('disable-features', 'CalculateNativeWinOcclusion');
}

function createWindow(benchmark = null) {
  const window = new BrowserWindow({
    width: 1280,
    height: 800,
    useContentSize: true,
    minWidth: 800,
    minHeight: 500,
    webPreferences: {
      contextIsolation: true,
      nodeIntegration: false,
      backgroundThrottling: false,
      preload: path.join(__dirname, 'preload.js'),
    },
  });
  const start = benchmark
    // `useContentSize` sizes the client area in DIP, but Windows frame/DPI
    // rounding can land the CSS viewport a pixel or two off (e.g. 1282x802 at
    // 125% scaling). Measure the empty document and converge on exactly
    // 1280x800 CSS px before loading the benchmark page, so the protocol gate
    // sees the same logical viewport on every platform.
    ? calibrateContent(window).then(() => window.loadFile(path.join(__dirname, 'index.html')))
    : window.loadFile(path.join(__dirname, 'index.html'));
  void start;
  if (benchmark) {
    const helperPath = process.env.MD_EDITOR_SIGNPOST_HELPER;
    const signpostHelper = helperPath
      ? spawn(helperPath, [], { stdio: ['pipe', 'ignore', 'ignore'] })
      : null;
    ipcMain.on('benchmark:action', (_event, index) => {
      if (signpostHelper?.stdin?.writable && Number.isInteger(index)) {
        signpostHelper.stdin.write(`${index}\n`);
      }
    });
    ipcMain.handle('benchmark:config', () => benchmark);
    ipcMain.once('benchmark:report', (_event, report) => {
      signpostHelper?.stdin?.end();
      report.system_trace_process_ids = [
        process.pid,
        window.webContents.getOSProcessId(),
        ...app.getAppMetrics().map(metric => metric.pid),
        ...(signpostHelper?.pid ? [signpostHelper.pid] : []),
      ].filter((pid, index, values) => Number.isInteger(pid) && pid > 0 && values.indexOf(pid) === index);
      process.stdout.write(`${JSON.stringify(report)}\n`, () => {
        const finish = () => app.quit();
        if (process.env.UI_BENCHMARK_SYSTEM_PRESENT === '1') {
          const requestedTail = Number.parseInt(process.env.UI_BENCHMARK_TRACE_TAIL_MS || '', 10);
          const tailMs = Number.isFinite(requestedTail) ? Math.min(Math.max(requestedTail, 0), 120000) : 15000;
          setTimeout(finish, tailMs);
        } else {
          finish();
        }
      });
    });
  }
}

async function calibrateContent(window) {
  await window.loadURL('about:blank');
  let lastSet = null;
  for (let attempt = 0; attempt < 6; attempt += 1) {
    const measured = await window.webContents.executeJavaScript('[innerWidth, innerHeight]', true);
    const [width, height] = Array.isArray(measured) ? measured : [];
    if (width === 1280 && height === 800) return;
    if (!Number.isInteger(width) || !Number.isInteger(height)) break;
    // DIP-to-CSS mapping is offset by a DPI-quantization constant (one DIP
    // here at 125%+ scaling), so solve from the previous (set -> measured)
    // pair. The resize event is not guaranteed to fire, hence the fallback
    // timer; measuring too early just costs one extra loop iteration.
    const next = lastSet === null
      ? { width: 2560 - width, height: 1600 - height }
      : {
          width: lastSet.width + (1280 - width),
          height: lastSet.height + (800 - height),
        };
    lastSet = next;
    window.setContentSize(next.width, next.height, false);
    await new Promise(resolve => {
      const timer = setTimeout(resolve, 250);
      window.once('resize', () => setTimeout(() => clearTimeout(timer) || resolve(), 40));
    });
  }
  throw new Error('benchmark window did not converge to a 1280x800 CSS viewport');
}

if (process.argv.includes('--benchmark')) {
  require('./benchmark');
} else {
  ipcMain.handle('document:open', async () => {
    const result = await dialog.showOpenDialog({ properties: ['openFile'], filters: markdownFilter });
    if (result.canceled) return null;
    const filePath = result.filePaths[0];
    return { path: filePath, name: path.basename(filePath), source: await fs.readFile(filePath, 'utf8') };
  });
  ipcMain.handle('document:save', async (_event, document) => {
    if (typeof document?.source !== 'string') throw new Error('Markdown source must be a string');
    let filePath = document.path;
    if (!filePath) {
      const result = await dialog.showSaveDialog({ defaultPath: 'untitled.md', filters: markdownFilter });
      if (result.canceled || !result.filePath) return null;
      filePath = result.filePath;
    }
    await fs.writeFile(filePath, document.source, 'utf8');
    return { path: filePath, name: path.basename(filePath) };
  });
  app.whenReady().then(async () => {
    const benchmarkIndex = process.argv.indexOf('--ui-benchmark');
    if (benchmarkIndex < 0) {
      createWindow();
      return;
    }
    const fixtureArg = process.argv[benchmarkIndex + 1];
    const scenario = process.argv[benchmarkIndex + 2];
    if (!fixtureArg || !['open', 'input', 'scroll'].includes(scenario)) {
      throw new Error('usage: electron . --ui-benchmark <fixture> <open|input|scroll>');
    }
    const fixture = path.resolve(process.cwd(), fixtureArg);
    const loadStarted = performance.now();
    const source = await fs.readFile(fixture, 'utf8');
    createWindow({ source, scenario, document_load_ms: performance.now() - loadStarted, viewport: { width: 1280, height: 800 }, gpu_backend: process.platform === 'darwin' ? 'Metal' : 'native' });
  });
  app.on('window-all-closed', () => {
    if (process.platform !== 'darwin' || process.argv.includes('--ui-benchmark')) app.quit();
  });
}
