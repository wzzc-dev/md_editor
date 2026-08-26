///|
test "markdown editor starts with a clean document" {
  let model = Model::new()
  assert_eq(model.source, model.saved_source)
  assert_eq(model.path, "")
}

///|
test "markdown editor input marks the source without changing saved content" {
  let model = Model::new()
  let next = update(model, Input("# Changed"))
  assert_eq(next.source, "# Changed")
  assert_true(next.source != next.saved_source)
}

///|
test "markdown editor new document clears its path" {
  let model = Model::new()
  let edited = update(model, Input("# Changed"))
  let next = update(edited, NewDocument)
  assert_eq(next.source, "# Untitled\n\n")
  assert_eq(next.path, "")
  assert_eq(next.source, next.saved_source)
}

///|
test "markdown editor can initialize from a benchmark fixture" {
  let model = Model::with_source("# Fixture\n\n**body**")
  assert_eq(model.source, "# Fixture\n\n**body**")
  assert_eq(model.saved_source, model.source)
  assert_eq(model.path, "")
}

///|
test "markdown editor runtime exposes the editing shell" {
  let runtime = @runtime.new_program_with_dimensions(
    program=program(),
    width=1100.0,
    height=760.0,
  )
  assert_true(
    runtime
    .draw_commands()
    .any(command => {
      command is @core.DrawCommand::DrawText({ text, .. }) &&
      text == "MoUI Markdown Editor"
    }),
  )
}
