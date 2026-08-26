///|
/// C Tokenizer Tests

// =============================================================================
// Keyword Tests
// =============================================================================

test "c: control flow keywords" {
  let tokenizer = @c.CTokenizer::new("if else for while do switch case default")
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens.length(), 8)
  for token in tokens {
    assert_eq(token.token_type, Keyword)
  }
}

///|
test "c: jump keywords" {
  let tokenizer = @c.CTokenizer::new("break continue return goto")
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens.length(), 4)
  for token in tokens {
    assert_eq(token.token_type, Keyword)
  }
}

///|
test "c: type keywords" {
  let tokenizer = @c.CTokenizer::new("int char void float double")
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens.length(), 5)
  for token in tokens {
    assert_eq(token.token_type, TypeKeyword)
  }
}

///|
test "c: storage class" {
  let tokenizer = @c.CTokenizer::new("static extern const volatile")
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens.length(), 4)
  for token in tokens {
    assert_eq(token.token_type, StorageClass)
  }
}

// =============================================================================
// Preprocessor Tests
// =============================================================================

///|
test "c: include angle brackets" {
  let tokenizer = @c.CTokenizer::new("#include <stdio.h>")
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens[0].token_type, Preprocessor)
  assert_eq(tokens[1].token_type, Include)
}

///|
test "c: include quotes" {
  let tokenizer = @c.CTokenizer::new("#include \"myheader.h\"")
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens[0].token_type, Preprocessor)
  assert_eq(tokens[1].token_type, Include)
}

///|
test "c: define" {
  let tokenizer = @c.CTokenizer::new("#define MAX 100")
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens[0].token_type, Preprocessor)
}

///|
test "c: ifdef" {
  let tokenizer = @c.CTokenizer::new("#ifdef DEBUG")
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens[0].token_type, Preprocessor)
}

// =============================================================================
// Literal Tests
// =============================================================================

///|
test "c: decimal numbers" {
  let tokenizer = @c.CTokenizer::new("0 42 1000")
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens.length(), 3)
  for token in tokens {
    assert_eq(token.token_type, Number)
  }
}

///|
test "c: hex numbers" {
  let tokenizer = @c.CTokenizer::new("0x0 0xFF 0x1A2B")
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens.length(), 3)
  for token in tokens {
    assert_eq(token.token_type, Number)
  }
}

///|
test "c: float numbers" {
  let tokenizer = @c.CTokenizer::new("3.14 1.0 1e10 2.5e-3")
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens.length(), 4)
  for token in tokens {
    assert_eq(token.token_type, Number)
  }
}

///|
test "c: number suffixes" {
  let tokenizer = @c.CTokenizer::new("42L 42UL 3.14f 3.14F")
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens.length(), 4)
  for token in tokens {
    assert_eq(token.token_type, Number)
  }
}

///|
test "c: string literal" {
  let tokenizer = @c.CTokenizer::new("\"hello world\"")
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens.length(), 1)
  assert_eq(tokens[0].token_type, String)
}

///|
test "c: string with escapes" {
  let tokenizer = @c.CTokenizer::new("\"line1\\nline2\\ttab\"")
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens.length(), 1)
  assert_eq(tokens[0].token_type, String)
}

///|
test "c: character literal" {
  let tokenizer = @c.CTokenizer::new("'a' '\\n' '\\0'")
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
test "c: arithmetic operators" {
  let tokenizer = @c.CTokenizer::new("a + b - c * d / e % f")
  let tokens = tokenizer.tokenize_all()
  let ops = tokens.iter().filter(fn(t) { t.token_type == Operator }).collect()
  assert_eq(ops.length(), 5)
}

///|
test "c: comparison operators" {
  let tokenizer = @c.CTokenizer::new("a == b != c < d > e <= f >= g")
  let tokens = tokenizer.tokenize_all()
  let cmp = tokens.iter().filter(fn(t) { t.token_type == Comparison }).collect()
  assert_eq(cmp.length(), 6)
}

///|
test "c: logical operators" {
  let tokenizer = @c.CTokenizer::new("a && b || !c")
  let tokens = tokenizer.tokenize_all()
  let log = tokens.iter().filter(fn(t) { t.token_type == Logical }).collect()
  assert_eq(log.length(), 3)
}

///|
test "c: bitwise operators" {
  let tokenizer = @c.CTokenizer::new("a & b | c ^ d ~ e << f >> g")
  let tokens = tokenizer.tokenize_all()
  let bit = tokens.iter().filter(fn(t) { t.token_type == Bitwise }).collect()
  assert_eq(bit.length(), 6)
}

///|
test "c: assignment operators" {
  let tokenizer = @c.CTokenizer::new("a = b += c -= d *= e /= f")
  let tokens = tokenizer.tokenize_all()
  let assign = tokens
    .iter()
    .filter(fn(t) { t.token_type == Assignment })
    .collect()
  assert_eq(assign.length(), 5)
}

///|
test "c: increment decrement" {
  let tokenizer = @c.CTokenizer::new("a++ b-- ++c --d")
  let tokens = tokenizer.tokenize_all()
  let inc = tokens.iter().filter(fn(t) { t.token_type == Increment }).collect()
  assert_eq(inc.length(), 4)
}

///|
test "c: arrow operator" {
  let tokenizer = @c.CTokenizer::new("ptr->field")
  let tokens = tokenizer.tokenize_all()
  let has_arrow = tokens.iter().any(fn(t) { t.token_type == Arrow })
  assert_true(has_arrow)
}

///|
test "c: ternary operator" {
  let tokenizer = @c.CTokenizer::new("a ? b : c")
  let tokens = tokenizer.tokenize_all()
  let ternary = tokens
    .iter()
    .filter(fn(t) { t.token_type == Ternary })
    .collect()
  assert_eq(ternary.length(), 2) // ? and :
}

// =============================================================================
// Comment Tests
// =============================================================================

///|
test "c: line comment" {
  let tokenizer = @c.CTokenizer::new("// this is a comment")
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens.length(), 1)
  assert_eq(tokens[0].token_type, LineComment)
}

///|
test "c: block comment" {
  let tokenizer = @c.CTokenizer::new("/* multi\nline */")
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens.length(), 1)
  assert_eq(tokens[0].token_type, BlockComment)
}

// =============================================================================
// Punctuation Tests
// =============================================================================

///|
test "c: brackets" {
  let tokenizer = @c.CTokenizer::new("() {} []")
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
test "c: simple function" {
  let source =
    #|int main() {
    #|    return 0;
    #|}
  let tokenizer = @c.CTokenizer::new(source)
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens[0].token_type, TypeKeyword) // int
  assert_eq(tokens[1].token_type, Identifier) // main
  let has_return = tokens.iter().any(fn(t) { t.token_type == Keyword })
  assert_true(has_return)
}

///|
test "c: struct definition" {
  let source =
    #|struct Point {
    #|    int x;
    #|    int y;
    #|};
  let tokenizer = @c.CTokenizer::new(source)
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens[0].token_type, TypeKeyword) // struct
  assert_eq(tokens[1].token_type, TypeName) // Point (uppercase)
}

///|
test "c: pointer operations" {
  let source = "int *ptr = &value; *ptr = 42;"
  let tokenizer = @c.CTokenizer::new(source)
  let tokens = tokenizer.tokenize_all()
  let has_type = tokens.iter().any(fn(t) { t.token_type == TypeKeyword })
  let has_number = tokens.iter().any(fn(t) { t.token_type == Number })
  assert_true(has_type)
  assert_true(has_number)
}

///|
test "c: highlight to html" {
  let source =
    #|#include <stdio.h>
    #|int main() {
    #|    printf("Hello");
    #|    return 0;
    #|}
  let html = @c.highlight_c_to_html(source)
  assert_true(html.contains("<span"))
  assert_true(html.contains("</span>"))
}
