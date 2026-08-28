const { app, BrowserWindow, dialog, ipcMain } = require('electron');
const fs = require('fs/promises');
const path = require('path');
const { performance } = require('perf_hooks');

const markdownFilter = [{ name: 'Markdown', extensions: ['md', 'markdown'] }];

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
    ipcMain.handle('benchmark:config', () => benchmark);
    ipcMain.once('benchmark:report', (_event, report) => {
      process.stdout.write(`${JSON.stringify(report)}\n`, () => app.quit());
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
    createWindow({ source, scenario, document_load_ms: performance.now() - loadStarted, viewport: { width: 1280, height: 800 } });
  });
  app.on('window-all-closed', () => {
    if (process.platform !== 'darwin' || process.argv.includes('--ui-benchmark')) app.quit();
  });
}
