///|
/// Ruby Tokenizer
pub(all) enum RubyTokenType {
  Keyword
  DeclKeyword
  Modifier
  String
  HeredocString
  Regex
  Symbol
  Number
  Bool
  Nil
  Identifier
  Constant
  InstanceVar
  ClassVar
  GlobalVar
  Operator
  Comparison
  Assignment
  Logical
  Range
  Splat
  BlockArg
  ParenOpen
  ParenClose
  BracketOpen
  BracketClose
  BraceOpen
  BraceClose
  Comma
  Semicolon
  Colon
  DoubleColon
  Dot
  Question
  Comment
  Whitespace
  Newline
  Unknown
} derive(Eq, Show)

///|
pub(all) struct RubyToken {
  token_type : RubyTokenType
  from : Int
  to : Int
} derive(Eq, Show)

///|
pub(all) struct RubyTokenizer {
  input : String
  priv chars : Array[Char]
  priv len : Int
  priv mut pos : Int
}

///|
let ruby_keywords : Array[String] = [
  "if", "elsif", "else", "unless", "case", "when", "then", "for", "while", "until",
  "do", "break", "next", "redo", "retry", "return", "yield", "raise", "rescue", "ensure",
  "begin", "end", "in", "and", "or", "not", "self", "super", "__FILE__", "__LINE__",
  "__ENCODING__", "defined?",
]

///|
let ruby_decl_keywords : Array[String] = [
  "def", "class", "module", "alias", "undef", "END", "BEGIN",
]

///|
let ruby_modifiers : Array[String] = [
  "public", "private", "protected", "attr_reader", "attr_writer", "attr_accessor",
  "include", "extend", "prepend", "require", "require_relative", "load",
]

///|
pub fn RubyTokenizer::new(input : String) -> RubyTokenizer {
  let chars = input.to_array()
  { input, chars, len: chars.length(), pos: 0 }
}

///|
fn RubyTokenizer::peek_at(self : RubyTokenizer, offset : Int) -> Char? {
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
fn RubyTokenizer::read_string(self : RubyTokenizer, quote : Char) -> RubyToken {
  let start = self.pos
  self.pos += 1
  while self.pos < self.len {
    let c = self.chars[self.pos]
    if c == '\\' {
      self.pos += 2
    } else if c == quote {
      self.pos += 1
      break
    } else {
      self.pos += 1
    }
  }
  { token_type: String, from: start, to: self.pos }
}

///|
fn RubyTokenizer::read_percent_string(self : RubyTokenizer) -> RubyToken {
  let start = self.pos
  self.pos += 1 // skip %

  // Check for type specifier
  if self.pos < self.len {
    let c = self.chars[self.pos]
    if c == 'q' ||
      c == 'Q' ||
      c == 'w' ||
      c == 'W' ||
      c == 'i' ||
      c == 'I' ||
      c == 's' ||
      c == 'x' ||
      c == 'r' {
      self.pos += 1
    }
  }
  if self.pos >= self.len {
    return { token_type: String, from: start, to: self.pos }
  }
  let open_delim = self.chars[self.pos]
  let close_delim = match open_delim {
    '(' => ')'
    '[' => ']'
    '{' => '}'
    '<' => '>'
    _ => open_delim
  }
  self.pos += 1
  let mut depth = 1
  while self.pos < self.len && depth > 0 {
    let c = self.chars[self.pos]
    if c == '\\' {
      self.pos += 2
    } else if c == open_delim && open_delim != close_delim {
      depth += 1
      self.pos += 1
    } else if c == close_delim {
      depth -= 1
      self.pos += 1
    } else {
      self.pos += 1
    }
  }
  { token_type: String, from: start, to: self.pos }
}

///|
fn RubyTokenizer::read_regex(self : RubyTokenizer) -> RubyToken {
  let start = self.pos
  self.pos += 1
  while self.pos < self.len {
    let c = self.chars[self.pos]
    if c == '\\' {
      self.pos += 2
    } else if c == '/' {
      self.pos += 1
      // Read flags
      while self.pos < self.len {
        let f = self.chars[self.pos]
        if f == 'i' || f == 'm' || f == 'x' || f == 'o' {
          self.pos += 1
        } else {
          break
        }
      }
      break
    } else {
      self.pos += 1
    }
  }
  { token_type: Regex, from: start, to: self.pos }
}

///|
fn RubyTokenizer::read_symbol(self : RubyTokenizer) -> RubyToken {
  let start = self.pos
  self.pos += 1 // skip :
  if self.pos < self.len {
    let c = self.chars[self.pos]
    if c == '"' || c == '\'' {
      // Quoted symbol
      let quote = c
      self.pos += 1
      while self.pos < self.len {
        let ch = self.chars[self.pos]
        if ch == '\\' {
          self.pos += 2
        } else if ch == quote {
          self.pos += 1
          break
        } else {
          self.pos += 1
        }
      }
    } else if is_id_start(c) {
      // Bare symbol
      while self.pos < self.len && is_id_continue(self.chars[self.pos]) {
        self.pos += 1
      }
      // Check for ? or ! at end
      if self.pos < self.len &&
        (self.chars[self.pos] == '?' || self.chars[self.pos] == '!') {
        self.pos += 1
      }
    }
  }
  { token_type: Symbol, from: start, to: self.pos }
}

///|
fn RubyTokenizer::read_number(self : RubyTokenizer) -> RubyToken {
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
      return { token_type: Number, from: start, to: self.pos }
    } else if next == 'o' || next == 'O' || (next >= '0' && next <= '7') {
      self.pos += 1
      if next == 'o' || next == 'O' {
        self.pos += 1
      }
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

  // Rational or imaginary suffix
  if self.pos < self.len &&
    (self.chars[self.pos] == 'r' || self.chars[self.pos] == 'i') {
    self.pos += 1
  }
  { token_type: Number, from: start, to: self.pos }
}

///|
fn RubyTokenizer::read_identifier(self : RubyTokenizer) -> RubyToken {
  let start = self.pos
  let first = self.chars[self.pos]
  while self.pos < self.len && is_id_continue(self.chars[self.pos]) {
    self.pos += 1
  }

  // Check for ? or ! at end (method names)
  if self.pos < self.len &&
    (self.chars[self.pos] == '?' || self.chars[self.pos] == '!') {
    self.pos += 1
  }
  let value = String::from_array(self.chars[start:self.pos])
  let token_type = if value == "true" || value == "false" {
    Bool
  } else if value == "nil" {
    Nil
  } else if ruby_keywords.contains(value) {
    Keyword
  } else if ruby_decl_keywords.contains(value) {
    DeclKeyword
  } else if ruby_modifiers.contains(value) {
    Modifier
  } else if first >= 'A' && first <= 'Z' {
    Constant
  } else {
    Identifier
  }
  { token_type, from: start, to: self.pos }
}

///|
fn RubyTokenizer::read_variable(
  self : RubyTokenizer,
  token_type : RubyTokenType,
) -> RubyToken {
  let start = self.pos
  self.pos += 1 // skip @ or $
  if token_type == ClassVar &&
    self.pos < self.len &&
    self.chars[self.pos] == '@' {
    self.pos += 1 // skip second @
  }
  while self.pos < self.len && is_id_continue(self.chars[self.pos]) {
    self.pos += 1
  }
  { token_type, from: start, to: self.pos }
}

///|
pub fn RubyTokenizer::next_token(self : RubyTokenizer) -> RubyToken? {
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

  // Comment
  if c == '#' {
    while self.pos < self.len && self.chars[self.pos] != '\n' {
      self.pos += 1
    }
    return Some({ token_type: Comment, from: start, to: self.pos })
  }

  // Strings
  if c == '"' || c == '\'' {
    return Some(self.read_string(c))
  }

  // Percent string
  if c == '%' && self.pos + 1 < self.len {
    let next = self.chars[self.pos + 1]
    if next == 'q' ||
      next == 'Q' ||
      next == 'w' ||
      next == 'W' ||
      next == 'i' ||
      next == 'I' ||
      next == 's' ||
      next == 'x' ||
      next == '(' ||
      next == '[' ||
      next == '{' ||
      next == '<' ||
      next == '!' ||
      next == '|' {
      return Some(self.read_percent_string())
    }
    if next == 'r' {
      self.pos += 1
      return Some(self.read_regex())
    }
  }

  // Regex
  if c == '/' {
    // Heuristic: regex if at start of expression
    return Some(self.read_regex())
  }

  // Symbol
  if c == ':' && self.pos + 1 < self.len {
    let next = self.chars[self.pos + 1]
    if next == ':' {
      self.pos += 2
      return Some({ token_type: DoubleColon, from: start, to: self.pos })
    }
    if is_id_start(next) || next == '"' || next == '\'' {
      return Some(self.read_symbol())
    }
  }

  // Number
  if is_digit(c) {
    return Some(self.read_number())
  }

  // Instance variable
  if c == '@' {
    if self.peek_at(1) == Some('@') {
      return Some(self.read_variable(ClassVar))
    }
    return Some(self.read_variable(InstanceVar))
  }

  // Global variable
  if c == '$' {
    return Some(self.read_variable(GlobalVar))
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
    if three_char == "..." || three_char == "<=>" || three_char == "**=" {
      self.pos += 3
      let token_type = if three_char == "..." { Range } else { Operator }
      return Some({ token_type, from: start, to: self.pos })
    }
  }
  match two_char {
    ".." => {
      self.pos += 2
      return Some({ token_type: Range, from: start, to: self.pos })
    }
    "**" | "<<" | ">>" => {
      self.pos += 2
      return Some({ token_type: Operator, from: start, to: self.pos })
    }
    "==" | "!=" | "<=" | ">=" | "=~" | "!~" | "===" => {
      self.pos += 2
      return Some({ token_type: Comparison, from: start, to: self.pos })
    }
    "&&" | "||" => {
      self.pos += 2
      return Some({ token_type: Logical, from: start, to: self.pos })
    }
    "+=" | "-=" | "*=" | "/=" | "%=" | "&=" | "|=" | "^=" | "||=" | "&&=" => {
      self.pos += 2
      return Some({ token_type: Assignment, from: start, to: self.pos })
    }
    "->" | "=>" => {
      self.pos += 2
      return Some({ token_type: Operator, from: start, to: self.pos })
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
    '?' => Question
    '+' | '-' | '/' | '%' | '^' | '~' => Operator
    '*' => Operator
    '<' | '>' => Comparison
    '=' => Assignment
    '!' => Logical
    '&' => BlockArg
    _ => Unknown
  }
  self.pos += 1
  Some({ token_type, from: start, to: self.pos })
}

///|
pub fn RubyTokenizer::tokenize_all(self : RubyTokenizer) -> Array[RubyToken] {
  let tokens : Array[RubyToken] = []
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
