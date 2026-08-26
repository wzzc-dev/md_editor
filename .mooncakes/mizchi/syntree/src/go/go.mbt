///| Go Tokenizer for syntax highlighting

// =============================================================================
// Go Token Types
// =============================================================================

///|
/// Go token types
pub(all) enum GoTokenType {
  // Keywords
  Keyword // if, else, for, return, etc.
  TypeKeyword // int, string, bool, etc.
  DeclKeyword // func, type, var, const, etc.

  // Identifiers
  Identifier // variable/function names
  TypeName // user-defined types (starts with uppercase)
  PackageName // package names

  // Literals
  Number // 123, 0x1F, 3.14, 1e-10, 1i
  String // "..." or `...`
  Rune // '.'

  // Operators
  Operator // +, -, *, /, %, etc.
  Assignment // =, :=, +=, etc.
  Comparison // ==, !=, <, >, <=, >=
  Logical // &&, ||, !
  Bitwise // &, |, ^, &^, <<, >>
  Arrow // <-
  Ellipsis // ...

  // Punctuation
  Semicolon // ;
  Comma // ,
  Colon // :
  Dot // .
  ParenOpen // (
  ParenClose // )
  BraceOpen // {
  BraceClose // }
  BracketOpen // [
  BracketClose // ]

  // Comments
  LineComment // // ...
  BlockComment // /* ... */

  // Error
  Error
} derive(Eq, Show)

// =============================================================================
// Go Token
// =============================================================================

///|
/// A token produced by the Go tokenizer
pub(all) struct GoToken {
  token_type : GoTokenType
  from : Int
  to : Int
} derive(Eq, Show)

// =============================================================================
// Go Keywords
// =============================================================================

///|
fn is_keyword(word : String) -> Bool {
  match word {
    "if" | "else" | "for" | "range" | "return" | "break" | "continue" => true
    "switch" | "case" | "default" | "fallthrough" => true
    "go" | "select" | "chan" | "defer" => true
    "goto" | "nil" | "true" | "false" | "iota" => true
    _ => false
  }
}

///|
fn is_type_keyword(word : String) -> Bool {
  match word {
    "bool" | "byte" | "complex64" | "complex128" => true
    "error" | "float32" | "float64" => true
    "int" | "int8" | "int16" | "int32" | "int64" => true
    "rune" | "string" => true
    "uint" | "uint8" | "uint16" | "uint32" | "uint64" | "uintptr" => true
    "any" | "comparable" => true
    _ => false
  }
}

///|
fn is_decl_keyword(word : String) -> Bool {
  match word {
    "func" | "type" | "var" | "const" | "package" | "import" => true
    "struct" | "interface" | "map" => true
    _ => false
  }
}

// =============================================================================
// Go Tokenizer
// =============================================================================

///|
/// Go Tokenizer state
pub(all) struct GoTokenizer {
  input : String
  priv chars : Array[Char]
  priv len : Int
  priv mut pos : Int
}

///|
/// Create a new Go tokenizer
pub fn GoTokenizer::new(input : String) -> GoTokenizer {
  let chars = input.to_array()
  { input, chars, len: chars.length(), pos: 0 }
}

///|
/// Check if at end of input
pub fn GoTokenizer::at_end(self : GoTokenizer) -> Bool {
  self.pos >= self.len
}

///|
/// Peek character at offset
fn GoTokenizer::peek_at(self : GoTokenizer, offset : Int) -> Char? {
  let idx = self.pos + offset
  if idx >= 0 && idx < self.len {
    Some(self.chars[idx])
  } else {
    None
  }
}

///|
/// Check if character is whitespace
fn is_whitespace(c : Char) -> Bool {
  c == ' ' || c == '\t' || c == '\n' || c == '\r'
}

///|
/// Check if character is a digit
fn is_digit(c : Char) -> Bool {
  c >= '0' && c <= '9'
}

///|
/// Check if character is hex digit
fn is_hex_digit(c : Char) -> Bool {
  is_digit(c) || (c >= 'a' && c <= 'f') || (c >= 'A' && c <= 'F')
}

///|
/// Check if character can start an identifier
fn is_ident_start(c : Char) -> Bool {
  (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || c == '_'
}

///|
/// Check if character can continue an identifier
fn is_ident_char(c : Char) -> Bool {
  is_ident_start(c) || is_digit(c)
}

///|
/// Skip whitespace
fn GoTokenizer::skip_whitespace(self : GoTokenizer) -> Unit {
  while self.pos < self.len && is_whitespace(self.chars[self.pos]) {
    self.pos += 1
  }
}

///|
/// Read a line comment // ...
fn GoTokenizer::read_line_comment(self : GoTokenizer) -> GoToken {
  let start = self.pos
  self.pos += 2 // skip //
  while self.pos < self.len && self.chars[self.pos] != '\n' {
    self.pos += 1
  }
  { token_type: LineComment, from: start, to: self.pos }
}

///|
/// Read a block comment /* ... */
fn GoTokenizer::read_block_comment(self : GoTokenizer) -> GoToken {
  let start = self.pos
  self.pos += 2 // skip /*
  while self.pos + 1 < self.len {
    if self.chars[self.pos] == '*' && self.chars[self.pos + 1] == '/' {
      self.pos += 2
      break
    }
    self.pos += 1
  }
  { token_type: BlockComment, from: start, to: self.pos }
}

///|
/// Read a string literal "..."
fn GoTokenizer::read_string(self : GoTokenizer) -> GoToken {
  let start = self.pos
  self.pos += 1 // skip opening "
  while self.pos < self.len {
    let c = self.chars[self.pos]
    if c == '"' {
      self.pos += 1
      break
    } else if c == '\\' && self.pos + 1 < self.len {
      self.pos += 2 // skip escape
    } else if c == '\n' {
      break // unterminated
    } else {
      self.pos += 1
    }
  }
  { token_type: String, from: start, to: self.pos }
}

///|
/// Read a raw string literal `...`
fn GoTokenizer::read_raw_string(self : GoTokenizer) -> GoToken {
  let start = self.pos
  self.pos += 1 // skip opening `
  while self.pos < self.len {
    if self.chars[self.pos] == '`' {
      self.pos += 1
      break
    }
    self.pos += 1
  }
  { token_type: String, from: start, to: self.pos }
}

///|
/// Read a rune literal '.'
fn GoTokenizer::read_rune(self : GoTokenizer) -> GoToken {
  let start = self.pos
  self.pos += 1 // skip opening '
  while self.pos < self.len {
    let c = self.chars[self.pos]
    if c == '\'' {
      self.pos += 1
      break
    } else if c == '\\' && self.pos + 1 < self.len {
      self.pos += 2 // skip escape
    } else if c == '\n' {
      break // unterminated
    } else {
      self.pos += 1
    }
  }
  { token_type: Rune, from: start, to: self.pos }
}

///|
/// Read a number literal
fn GoTokenizer::read_number(self : GoTokenizer) -> GoToken {
  let start = self.pos

  // Check for hex/binary/octal
  if self.chars[self.pos] == '0' && self.pos + 1 < self.len {
    let next = self.chars[self.pos + 1]
    if next == 'x' || next == 'X' {
      self.pos += 2
      while self.pos < self.len &&
            (is_hex_digit(self.chars[self.pos]) || self.chars[self.pos] == '_') {
        self.pos += 1
      }
      return { token_type: Number, from: start, to: self.pos }
    }
    if next == 'b' || next == 'B' {
      self.pos += 2
      while self.pos < self.len &&
            (
              self.chars[self.pos] == '0' ||
              self.chars[self.pos] == '1' ||
              self.chars[self.pos] == '_'
            ) {
        self.pos += 1
      }
      return { token_type: Number, from: start, to: self.pos }
    }
    if next == 'o' || next == 'O' {
      self.pos += 2
      while self.pos < self.len {
        let c = self.chars[self.pos]
        if (c >= '0' && c <= '7') || c == '_' {
          self.pos += 1
        } else {
          break
        }
      }
      return { token_type: Number, from: start, to: self.pos }
    }
  }

  // Decimal
  while self.pos < self.len &&
        (is_digit(self.chars[self.pos]) || self.chars[self.pos] == '_') {
    self.pos += 1
  }

  // Float
  if self.pos < self.len && self.chars[self.pos] == '.' {
    if self.peek_at(1).map(is_digit).unwrap_or(false) {
      self.pos += 1
      while self.pos < self.len &&
            (is_digit(self.chars[self.pos]) || self.chars[self.pos] == '_') {
        self.pos += 1
      }
    }
  }

  // Exponent
  if self.pos < self.len &&
    (self.chars[self.pos] == 'e' || self.chars[self.pos] == 'E') {
    self.pos += 1
    if self.pos < self.len &&
      (self.chars[self.pos] == '+' || self.chars[self.pos] == '-') {
      self.pos += 1
    }
    while self.pos < self.len &&
          (is_digit(self.chars[self.pos]) || self.chars[self.pos] == '_') {
      self.pos += 1
    }
  }

  // Imaginary suffix
  if self.pos < self.len && self.chars[self.pos] == 'i' {
    self.pos += 1
  }
  { token_type: Number, from: start, to: self.pos }
}

///|
/// Read an identifier
fn GoTokenizer::read_identifier(self : GoTokenizer) -> GoToken {
  let start = self.pos
  while self.pos < self.len && is_ident_char(self.chars[self.pos]) {
    self.pos += 1
  }
  let word = String::from_array(self.chars[start:self.pos])
  if is_keyword(word) {
    { token_type: Keyword, from: start, to: self.pos }
  } else if is_type_keyword(word) {
    { token_type: TypeKeyword, from: start, to: self.pos }
  } else if is_decl_keyword(word) {
    { token_type: DeclKeyword, from: start, to: self.pos }
  } else {
    // Heuristic: exported types/functions start with uppercase
    let chars_arr = word.to_array()
    if chars_arr.length() > 0 {
      let first = chars_arr[0]
      if first >= 'A' && first <= 'Z' {
        return { token_type: TypeName, from: start, to: self.pos }
      }
    }
    { token_type: Identifier, from: start, to: self.pos }
  }
}

///|
/// Tokenize the entire input
pub fn GoTokenizer::tokenize_all(self : GoTokenizer) -> Array[GoToken] {
  let tokens : Array[GoToken] = []
  while self.pos < self.len {
    self.skip_whitespace()
    if self.pos >= self.len {
      break
    }
    let c = self.chars[self.pos]

    // Comments
    if c == '/' && self.peek_at(1) == Some('/') {
      tokens.push(self.read_line_comment())
      continue
    }
    if c == '/' && self.peek_at(1) == Some('*') {
      tokens.push(self.read_block_comment())
      continue
    }

    // String
    if c == '"' {
      tokens.push(self.read_string())
      continue
    }

    // Raw string
    if c == '`' {
      tokens.push(self.read_raw_string())
      continue
    }

    // Rune
    if c == '\'' {
      tokens.push(self.read_rune())
      continue
    }

    // Number
    if is_digit(c) ||
      (c == '.' && self.peek_at(1).map(is_digit).unwrap_or(false)) {
      tokens.push(self.read_number())
      continue
    }

    // Identifier
    if is_ident_start(c) {
      tokens.push(self.read_identifier())
      continue
    }

    // Operators and punctuation
    match c {
      '+' | '-' | '*' | '/' | '%' => {
        let start = self.pos
        self.pos += 1
        if self.pos < self.len {
          let next = self.chars[self.pos]
          if next == '=' {
            self.pos += 1
            tokens.push({ token_type: Assignment, from: start, to: self.pos })
          } else if c == '+' && next == '+' {
            self.pos += 1
            tokens.push({ token_type: Operator, from: start, to: self.pos })
          } else if c == '-' && next == '-' {
            self.pos += 1
            tokens.push({ token_type: Operator, from: start, to: self.pos })
          } else {
            tokens.push({ token_type: Operator, from: start, to: self.pos })
          }
        } else {
          tokens.push({ token_type: Operator, from: start, to: self.pos })
        }
      }
      '=' => {
        let start = self.pos
        self.pos += 1
        if self.pos < self.len && self.chars[self.pos] == '=' {
          self.pos += 1
          tokens.push({ token_type: Comparison, from: start, to: self.pos })
        } else {
          tokens.push({ token_type: Assignment, from: start, to: self.pos })
        }
      }
      ':' => {
        let start = self.pos
        self.pos += 1
        if self.pos < self.len && self.chars[self.pos] == '=' {
          self.pos += 1
          tokens.push({ token_type: Assignment, from: start, to: self.pos })
        } else {
          tokens.push({ token_type: Colon, from: start, to: self.pos })
        }
      }
      '!' => {
        let start = self.pos
        self.pos += 1
        if self.pos < self.len && self.chars[self.pos] == '=' {
          self.pos += 1
          tokens.push({ token_type: Comparison, from: start, to: self.pos })
        } else {
          tokens.push({ token_type: Logical, from: start, to: self.pos })
        }
      }
      '<' => {
        let start = self.pos
        self.pos += 1
        if self.pos < self.len {
          let next = self.chars[self.pos]
          if next == '=' {
            self.pos += 1
            tokens.push({ token_type: Comparison, from: start, to: self.pos })
          } else if next == '<' {
            self.pos += 1
            if self.pos < self.len && self.chars[self.pos] == '=' {
              self.pos += 1
              tokens.push({ token_type: Assignment, from: start, to: self.pos })
            } else {
              tokens.push({ token_type: Bitwise, from: start, to: self.pos })
            }
          } else if next == '-' {
            self.pos += 1
            tokens.push({ token_type: Arrow, from: start, to: self.pos })
          } else {
            tokens.push({ token_type: Comparison, from: start, to: self.pos })
          }
        } else {
          tokens.push({ token_type: Comparison, from: start, to: self.pos })
        }
      }
      '>' => {
        let start = self.pos
        self.pos += 1
        if self.pos < self.len {
          let next = self.chars[self.pos]
          if next == '=' {
            self.pos += 1
            tokens.push({ token_type: Comparison, from: start, to: self.pos })
          } else if next == '>' {
            self.pos += 1
            if self.pos < self.len && self.chars[self.pos] == '=' {
              self.pos += 1
              tokens.push({ token_type: Assignment, from: start, to: self.pos })
            } else {
              tokens.push({ token_type: Bitwise, from: start, to: self.pos })
            }
          } else {
            tokens.push({ token_type: Comparison, from: start, to: self.pos })
          }
        } else {
          tokens.push({ token_type: Comparison, from: start, to: self.pos })
        }
      }
      '&' => {
        let start = self.pos
        self.pos += 1
        if self.pos < self.len {
          let next = self.chars[self.pos]
          if next == '&' {
            self.pos += 1
            tokens.push({ token_type: Logical, from: start, to: self.pos })
          } else if next == '=' {
            self.pos += 1
            tokens.push({ token_type: Assignment, from: start, to: self.pos })
          } else if next == '^' {
            self.pos += 1
            if self.pos < self.len && self.chars[self.pos] == '=' {
              self.pos += 1
              tokens.push({ token_type: Assignment, from: start, to: self.pos })
            } else {
              tokens.push({ token_type: Bitwise, from: start, to: self.pos })
            }
          } else {
            tokens.push({ token_type: Bitwise, from: start, to: self.pos })
          }
        } else {
          tokens.push({ token_type: Bitwise, from: start, to: self.pos })
        }
      }
      '|' => {
        let start = self.pos
        self.pos += 1
        if self.pos < self.len {
          let next = self.chars[self.pos]
          if next == '|' {
            self.pos += 1
            tokens.push({ token_type: Logical, from: start, to: self.pos })
          } else if next == '=' {
            self.pos += 1
            tokens.push({ token_type: Assignment, from: start, to: self.pos })
          } else {
            tokens.push({ token_type: Bitwise, from: start, to: self.pos })
          }
        } else {
          tokens.push({ token_type: Bitwise, from: start, to: self.pos })
        }
      }
      '^' => {
        let start = self.pos
        self.pos += 1
        if self.pos < self.len && self.chars[self.pos] == '=' {
          self.pos += 1
          tokens.push({ token_type: Assignment, from: start, to: self.pos })
        } else {
          tokens.push({ token_type: Bitwise, from: start, to: self.pos })
        }
      }
      '.' => {
        let start = self.pos
        self.pos += 1
        if self.pos + 1 < self.len &&
          self.chars[self.pos] == '.' &&
          self.chars[self.pos + 1] == '.' {
          self.pos += 2
          tokens.push({ token_type: Ellipsis, from: start, to: self.pos })
        } else {
          tokens.push({ token_type: Dot, from: start, to: self.pos })
        }
      }
      ';' => {
        let start = self.pos
        self.pos += 1
        tokens.push({ token_type: Semicolon, from: start, to: self.pos })
      }
      ',' => {
        let start = self.pos
        self.pos += 1
        tokens.push({ token_type: Comma, from: start, to: self.pos })
      }
      '(' => {
        let start = self.pos
        self.pos += 1
        tokens.push({ token_type: ParenOpen, from: start, to: self.pos })
      }
      ')' => {
        let start = self.pos
        self.pos += 1
        tokens.push({ token_type: ParenClose, from: start, to: self.pos })
      }
      '{' => {
        let start = self.pos
        self.pos += 1
        tokens.push({ token_type: BraceOpen, from: start, to: self.pos })
      }
      '}' => {
        let start = self.pos
        self.pos += 1
        tokens.push({ token_type: BraceClose, from: start, to: self.pos })
      }
      '[' => {
        let start = self.pos
        self.pos += 1
        tokens.push({ token_type: BracketOpen, from: start, to: self.pos })
      }
      ']' => {
        let start = self.pos
        self.pos += 1
        tokens.push({ token_type: BracketClose, from: start, to: self.pos })
      }
      _ => {
        let start = self.pos
        self.pos += 1
        tokens.push({ token_type: Error, from: start, to: self.pos })
      }
    }
  }
  tokens
}
