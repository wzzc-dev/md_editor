///|
using @views {button, column, row, spacer, text}

///|
pub struct Model {
  mut source : String
  mut saved_source : String
  mut path : String
}

///|
pub(all) enum Msg {
  Input(String)
  NewDocument
  OpenDocument
  SaveDocument
  OpenPicked(@services.ServiceTaskResult[String])
  OpenLoaded(String, @services.ServiceTaskResult[String])
  SavePicked(@services.ServiceTaskResult[String])
  SaveWritten(@services.ServiceTaskResult[Unit])
}

///|
pub struct Update {
  model : Model
  effect : @moui.Effect[Msg]
}

///|
pub fn Model::new() -> Model {
  let source = "# MoUI Markdown Editor\n\nEdit **Markdown** and see the formatted page update live.\n\n- Open a .md file\n- Type with normal keyboard shortcuts\n- Scroll long documents with the wheel\n\n> The saved value is always Markdown source.\n\n```text\nlet renderer = \\\"Skia\\\"\n```\n"
  { source, saved_source: source, path: "" }
}

///|
/// Construct a clean model around an externally supplied Markdown fixture.
/// This is used by benchmark harnesses so they exercise the exact same view
/// tree as the interactive application.
pub fn Model::with_source(source : String) -> Model {
  { source, saved_source: source, path: "" }
}

///|
pub fn update(model : Model, message : Msg) -> Model {
  match message {
    Input(value) => {
      model.source = value
      model
    }
    NewDocument => {
      model.source = "# Untitled\n\n"
      model.saved_source = model.source
      model.path = ""
      model
    }
    OpenDocument => model
    SaveDocument => {
      model.saved_source = model.source
      model
    }
    OpenPicked(_) | OpenLoaded(_, _) | SavePicked(_) | SaveWritten(_) => model
  }
}

///|
fn Model::update_with_services(
  model : Model,
  message : Msg,
  services : @services.AppServices,
) -> Update {
  match message {
    OpenDocument =>
      {
        model,
        effect: services
        .files()
        .open_file(
          options=@services.FileDialogOptions::new(title="Open Markdown", filters=[
            "md", "markdown",
          ]),
        )
        .effect(map=result => OpenPicked(result)),
      }
    OpenPicked(result) =>
      match result {
        Success(path) => {
          model.path = path
          {
            model,
            effect: services
            .files()
            .read_text(path)
            .effect(map=loaded => OpenLoaded(path, loaded)),
          }
        }
        Failure(error) => {
          model.path = "Open failed: " + error.message
          { model, effect: @moui.Effect::none() }
        }
        Cancelled => { model, effect: @moui.Effect::none() }
      }
    OpenLoaded(path, result) =>
      match result {
        Success(source) => {
          model.source = source
          model.saved_source = source
          model.path = path
          { model, effect: @moui.Effect::none() }
        }
        Failure(error) => {
          model.path = "Read failed: " + error.message
          { model, effect: @moui.Effect::none() }
        }
        Cancelled => { model, effect: @moui.Effect::none() }
      }
    SaveDocument =>
      if model.path == "" {
        {
          model,
          effect: services
          .files()
          .save_file(
            options=@services.FileDialogOptions::new(
              title="Save Markdown",
              filters=["md", "markdown"],
              default_name=Some("untitled.md"),
            ),
          )
          .effect(map=result => SavePicked(result)),
        }
      } else {
        {
          model,
          effect: services
          .files()
          .write_text(model.path, model.source)
          .effect(map=result => SaveWritten(result)),
        }
      }
    SavePicked(result) =>
      match result {
        Success(path) => {
          model.path = path
          {
            model,
            effect: services
            .files()
            .write_text(path, model.source)
            .effect(map=result => SaveWritten(result)),
          }
        }
        Failure(error) => {
          model.path = "Save failed: " + error.message
          { model, effect: @moui.Effect::none() }
        }
        Cancelled => { model, effect: @moui.Effect::none() }
      }
    SaveWritten(result) =>
      match result {
        Success(_) => {
          model.saved_source = model.source
          { model, effect: @moui.Effect::none() }
        }
        Failure(error) => {
          model.path = "Save failed: " + error.message
          { model, effect: @moui.Effect::none() }
        }
        Cancelled => { model, effect: @moui.Effect::none() }
      }
    _ => { model: update(model, message), effect: @moui.Effect::none() }
  }
}

///|
fn editor_font() -> @text.FontSpec {
  @text.FontSpec::new(size=16.0)
}

///|
pub fn view(model : Model) -> @moui.View[Msg] {
  let clean = model.source == model.saved_source
  let title = if model.path == "" { "Untitled.md" } else { model.path }
  let status = if clean { "Saved" } else { "Unsaved changes" }
  let editor = @moui_richtext.controlled_markdown_editor(
    value=model.source,
    on_input=value => Input(value),
    placeholder="Write Markdown...",
    size=@geometry.Size::new(width=960.0, height=650.0),
    font=editor_font(),
    foreground=@graphics.Color::rgba(r=0.12, g=0.13, b=0.15),
    placeholder_color=@graphics.Color::rgba(r=0.45, g=0.47, b=0.50),
    background=@graphics.Brush::solid(@graphics.Color::white()),
    cursor_color=@graphics.Color::rgba(r=0.10, g=0.35, b=0.80),
    corner_radius=6.0,
    accepts_tab_input=true,
    key=Some("moui-markdown-editor"),
  )
  column([
    row([
      text("MoUI Markdown Editor").title(),
      spacer(weight=1.0),
      button("New", on_click=NewDocument),
      button("Open", on_click=OpenDocument),
      button("Save", on_click=SaveDocument),
    ]),
    text(title),
    editor,
    row([
      text(status),
      spacer(weight=1.0),
      text("Skia | scrollable formatted document"),
    ]),
  ])
}

///|
pub fn program(
  environment? : @services.AppEnvironment = @services.AppEnvironment::new(),
) -> @moui.Program[Model, Msg] {
  program_with_source(Model::new().source, environment~)
}

///|
/// Build the editor program with a deterministic initial document.
pub fn program_with_source(
  source : String,
  environment? : @services.AppEnvironment = @services.AppEnvironment::new(),
) -> @moui.Program[Model, Msg] {
  let services = environment.services()
  @moui.Program::new(
    init=() => (Model::with_source(source), @moui.Effect::none()),
    update=(model, message) => {
      let next = model.update_with_services(message, services)
      (next.model, next.effect)
    },
    view~,
  )
}
