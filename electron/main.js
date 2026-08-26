const { app, BrowserWindow, dialog, ipcMain } = require('electron');
const fs = require('fs/promises');
const path = require('path');

const markdownFilter = [{ name: 'Markdown', extensions: ['md', 'markdown'] }];

function createWindow() {
  const window = new BrowserWindow({
    width: 1280,
    height: 800,
    minWidth: 800,
    minHeight: 500,
    webPreferences: {
      contextIsolation: true,
      nodeIntegration: false,
      preload: path.join(__dirname, 'preload.js'),
    },
  });
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
  app.whenReady().then(createWindow);
  app.on('window-all-closed', () => { if (process.platform !== 'darwin') app.quit(); });
}
