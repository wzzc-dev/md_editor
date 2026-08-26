///|
/// Zig Tokenizer Tests

// =============================================================================
// Keyword Tests
// =============================================================================

test "zig: control flow" {
  let tokenizer = @zig.ZigTokenizer::new(
    "if else while for return break continue",
  )
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens.length(), 7)
  for token in tokens {
    assert_eq(token.token_type, Keyword)
  }
}

///|
test "zig: declaration keywords" {
  let tokenizer = @zig.ZigTokenizer::new("fn pub const var comptime inline")
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens.length(), 6)
  for token in tokens {
    assert_eq(token.token_type, Keyword)
  }
}

///|
test "zig: type definition keywords" {
  let tokenizer = @zig.ZigTokenizer::new("struct enum union error opaque")
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens.length(), 5)
  for token in tokens {
    assert_eq(token.token_type, Keyword)
  }
}

///|
test "zig: error handling keywords" {
  let tokenizer = @zig.ZigTokenizer::new("try catch defer errdefer orelse")
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens.length(), 5)
  for token in tokens {
    assert_eq(token.token_type, Keyword)
  }
}

// =============================================================================
// Type Tests
// =============================================================================

///|
test "zig: integer types" {
  let tokenizer = @zig.ZigTokenizer::new(
    "u8 u16 u32 u64 i8 i16 i32 i64 usize isize",
  )
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens.length(), 10)
  for token in tokens {
    assert_eq(token.token_type, TypeKeyword)
  }
}

///|
test "zig: float types" {
  let tokenizer = @zig.ZigTokenizer::new("f16 f32 f64 f80 f128")
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens.length(), 5)
  for token in tokens {
    assert_eq(token.token_type, TypeKeyword)
  }
}

///|
test "zig: special types" {
  let tokenizer = @zig.ZigTokenizer::new("void bool noreturn type anytype")
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens.length(), 5)
  for token in tokens {
    assert_eq(token.token_type, TypeKeyword)
  }
}

// =============================================================================
// Builtin Tests
// =============================================================================

///|
test "zig: builtins" {
  let tokenizer = @zig.ZigTokenizer::new("@import @compileError @typeInfo @as")
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens.length(), 4)
  for token in tokens {
    assert_eq(token.token_type, Builtin)
  }
}

// =============================================================================
// Literal Tests
// =============================================================================

///|
test "zig: decimal numbers" {
  let tokenizer = @zig.ZigTokenizer::new("0 42 1_000_000")
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens.length(), 3)
  for token in tokens {
    assert_eq(token.token_type, Number)
  }
}

///|
test "zig: hex numbers" {
  let tokenizer = @zig.ZigTokenizer::new("0x0 0xFF 0x1A_2B")
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens.length(), 3)
  for token in tokens {
    assert_eq(token.token_type, Number)
  }
}

///|
test "zig: binary numbers" {
  let tokenizer = @zig.ZigTokenizer::new("0b0 0b1010 0b1111_0000")
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens.length(), 3)
  for token in tokens {
    assert_eq(token.token_type, Number)
  }
}

///|
test "zig: octal numbers" {
  let tokenizer = @zig.ZigTokenizer::new("0o0 0o77 0o755")
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens.length(), 3)
  for token in tokens {
    assert_eq(token.token_type, Number)
  }
}

///|
test "zig: float numbers" {
  let tokenizer = @zig.ZigTokenizer::new("3.14 1.0 1e10 2.5e-3")
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens.length(), 4)
  for token in tokens {
    assert_eq(token.token_type, Number)
  }
}

///|
test "zig: string literal" {
  let tokenizer = @zig.ZigTokenizer::new("\"hello world\"")
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens.length(), 1)
  assert_eq(tokens[0].token_type, String)
}

///|
test "zig: multiline string" {
  let source =
    #|\\hello
    #|\\world
  let tokenizer = @zig.ZigTokenizer::new(source)
  let tokens = tokenizer.tokenize_all()
  let multi = tokens
    .iter()
    .filter(fn(t) { t.token_type == MultilineString })
    .collect()
  assert_eq(multi.length(), 2)
}

///|
test "zig: character literal" {
  let tokenizer = @zig.ZigTokenizer::new("'a' '\\n' '\\0'")
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens.length(), 3)
  for token in tokens {
    assert_eq(token.token_type, Char)
  }
}

// =============================================================================
// Operator Tests
// =============================================================================

///|
test "zig: optional type" {
  let tokenizer = @zig.ZigTokenizer::new("?u32 ?[]u8")
  let tokens = tokenizer.tokenize_all()
  let opt = tokens.iter().filter(fn(t) { t.token_type == Optional }).collect()
  assert_eq(opt.length(), 2)
}

///|
test "zig: error union" {
  let tokenizer = @zig.ZigTokenizer::new("!void error!u32")
  let tokens = tokenizer.tokenize_all()
  let err = tokens.iter().filter(fn(t) { t.token_type == ErrorUnion }).collect()
  assert_eq(err.length(), 2)
}

///|
test "zig: arrow operator" {
  let tokenizer = @zig.ZigTokenizer::new(".foo => bar")
  let tokens = tokenizer.tokenize_all()
  let has_arrow = tokens.iter().any(fn(t) { t.token_type == Arrow })
  assert_true(has_arrow)
}

///|
test "zig: comparison" {
  let tokenizer = @zig.ZigTokenizer::new("a == b != c < d > e <= f >= g")
  let tokens = tokenizer.tokenize_all()
  let cmp = tokens.iter().filter(fn(t) { t.token_type == Comparison }).collect()
  assert_true(cmp.length() >= 6)
}

// =============================================================================
// Comment Tests
// =============================================================================

///|
test "zig: line comment" {
  let tokenizer = @zig.ZigTokenizer::new("// this is a comment")
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens.length(), 1)
  assert_eq(tokens[0].token_type, LineComment)
}

///|
test "zig: doc comment" {
  let tokenizer = @zig.ZigTokenizer::new("/// this is a doc comment")
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens.length(), 1)
  assert_eq(tokens[0].token_type, DocComment)
}

// =============================================================================
// Punctuation Tests
// =============================================================================

///|
test "zig: brackets" {
  let tokenizer = @zig.ZigTokenizer::new("() {} []")
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens[0].token_type, ParenOpen)
  assert_eq(tokens[1].token_type, ParenClose)
  assert_eq(tokens[2].token_type, BraceOpen)
  assert_eq(tokens[3].token_type, BraceClose)
  assert_eq(tokens[4].token_type, BracketOpen)
  assert_eq(tokens[5].token_type, BracketClose)
}

// =============================================================================
// Integration Tests
// =============================================================================

///|
test "zig: simple function" {
  let source =
    #|pub fn main() void {
    #|    return;
    #|}
  let tokenizer = @zig.ZigTokenizer::new(source)
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens[0].token_type, Keyword) // pub
  assert_eq(tokens[1].token_type, Keyword) // fn
  assert_eq(tokens[2].token_type, Identifier) // main
}

///|
test "zig: struct definition" {
  let source =
    #|const Point = struct {
    #|    x: i32,
    #|    y: i32,
    #|};
  let tokenizer = @zig.ZigTokenizer::new(source)
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens[0].token_type, Keyword) // const
  assert_eq(tokens[1].token_type, TypeName) // Point
}

///|
test "zig: import statement" {
  let tokenizer = @zig.ZigTokenizer::new("const std = @import(\"std\");")
  let tokens = tokenizer.tokenize_all()
  let has_builtin = tokens.iter().any(fn(t) { t.token_type == Builtin })
  let has_string = tokens.iter().any(fn(t) { t.token_type == String })
  assert_true(has_builtin)
  assert_true(has_string)
}

///|
test "zig: highlight to html" {
  let source =
    #|const std = @import("std");
    #|pub fn main() void {
    #|    std.debug.print("Hello\n", .{});
    #|}
  let html = @zig.highlight_zig_to_html(source)
  assert_true(html.contains("<span"))
  assert_true(html.contains("</span>"))
}
