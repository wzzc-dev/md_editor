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
  window.loadFile(path.join(__dirname, 'index.html'));
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
