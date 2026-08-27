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
test "block input updates the Markdown source" {
  let model = Model::with_source("# First\n\nSecond")
  let next = update(model, BlockInput(0, "# Changed"))
  assert_eq(next.source, "# Changed\n\nSecond\n")
  assert_eq(next.blocks[0].markdown, "# Changed")
  assert_eq(next.blocks[1].markdown, "Second")
  assert_eq(next.saved_source, "# First\n\nSecond")
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
      command is DrawText({ text, .. }) && text == "MoUI Markdown Editor"
    }),
  )
}

///|
test "markdown editor scroll changes the visible virtual blocks" {
  let rows : Array[String] = []
  for index in 0..<40 {
    rows.push("# Row \{index}")
  }
  let runtime = @runtime.new_program_with_dimensions(
    program=program_with_source(rows.join("\n\n")),
    width=1100.0,
    height=760.0,
  )
  let before = runtime.draw_commands()
  assert_true(
    before.any(command => {
      command is DrawText({ text, .. }) && text.contains("Row 0")
    }),
  )
  let dispatched = runtime.dispatch_pointer_input(
    @core.PointerEvent::new(
      position=@core.Point::new(x=480.0, y=360.0),
      phase=Move,
      wheel_delta=@core.Point::new(x=0.0, y=-480.0),
    ),
  )
  assert_true(dispatched.handled)
  let after = runtime.draw_commands()
  assert_false(
    after.any(command => {
      command is DrawText({ text, .. }) && text.contains("Row 0")
    }),
  )
  assert_true(
    after.any(command => {
      command is DrawText({ text, .. }) && text.contains("Row 8")
    }),
  )
}
