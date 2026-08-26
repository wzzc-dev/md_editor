///|
/// C# Tokenizer
pub(all) enum CsharpTokenType {
  Keyword
  ContextKeyword
  Modifier
  String
  VerbatimString
  InterpolatedString
  Char
  Number
  Bool
  Null
  Identifier
  TypeKeyword
  TypeName
  Attribute
  Preprocessor
  Operator
  Comparison
  Assignment
  Logical
  Bitwise
  Increment
  NullCoalesce
  NullConditional
  Arrow
  Lambda
  ParenOpen
  ParenClose
  BracketOpen
  BracketClose
  BraceOpen
  BraceClose
  Comma
  Semicolon
  Colon
  Dot
  LineComment
  BlockComment
  DocComment
  Whitespace
  Newline
  Unknown
} derive(Eq, Show)

///|
pub(all) struct CsharpToken {
  token_type : CsharpTokenType
  from : Int
  to : Int
} derive(Eq, Show)

///|
pub(all) struct CsharpTokenizer {
  input : String
  priv chars : Array[Char]
  priv len : Int
  priv mut pos : Int
}

///|
let csharp_keywords : Array[String] = [
  "if", "else", "switch", "case", "default", "for", "foreach", "while", "do", "break",
  "continue", "return", "throw", "try", "catch", "finally", "goto", "new", "typeof",
  "sizeof", "nameof", "is", "as", "in", "out", "ref", "params", "this", "base", "class",
  "struct", "interface", "enum", "delegate", "event", "namespace", "using", "true",
  "false", "null", "checked", "unchecked", "lock", "fixed", "stackalloc", "unsafe",
  "operator", "implicit", "explicit",
]

///|
let csharp_context_keywords : Array[String] = [
  "var", "dynamic", "async", "await", "yield", "get", "set", "init", "add", "remove",
  "value", "global", "alias", "partial", "where", "when", "from", "select", "orderby",
  "ascending", "descending", "group", "by", "into", "join", "on", "equals", "let",
  "record", "with", "required", "file", "scoped",
]

///|
let csharp_modifiers : Array[String] = [
  "public", "private", "protected", "internal", "static", "readonly", "const", "volatile",
  "virtual", "override", "abstract", "sealed", "extern", "new",
]

///|
let csharp_type_keywords : Array[String] = [
  "void", "bool", "byte", "sbyte", "char", "short", "ushort", "int", "uint", "long",
  "ulong", "float", "double", "decimal", "string", "object", "nint", "nuint",
]

///|
pub fn CsharpTokenizer::new(input : String) -> CsharpTokenizer {
  let chars = input.to_array()
  { input, chars, len: chars.length(), pos: 0 }
}

///|
fn CsharpTokenizer::peek_at(self : CsharpTokenizer, offset : Int) -> Char? {
  let idx = self.pos + offset
  if idx >= 0 && idx < self.len {
    Some(self.chars[idx])
  } else {
    None
  }
}

///|
fn is_id_start(c : Char) -> Bool {
  (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || c == '_' || c == '@'
}

///|
fn is_id_continue(c : Char) -> Bool {
  (c >= 'a' && c <= 'z') ||
  (c >= 'A' && c <= 'Z') ||
  (c >= '0' && c <= '9') ||
  c == '_'
}

///|
fn is_digit(c : Char) -> Bool {
  c >= '0' && c <= '9'
}

///|
fn CsharpTokenizer::read_string(self : CsharpTokenizer) -> CsharpToken {
  let start = self.pos
  self.pos += 1
  while self.pos < self.len {
    let c = self.chars[self.pos]
    if c == '\\' {
      self.pos += 2
    } else if c == '"' {
      self.pos += 1
      break
    } else {
      self.pos += 1
    }
  }
  { token_type: String, from: start, to: self.pos }
}

///|
fn CsharpTokenizer::read_verbatim_string(self : CsharpTokenizer) -> CsharpToken {
  let start = self.pos
  self.pos += 2 // skip @"
  while self.pos < self.len {
    let c = self.chars[self.pos]
    if c == '"' {
      self.pos += 1
      if self.pos < self.len && self.chars[self.pos] == '"' {
        self.pos += 1 // escaped quote
      } else {
        break
      }
    } else {
      self.pos += 1
    }
  }
  { token_type: VerbatimString, from: start, to: self.pos }
}

///|
fn CsharpTokenizer::read_interpolated_string(
  self : CsharpTokenizer,
) -> CsharpToken {
  let start = self.pos
  self.pos += 2 // skip $"
  while self.pos < self.len {
    let c = self.chars[self.pos]
    if c == '\\' {
      self.pos += 2
    } else if c == '"' {
      self.pos += 1
      break
    } else if c == '{' {
      // Skip interpolation
      self.pos += 1
      let mut depth = 1
      while self.pos < self.len && depth > 0 {
        if self.chars[self.pos] == '{' {
          depth += 1
        } else if self.chars[self.pos] == '}' {
          depth -= 1
        }
        self.pos += 1
      }
    } else {
      self.pos += 1
    }
  }
  { token_type: InterpolatedString, from: start, to: self.pos }
}

///|
fn CsharpTokenizer::read_char(self : CsharpTokenizer) -> CsharpToken {
  let start = self.pos
  self.pos += 1
  if self.pos < self.len && self.chars[self.pos] == '\\' {
    self.pos += 2
  } else if self.pos < self.len {
    self.pos += 1
  }
  if self.pos < self.len && self.chars[self.pos] == '\'' {
    self.pos += 1
  }
  { token_type: Char, from: start, to: self.pos }
}

///|
fn CsharpTokenizer::read_number(self : CsharpTokenizer) -> CsharpToken {
  let start = self.pos
  if self.chars[self.pos] == '0' && self.pos + 1 < self.len {
    let next = self.chars[self.pos + 1]
    if next == 'x' || next == 'X' {
      self.pos += 2
      while self.pos < self.len {
        let c = self.chars[self.pos]
        if (c >= '0' && c <= '9') ||
          (c >= 'a' && c <= 'f') ||
          (c >= 'A' && c <= 'F') ||
          c == '_' {
          self.pos += 1
        } else {
          break
        }
      }
      self.read_number_suffix()
      return { token_type: Number, from: start, to: self.pos }
    } else if next == 'b' || next == 'B' {
      self.pos += 2
      while self.pos < self.len {
        let c = self.chars[self.pos]
        if c == '0' || c == '1' || c == '_' {
          self.pos += 1
        } else {
          break
        }
      }
      self.read_number_suffix()
      return { token_type: Number, from: start, to: self.pos }
    }
  }
  while self.pos < self.len &&
        (is_digit(self.chars[self.pos]) || self.chars[self.pos] == '_') {
    self.pos += 1
  }
  if self.pos < self.len &&
    self.chars[self.pos] == '.' &&
    self.pos + 1 < self.len &&
    is_digit(self.chars[self.pos + 1]) {
    self.pos += 1
    while self.pos < self.len &&
          (is_digit(self.chars[self.pos]) || self.chars[self.pos] == '_') {
      self.pos += 1
    }
  }
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
  self.read_number_suffix()
  { token_type: Number, from: start, to: self.pos }
}

///|
fn CsharpTokenizer::read_number_suffix(self : CsharpTokenizer) -> Unit {
  while self.pos < self.len {
    let c = self.chars[self.pos]
    if c == 'u' ||
      c == 'U' ||
      c == 'l' ||
      c == 'L' ||
      c == 'f' ||
      c == 'F' ||
      c == 'd' ||
      c == 'D' ||
      c == 'm' ||
      c == 'M' {
      self.pos += 1
    } else {
      break
    }
  }
}

///|
fn CsharpTokenizer::read_identifier(self : CsharpTokenizer) -> CsharpToken {
  let start = self.pos
  let has_at = self.chars[self.pos] == '@'
  if has_at {
    self.pos += 1
  }
  let first = if self.pos < self.len { self.chars[self.pos] } else { '_' }
  while self.pos < self.len && is_id_continue(self.chars[self.pos]) {
    self.pos += 1
  }
  let value_start = if has_at { start + 1 } else { start }
  let value = String::from_array(self.chars[value_start:self.pos])
  let token_type = if has_at {
    Identifier
  } else if value == "true" || value == "false" {
    Bool
  } else if value == "null" {
    Null
  } else if csharp_keywords.contains(value) {
    Keyword
  } else if csharp_context_keywords.contains(value) {
    ContextKeyword
  } else if csharp_modifiers.contains(value) {
    Modifier
  } else if csharp_type_keywords.contains(value) {
    TypeKeyword
  } else if first >= 'A' && first <= 'Z' {
    TypeName
  } else {
    Identifier
  }
  { token_type, from: start, to: self.pos }
}

///|
fn CsharpTokenizer::read_preprocessor(self : CsharpTokenizer) -> CsharpToken {
  let start = self.pos
  while self.pos < self.len && self.chars[self.pos] != '\n' {
    self.pos += 1
  }
  { token_type: Preprocessor, from: start, to: self.pos }
}

///|
pub fn CsharpTokenizer::next_token(self : CsharpTokenizer) -> CsharpToken? {
  if self.pos >= self.len {
    return None
  }
  let start = self.pos
  let c = self.chars[self.pos]

  // Whitespace
  if c == ' ' || c == '\t' || c == '\r' {
    while self.pos < self.len {
      let ch = self.chars[self.pos]
      if ch == ' ' || ch == '\t' || ch == '\r' {
        self.pos += 1
      } else {
        break
      }
    }
    return Some({ token_type: Whitespace, from: start, to: self.pos })
  }

  // Newline
  if c == '\n' {
    self.pos += 1
    return Some({ token_type: Newline, from: start, to: self.pos })
  }

  // Comments
  if c == '/' {
    if self.peek_at(1) == Some('/') {
      let is_doc = self.peek_at(2) == Some('/')
      while self.pos < self.len && self.chars[self.pos] != '\n' {
        self.pos += 1
      }
      let token_type = if is_doc { DocComment } else { LineComment }
      return Some({ token_type, from: start, to: self.pos })
    } else if self.peek_at(1) == Some('*') {
      self.pos += 2
      while self.pos < self.len {
        if self.chars[self.pos] == '*' && self.peek_at(1) == Some('/') {
          self.pos += 2
          break
        }
        self.pos += 1
      }
      return Some({ token_type: BlockComment, from: start, to: self.pos })
    }
  }

  // Preprocessor
  if c == '#' {
    return Some(self.read_preprocessor())
  }

  // Verbatim string
  if c == '@' && self.peek_at(1) == Some('"') {
    return Some(self.read_verbatim_string())
  }

  // Interpolated string
  if c == '$' && self.peek_at(1) == Some('"') {
    return Some(self.read_interpolated_string())
  }

  // Attribute
  if c == '[' {
    // Check if this looks like an attribute
    self.pos += 1
    return Some({ token_type: BracketOpen, from: start, to: self.pos })
  }

  // String
  if c == '"' {
    return Some(self.read_string())
  }

  // Char
  if c == '\'' {
    return Some(self.read_char())
  }

  // Number
  if is_digit(c) {
    return Some(self.read_number())
  }

  // Identifier
  if is_id_start(c) {
    return Some(self.read_identifier())
  }

  // Multi-char operators
  let c2 = self.peek_at(1)
  let two_char = match c2 {
    Some(ch) => c.to_string() + ch.to_string()
    None => ""
  }

  // Three-char operators
  if self.pos + 2 < self.len {
    let c3 = self.chars[self.pos + 2]
    let three_char = two_char + c3.to_string()
    if three_char == "<<=" || three_char == ">>=" || three_char == "??=" {
      self.pos += 3
      return Some({ token_type: Assignment, from: start, to: self.pos })
    }
  }
  match two_char {
    "=>" => {
      self.pos += 2
      return Some({ token_type: Lambda, from: start, to: self.pos })
    }
    "->" => {
      self.pos += 2
      return Some({ token_type: Arrow, from: start, to: self.pos })
    }
    "??" => {
      self.pos += 2
      return Some({ token_type: NullCoalesce, from: start, to: self.pos })
    }
    "?." | "?[" => {
      self.pos += 2
      return Some({ token_type: NullConditional, from: start, to: self.pos })
    }
    "==" | "!=" | "<=" | ">=" => {
      self.pos += 2
      return Some({ token_type: Comparison, from: start, to: self.pos })
    }
    "&&" | "||" => {
      self.pos += 2
      return Some({ token_type: Logical, from: start, to: self.pos })
    }
    "++" | "--" => {
      self.pos += 2
      return Some({ token_type: Increment, from: start, to: self.pos })
    }
    "+=" | "-=" | "*=" | "/=" | "%=" | "&=" | "|=" | "^=" => {
      self.pos += 2
      return Some({ token_type: Assignment, from: start, to: self.pos })
    }
    "<<" | ">>" => {
      self.pos += 2
      return Some({ token_type: Bitwise, from: start, to: self.pos })
    }
    _ => ()
  }

  // Single-char tokens
  let token_type = match c {
    '(' => ParenOpen
    ')' => ParenClose
    ']' => BracketClose
    '{' => BraceOpen
    '}' => BraceClose
    ',' => Comma
    ';' => Semicolon
    ':' => Colon
    '.' => Dot
    '+' | '-' | '*' | '/' | '%' => Operator
    '<' | '>' => Comparison
    '=' => Assignment
    '!' => Logical
    '&' | '|' | '^' | '~' => Bitwise
    '?' => Operator
    _ => Unknown
  }
  self.pos += 1
  Some({ token_type, from: start, to: self.pos })
}

///|
pub fn CsharpTokenizer::tokenize_all(
  self : CsharpTokenizer,
) -> Array[CsharpToken] {
  let tokens : Array[CsharpToken] = []
  while true {
    match self.next_token() {
      Some(token) =>
        match token.token_type {
          Whitespace | Newline => ()
          _ => tokens.push(token)
        }
      None => break
    }
  }
  tokens
}
