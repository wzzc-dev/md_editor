# Electron comparison editor

The renderer is a deliberately small Vditor WYSIWYG editor. Native Electron
file dialogs open and save Markdown source through a narrow preload bridge.
The document is a fixed-row virtual list: visible inactive rows use Vditor's
bundled Lute parser, while exactly one active row mounts Vditor with
`mode: "wysiwyg"`. This keeps large fixtures usable without replacing the
formatted editing surface with a plain Markdown textarea.
The deterministic Node benchmark emits the shared block baseline plus a
Small-only `wysiwyg-full` row from the same parser:

```sh
npm ci --prefix electron
npm run check --prefix electron
npm start --prefix electron
npm run benchmark --prefix electron -- data/medium.md scroll
python3 electron/ui_benchmark.py data/medium.md scroll
```

Electron 44 no longer downloads its platform runtime from the dependency's own
install hook, so this project declares `postinstall: install-electron`.
`ui_benchmark.py` starts that runtime directly and keeps `npm` startup overhead
out of the measured process.
