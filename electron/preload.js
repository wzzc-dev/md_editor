const { contextBridge, ipcRenderer } = require('electron');

contextBridge.exposeInMainWorld('documentApi', {
  open: () => ipcRenderer.invoke('document:open'),
  save: document => ipcRenderer.invoke('document:save', document),
});

contextBridge.exposeInMainWorld('benchmarkApi', {
  config: () => ipcRenderer.invoke('benchmark:config').catch(() => null),
  report: report => ipcRenderer.send('benchmark:report', report),
});
