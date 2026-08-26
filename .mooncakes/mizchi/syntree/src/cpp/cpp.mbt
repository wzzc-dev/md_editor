///|
/// C++ Tokenizer
pub(all) enum CppTokenType {
  Keyword
  Modifier
  String
  RawString
  Char
  Number
  Identifier
  TypeKeyword
  TypeName
  Preprocessor
  Operator
  Comparison
  Assignment
  Logical
  Bitwise
  Increment
  Arrow
  Scope
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
  Ellipsis
  LineComment
  BlockComment
  Whitespace
  Newline
  Unknown
} derive(Eq, Show)

///|
pub(all) struct CppToken {
  token_type : CppTokenType
  from : Int
  to : Int
} derive(Eq, Show)

///|
pub(all) struct CppTokenizer {
  input : String
  priv chars : Array[Char]
  priv len : Int
  priv mut pos : Int
}

///|
let cpp_keywords : Array[String] = [
  "if", "else", "for", "while", "do", "switch", "case", "default", "break", "continue",
  "return", "goto", "throw", "try", "catch", "new", "delete", "this", "sizeof", "alignof",
  "typeid", "decltype", "nullptr", "true", "false", "namespace", "using", "typedef",
  "template", "typename", "class", "struct", "union", "enum", "public", "private",
  "protected", "friend", "virtual", "override", "final", "explicit", "operator",
  "co_await", "co_yield", "co_return", "requires", "concept", "export", "import",
  "module",
]

///|
let cpp_modifiers : Array[String] = [
  "const", "constexpr", "consteval", "constinit", "volatile", "mutable", "static",
  "extern", "inline", "thread_local", "register", "auto", "noexcept",
]

///|
let cpp_type_keywords : Array[String] = [
  "void", "bool", "char", "wchar_t", "char8_t", "char16_t", "char32_t", "short",
  "int", "long", "float", "double", "signed", "unsigned",
]

///|
pub fn CppTokenizer::new(input : String) -> CppTokenizer {
  let chars = input.to_array()
  { input, chars, len: chars.length(), pos: 0 }
}

///|
fn CppTokenizer::peek_at(self : CppTokenizer, offset : Int) -> Char? {
  let idx = self.pos + offset
  if idx >= 0 && idx < self.len {
    Some(self.chars[idx])
  } else {
    None
  }
}

///|
fn is_id_start(c : Char) -> Bool {
  (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || c == '_'
}

///|
fn is_id_continue(c : Char) -> Bool {
  is_id_start(c) || (c >= '0' && c <= '9')
}

///|
fn is_digit(c : Char) -> Bool {
  c >= '0' && c <= '9'
}

///|
fn is_hex_digit(c : Char) -> Bool {
  is_digit(c) || (c >= 'a' && c <= 'f') || (c >= 'A' && c <= 'F')
}

///|
fn CppTokenizer::read_string(self : CppTokenizer) -> CppToken {
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
fn CppTokenizer::read_raw_string(self : CppTokenizer) -> CppToken {
  let start = self.pos
  self.pos += 2 // skip R"
  // Read delimiter
  let delim_start = self.pos
  while self.pos < self.len && self.chars[self.pos] != '(' {
    self.pos += 1
  }
  let delim = String::from_array(self.chars[delim_start:self.pos])
  if self.pos < self.len {
    self.pos += 1 // skip (
  }
  // Read until )delimiter"
  while self.pos < self.len {
    if self.chars[self.pos] == ')' {
      let check_start = self.pos + 1
      let mut matches = true
      for i = 0; i < delim.length(); i = i + 1 {
        if check_start + i >= self.len ||
          self.chars[check_start + i] != delim.iter().nth(i).unwrap() {
          matches = false
          break
        }
      }
      if matches &&
        check_start + delim.length() < self.len &&
        self.chars[check_start + delim.length()] == '"' {
        self.pos = check_start + delim.length() + 1
        break
      }
    }
    self.pos += 1
  }
  { token_type: RawString, from: start, to: self.pos }
}

///|
fn CppTokenizer::read_char(self : CppTokenizer) -> CppToken {
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
fn CppTokenizer::read_number(self : CppTokenizer) -> CppToken {
  let start = self.pos
  if self.chars[self.pos] == '0' && self.pos + 1 < self.len {
    let next = self.chars[self.pos + 1]
    if next == 'x' || next == 'X' {
      self.pos += 2
      while self.pos < self.len {
        let c = self.chars[self.pos]
        if is_hex_digit(c) || c == '\'' {
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
        if c == '0' || c == '1' || c == '\'' {
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
        (is_digit(self.chars[self.pos]) || self.chars[self.pos] == '\'') {
    self.pos += 1
  }
  if self.pos < self.len &&
    self.chars[self.pos] == '.' &&
    self.pos + 1 < self.len &&
    is_digit(self.chars[self.pos + 1]) {
    self.pos += 1
    while self.pos < self.len &&
          (is_digit(self.chars[self.pos]) || self.chars[self.pos] == '\'') {
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
          (is_digit(self.chars[self.pos]) || self.chars[self.pos] == '\'') {
      self.pos += 1
    }
  }
  self.read_number_suffix()
  { token_type: Number, from: start, to: self.pos }
}

///|
fn CppTokenizer::read_number_suffix(self : CppTokenizer) -> Unit {
  while self.pos < self.len {
    let c = self.chars[self.pos]
    if c == 'u' || c == 'U' || c == 'l' || c == 'L' || c == 'f' || c == 'F' {
      self.pos += 1
    } else {
      break
    }
  }
}

///|
fn CppTokenizer::read_identifier(self : CppTokenizer) -> CppToken {
  let start = self.pos
  let first = self.chars[self.pos]
  while self.pos < self.len && is_id_continue(self.chars[self.pos]) {
    self.pos += 1
  }
  let value = String::from_array(self.chars[start:self.pos])
  let token_type = if cpp_keywords.contains(value) {
    Keyword
  } else if cpp_modifiers.contains(value) {
    Modifier
  } else if cpp_type_keywords.contains(value) {
    TypeKeyword
  } else if first >= 'A' && first <= 'Z' {
    TypeName
  } else {
    Identifier
  }
  { token_type, from: start, to: self.pos }
}

///|
fn CppTokenizer::read_preprocessor(self : CppTokenizer) -> CppToken {
  let start = self.pos
  self.pos += 1
  while self.pos < self.len &&
        (self.chars[self.pos] == ' ' || self.chars[self.pos] == '\t') {
    self.pos += 1
  }
  while self.pos < self.len && is_id_continue(self.chars[self.pos]) {
    self.pos += 1
  }
  { token_type: Preprocessor, from: start, to: self.pos }
}

///|
pub fn CppTokenizer::next_token(self : CppTokenizer) -> CppToken? {
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
      while self.pos < self.len && self.chars[self.pos] != '\n' {
        self.pos += 1
      }
      return Some({ token_type: LineComment, from: start, to: self.pos })
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

  // Raw string
  if c == 'R' && self.peek_at(1) == Some('"') {
    return Some(self.read_raw_string())
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

  // Ellipsis
  if c == '.' && self.peek_at(1) == Some('.') && self.peek_at(2) == Some('.') {
    self.pos += 3
    return Some({ token_type: Ellipsis, from: start, to: self.pos })
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
    if three_char == "<<=" || three_char == ">>=" {
      self.pos += 3
      return Some({ token_type: Assignment, from: start, to: self.pos })
    }
    if three_char == "<=>" {
      self.pos += 3
      return Some({ token_type: Comparison, from: start, to: self.pos })
    }
  }
  match two_char {
    "->" => {
      self.pos += 2
      return Some({ token_type: Arrow, from: start, to: self.pos })
    }
    "::" => {
      self.pos += 2
      return Some({ token_type: Scope, from: start, to: self.pos })
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
    '[' => BracketOpen
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
pub fn CppTokenizer::tokenize_all(self : CppTokenizer) -> Array[CppToken] {
  let tokens : Array[CppToken] = []
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
