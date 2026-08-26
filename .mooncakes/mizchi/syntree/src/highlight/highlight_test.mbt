///|
/// Highlight HTML generation tests

// =============================================================================
// Theme Tests
// =============================================================================

test "theme: github_dark has correct name" {
  let theme = github_dark()
  assert_eq(theme.name, "github-dark")
}

///|
test "theme: github_light has correct name" {
  let theme = github_light()
  assert_eq(theme.name, "github-light")
}

///|
test "theme: one_dark_pro has correct name" {
  let theme = one_dark_pro()
  assert_eq(theme.name, "one-dark-pro")
}

///|
test "theme: vitesse_dark has correct name" {
  let theme = vitesse_dark()
  assert_eq(theme.name, "vitesse-dark")
}

///|
test "theme: get_color returns correct color for keyword" {
  let theme = github_dark()
  let color = theme.get_color(@syntree.Keyword)
  assert_eq(color, "#ff7b72")
}

///|
test "theme: get_color returns correct color for string" {
  let theme = github_dark()
  let color = theme.get_color(@syntree.String)
  assert_eq(color, "#a5d6ff")
}

///|
test "theme: get_color returns correct color for number" {
  let theme = github_dark()
  let color = theme.get_color(@syntree.Number)
  assert_eq(color, "#79c0ff")
}

///|
test "theme: get_color returns correct color for comment" {
  let theme = github_dark()
  let color = theme.get_color(@syntree.Comment)
  assert_eq(color, "#8b949e")
}

///|
test "theme: get_color returns correct color for type" {
  let theme = github_dark()
  let color = theme.get_color(@syntree.TypeName)
  assert_eq(color, "#ffa657")
}

///|
test "theme: get_color returns correct color for function" {
  let theme = github_dark()
  let color = theme.get_color(@syntree.FunctionName)
  assert_eq(color, "#d2a8ff")
}

///|
test "theme: get_color returns foreground for None tag" {
  let theme = github_dark()
  let color = theme.get_color(@syntree.None)
  assert_eq(color, "#c9d1d9")
}

///|
test "theme: github_light has white background" {
  let theme = github_light()
  assert_eq(theme.background, "#ffffff")
}

///|
test "theme: one_dark_pro has correct background" {
  let theme = one_dark_pro()
  assert_eq(theme.background, "#282c34")
}

///|
test "theme: vitesse_dark has correct background" {
  let theme = vitesse_dark()
  assert_eq(theme.background, "#121212")
}

// =============================================================================
// HTML Output Tests
// =============================================================================

///|
test "highlight: simple JavaScript produces valid HTML" {
  let source = "const x = 42;"
  let html = highlight_typescript(source, github_dark())

  // Check for highlight class
  assert_true(html.contains("<pre class=\"highlight github-dark\""))

  // Check for background color
  assert_true(html.contains("background-color: #0d1117"))

  // Check for code tag
  assert_true(html.contains("<code>"))
  assert_true(html.contains("</code></pre>"))

  // Check for line span
  assert_true(html.contains("<span class=\"line\">"))
}

///|
test "highlight: multiline code produces multiple lines" {
  let source =
    #|const a = 1;
    #|const b = 2;
  let html = highlight_typescript(source, github_dark())

  // Should have multiple line spans
  let line_count = count_occurrences(html, "<span class=\"line\">")
  assert_true(line_count >= 2)
}

///|
test "highlight: MoonBit code highlights correctly" {
  let source = "fn main() -> Int { 42 }"
  let html = highlight_moonbit(source, github_dark())

  // Check for highlight structure
  assert_true(html.contains("<pre class=\"highlight"))
  assert_true(html.contains("<code>"))
  assert_true(html.contains("<span class=\"line\">"))
}

///|
test "highlight: JSON highlights correctly" {
  let source = "{\"key\": 123}"
  let html = highlight_json(source, github_dark())

  // Check for highlight structure
  assert_true(html.contains("<pre class=\"highlight"))
  assert_true(html.contains("<code>"))
}

///|
test "highlight: different themes produce different colors" {
  let source = "const x = 42;"
  let dark = highlight_typescript(source, github_dark())
  let light = highlight_typescript(source, github_light())

  // Background colors should be different
  assert_true(dark.contains("#0d1117"))
  assert_true(light.contains("#ffffff"))
}

///|
test "highlight: HTML special chars are escaped" {
  let source = "const x = '<div>';"
  let html = highlight_typescript(source, github_dark())

  // < and > should be escaped
  assert_true(html.contains("&lt;"))
  assert_true(html.contains("&gt;"))

  // Raw < and > should not appear in the token content
  assert_false(html.contains(">'<"))
}

///|
test "highlight: empty source produces valid HTML" {
  let source = ""
  let html = highlight_typescript(source, github_dark())

  // Should still have valid structure
  assert_true(html.contains("<pre class=\"highlight"))
  assert_true(html.contains("</code></pre>"))
}

///|
test "highlight: token colors are applied" {
  let source = "const x = 42;"
  let html = highlight_typescript(source, github_dark())

  // Should have colored spans
  assert_true(html.contains("style=\"color:"))
}

// =============================================================================
// TypeScript-specific Tests
// =============================================================================

///|
test "highlight/ts: function declaration" {
  let source = "function greet(name: string): void {}"
  let html = highlight_typescript(source, github_dark())
  assert_true(html.contains("<pre class=\"highlight"))
  assert_true(html.contains("<span class=\"line\">"))
}

///|
test "highlight/ts: arrow function" {
  let source = "const add = (a: number, b: number) => a + b;"
  let html = highlight_typescript(source, github_dark())
  assert_true(html.contains("<pre class=\"highlight"))
}

///|
test "highlight/ts: class declaration" {
  let source =
    #|class Person {
    #|  name: string;
    #|  constructor(name: string) {
    #|    this.name = name;
    #|  }
    #|}
  let html = highlight_typescript(source, github_dark())
  let line_count = count_occurrences(html, "<span class=\"line\">")
  assert_true(line_count >= 5)
}

///|
test "highlight/ts: template literal" {
  let source = "const msg = `Hello, ${name}!`;"
  let html = highlight_typescript(source, github_dark())
  assert_true(html.contains("<pre class=\"highlight"))
}

///|
test "highlight/ts: JSX element" {
  let source = "const el = <div className=\"container\">Hello</div>;"
  let html = highlight_typescript(source, github_dark())
  assert_true(html.contains("<pre class=\"highlight"))
  // < should be escaped in the output
  assert_true(html.contains("&lt;"))
}

///|
test "highlight/ts: import statement" {
  let source = "import { useState } from 'react';"
  let html = highlight_typescript(source, github_dark())
  assert_true(html.contains("<pre class=\"highlight"))
}

///|
test "highlight/ts: async/await" {
  let source = "async function fetch() { await getData(); }"
  let html = highlight_typescript(source, github_dark())
  assert_true(html.contains("<pre class=\"highlight"))
}

// =============================================================================
// MoonBit-specific Tests
// =============================================================================

///|
test "highlight/mbt: function definition" {
  let source = "fn add(a : Int, b : Int) -> Int { a + b }"
  let html = highlight_moonbit(source, github_dark())
  assert_true(html.contains("<pre class=\"highlight"))
  assert_true(html.contains("<span class=\"line\">"))
}

///|
test "highlight/mbt: struct definition" {
  let source =
    #|struct Point {
    #|  x : Int
    #|  y : Int
    #|}
  let html = highlight_moonbit(source, github_dark())
  let line_count = count_occurrences(html, "<span class=\"line\">")
  assert_true(line_count >= 4)
}

///|
test "highlight/mbt: enum definition" {
  let source =
    #|enum Option[T] {
    #|  Some(T)
    #|  None
    #|}
  let html = highlight_moonbit(source, github_dark())
  assert_true(html.contains("<pre class=\"highlight"))
}

///|
test "highlight/mbt: pattern matching" {
  let source =
    #|match x {
    #|  Some(v) => v
    #|  None => 0
    #|}
  let html = highlight_moonbit(source, github_dark())
  assert_true(html.contains("<pre class=\"highlight"))
}

///|
test "highlight/mbt: string interpolation" {
  let source = "let msg = \"value: \\{x}\""
  let html = highlight_moonbit(source, github_dark())
  assert_true(html.contains("<pre class=\"highlight"))
}

///|
test "highlight/mbt: raw string" {
  let source =
    #|let code =
    #|  #|fn main() {
    #|  #|  println("Hello")
    #|  #|}
  let html = highlight_moonbit(source, github_dark())
  assert_true(html.contains("<pre class=\"highlight"))
}

///|
test "highlight/mbt: doc comment" {
  let source =
    #|///| This is a doc comment
    #|fn documented() -> Unit {}
  let html = highlight_moonbit(source, github_dark())
  assert_true(html.contains("<pre class=\"highlight"))
}

///|
test "highlight/mbt: type annotation" {
  let source = "let x : Array[Int] = []"
  let html = highlight_moonbit(source, github_dark())
  assert_true(html.contains("<pre class=\"highlight"))
}

// =============================================================================
// JSON-specific Tests
// =============================================================================

///|
test "highlight/json: simple object" {
  let source = "{\"name\": \"Alice\", \"age\": 30}"
  let html = highlight_json(source, github_dark())
  assert_true(html.contains("<pre class=\"highlight"))
}

///|
test "highlight/json: nested object" {
  let source =
    #|{
    #|  "person": {
    #|    "name": "Bob",
    #|    "address": {
    #|      "city": "Tokyo"
    #|    }
    #|  }
    #|}
  let html = highlight_json(source, github_dark())
  let line_count = count_occurrences(html, "<span class=\"line\">")
  assert_true(line_count >= 7)
}

///|
test "highlight/json: array" {
  let source = "[1, 2, 3, \"four\", true, null]"
  let html = highlight_json(source, github_dark())
  assert_true(html.contains("<pre class=\"highlight"))
}

///|
test "highlight/json: boolean and null" {
  let source = "{\"active\": true, \"deleted\": false, \"data\": null}"
  let html = highlight_json(source, github_dark())
  assert_true(html.contains("<pre class=\"highlight"))
}

// =============================================================================
// HTML-specific Tests
// =============================================================================

///|
test "highlight/html: simple div" {
  let source = "<div>Hello</div>"
  let html = highlight_html(source, github_dark())
  assert_true(html.contains("<pre class=\"highlight"))
  assert_true(html.contains("<span class=\"line\">"))
}

///|
test "highlight/html: with attributes" {
  let source = "<div class=\"container\" id=\"main\">Content</div>"
  let html = highlight_html(source, github_dark())
  assert_true(html.contains("<pre class=\"highlight"))
}

///|
test "highlight/html: self-closing tag" {
  let source = "<img src=\"image.png\" alt=\"An image\" />"
  let html = highlight_html(source, github_dark())
  assert_true(html.contains("<pre class=\"highlight"))
}

///|
test "highlight/html: nested tags" {
  let source =
    #|<html>
    #|  <head>
    #|    <title>Test</title>
    #|  </head>
    #|  <body>
    #|    <h1>Hello</h1>
    #|  </body>
    #|</html>
  let html = highlight_html(source, github_dark())
  let line_count = count_occurrences(html, "<span class=\"line\">")
  assert_true(line_count >= 8)
}

///|
test "highlight/html: comment" {
  let source = "<!-- This is a comment -->"
  let html = highlight_html(source, github_dark())
  assert_true(html.contains("<pre class=\"highlight"))
}

///|
test "highlight/html: doctype" {
  let source = "<!DOCTYPE html>"
  let html = highlight_html(source, github_dark())
  assert_true(html.contains("<pre class=\"highlight"))
}

///|
test "highlight/html: escapes angle brackets" {
  let source = "<div>"
  let html = highlight_html(source, github_dark())

  // Source < and > should be escaped in output
  assert_true(html.contains("&lt;"))
  assert_true(html.contains("&gt;"))
}

///|
test "highlight/html: form with inputs" {
  let source =
    #|<form action="/submit" method="post">
    #|  <input type="text" name="username" required>
    #|  <button type="submit">Submit</button>
    #|</form>
  let html = highlight_html(source, github_dark())
  assert_true(html.contains("<pre class=\"highlight"))
}

// =============================================================================
// CSS-specific Tests
// =============================================================================

///|
test "highlight/css: simple rule" {
  let source = ".container { color: red; }"
  let html = highlight_css(source, github_dark())
  assert_true(html.contains("<pre class=\"highlight"))
  assert_true(html.contains("<span class=\"line\">"))
}

///|
test "highlight/css: multiple properties" {
  let source =
    #|.box {
    #|  width: 100px;
    #|  height: 50px;
    #|  background-color: #f0f0f0;
    #|}
  let html = highlight_css(source, github_dark())
  let line_count = count_occurrences(html, "<span class=\"line\">")
  assert_true(line_count >= 5)
}

///|
test "highlight/css: selectors" {
  let source = "div.container > p:first-child::before {}"
  let html = highlight_css(source, github_dark())
  assert_true(html.contains("<pre class=\"highlight"))
}

///|
test "highlight/css: media query" {
  let source =
    #|@media (max-width: 768px) {
    #|  .container {
    #|    width: 100%;
    #|  }
    #|}
  let html = highlight_css(source, github_dark())
  assert_true(html.contains("<pre class=\"highlight"))
}

///|
test "highlight/css: keyframes" {
  let source =
    #|@keyframes fade {
    #|  from { opacity: 0; }
    #|  to { opacity: 1; }
    #|}
  let html = highlight_css(source, github_dark())
  assert_true(html.contains("<pre class=\"highlight"))
}

///|
test "highlight/css: color values" {
  let source = ".foo { color: #ff0000; background: rgb(255, 255, 255); }"
  let html = highlight_css(source, github_dark())
  assert_true(html.contains("<pre class=\"highlight"))
}

///|
test "highlight/css: url value" {
  let source = ".bg { background-image: url('image.png'); }"
  let html = highlight_css(source, github_dark())
  assert_true(html.contains("<pre class=\"highlight"))
}

///|
test "highlight/css: comment" {
  let source = "/* This is a CSS comment */ .foo {}"
  let html = highlight_css(source, github_dark())
  assert_true(html.contains("<pre class=\"highlight"))
}

// =============================================================================
// Bash-specific Tests
// =============================================================================

///|
test "highlight/bash: simple command" {
  let source = "echo hello world"
  let html = highlight_bash(source, github_dark())
  assert_true(html.contains("<pre class=\"highlight"))
  assert_true(html.contains("<span class=\"line\">"))
}

///|
test "highlight/bash: command with pipe" {
  let source = "cat file.txt | grep pattern | wc -l"
  let html = highlight_bash(source, github_dark())
  assert_true(html.contains("<pre class=\"highlight"))
}

///|
test "highlight/bash: script with shebang" {
  let source =
    #|#!/bin/bash
    #|echo "Hello World"
    #|exit 0
  let html = highlight_bash(source, github_dark())
  let line_count = count_occurrences(html, "<span class=\"line\">")
  assert_true(line_count >= 3)
}

///|
test "highlight/bash: if statement" {
  let source =
    #|if [ -f file.txt ]; then
    #|  echo "File exists"
    #|else
    #|  echo "File not found"
    #|fi
  let html = highlight_bash(source, github_dark())
  assert_true(html.contains("<pre class=\"highlight"))
}

///|
test "highlight/bash: for loop" {
  let source =
    #|for i in 1 2 3; do
    #|  echo $i
    #|done
  let html = highlight_bash(source, github_dark())
  assert_true(html.contains("<pre class=\"highlight"))
}

///|
test "highlight/bash: variables" {
  let source = "NAME=\"John\"\necho $NAME\necho ${HOME}"
  let html = highlight_bash(source, github_dark())
  assert_true(html.contains("<pre class=\"highlight"))
}

///|
test "highlight/bash: command substitution" {
  let source = "DATE=$(date +%Y-%m-%d)\necho \"Today is $DATE\""
  let html = highlight_bash(source, github_dark())
  assert_true(html.contains("<pre class=\"highlight"))
}

///|
test "highlight/bash: redirect and background" {
  let source = "command > output.txt 2>&1 &"
  let html = highlight_bash(source, github_dark())
  assert_true(html.contains("<pre class=\"highlight"))
}

///|
test "highlight/bash: function definition" {
  let source =
    #|function greet() {
    #|  echo "Hello, $1!"
    #|}
  let html = highlight_bash(source, github_dark())
  assert_true(html.contains("<pre class=\"highlight"))
}

///|
test "highlight/bash: comment" {
  let source = "# This is a comment\necho test  # inline comment"
  let html = highlight_bash(source, github_dark())
  assert_true(html.contains("<pre class=\"highlight"))
}

// =============================================================================
// Rust-specific Tests
// =============================================================================

///|
test "highlight/rust: simple function" {
  let source = "fn main() { println!(\"Hello\"); }"
  let html = highlight_rust(source, github_dark())
  assert_true(html.contains("<pre class=\"highlight"))
  assert_true(html.contains("<span class=\"line\">"))
}

///|
test "highlight/rust: struct definition" {
  let source =
    #|struct Point {
    #|    x: f64,
    #|    y: f64,
    #|}
  let html = highlight_rust(source, github_dark())
  let line_count = count_occurrences(html, "<span class=\"line\">")
  assert_true(line_count >= 4)
}

///|
test "highlight/rust: enum definition" {
  let source =
    #|enum Option<T> {
    #|    Some(T),
    #|    None,
    #|}
  let html = highlight_rust(source, github_dark())
  assert_true(html.contains("<pre class=\"highlight"))
}

///|
test "highlight/rust: impl block" {
  let source =
    #|impl Point {
    #|    fn new(x: f64, y: f64) -> Self {
    #|        Point { x, y }
    #|    }
    #|}
  let html = highlight_rust(source, github_dark())
  assert_true(html.contains("<pre class=\"highlight"))
}

///|
test "highlight/rust: match expression" {
  let source =
    #|match value {
    #|    Some(v) => v,
    #|    None => 0,
    #|}
  let html = highlight_rust(source, github_dark())
  assert_true(html.contains("<pre class=\"highlight"))
}

///|
test "highlight/rust: lifetimes" {
  let source = "fn longest<'a>(x: &'a str, y: &'a str) -> &'a str { x }"
  let html = highlight_rust(source, github_dark())
  assert_true(html.contains("<pre class=\"highlight"))
}

///|
test "highlight/rust: macros" {
  let source = "let v = vec![1, 2, 3];\nprintln!(\"{:?}\", v);"
  let html = highlight_rust(source, github_dark())
  assert_true(html.contains("<pre class=\"highlight"))
}

///|
test "highlight/rust: attributes" {
  let source = "#[derive(Debug, Clone)]\nstruct Data { value: i32 }"
  let html = highlight_rust(source, github_dark())
  assert_true(html.contains("<pre class=\"highlight"))
}

///|
test "highlight/rust: doc comment" {
  let source = "/// This is a doc comment\nfn documented() {}"
  let html = highlight_rust(source, github_dark())
  assert_true(html.contains("<pre class=\"highlight"))
}

///|
test "highlight/rust: use statement" {
  let source = "use std::collections::HashMap;"
  let html = highlight_rust(source, github_dark())
  assert_true(html.contains("<pre class=\"highlight"))
}

// =============================================================================
// Edge Cases
// =============================================================================

///|
test "highlight: single character" {
  let source = "x"
  let html = highlight_typescript(source, github_dark())
  assert_true(html.contains("<pre class=\"highlight"))
  assert_true(html.contains("</code></pre>"))
}

///|
test "highlight: only whitespace" {
  let source = "   "
  let html = highlight_typescript(source, github_dark())
  assert_true(html.contains("<pre class=\"highlight"))
}

///|
test "highlight: only newlines" {
  let source = "\n\n\n"
  let html = highlight_typescript(source, github_dark())
  let line_count = count_occurrences(html, "<span class=\"line\">")
  assert_true(line_count >= 3)
}

///|
test "highlight: ampersand escaping" {
  let source = "const x = 'a & b';"
  let html = highlight_typescript(source, github_dark())
  assert_true(html.contains("&amp;"))
}

///|
test "highlight: quote escaping" {
  let source = "const x = \"he said \\\"hello\\\"\";"
  let html = highlight_typescript(source, github_dark())
  assert_true(html.contains("<pre class=\"highlight"))
}

///|
test "highlight: very long line" {
  let mut source = "const x = \""
  for i = 0; i < 100; i = i + 1 {
    source = source + "a"
  }
  source = source + "\";"
  let html = highlight_typescript(source, github_dark())
  assert_true(html.contains("<pre class=\"highlight"))
  assert_true(html.contains("</code></pre>"))
}

///|
test "highlight: unicode characters" {
  let source = "const greeting = \"こんにちは世界\";"
  let html = highlight_typescript(source, github_dark())
  assert_true(html.contains("こんにちは世界"))
}

///|
test "highlight: emoji" {
  let source = "const emoji = \"🎉🚀\";"
  let html = highlight_typescript(source, github_dark())
  assert_true(html.contains("🎉🚀"))
}

// =============================================================================
// Theme Comparison Tests
// =============================================================================

///|
test "highlight: all themes produce valid HTML" {
  let source = "const x = 42;"
  let themes = [github_dark(), github_light(), one_dark_pro(), vitesse_dark()]
  for theme in themes {
    let html = highlight_typescript(source, theme)
    assert_true(html.contains("<pre class=\"highlight"))
    assert_true(html.contains("</code></pre>"))
  }
}

///|
test "highlight: theme name appears in class" {
  let source = "let x = 1"
  assert_true(highlight_moonbit(source, github_dark()).contains("github-dark"))
  assert_true(
    highlight_moonbit(source, github_light()).contains("github-light"),
  )
  assert_true(
    highlight_moonbit(source, one_dark_pro()).contains("one-dark-pro"),
  )
  assert_true(
    highlight_moonbit(source, vitesse_dark()).contains("vitesse-dark"),
  )
}

// =============================================================================
// Helper Functions
// =============================================================================

///|
fn count_occurrences(s : String, pattern : String) -> Int {
  let mut count = 0
  let mut pos = 0
  let chars = s.to_array()
  let pattern_chars = pattern.to_array()
  let len = chars.length()
  let pattern_len = pattern_chars.length()
  while pos + pattern_len <= len {
    let mut matches = true
    for i = 0; i < pattern_len; i = i + 1 {
      if chars[pos + i] != pattern_chars[i] {
        matches = false
        break
      }
    }
    if matches {
      count = count + 1
      pos = pos + pattern_len
    } else {
      pos = pos + 1
    }
  }
  count
}
