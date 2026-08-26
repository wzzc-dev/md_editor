# Compatibility checklist (Rust `accesskit` + `accesskit_consumer`)

Upstream pin:
- Crate: `accesskit` `0.24.0`
- Commit: `528fba56534d06551d8ce8c28cb444bd18ed1cfc` (2026-02-02)

Scope:
- This module ports the Rust `accesskit` **common** crate (data model + JSON shape).
- This module also ports the Rust `accesskit_consumer` crate as the MoonBit package `Milky2018/moon_accesskit/consumer`.
- Platform adapters and runtime integration are out of scope.

## Implemented

- Geometry types: `Affine`, `Point`, `Rect`, `Size`, `Vec2`.
- Core identifiers: `NodeId`, `Uuid`, `TreeId`.
- Core enums: `Role`, `Action`, `ScrollUnit`, `ScrollHint`, and property enums.
- Node model: `Node`, flags, actions, property storage, and property accessors.
- Tree updates & actions: `Tree`, `TreeUpdate`, `ActionData`, `ActionRequest`, and handler traits.
- JSON: `ToJson` / `@json.FromJson` implemented for `TreeUpdate`, `ActionRequest`, `Node`, geometry types, and related enums/structs.
  - Field/variant names use `camelCase` to match Rust `serde` JSON conventions.
- Consumer tree state: `consumer::Tree` / `consumer::State`, subtree grafting, focus logic, and iterators/filtering behavior aligned to `accesskit_consumer`.

## Not implemented / N/A

- Rust feature gates such as `schemars` (JSON schema generation) and `pyo3` bindings.
- Any platform adapter crates (Windows/macOS/Linux/Android/etc), including:
  - `accesskit_winit`
  - `accesskit_windows`
  - `accesskit_macos`
  - `accesskit_unix`
  - `accesskit_android`
  - `accesskit_atspi_common`
