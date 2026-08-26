///|
/// YAML Tokenizer Tests

// =============================================================================
// Basic Token Tests
// =============================================================================

test "yaml: basic key-value" {
  let tokenizer = @yaml.YamlTokenizer::new("name: John")
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens.length(), 3)
  assert_eq(tokens[0].token_type, Key)
  assert_eq(tokens[1].token_type, Colon)
  assert_eq(tokens[2].token_type, Value)
}

///|
test "yaml: multiple key-values" {
  let source =
    #|name: John
    #|age: 30
    #|city: Tokyo
  let tokenizer = @yaml.YamlTokenizer::new(source)
  let tokens = tokenizer.tokenize_all()
  let keys = tokens.iter().filter(fn(t) { t.token_type == Key }).collect()
  assert_eq(keys.length(), 3)
}

// =============================================================================
// List Tests
// =============================================================================

///|
test "yaml: simple list" {
  let source =
    #|- apple
    #|- banana
    #|- cherry
  let tokenizer = @yaml.YamlTokenizer::new(source)
  let tokens = tokenizer.tokenize_all()
  let dashes = tokens.iter().filter(fn(t) { t.token_type == Dash }).collect()
  assert_eq(dashes.length(), 3)
}

///|
test "yaml: nested list" {
  let source =
    #|fruits:
    #|  - apple
    #|  - banana
  let tokenizer = @yaml.YamlTokenizer::new(source)
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens[0].token_type, Key) // fruits
  assert_eq(tokens[1].token_type, Colon)
}

// =============================================================================
// String Tests
// =============================================================================

///|
test "yaml: double quoted string" {
  let tokenizer = @yaml.YamlTokenizer::new("msg: \"Hello, World!\"")
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens[2].token_type, String)
}

///|
test "yaml: single quoted string" {
  let tokenizer = @yaml.YamlTokenizer::new("msg: 'Hello, World!'")
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens[2].token_type, String)
}

///|
test "yaml: string with escapes" {
  let tokenizer = @yaml.YamlTokenizer::new("msg: \"line1\\nline2\"")
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens[2].token_type, String)
}

///|
test "yaml: single quote escape" {
  let tokenizer = @yaml.YamlTokenizer::new("msg: 'it''s ok'")
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens[2].token_type, String)
}

// =============================================================================
// Scalar Type Tests
// =============================================================================

///|
test "yaml: boolean true variants" {
  let source =
    #|a: true
    #|b: True
    #|c: TRUE
    #|d: yes
    #|e: on
  let tokenizer = @yaml.YamlTokenizer::new(source)
  let tokens = tokenizer.tokenize_all()
  let bools = tokens.iter().filter(fn(t) { t.token_type == Bool }).collect()
  assert_eq(bools.length(), 5)
}

///|
test "yaml: boolean false variants" {
  let source =
    #|a: false
    #|b: False
    #|c: no
    #|d: off
  let tokenizer = @yaml.YamlTokenizer::new(source)
  let tokens = tokenizer.tokenize_all()
  let bools = tokens.iter().filter(fn(t) { t.token_type == Bool }).collect()
  assert_eq(bools.length(), 4)
}

///|
test "yaml: null variants" {
  let source =
    #|a: null
    #|b: Null
    #|c: ~
  let tokenizer = @yaml.YamlTokenizer::new(source)
  let tokens = tokenizer.tokenize_all()
  let nulls = tokens.iter().filter(fn(t) { t.token_type == Null }).collect()
  assert_eq(nulls.length(), 3)
}

///|
test "yaml: integer numbers" {
  let source =
    #|a: 42
    #|b: -17
    #|c: +99
  let tokenizer = @yaml.YamlTokenizer::new(source)
  let tokens = tokenizer.tokenize_all()
  let nums = tokens.iter().filter(fn(t) { t.token_type == Number }).collect()
  assert_eq(nums.length(), 3)
}

///|
test "yaml: float numbers" {
  let source =
    #|a: 3.14
    #|b: -2.5
    #|c: 1.0e10
  let tokenizer = @yaml.YamlTokenizer::new(source)
  let tokens = tokenizer.tokenize_all()
  let nums = tokens.iter().filter(fn(t) { t.token_type == Number }).collect()
  assert_eq(nums.length(), 3)
}

///|
test "yaml: hex numbers" {
  let tokenizer = @yaml.YamlTokenizer::new("hex: 0x1F")
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens[2].token_type, Number)
}

// =============================================================================
// Comment Tests
// =============================================================================

///|
test "yaml: line comment" {
  let tokenizer = @yaml.YamlTokenizer::new("# This is a comment")
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens.length(), 1)
  assert_eq(tokens[0].token_type, Comment)
}

///|
test "yaml: inline comment" {
  let tokenizer = @yaml.YamlTokenizer::new("key: value # comment")
  let tokens = tokenizer.tokenize_all()
  let has_comment = tokens.iter().any(fn(t) { t.token_type == Comment })
  assert_true(has_comment)
}

// =============================================================================
// Anchor and Alias Tests
// =============================================================================

///|
test "yaml: anchor" {
  let tokenizer = @yaml.YamlTokenizer::new("defaults: &default_settings")
  let tokens = tokenizer.tokenize_all()
  let has_anchor = tokens.iter().any(fn(t) { t.token_type == Anchor })
  assert_true(has_anchor)
}

///|
test "yaml: alias" {
  let tokenizer = @yaml.YamlTokenizer::new("production: *default_settings")
  let tokens = tokenizer.tokenize_all()
  let has_alias = tokens.iter().any(fn(t) { t.token_type == Alias })
  assert_true(has_alias)
}

// =============================================================================
// Tag Tests
// =============================================================================

///|
test "yaml: explicit tag" {
  let tokenizer = @yaml.YamlTokenizer::new("date: !!timestamp 2024-01-01")
  let tokens = tokenizer.tokenize_all()
  let has_tag = tokens.iter().any(fn(t) { t.token_type == Tag })
  assert_true(has_tag)
}

// =============================================================================
// Flow Style Tests
// =============================================================================

///|
test "yaml: flow sequence" {
  let tokenizer = @yaml.YamlTokenizer::new("items: [1, 2, 3]")
  let tokens = tokenizer.tokenize_all()
  let has_open = tokens.iter().any(fn(t) { t.token_type == BracketOpen })
  let has_close = tokens.iter().any(fn(t) { t.token_type == BracketClose })
  assert_true(has_open)
  assert_true(has_close)
}

///|
test "yaml: flow mapping" {
  let tokenizer = @yaml.YamlTokenizer::new("person: {name: John, age: 30}")
  let tokens = tokenizer.tokenize_all()
  let has_open = tokens.iter().any(fn(t) { t.token_type == BraceOpen })
  let has_close = tokens.iter().any(fn(t) { t.token_type == BraceClose })
  assert_true(has_open)
  assert_true(has_close)
}

// =============================================================================
// Block Scalar Tests
// =============================================================================

///|
test "yaml: literal block scalar" {
  let tokenizer = @yaml.YamlTokenizer::new("text: |")
  let tokens = tokenizer.tokenize_all()
  let has_pipe = tokens.iter().any(fn(t) { t.token_type == Pipe })
  assert_true(has_pipe)
}

///|
test "yaml: folded block scalar" {
  let tokenizer = @yaml.YamlTokenizer::new("text: >")
  let tokens = tokenizer.tokenize_all()
  let has_greater = tokens.iter().any(fn(t) { t.token_type == Greater })
  assert_true(has_greater)
}

// =============================================================================
// Directive Tests
// =============================================================================

///|
test "yaml: document start" {
  let tokenizer = @yaml.YamlTokenizer::new("---\nkey: value")
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens[0].token_type, Directive)
}

///|
test "yaml: document end" {
  let tokenizer = @yaml.YamlTokenizer::new("key: value\n...")
  let tokens = tokenizer.tokenize_all()
  let has_end = tokens.iter().any(fn(t) { t.token_type == Directive })
  assert_true(has_end)
}

// =============================================================================
// Integration Tests
// =============================================================================

///|
test "yaml: complex document" {
  let source =
    #|# Configuration file
    #|version: 1.0
    #|database:
    #|  host: localhost
    #|  port: 5432
    #|  enabled: true
    #|tags: [dev, test]
  let tokenizer = @yaml.YamlTokenizer::new(source)
  let tokens = tokenizer.tokenize_all()
  assert_true(tokens.length() > 10)
  let has_comment = tokens.iter().any(fn(t) { t.token_type == Comment })
  let has_number = tokens.iter().any(fn(t) { t.token_type == Number })
  let has_bool = tokens.iter().any(fn(t) { t.token_type == Bool })
  assert_true(has_comment)
  assert_true(has_number)
  assert_true(has_bool)
}

///|
test "yaml: highlight to html" {
  let source =
    #|name: John
    #|age: 30
    #|active: true
  let html = @yaml.highlight_yaml_to_html(source)
  assert_true(html.contains("<span"))
  assert_true(html.contains("</span>"))
}
