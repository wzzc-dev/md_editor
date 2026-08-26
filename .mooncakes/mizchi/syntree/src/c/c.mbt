///| C Tokenizer for syntax highlighting

// =============================================================================
// C Token Types
// =============================================================================

///|
/// C token types
pub(all) enum CTokenType {
  // Keywords
  Keyword // if, else, for, while, return, etc.
  TypeKeyword // int, char, void, struct, enum, etc.
  StorageClass // static, extern, const, volatile, etc.

  // Identifiers
  Identifier // variable/function names
  TypeName // user-defined types (heuristic: starts with uppercase or _t suffix)

  // Literals
  Number // 123, 0x1F, 3.14, 1e-10
  String // "..."
  Char // '.'

  // Preprocessor
  Preprocessor // #include, #define, #ifdef, etc.
  Include // <...> or "..." after #include

  // Operators
  Operator // +, -, *, /, %, etc.
  Assignment // =, +=, -=, etc.
  Comparison // ==, !=, <, >, <=, >=
  Logical // &&, ||, !
  Bitwise // &, |, ^, ~, <<, >>
  Arrow // ->
  Dot // .
  Increment // ++, --
  Ternary // ?, :

  // Punctuation
  Semicolon // ;
  Comma // ,
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
// C Token
// =============================================================================

///|
/// A token produced by the C tokenizer
pub(all) struct CToken {
  token_type : CTokenType
  from : Int
  to : Int
} derive(Eq, Show)

// =============================================================================
// C Keywords
// =============================================================================

///|
fn is_keyword(word : String) -> Bool {
  match word {
    "if" | "else" | "for" | "while" | "do" | "switch" | "case" | "default" =>
      true
    "break" | "continue" | "return" | "goto" => true
    "sizeof" | "typeof" | "_Alignof" | "_Generic" => true
    _ => false
  }
}

///|
fn is_type_keyword(word : String) -> Bool {
  match word {
    "void" | "char" | "short" | "int" | "long" | "float" | "double" => true
    "signed" | "unsigned" => true
    "struct" | "union" | "enum" | "typedef" => true
    "_Bool" | "_Complex" | "_Imaginary" => true
    "bool" | "true" | "false" => true // C99/C23
    "size_t" | "ptrdiff_t" | "intptr_t" | "uintptr_t" => true
    "int8_t" | "int16_t" | "int32_t" | "int64_t" => true
    "uint8_t" | "uint16_t" | "uint32_t" | "uint64_t" => true
    "NULL" => true
    _ => false
  }
}

///|
fn is_storage_class(word : String) -> Bool {
  match word {
    "auto" | "register" | "static" | "extern" | "inline" => true
    "const" | "volatile" | "restrict" => true
    "_Thread_local" | "_Atomic" | "_Noreturn" => true
    _ => false
  }
}

// =============================================================================
// C Tokenizer
// =============================================================================

///|
/// C Tokenizer state
pub(all) struct CTokenizer {
  input : String
  priv chars : Array[Char]
  priv len : Int
  priv mut pos : Int
}

///|
/// Create a new C tokenizer
pub fn CTokenizer::new(input : String) -> CTokenizer {
  let chars = input.to_array()
  { input, chars, len: chars.length(), pos: 0 }
}

///|
/// Check if at end of input
pub fn CTokenizer::at_end(self : CTokenizer) -> Bool {
  self.pos >= self.len
}

///|
/// Peek character at offset
fn CTokenizer::peek_at(self : CTokenizer, offset : Int) -> Char? {
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
fn CTokenizer::skip_whitespace(self : CTokenizer) -> Unit {
  while self.pos < self.len && is_whitespace(self.chars[self.pos]) {
    self.pos += 1
  }
}

///|
/// Read a line comment // ...
fn CTokenizer::read_line_comment(self : CTokenizer) -> CToken {
  let start = self.pos
  self.pos += 2 // skip //
  while self.pos < self.len && self.chars[self.pos] != '\n' {
    self.pos += 1
  }
  { token_type: LineComment, from: start, to: self.pos }
}

///|
/// Read a block comment /* ... */
fn CTokenizer::read_block_comment(self : CTokenizer) -> CToken {
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
fn CTokenizer::read_string(self : CTokenizer) -> CToken {
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
/// Read a character literal '.'
fn CTokenizer::read_char(self : CTokenizer) -> CToken {
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
  { token_type: Char, from: start, to: self.pos }
}

///|
/// Read a number literal
fn CTokenizer::read_number(self : CTokenizer) -> CToken {
  let start = self.pos

  // Check for hex
  if self.chars[self.pos] == '0' && self.pos + 1 < self.len {
    let next = self.chars[self.pos + 1]
    if next == 'x' || next == 'X' {
      self.pos += 2
      while self.pos < self.len && is_hex_digit(self.chars[self.pos]) {
        self.pos += 1
      }
      // suffix
      while self.pos < self.len {
        let c = self.chars[self.pos]
        if c == 'u' || c == 'U' || c == 'l' || c == 'L' {
          self.pos += 1
        } else {
          break
        }
      }
      return { token_type: Number, from: start, to: self.pos }
    }
    // binary
    if next == 'b' || next == 'B' {
      self.pos += 2
      while self.pos < self.len &&
            (self.chars[self.pos] == '0' || self.chars[self.pos] == '1') {
        self.pos += 1
      }
      return { token_type: Number, from: start, to: self.pos }
    }
  }

  // Decimal or octal
  while self.pos < self.len && is_digit(self.chars[self.pos]) {
    self.pos += 1
  }

  // Float
  if self.pos < self.len && self.chars[self.pos] == '.' {
    self.pos += 1
    while self.pos < self.len && is_digit(self.chars[self.pos]) {
      self.pos += 1
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
    while self.pos < self.len && is_digit(self.chars[self.pos]) {
      self.pos += 1
    }
  }

  // Suffix
  while self.pos < self.len {
    let c = self.chars[self.pos]
    if c == 'f' || c == 'F' || c == 'l' || c == 'L' || c == 'u' || c == 'U' {
      self.pos += 1
    } else {
      break
    }
  }
  { token_type: Number, from: start, to: self.pos }
}

///|
/// Read an identifier
fn CTokenizer::read_identifier(self : CTokenizer) -> CToken {
  let start = self.pos
  while self.pos < self.len && is_ident_char(self.chars[self.pos]) {
    self.pos += 1
  }
  let word = String::from_array(self.chars[start:self.pos])
  if is_keyword(word) {
    { token_type: Keyword, from: start, to: self.pos }
  } else if is_type_keyword(word) {
    { token_type: TypeKeyword, from: start, to: self.pos }
  } else if is_storage_class(word) {
    { token_type: StorageClass, from: start, to: self.pos }
  } else {
    // Heuristic: types often start with uppercase or end with _t
    let chars_arr = word.to_array()
    if chars_arr.length() > 0 {
      let first = chars_arr[0]
      if (first >= 'A' && first <= 'Z') || word.has_suffix("_t") {
        return { token_type: TypeName, from: start, to: self.pos }
      }
    }
    { token_type: Identifier, from: start, to: self.pos }
  }
}

///|
/// Read a preprocessor directive
fn CTokenizer::read_preprocessor(self : CTokenizer) -> Array[CToken] {
  let tokens : Array[CToken] = []
  let start = self.pos
  self.pos += 1 // skip #

  // Skip whitespace
  while self.pos < self.len &&
        (self.chars[self.pos] == ' ' || self.chars[self.pos] == '\t') {
    self.pos += 1
  }

  // Read directive name
  let dir_start = self.pos
  while self.pos < self.len && is_ident_char(self.chars[self.pos]) {
    self.pos += 1
  }
  let directive = String::from_array(self.chars[dir_start:self.pos])
  tokens.push({ token_type: Preprocessor, from: start, to: self.pos })

  // Handle #include specially
  if directive == "include" {
    // Skip whitespace
    while self.pos < self.len &&
          (self.chars[self.pos] == ' ' || self.chars[self.pos] == '\t') {
      self.pos += 1
    }
    if self.pos < self.len {
      let inc_start = self.pos
      let c = self.chars[self.pos]
      if c == '<' {
        self.pos += 1
        while self.pos < self.len &&
              self.chars[self.pos] != '>' &&
              self.chars[self.pos] != '\n' {
          self.pos += 1
        }
        if self.pos < self.len && self.chars[self.pos] == '>' {
          self.pos += 1
        }
        tokens.push({ token_type: Include, from: inc_start, to: self.pos })
      } else if c == '"' {
        self.pos += 1
        while self.pos < self.len &&
              self.chars[self.pos] != '"' &&
              self.chars[self.pos] != '\n' {
          self.pos += 1
        }
        if self.pos < self.len && self.chars[self.pos] == '"' {
          self.pos += 1
        }
        tokens.push({ token_type: Include, from: inc_start, to: self.pos })
      }
    }
  }

  // Skip rest of line (handling line continuations)
  while self.pos < self.len {
    if self.chars[self.pos] == '\n' {
      break
    }
    if self.chars[self.pos] == '\\' && self.peek_at(1) == Some('\n') {
      self.pos += 2
      continue
    }
    self.pos += 1
  }
  tokens
}

///|
/// Tokenize the entire input
pub fn CTokenizer::tokenize_all(self : CTokenizer) -> Array[CToken] {
  let tokens : Array[CToken] = []
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

    // Preprocessor
    if c == '#' {
      for tok in self.read_preprocessor() {
        tokens.push(tok)
      }
      continue
    }

    // String
    if c == '"' {
      tokens.push(self.read_string())
      continue
    }
    // Wide string
    if c == 'L' && self.peek_at(1) == Some('"') {
      self.pos += 1
      tokens.push(self.read_string())
      continue
    }

    // Char
    if c == '\'' {
      tokens.push(self.read_char())
      continue
    }
    // Wide char
    if c == 'L' && self.peek_at(1) == Some('\'') {
      self.pos += 1
      tokens.push(self.read_char())
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
      '+' => {
        let start = self.pos
        self.pos += 1
        if self.pos < self.len {
          let next = self.chars[self.pos]
          if next == '+' {
            self.pos += 1
            tokens.push({ token_type: Increment, from: start, to: self.pos })
          } else if next == '=' {
            self.pos += 1
            tokens.push({ token_type: Assignment, from: start, to: self.pos })
          } else {
            tokens.push({ token_type: Operator, from: start, to: self.pos })
          }
        } else {
          tokens.push({ token_type: Operator, from: start, to: self.pos })
        }
      }
      '-' => {
        let start = self.pos
        self.pos += 1
        if self.pos < self.len {
          let next = self.chars[self.pos]
          if next == '-' {
            self.pos += 1
            tokens.push({ token_type: Increment, from: start, to: self.pos })
          } else if next == '=' {
            self.pos += 1
            tokens.push({ token_type: Assignment, from: start, to: self.pos })
          } else if next == '>' {
            self.pos += 1
            tokens.push({ token_type: Arrow, from: start, to: self.pos })
          } else {
            tokens.push({ token_type: Operator, from: start, to: self.pos })
          }
        } else {
          tokens.push({ token_type: Operator, from: start, to: self.pos })
        }
      }
      '*' | '/' | '%' => {
        let start = self.pos
        self.pos += 1
        if self.pos < self.len && self.chars[self.pos] == '=' {
          self.pos += 1
          tokens.push({ token_type: Assignment, from: start, to: self.pos })
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
      '~' => {
        let start = self.pos
        self.pos += 1
        tokens.push({ token_type: Bitwise, from: start, to: self.pos })
      }
      '?' => {
        let start = self.pos
        self.pos += 1
        tokens.push({ token_type: Ternary, from: start, to: self.pos })
      }
      ':' => {
        let start = self.pos
        self.pos += 1
        tokens.push({ token_type: Ternary, from: start, to: self.pos })
      }
      '.' => {
        let start = self.pos
        self.pos += 1
        if self.pos + 1 < self.len &&
          self.chars[self.pos] == '.' &&
          self.chars[self.pos + 1] == '.' {
          self.pos += 2
          tokens.push({ token_type: Operator, from: start, to: self.pos }) // ...
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
