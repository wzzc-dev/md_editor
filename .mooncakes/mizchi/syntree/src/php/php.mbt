///|
/// PHP Tokenizer
pub(all) enum PhpTokenType {
  OpenTag
  CloseTag
  Keyword
  DeclKeyword
  Modifier
  String
  HeredocString
  Char
  Number
  Bool
  Null
  Identifier
  TypeName
  Variable
  Attribute
  Operator
  Comparison
  Assignment
  Logical
  Bitwise
  Increment
  NullCoalesce
  NullSafe
  Arrow
  DoubleArrow
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
  LineComment
  BlockComment
  DocComment
  Whitespace
  Newline
  Unknown
} derive(Eq, Show)

///|
pub(all) struct PhpToken {
  token_type : PhpTokenType
  from : Int
  to : Int
} derive(Eq, Show)

///|
pub(all) struct PhpTokenizer {
  input : String
  priv chars : Array[Char]
  priv len : Int
  priv mut pos : Int
}

///|
let php_keywords : Array[String] = [
  "if", "elseif", "else", "endif", "switch", "case", "default", "endswitch", "for",
  "endfor", "foreach", "endforeach", "while", "endwhile", "do", "break", "continue",
  "return", "yield", "throw", "try", "catch", "finally", "new", "clone", "instanceof",
  "as", "echo", "print", "die", "exit", "include", "include_once", "require", "require_once",
  "use", "namespace", "implements", "extends", "insteadof", "global", "static", "const",
  "var", "list", "array", "match", "fn", "declare", "goto",
]

///|
let php_decl_keywords : Array[String] = [
  "function", "class", "interface", "trait", "enum", "abstract", "final",
]

///|
let php_modifiers : Array[String] = [
  "public", "private", "protected", "readonly", "static", "final", "abstract",
]

///|
let php_type_keywords : Array[String] = [
  "void", "bool", "int", "float", "string", "array", "object", "callable", "iterable",
  "mixed", "never", "null", "true", "false", "self", "parent",
]

///|
pub fn PhpTokenizer::new(input : String) -> PhpTokenizer {
  let chars = input.to_array()
  { input, chars, len: chars.length(), pos: 0 }
}

///|
fn PhpTokenizer::peek_at(self : PhpTokenizer, offset : Int) -> Char? {
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
fn PhpTokenizer::read_string(self : PhpTokenizer, quote : Char) -> PhpToken {
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
fn PhpTokenizer::read_heredoc(self : PhpTokenizer) -> PhpToken {
  let start = self.pos
  self.pos += 3 // skip <<<

  // Skip optional whitespace
  while self.pos < self.len && self.chars[self.pos] == ' ' {
    self.pos += 1
  }

  // Check for nowdoc (')
  let is_nowdoc = self.pos < self.len && self.chars[self.pos] == '\''
  if is_nowdoc {
    self.pos += 1
  }

  // Read identifier
  let ident_start = self.pos
  while self.pos < self.len && is_id_continue(self.chars[self.pos]) {
    self.pos += 1
  }
  let ident = String::from_array(self.chars[ident_start:self.pos])
  if is_nowdoc && self.pos < self.len && self.chars[self.pos] == '\'' {
    self.pos += 1
  }

  // Skip to end of line
  while self.pos < self.len && self.chars[self.pos] != '\n' {
    self.pos += 1
  }
  if self.pos < self.len {
    self.pos += 1
  }

  // Read until closing identifier
  while self.pos < self.len {
    // Check if line starts with identifier
    let line_start = self.pos
    while self.pos < self.len && is_id_continue(self.chars[self.pos]) {
      self.pos += 1
    }
    let line_ident = String::from_array(self.chars[line_start:self.pos])
    if line_ident == ident {
      break
    }
    // Skip to next line
    while self.pos < self.len && self.chars[self.pos] != '\n' {
      self.pos += 1
    }
    if self.pos < self.len {
      self.pos += 1
    }
  }
  { token_type: HeredocString, from: start, to: self.pos }
}

///|
fn PhpTokenizer::read_number(self : PhpTokenizer) -> PhpToken {
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
  { token_type: Number, from: start, to: self.pos }
}

///|
fn PhpTokenizer::read_identifier(self : PhpTokenizer) -> PhpToken {
  let start = self.pos
  let first = self.chars[self.pos]
  while self.pos < self.len && is_id_continue(self.chars[self.pos]) {
    self.pos += 1
  }
  let value = String::from_array(self.chars[start:self.pos])
  let lower = to_lower(value)
  let token_type = if lower == "true" || lower == "false" {
    Bool
  } else if lower == "null" {
    Null
  } else if php_keywords.contains(lower) {
    Keyword
  } else if php_decl_keywords.contains(lower) {
    DeclKeyword
  } else if php_modifiers.contains(lower) {
    Modifier
  } else if php_type_keywords.contains(lower) {
    TypeName
  } else if first >= 'A' && first <= 'Z' {
    TypeName
  } else {
    Identifier
  }
  { token_type, from: start, to: self.pos }
}

///|
fn to_lower(s : String) -> String {
  let buf = StringBuilder::new()
  for c in s {
    let lower = if c >= 'A' && c <= 'Z' {
      (c.to_int() + 32).unsafe_to_char()
    } else {
      c
    }
    buf.write_char(lower)
  }
  buf.to_string()
}

///|
fn PhpTokenizer::read_variable(self : PhpTokenizer) -> PhpToken {
  let start = self.pos
  self.pos += 1 // skip $
  while self.pos < self.len && is_id_continue(self.chars[self.pos]) {
    self.pos += 1
  }
  { token_type: Variable, from: start, to: self.pos }
}

///|
pub fn PhpTokenizer::next_token(self : PhpTokenizer) -> PhpToken? {
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

  // PHP open tag
  if c == '<' && self.peek_at(1) == Some('?') {
    self.pos += 2
    if self.pos + 3 < self.len {
      let next3 = String::from_array(self.chars[self.pos:self.pos + 3])
      if next3 == "php" {
        self.pos += 3
      }
    }
    return Some({ token_type: OpenTag, from: start, to: self.pos })
  }

  // PHP close tag
  if c == '?' && self.peek_at(1) == Some('>') {
    self.pos += 2
    return Some({ token_type: CloseTag, from: start, to: self.pos })
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
      let is_doc = self.pos < self.len && self.chars[self.pos] == '*'
      while self.pos < self.len {
        if self.chars[self.pos] == '*' && self.peek_at(1) == Some('/') {
          self.pos += 2
          break
        }
        self.pos += 1
      }
      let token_type = if is_doc { DocComment } else { BlockComment }
      return Some({ token_type, from: start, to: self.pos })
    }
  }

  // Shell-style comment
  if c == '#' && self.peek_at(1) != Some('[') {
    while self.pos < self.len && self.chars[self.pos] != '\n' {
      self.pos += 1
    }
    return Some({ token_type: LineComment, from: start, to: self.pos })
  }

  // Attribute
  if c == '#' && self.peek_at(1) == Some('[') {
    self.pos += 2
    let mut depth = 1
    while self.pos < self.len && depth > 0 {
      if self.chars[self.pos] == '[' {
        depth += 1
      } else if self.chars[self.pos] == ']' {
        depth -= 1
      }
      self.pos += 1
    }
    return Some({ token_type: Attribute, from: start, to: self.pos })
  }

  // Heredoc/Nowdoc
  if c == '<' && self.peek_at(1) == Some('<') && self.peek_at(2) == Some('<') {
    return Some(self.read_heredoc())
  }

  // Strings
  if c == '"' || c == '\'' {
    return Some(self.read_string(c))
  }

  // Variable
  if c == '$' {
    return Some(self.read_variable())
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
    if three_char == "===" ||
      three_char == "!==" ||
      three_char == "<=>" ||
      three_char == "**=" ||
      three_char == "??=" {
      self.pos += 3
      let token_type = if three_char == "===" ||
        three_char == "!==" ||
        three_char == "<=>" {
        Comparison
      } else {
        Assignment
      }
      return Some({ token_type, from: start, to: self.pos })
    }
    if three_char == "..." {
      self.pos += 3
      return Some({ token_type: Operator, from: start, to: self.pos })
    }
  }
  match two_char {
    "->" => {
      self.pos += 2
      return Some({ token_type: Arrow, from: start, to: self.pos })
    }
    "=>" => {
      self.pos += 2
      return Some({ token_type: DoubleArrow, from: start, to: self.pos })
    }
    "::" => {
      self.pos += 2
      return Some({ token_type: Scope, from: start, to: self.pos })
    }
    "??" => {
      self.pos += 2
      return Some({ token_type: NullCoalesce, from: start, to: self.pos })
    }
    "?-" =>
      if self.peek_at(2) == Some('>') {
        self.pos += 3
        return Some({ token_type: NullSafe, from: start, to: self.pos })
      }
    "==" | "!=" | "<=" | ">=" | "<>" => {
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
    "+=" | "-=" | "*=" | "/=" | "%=" | ".=" | "&=" | "|=" | "^=" => {
      self.pos += 2
      return Some({ token_type: Assignment, from: start, to: self.pos })
    }
    "**" | "<<" | ">>" => {
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
    '+' | '-' | '*' | '/' | '%' | '@' | '~' => Operator
    '<' | '>' => Comparison
    '=' => Assignment
    '!' => Logical
    '&' | '|' | '^' => Bitwise
    '?' => Operator
    _ => Unknown
  }
  self.pos += 1
  Some({ token_type, from: start, to: self.pos })
}

///|
pub fn PhpTokenizer::tokenize_all(self : PhpTokenizer) -> Array[PhpToken] {
  let tokens : Array[PhpToken] = []
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
