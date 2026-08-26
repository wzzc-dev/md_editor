///|
/// Go Tokenizer Tests

// =============================================================================
// Keyword Tests
// =============================================================================

test "go: control flow" {
  let tokenizer = @go.GoTokenizer::new(
    "if else for range return break continue",
  )
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens.length(), 7)
  for token in tokens {
    assert_eq(token.token_type, Keyword)
  }
}

///|
test "go: switch keywords" {
  let tokenizer = @go.GoTokenizer::new("switch case default fallthrough")
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens.length(), 4)
  for token in tokens {
    assert_eq(token.token_type, Keyword)
  }
}

///|
test "go: concurrency keywords" {
  let tokenizer = @go.GoTokenizer::new("go select chan defer")
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens.length(), 4)
  for token in tokens {
    assert_eq(token.token_type, Keyword)
  }
}

///|
test "go: literal keywords" {
  let tokenizer = @go.GoTokenizer::new("nil true false iota")
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens.length(), 4)
  for token in tokens {
    assert_eq(token.token_type, Keyword)
  }
}

// =============================================================================
// Declaration Keywords Tests
// =============================================================================

///|
test "go: declaration keywords" {
  let tokenizer = @go.GoTokenizer::new("func type var const package import")
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens.length(), 6)
  for token in tokens {
    assert_eq(token.token_type, DeclKeyword)
  }
}

///|
test "go: type keywords" {
  let tokenizer = @go.GoTokenizer::new("struct interface map")
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens.length(), 3)
  for token in tokens {
    assert_eq(token.token_type, DeclKeyword)
  }
}

// =============================================================================
// Type Tests
// =============================================================================

///|
test "go: integer types" {
  let tokenizer = @go.GoTokenizer::new("int int8 int16 int32 int64")
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens.length(), 5)
  for token in tokens {
    assert_eq(token.token_type, TypeKeyword)
  }
}

///|
test "go: unsigned types" {
  let tokenizer = @go.GoTokenizer::new(
    "uint uint8 uint16 uint32 uint64 uintptr",
  )
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens.length(), 6)
  for token in tokens {
    assert_eq(token.token_type, TypeKeyword)
  }
}

///|
test "go: float and complex types" {
  let tokenizer = @go.GoTokenizer::new("float32 float64 complex64 complex128")
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens.length(), 4)
  for token in tokens {
    assert_eq(token.token_type, TypeKeyword)
  }
}

///|
test "go: special types" {
  let tokenizer = @go.GoTokenizer::new("bool byte rune string error any")
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens.length(), 6)
  for token in tokens {
    assert_eq(token.token_type, TypeKeyword)
  }
}

// =============================================================================
// Literal Tests
// =============================================================================

///|
test "go: decimal numbers" {
  let tokenizer = @go.GoTokenizer::new("0 42 1_000_000")
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens.length(), 3)
  for token in tokens {
    assert_eq(token.token_type, Number)
  }
}

///|
test "go: hex numbers" {
  let tokenizer = @go.GoTokenizer::new("0x0 0xFF 0x1A_2B")
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens.length(), 3)
  for token in tokens {
    assert_eq(token.token_type, Number)
  }
}

///|
test "go: binary numbers" {
  let tokenizer = @go.GoTokenizer::new("0b0 0b1010 0b1111_0000")
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens.length(), 3)
  for token in tokens {
    assert_eq(token.token_type, Number)
  }
}

///|
test "go: octal numbers" {
  let tokenizer = @go.GoTokenizer::new("0o0 0o77 0o755")
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens.length(), 3)
  for token in tokens {
    assert_eq(token.token_type, Number)
  }
}

///|
test "go: float numbers" {
  let tokenizer = @go.GoTokenizer::new("3.14 1.0 1e10 2.5e-3")
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens.length(), 4)
  for token in tokens {
    assert_eq(token.token_type, Number)
  }
}

///|
test "go: imaginary numbers" {
  let tokenizer = @go.GoTokenizer::new("1i 3.14i 1e10i")
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens.length(), 3)
  for token in tokens {
    assert_eq(token.token_type, Number)
  }
}

///|
test "go: string literal" {
  let tokenizer = @go.GoTokenizer::new("\"hello world\"")
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens.length(), 1)
  assert_eq(tokens[0].token_type, String)
}

///|
test "go: raw string literal" {
  let tokenizer = @go.GoTokenizer::new("`raw\nstring`")
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens.length(), 1)
  assert_eq(tokens[0].token_type, String)
}

///|
test "go: rune literal" {
  let tokenizer = @go.GoTokenizer::new("'a' '\\n' '\\u0041'")
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens.length(), 3)
  for token in tokens {
    assert_eq(token.token_type, Rune)
  }
}

// =============================================================================
// Operator Tests
// =============================================================================

///|
test "go: short declaration" {
  let tokenizer = @go.GoTokenizer::new("x := 42")
  let tokens = tokenizer.tokenize_all()
  let has_assign = tokens.iter().any(fn(t) { t.token_type == Assignment })
  assert_true(has_assign)
}

///|
test "go: channel arrow" {
  let tokenizer = @go.GoTokenizer::new("ch <- value")
  let tokens = tokenizer.tokenize_all()
  let has_arrow = tokens.iter().any(fn(t) { t.token_type == Arrow })
  assert_true(has_arrow)
}

///|
test "go: comparison" {
  let tokenizer = @go.GoTokenizer::new("a == b != c < d > e <= f >= g")
  let tokens = tokenizer.tokenize_all()
  let cmp = tokens.iter().filter(fn(t) { t.token_type == Comparison }).collect()
  assert_eq(cmp.length(), 6)
}

///|
test "go: logical operators" {
  let tokenizer = @go.GoTokenizer::new("a && b || !c")
  let tokens = tokenizer.tokenize_all()
  let log = tokens.iter().filter(fn(t) { t.token_type == Logical }).collect()
  assert_eq(log.length(), 3)
}

///|
test "go: bitwise operators" {
  let tokenizer = @go.GoTokenizer::new("a & b | c ^ d &^ e << f >> g")
  let tokens = tokenizer.tokenize_all()
  let bit = tokens.iter().filter(fn(t) { t.token_type == Bitwise }).collect()
  assert_eq(bit.length(), 6)
}

///|
test "go: ellipsis" {
  let tokenizer = @go.GoTokenizer::new("args ...int")
  let tokens = tokenizer.tokenize_all()
  let has_ellipsis = tokens.iter().any(fn(t) { t.token_type == Ellipsis })
  assert_true(has_ellipsis)
}

// =============================================================================
// Comment Tests
// =============================================================================

///|
test "go: line comment" {
  let tokenizer = @go.GoTokenizer::new("// this is a comment")
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens.length(), 1)
  assert_eq(tokens[0].token_type, LineComment)
}

///|
test "go: block comment" {
  let tokenizer = @go.GoTokenizer::new("/* multi\nline */")
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens.length(), 1)
  assert_eq(tokens[0].token_type, BlockComment)
}

// =============================================================================
// Punctuation Tests
// =============================================================================

///|
test "go: brackets" {
  let tokenizer = @go.GoTokenizer::new("() {} []")
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
test "go: package declaration" {
  let tokenizer = @go.GoTokenizer::new("package main")
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens[0].token_type, DeclKeyword) // package
  assert_eq(tokens[1].token_type, Identifier) // main
}

///|
test "go: import statement" {
  let tokenizer = @go.GoTokenizer::new("import \"fmt\"")
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens[0].token_type, DeclKeyword) // import
  assert_eq(tokens[1].token_type, String) // "fmt"
}

///|
test "go: simple function" {
  let source =
    #|func main() {
    #|    fmt.Println("Hello")
    #|}
  let tokenizer = @go.GoTokenizer::new(source)
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens[0].token_type, DeclKeyword) // func
  assert_eq(tokens[1].token_type, Identifier) // main
}

///|
test "go: struct definition" {
  let source =
    #|type Point struct {
    #|    X int
    #|    Y int
    #|}
  let tokenizer = @go.GoTokenizer::new(source)
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens[0].token_type, DeclKeyword) // type
  assert_eq(tokens[1].token_type, TypeName) // Point (uppercase)
  assert_eq(tokens[2].token_type, DeclKeyword) // struct
}

///|
test "go: interface definition" {
  let source =
    #|type Reader interface {
    #|    Read(p []byte) (n int, err error)
    #|}
  let tokenizer = @go.GoTokenizer::new(source)
  let tokens = tokenizer.tokenize_all()
  assert_eq(tokens[0].token_type, DeclKeyword) // type
  assert_eq(tokens[1].token_type, TypeName) // Reader
  assert_eq(tokens[2].token_type, DeclKeyword) // interface
}

///|
test "go: goroutine and channel" {
  let source =
    #|ch := make(chan int)
    #|go func() { ch <- 42 }()
  let tokenizer = @go.GoTokenizer::new(source)
  let tokens = tokenizer.tokenize_all()
  let has_go = tokens.iter().any(fn(t) { t.token_type == Keyword })
  let has_arrow = tokens.iter().any(fn(t) { t.token_type == Arrow })
  assert_true(has_go)
  assert_true(has_arrow)
}

///|
test "go: highlight to html" {
  let source =
    #|package main
    #|
    #|import "fmt"
    #|
    #|func main() {
    #|    fmt.Println("Hello, World!")
    #|}
  let html = @go.highlight_go_to_html(source)
  assert_true(html.contains("<span"))
  assert_true(html.contains("</span>"))
}
