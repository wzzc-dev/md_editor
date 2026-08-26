///| Zig Tokenizer for syntax highlighting

// =============================================================================
// Zig Token Types
// =============================================================================

///|
/// Zig token types
pub(all) enum ZigTokenType {
  // Keywords
  Keyword // if, else, while, for, return, etc.
  TypeKeyword // u8, i32, bool, void, etc.
  Builtin // @import, @compileError, etc.

  // Identifiers
  Identifier // variable/function names
  TypeName // user-defined types (starts with uppercase)

  // Literals
  Number // 123, 0x1F, 0b1010, 3.14
  String // "..."
  MultilineString // \\...
  Char // '.'

  // Operators
  Operator // +, -, *, /, etc.
  Assignment // =
  Comparison // ==, !=, <, >, <=, >=
  Arrow // =>
  Optional // ?
  ErrorUnion // !
  Pointer // *, [*], [*:0]
  Range // ..

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
  Pipe // |

  // Comments
  LineComment // // ...
  DocComment // /// ...

  // Error
  Error
} derive(Eq, Show)

// =============================================================================
// Zig Token
// =============================================================================

///|
/// A token produced by the Zig tokenizer
pub(all) struct ZigToken {
  token_type : ZigTokenType
  from : Int
  to : Int
} derive(Eq, Show)

// =============================================================================
// Zig Keywords
// =============================================================================

///|
fn is_keyword(word : String) -> Bool {
  match word {
    "if" | "else" | "while" | "for" | "return" | "break" | "continue" => true
    "switch" | "fn" | "pub" | "const" | "var" | "comptime" | "inline" => true
    "struct" | "enum" | "union" | "error" | "opaque" => true
    "try" | "catch" | "defer" | "errdefer" | "orelse" => true
    "and" | "or" | "unreachable" | "undefined" | "null" => true
    "true" | "false" | "test" | "export" | "extern" | "packed" => true
    "threadlocal"
    | "linksection"
    | "align"
    | "nosuspend"
    | "suspend"
    | "resume" => true
    "async" | "await" | "anyframe" | "asm" | "volatile" => true
    "allowzero" | "noalias" | "usingnamespace" => true
    _ => false
  }
}

///|
fn is_type_keyword(word : String) -> Bool {
  match word {
    "void"
    | "bool"
    | "noreturn"
    | "type"
    | "anytype"
    | "anyerror"
    | "anyopaque" => true
    "u8" | "u16" | "u32" | "u64" | "u128" | "usize" => true
    "i8" | "i16" | "i32" | "i64" | "i128" | "isize" => true
    "f16" | "f32" | "f64" | "f80" | "f128" => true
    "c_char" | "c_short" | "c_ushort" | "c_int" | "c_uint" => true
    "c_long" | "c_ulong" | "c_longlong" | "c_ulonglong" | "c_longdouble" => true
    "comptime_int" | "comptime_float" => true
    _ => false
  }
}

// =============================================================================
// Zig Tokenizer
// =============================================================================

///|
/// Zig Tokenizer state
pub(all) struct ZigTokenizer {
  input : String
  priv chars : Array[Char]
  priv len : Int
  priv mut pos : Int
}

///|
/// Create a new Zig tokenizer
pub fn ZigTokenizer::new(input : String) -> ZigTokenizer {
  let chars = input.to_array()
  { input, chars, len: chars.length(), pos: 0 }
}

///|
/// Check if at end of input
pub fn ZigTokenizer::at_end(self : ZigTokenizer) -> Bool {
  self.pos >= self.len
}

///|
/// Peek character at offset
fn ZigTokenizer::peek_at(self : ZigTokenizer, offset : Int) -> Char? {
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
fn ZigTokenizer::skip_whitespace(self : ZigTokenizer) -> Unit {
  while self.pos < self.len && is_whitespace(self.chars[self.pos]) {
    self.pos += 1
  }
}

///|
/// Read a line comment // ...
fn ZigTokenizer::read_line_comment(self : ZigTokenizer) -> ZigToken {
  let start = self.pos
  self.pos += 2 // skip //
  // Check for doc comment ///
  let is_doc = self.pos < self.len && self.chars[self.pos] == '/'
  if is_doc {
    self.pos += 1
  }
  while self.pos < self.len && self.chars[self.pos] != '\n' {
    self.pos += 1
  }
  {
    token_type: if is_doc {
      DocComment
    } else {
      LineComment
    },
    from: start,
    to: self.pos,
  }
}

///|
/// Read a string literal "..."
fn ZigTokenizer::read_string(self : ZigTokenizer) -> ZigToken {
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
/// Read a multiline string \\...
fn ZigTokenizer::read_multiline_string(self : ZigTokenizer) -> ZigToken {
  let start = self.pos
  self.pos += 2 // skip \\
  while self.pos < self.len && self.chars[self.pos] != '\n' {
    self.pos += 1
  }
  { token_type: MultilineString, from: start, to: self.pos }
}

///|
/// Read a character literal '.'
fn ZigTokenizer::read_char(self : ZigTokenizer) -> ZigToken {
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
fn ZigTokenizer::read_number(self : ZigTokenizer) -> ZigToken {
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
  { token_type: Number, from: start, to: self.pos }
}

///|
/// Read an identifier
fn ZigTokenizer::read_identifier(self : ZigTokenizer) -> ZigToken {
  let start = self.pos
  while self.pos < self.len && is_ident_char(self.chars[self.pos]) {
    self.pos += 1
  }
  let word = String::from_array(self.chars[start:self.pos])
  if is_keyword(word) {
    { token_type: Keyword, from: start, to: self.pos }
  } else if is_type_keyword(word) {
    { token_type: TypeKeyword, from: start, to: self.pos }
  } else {
    // Heuristic: types start with uppercase
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
/// Read a builtin @name
fn ZigTokenizer::read_builtin(self : ZigTokenizer) -> ZigToken {
  let start = self.pos
  self.pos += 1 // skip @
  while self.pos < self.len && is_ident_char(self.chars[self.pos]) {
    self.pos += 1
  }
  { token_type: Builtin, from: start, to: self.pos }
}

///|
/// Tokenize the entire input
pub fn ZigTokenizer::tokenize_all(self : ZigTokenizer) -> Array[ZigToken] {
  let tokens : Array[ZigToken] = []
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

    // Multiline string
    if c == '\\' && self.peek_at(1) == Some('\\') {
      tokens.push(self.read_multiline_string())
      continue
    }

    // String
    if c == '"' {
      tokens.push(self.read_string())
      continue
    }

    // Char
    if c == '\'' {
      tokens.push(self.read_char())
      continue
    }

    // Builtin
    if c == '@' {
      tokens.push(self.read_builtin())
      continue
    }

    // Number
    if is_digit(c) {
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
        if self.pos < self.len && self.chars[self.pos] == '=' {
          self.pos += 1
        }
        tokens.push({ token_type: Operator, from: start, to: self.pos })
      }
      '=' => {
        let start = self.pos
        self.pos += 1
        if self.pos < self.len {
          let next = self.chars[self.pos]
          if next == '=' {
            self.pos += 1
            tokens.push({ token_type: Comparison, from: start, to: self.pos })
          } else if next == '>' {
            self.pos += 1
            tokens.push({ token_type: Arrow, from: start, to: self.pos })
          } else {
            tokens.push({ token_type: Assignment, from: start, to: self.pos })
          }
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
          tokens.push({ token_type: ErrorUnion, from: start, to: self.pos })
        }
      }
      '<' | '>' => {
        let start = self.pos
        let ch = c
        self.pos += 1
        if self.pos < self.len && self.chars[self.pos] == '=' {
          self.pos += 1
        } else if self.pos < self.len && self.chars[self.pos] == ch {
          self.pos += 1
          if self.pos < self.len && self.chars[self.pos] == '=' {
            self.pos += 1
          }
        }
        tokens.push({ token_type: Comparison, from: start, to: self.pos })
      }
      '?' => {
        let start = self.pos
        self.pos += 1
        tokens.push({ token_type: Optional, from: start, to: self.pos })
      }
      '.' => {
        let start = self.pos
        self.pos += 1
        if self.pos < self.len && self.chars[self.pos] == '.' {
          self.pos += 1
          if self.pos < self.len && self.chars[self.pos] == '.' {
            self.pos += 1
          }
          tokens.push({ token_type: Range, from: start, to: self.pos })
        } else if self.pos < self.len && self.chars[self.pos] == '*' {
          self.pos += 1
          tokens.push({ token_type: Pointer, from: start, to: self.pos })
        } else {
          tokens.push({ token_type: Dot, from: start, to: self.pos })
        }
      }
      '&' | '~' | '^' => {
        let start = self.pos
        self.pos += 1
        if self.pos < self.len && self.chars[self.pos] == '=' {
          self.pos += 1
        }
        tokens.push({ token_type: Operator, from: start, to: self.pos })
      }
      '|' => {
        let start = self.pos
        self.pos += 1
        if self.pos < self.len && self.chars[self.pos] == '|' {
          self.pos += 1
        } else if self.pos < self.len && self.chars[self.pos] == '=' {
          self.pos += 1
        }
        tokens.push({ token_type: Pipe, from: start, to: self.pos })
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
      ':' => {
        let start = self.pos
        self.pos += 1
        tokens.push({ token_type: Colon, from: start, to: self.pos })
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
        // Check for [*] or [*:0] etc
        if self.pos < self.len && self.chars[self.pos] == '*' {
          self.pos += 1
          while self.pos < self.len && self.chars[self.pos] != ']' {
            self.pos += 1
          }
          if self.pos < self.len {
            self.pos += 1
          }
          tokens.push({ token_type: Pointer, from: start, to: self.pos })
        } else {
          tokens.push({ token_type: BracketOpen, from: start, to: self.pos })
        }
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
