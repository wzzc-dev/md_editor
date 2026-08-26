///| YAML Tokenizer for syntax highlighting

// =============================================================================
// YAML Token Types
// =============================================================================

///|
/// YAML token types
pub(all) enum YamlTokenType {
  // Structure
  Key // mapping key
  Value // mapping value
  ListItem // - item

  // Scalars
  String // quoted strings
  UnquotedString // unquoted values
  Number // numeric values
  Bool // true/false
  Null // null/~

  // Special
  Anchor // &anchor
  Alias // *alias
  Tag // !!type or !tag
  Directive // %YAML, %TAG

  // Punctuation
  Colon // :
  Dash // -
  Comma // ,
  BracketOpen // [
  BracketClose // ]
  BraceOpen // {
  BraceClose // }
  Pipe // | (literal block)
  Greater // > (folded block)

  // Comments
  Comment // # comment

  // Errors
  Error
} derive(Eq, Show)

// =============================================================================
// YAML Token
// =============================================================================

///|
/// A token produced by the YAML tokenizer
pub(all) struct YamlToken {
  token_type : YamlTokenType
  from : Int
  to : Int
} derive(Eq, Show)

// =============================================================================
// YAML Tokenizer
// =============================================================================

///|
/// YAML Tokenizer state
pub(all) struct YamlTokenizer {
  input : String
  priv chars : Array[Char]
  priv len : Int
  priv mut pos : Int
  priv mut at_line_start : Bool
  priv mut expect_value : Bool
}

///|
/// Create a new YAML tokenizer
pub fn YamlTokenizer::new(input : String) -> YamlTokenizer {
  let chars = input.to_array()
  {
    input,
    chars,
    len: chars.length(),
    pos: 0,
    at_line_start: true,
    expect_value: false,
  }
}

///|
/// Check if at end of input
pub fn YamlTokenizer::at_end(self : YamlTokenizer) -> Bool {
  self.pos >= self.len
}

///|
/// Peek character at offset
fn YamlTokenizer::peek_at(self : YamlTokenizer, offset : Int) -> Char? {
  let idx = self.pos + offset
  if idx >= 0 && idx < self.len {
    Some(self.chars[idx])
  } else {
    None
  }
}

///|
/// Check if character is whitespace (not newline)
fn is_whitespace(c : Char) -> Bool {
  c == ' ' || c == '\t'
}

///|
/// Check if character is a digit
fn is_digit(c : Char) -> Bool {
  c >= '0' && c <= '9'
}

///|
/// Check if character is alphanumeric or underscore
fn is_alnum(c : Char) -> Bool {
  (c >= 'a' && c <= 'z') ||
  (c >= 'A' && c <= 'Z') ||
  (c >= '0' && c <= '9') ||
  c == '_'
}

///|
/// Skip whitespace (not newlines)
fn YamlTokenizer::skip_whitespace(self : YamlTokenizer) -> Unit {
  while self.pos < self.len && is_whitespace(self.chars[self.pos]) {
    self.pos += 1
  }
}

///|
/// Read a comment: # ... (to end of line)
fn YamlTokenizer::read_comment(self : YamlTokenizer) -> YamlToken {
  let start = self.pos
  while self.pos < self.len && self.chars[self.pos] != '\n' {
    self.pos += 1
  }
  { token_type: Comment, from: start, to: self.pos }
}

///|
/// Read a single-quoted string
fn YamlTokenizer::read_single_string(self : YamlTokenizer) -> YamlToken {
  let start = self.pos
  self.pos += 1 // skip opening '
  while self.pos < self.len {
    let c = self.chars[self.pos]
    if c == '\'' {
      if self.peek_at(1) == Some('\'') {
        self.pos += 2 // escaped quote
      } else {
        self.pos += 1 // closing quote
        break
      }
    } else {
      self.pos += 1
    }
  }
  { token_type: String, from: start, to: self.pos }
}

///|
/// Read a double-quoted string
fn YamlTokenizer::read_double_string(self : YamlTokenizer) -> YamlToken {
  let start = self.pos
  self.pos += 1 // skip opening "
  while self.pos < self.len {
    let c = self.chars[self.pos]
    if c == '"' {
      self.pos += 1
      break
    } else if c == '\\' && self.pos + 1 < self.len {
      self.pos += 2 // skip escape
    } else {
      self.pos += 1
    }
  }
  { token_type: String, from: start, to: self.pos }
}

///|
/// Check if a word is a boolean
fn is_bool(word : String) -> Bool {
  match word {
    "true" | "false" | "True" | "False" | "TRUE" | "FALSE" => true
    "yes" | "no" | "Yes" | "No" | "YES" | "NO" => true
    "on" | "off" | "On" | "Off" | "ON" | "OFF" => true
    _ => false
  }
}

///|
/// Check if a word is null
fn is_null(word : String) -> Bool {
  match word {
    "null" | "Null" | "NULL" | "~" => true
    _ => false
  }
}

///|
/// Check if string is a number
fn is_number_str(s : String) -> Bool {
  let chars = s.to_array()
  if chars.length() == 0 {
    return false
  }
  let mut i = 0
  // optional sign
  if i < chars.length() && (chars[i] == '+' || chars[i] == '-') {
    i += 1
  }
  if i >= chars.length() {
    return false
  }
  // special values
  let rest = String::from_array(chars[i:])
  if rest == ".inf" ||
    rest == ".Inf" ||
    rest == ".INF" ||
    rest == ".nan" ||
    rest == ".NaN" ||
    rest == ".NAN" {
    return true
  }
  // hex
  if chars.length() > i + 2 &&
    chars[i] == '0' &&
    (chars[i + 1] == 'x' || chars[i + 1] == 'X') {
    i += 2
    while i < chars.length() {
      let c = chars[i]
      if not(
          (c >= '0' && c <= '9') ||
          (c >= 'a' && c <= 'f') ||
          (c >= 'A' && c <= 'F'),
        ) {
        return false
      }
      i += 1
    }
    return true
  }
  // octal
  if chars.length() > i + 2 &&
    chars[i] == '0' &&
    (chars[i + 1] == 'o' || chars[i + 1] == 'O') {
    i += 2
    while i < chars.length() {
      let c = chars[i]
      if not(c >= '0' && c <= '7') {
        return false
      }
      i += 1
    }
    return true
  }
  // decimal (with optional . and e)
  let mut has_digit = false
  while i < chars.length() && is_digit(chars[i]) {
    has_digit = true
    i += 1
  }
  if i < chars.length() && chars[i] == '.' {
    i += 1
    while i < chars.length() && is_digit(chars[i]) {
      has_digit = true
      i += 1
    }
  }
  if i < chars.length() && (chars[i] == 'e' || chars[i] == 'E') {
    i += 1
    if i < chars.length() && (chars[i] == '+' || chars[i] == '-') {
      i += 1
    }
    while i < chars.length() && is_digit(chars[i]) {
      i += 1
    }
  }
  has_digit && i == chars.length()
}

///|
/// Read an anchor &name
fn YamlTokenizer::read_anchor(self : YamlTokenizer) -> YamlToken {
  let start = self.pos
  self.pos += 1 // skip &
  while self.pos < self.len && is_alnum(self.chars[self.pos]) {
    self.pos += 1
  }
  { token_type: Anchor, from: start, to: self.pos }
}

///|
/// Read an alias *name
fn YamlTokenizer::read_alias(self : YamlTokenizer) -> YamlToken {
  let start = self.pos
  self.pos += 1 // skip *
  while self.pos < self.len && is_alnum(self.chars[self.pos]) {
    self.pos += 1
  }
  { token_type: Alias, from: start, to: self.pos }
}

///|
/// Read a tag !tag or !!type
fn YamlTokenizer::read_tag(self : YamlTokenizer) -> YamlToken {
  let start = self.pos
  self.pos += 1 // skip first !
  if self.pos < self.len && self.chars[self.pos] == '!' {
    self.pos += 1 // skip second !
  }
  while self.pos < self.len {
    let c = self.chars[self.pos]
    if is_alnum(c) || c == '/' || c == ':' {
      self.pos += 1
    } else {
      break
    }
  }
  { token_type: Tag, from: start, to: self.pos }
}

///|
/// Read a directive %YAML or %TAG
fn YamlTokenizer::read_directive(self : YamlTokenizer) -> YamlToken {
  let start = self.pos
  while self.pos < self.len && self.chars[self.pos] != '\n' {
    self.pos += 1
  }
  { token_type: Directive, from: start, to: self.pos }
}

///|
/// Read an unquoted string/value (key or scalar)
fn YamlTokenizer::read_unquoted(self : YamlTokenizer) -> YamlToken {
  let start = self.pos
  while self.pos < self.len {
    let c = self.chars[self.pos]
    if c == '\n' ||
      c == ':' ||
      c == '#' ||
      c == ',' ||
      c == '[' ||
      c == ']' ||
      c == '{' ||
      c == '}' {
      break
    }
    self.pos += 1
  }
  // Trim trailing whitespace
  while self.pos > start && is_whitespace(self.chars[self.pos - 1]) {
    self.pos -= 1
  }
  let text = String::from_array(self.chars[start:self.pos])
  if is_bool(text) {
    { token_type: Bool, from: start, to: self.pos }
  } else if is_null(text) {
    { token_type: Null, from: start, to: self.pos }
  } else if is_number_str(text) {
    { token_type: Number, from: start, to: self.pos }
  } else if self.expect_value {
    { token_type: Value, from: start, to: self.pos }
  } else {
    { token_type: Key, from: start, to: self.pos }
  }
}

///|
/// Tokenize the entire input
pub fn YamlTokenizer::tokenize_all(self : YamlTokenizer) -> Array[YamlToken] {
  let tokens : Array[YamlToken] = []
  while self.pos < self.len {
    self.skip_whitespace()
    if self.pos >= self.len {
      break
    }
    let c = self.chars[self.pos]

    // Newline
    if c == '\n' {
      self.pos += 1
      self.at_line_start = true
      self.expect_value = false
      continue
    }

    // Comment
    if c == '#' {
      tokens.push(self.read_comment())
      continue
    }

    // Directive
    if c == '%' && self.at_line_start {
      tokens.push(self.read_directive())
      continue
    }

    // Document markers
    if self.at_line_start &&
      c == '-' &&
      self.peek_at(1) == Some('-') &&
      self.peek_at(2) == Some('-') {
      let start = self.pos
      self.pos += 3
      tokens.push({ token_type: Directive, from: start, to: self.pos })
      continue
    }
    if self.at_line_start &&
      c == '.' &&
      self.peek_at(1) == Some('.') &&
      self.peek_at(2) == Some('.') {
      let start = self.pos
      self.pos += 3
      tokens.push({ token_type: Directive, from: start, to: self.pos })
      continue
    }

    // Strings
    if c == '"' {
      tokens.push(self.read_double_string())
      self.at_line_start = false
      continue
    }
    if c == '\'' {
      tokens.push(self.read_single_string())
      self.at_line_start = false
      continue
    }

    // Anchor
    if c == '&' {
      tokens.push(self.read_anchor())
      self.at_line_start = false
      continue
    }

    // Alias
    if c == '*' {
      tokens.push(self.read_alias())
      self.at_line_start = false
      continue
    }

    // Tag
    if c == '!' {
      tokens.push(self.read_tag())
      self.at_line_start = false
      continue
    }

    // List item
    if c == '-' &&
      (
        self.peek_at(1) == Some(' ') ||
        self.peek_at(1) == Some('\n') ||
        self.peek_at(1) == None
      ) {
      let start = self.pos
      self.pos += 1
      tokens.push({ token_type: Dash, from: start, to: self.pos })
      self.at_line_start = false
      self.expect_value = true
      continue
    }

    // Colon
    if c == ':' &&
      (
        self.peek_at(1) == Some(' ') ||
        self.peek_at(1) == Some('\n') ||
        self.peek_at(1) == None
      ) {
      let start = self.pos
      self.pos += 1
      tokens.push({ token_type: Colon, from: start, to: self.pos })
      self.expect_value = true
      continue
    }

    // Block scalars
    if c == '|' || c == '>' {
      let start = self.pos
      let tt : YamlTokenType = if c == '|' { Pipe } else { Greater }
      self.pos += 1
      // Skip block header modifiers (+, -, digits)
      while self.pos < self.len {
        let ch = self.chars[self.pos]
        if ch == '+' || ch == '-' || is_digit(ch) {
          self.pos += 1
        } else {
          break
        }
      }
      tokens.push({ token_type: tt, from: start, to: self.pos })
      continue
    }

    // Flow indicators
    match c {
      '[' => {
        let start = self.pos
        self.pos += 1
        tokens.push({ token_type: BracketOpen, from: start, to: self.pos })
        self.expect_value = true
      }
      ']' => {
        let start = self.pos
        self.pos += 1
        tokens.push({ token_type: BracketClose, from: start, to: self.pos })
        self.expect_value = false
      }
      '{' => {
        let start = self.pos
        self.pos += 1
        tokens.push({ token_type: BraceOpen, from: start, to: self.pos })
        self.expect_value = false
      }
      '}' => {
        let start = self.pos
        self.pos += 1
        tokens.push({ token_type: BraceClose, from: start, to: self.pos })
        self.expect_value = false
      }
      ',' => {
        let start = self.pos
        self.pos += 1
        tokens.push({ token_type: Comma, from: start, to: self.pos })
        self.expect_value = true
      }
      _ => {
        // Unquoted string (key or value)
        tokens.push(self.read_unquoted())
        self.at_line_start = false
      }
    }
  }
  tokens
}
