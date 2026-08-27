# Flutter comparison editor

The Material 3 implementation parses the source into blocks and virtualizes
them with `ListView.builder`. The active block is a multiline WYSIWYG
`TextField`; inactive blocks are formatted `RichText`. Syntax markers remain
in the source for selection and saving but are zero-size and transparent in
the active `TextSpan`. File dialogs are provided by `file_selector`.

```sh
flutter pub get
flutter run -d macos --no-enable-impeller -- data/medium.md
flutter build macos --profile
cd ..
python3 flutter/ui_benchmark.py skia data/medium.md scroll
python3 flutter/ui_benchmark.py impeller data/medium.md scroll
```

The UI wrapper rejects a renderer label unless the Flutter engine startup log
confirms it and the application reports a 1280x800 logical viewport.
