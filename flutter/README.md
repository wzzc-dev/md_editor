# Flutter comparison editor

The Material 3 implementation keeps the source in a multiline `TextField` and renders
matching block-level Markdown semantics in a scrollable pane. File dialogs are
provided by `file_selector`.

```sh
flutter pub get
flutter run -d macos --no-enable-impeller data/medium.md
flutter run -d windows --enable-impeller data/medium.md
```
