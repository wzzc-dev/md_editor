# Electron comparison editor

The renderer is a deliberately small split-pane editor. Native Electron file
dialogs open and save Markdown source through a narrow preload bridge. The
preview uses matching block-level Markdown semantics (headings, paragraphs,
lists, quotes, code and inline emphasis). The same transformation is available
as a deterministic Node benchmark:

```sh
npm install --prefix electron
npm start --prefix electron
npm run benchmark --prefix electron -- data/medium.md scroll
```
