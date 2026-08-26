# MoonBit AccessKit (common)

This repository is a MoonBit port of the Rust [`accesskit`](https://github.com/AccessKit/accesskit) crates:

- `Milky2018/moon_accesskit` (common): data model + JSON codec
- `Milky2018/moon_accesskit/consumer` (consumer): in-memory tree state, update application, and iterators

Upstream pin (for compatibility work):
- Rust crate: `accesskit` `0.24.0`
- Git commit: `528fba56534d06551d8ce8c28cb444bd18ed1cfc` (2026-02-02)

## Usage

```mbt
///|
test "build and JSON-encode a TreeUpdate" {
  let tree_id = TreeId::root()
  let root = NodeId::new(1UL)
  let node = Node::new(Role::Button)
  node.set_label("OK")
  let update = TreeUpdate::new(tree_id, root)
  update.set_tree(Tree::new(root))
  update.push_node(root, node)
  let json = update.to_json().stringify(indent=2)
  let roundtrip : TreeUpdate = @json.from_json(@json.parse(json))
  assert_eq(roundtrip.focus().to_u64(), 1UL)
}
```

## Consumer package

The `Milky2018/moon_accesskit/consumer` package provides:

- `Tree` / `State`: apply `TreeUpdate`s and query nodes
- `common_filter`: a reference-compatible filter used by iterators
- `ChangeHandler`: receive change callbacks when applying updates

See the runnable example in `cmd/consumer_demo`.

## JSON compatibility

This port implements `ToJson` / `@json.FromJson` for `TreeUpdate`, `ActionRequest`,
`Node`, geometry types, and related enums/structs.

The JSON shape is designed to mirror Rust `serde` JSON (notably `camelCase` field
names for structs and enum variant names).
