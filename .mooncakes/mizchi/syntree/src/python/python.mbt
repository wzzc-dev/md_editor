///| Python Tokenizer

///|
/// Token types for Python
pub(all) enum PythonTokenType {
  Keyword
  String
  FString
  Number
  Identifier
  Decorator
  BuiltinFunc
  BuiltinType
  ClassName
  Operator
  Comparison
  Assignment
  Logical
  Bitwise
  Walrus
  Arrow
  ParenOpen
  ParenClose
  BracketOpen
  BracketClose
  BraceOpen
  BraceClose
  Comma
  Colon
  Semicolon
  Dot
  Ellipsis
  Comment
  Whitespace
  Newline
  Unknown
} derive(Eq, Show)

///|
pub(all) struct PythonToken {
  token_type : PythonTokenType
  from : Int
  to : Int
} derive(Eq, Show)

///|
pub(all) struct PythonTokenizer {
  input : String
  priv chars : Array[Char]
  priv len : Int
  priv mut pos : Int
}

///|
let python_keywords : Array[String] = [
  "False", "None", "True", "and", "as", "assert", "async", "await", "break", "class",
  "continue", "def", "del", "elif", "else", "except", "finally", "for", "from", "global",
  "if", "import", "in", "is", "lambda", "nonlocal", "not", "or", "pass", "raise",
  "return", "try", "while", "with", "yield", "match", "case", "type",
]

///|
let python_builtin_funcs : Array[String] = [
  "abs", "all", "any", "bin", "bool", "callable", "chr", "dict", "dir", "enumerate",
  "eval", "filter", "float", "format", "getattr", "globals", "hasattr", "hash", "help",
  "hex", "id", "input", "int", "isinstance", "issubclass", "iter", "len", "list",
  "locals", "map", "max", "min", "next", "object", "oct", "open", "ord", "pow", "print",
  "range", "repr", "reversed", "round", "set", "setattr", "slice", "sorted", "str",
  "sum", "super", "tuple", "type", "vars", "zip",
]

///|
let python_builtin_types : Array[String] = [
  "int", "float", "complex", "str", "bytes", "list", "tuple", "dict", "set", "frozenset",
  "bool", "object",
]

///|
pub fn PythonTokenizer::new(input : String) -> PythonTokenizer {
  let chars = input.to_array()
  { input, chars, len: chars.length(), pos: 0 }
}

///|
fn PythonTokenizer::peek_at(self : PythonTokenizer, offset : Int) -> Char? {
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
fn PythonTokenizer::read_string(
  self : PythonTokenizer,
  quote : Char,
  is_fstring : Bool,
) -> PythonToken {
  let start = self.pos
  self.pos += 1

  // Check for triple quote
  let is_triple = self.peek_at(0) == Some(quote) &&
    self.peek_at(1) == Some(quote)
  if is_triple {
    self.pos += 2
  }
  while self.pos < self.len {
    let c = self.chars[self.pos]
    if c == '\\' {
      self.pos += 2
    } else if c == quote {
      if is_triple {
        if self.peek_at(1) == Some(quote) && self.peek_at(2) == Some(quote) {
          self.pos += 3
          break
        } else {
          self.pos += 1
        }
      } else {
        self.pos += 1
        break
      }
    } else {
      self.pos += 1
    }
  }
  let token_type = if is_fstring { FString } else { String }
  { token_type, from: start, to: self.pos }
}

///|
fn PythonTokenizer::read_number(self : PythonTokenizer) -> PythonToken {
  let start = self.pos
  if self.chars[self.pos] == '0' && self.pos + 1 < self.len {
    let next = self.chars[self.pos + 1]
    if next == 'x' || next == 'X' {
      self.pos += 2
      while self.pos < self.len &&
            (is_hex_digit(self.chars[self.pos]) || self.chars[self.pos] == '_') {
        self.pos += 1
      }
      return { token_type: Number, from: start, to: self.pos }
    } else if next == 'b' || next == 'B' {
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
    } else if next == 'o' || next == 'O' {
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
  while self.pos < self.len &&
        (is_digit(self.chars[self.pos]) || self.chars[self.pos] == '_') {
    self.pos += 1
  }

  // Decimal part
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

  // Exponent
  if self.pos < self.len {
    let e = self.chars[self.pos]
    if e == 'e' || e == 'E' {
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
  }

  // Complex suffix
  if self.pos < self.len &&
    (self.chars[self.pos] == 'j' || self.chars[self.pos] == 'J') {
    self.pos += 1
  }
  { token_type: Number, from: start, to: self.pos }
}

///|
fn PythonTokenizer::read_identifier(self : PythonTokenizer) -> PythonToken {
  let start = self.pos
  while self.pos < self.len && is_id_continue(self.chars[self.pos]) {
    self.pos += 1
  }
  let value = String::from_array(self.chars[start:self.pos])

  // Check for f-string prefix
  if (value == "f" || value == "F" || value == "rf" || value == "fr") &&
    self.pos < self.len &&
    (self.chars[self.pos] == '"' || self.chars[self.pos] == '\'') {
    return self.read_string(self.chars[self.pos], true)
  }

  // Check for raw/byte string prefix
  if (
      value == "r" ||
      value == "R" ||
      value == "b" ||
      value == "B" ||
      value == "br" ||
      value == "Br" ||
      value == "bR" ||
      value == "BR"
    ) &&
    self.pos < self.len &&
    (self.chars[self.pos] == '"' || self.chars[self.pos] == '\'') {
    return self.read_string(self.chars[self.pos], false)
  }
  let token_type = if python_keywords.contains(value) {
    Keyword
  } else if python_builtin_funcs.contains(value) {
    BuiltinFunc
  } else if python_builtin_types.contains(value) {
    BuiltinType
  } else if value.length() > 0 &&
    self.input[start] >= 'A' &&
    self.input[start] <= 'Z' {
    ClassName
  } else {
    Identifier
  }
  { token_type, from: start, to: self.pos }
}

///|
pub fn PythonTokenizer::next_token(self : PythonTokenizer) -> PythonToken? {
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

  // String
  if c == '"' || c == '\'' {
    return Some(self.read_string(c, false))
  }

  // Number
  if is_digit(c) {
    return Some(self.read_number())
  }

  // Decorator
  if c == '@' {
    self.pos += 1
    if self.pos < self.len && is_id_start(self.chars[self.pos]) {
      while self.pos < self.len && is_id_continue(self.chars[self.pos]) {
        self.pos += 1
      }
      while self.pos < self.len &&
            self.chars[self.pos] == '.' &&
            self.pos + 1 < self.len &&
            is_id_start(self.chars[self.pos + 1]) {
        self.pos += 1
        while self.pos < self.len && is_id_continue(self.chars[self.pos]) {
          self.pos += 1
        }
      }
    }
    return Some({ token_type: Decorator, from: start, to: self.pos })
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
    if three_char == "<<=" ||
      three_char == ">>=" ||
      three_char == "**=" ||
      three_char == "//=" {
      self.pos += 3
      return Some({ token_type: Assignment, from: start, to: self.pos })
    }
  }
  match two_char {
    ":=" => {
      self.pos += 2
      return Some({ token_type: Walrus, from: start, to: self.pos })
    }
    "->" => {
      self.pos += 2
      return Some({ token_type: Arrow, from: start, to: self.pos })
    }
    "==" | "!=" | "<=" | ">=" => {
      self.pos += 2
      return Some({ token_type: Comparison, from: start, to: self.pos })
    }
    "+=" | "-=" | "*=" | "/=" | "%=" | "&=" | "|=" | "^=" => {
      self.pos += 2
      return Some({ token_type: Assignment, from: start, to: self.pos })
    }
    "**" | "//" => {
      self.pos += 2
      return Some({ token_type: Operator, from: start, to: self.pos })
    }
    "<<" | ">>" => {
      self.pos += 2
      return Some({ token_type: Bitwise, from: start, to: self.pos })
    }
    "&&" | "||" => {
      self.pos += 2
      return Some({ token_type: Logical, from: start, to: self.pos })
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
    ':' => Colon
    ';' => Semicolon
    '.' => Dot
    '+' | '-' | '*' | '/' | '%' => Operator
    '<' | '>' => Comparison
    '=' => Assignment
    '&' | '|' | '^' | '~' => Bitwise
    _ => Unknown
  }
  self.pos += 1
  Some({ token_type, from: start, to: self.pos })
}

///|
pub fn PythonTokenizer::tokenize_all(
  self : PythonTokenizer,
) -> Array[PythonToken] {
  let tokens : Array[PythonToken] = []
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
