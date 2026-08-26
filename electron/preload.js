const { contextBridge, ipcRenderer } = require('electron');

contextBridge.exposeInMainWorld('documentApi', {
  open: () => ipcRenderer.invoke('document:open'),
  save: document => ipcRenderer.invoke('document:save', document),
});
