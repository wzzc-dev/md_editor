///|
pub const SAMPLE : String = "# GPUI MoonBit Markdown Editor\n\nEdit **Markdown** directly in the formatted document.\n\n- MoonBit owns this UI tree and editor state\n- Rust exposes GPUI through native bindings\n- Click a block to edit it\n\n> The saved value is always Markdown source.\n\n```text\nlet ui = \"MoonBit\"\n```\n"

///|
priv struct EditorModel {
  mut dirty : Bool
  mut source_length : Int
  mut path : String
  blocks : Array[MarkdownBlock]
  mut active_block : Int
  mut status : String
  mut scroll_y : Float
}

///|
fn EditorModel::from_source(source : String, path : String) -> EditorModel {
  {
    dirty: false,
    source_length: source.length(),
    path,
    blocks: parse_markdown_blocks(source),
    active_block: 0,
    status: "",
    scroll_y: 0.0,
  }
}

///|
let store : @gpui.Store = @gpui.Store::new()

///|
let model_cell : @gpui.CellId[EditorModel] = store.new_cell(
  EditorModel::from_source(SAMPLE, ""),
)

///|
let model : @gpui.Signal[EditorModel] = store.signal(model_cell)

///|
let handlers : @gpui.HandlerRegistry = @gpui.HandlerRegistry::new()

/// Set by the input handler when the retained active text and footer nodes can
/// be updated without rebuilding the command tree.
let incremental_input : Ref[Bool] = { val: false }

/// GPUI's native input is single-line and panics when asked to shape a
/// newline, while Code blocks span lines. The input buffer therefore carries
/// newlines as a private-use placeholder; the model always keeps real '\n'.

///|
const NEWLINE_PLACEHOLDER : Char = '\u{E000}'

///|
fn input_text_of_markdown(markdown : String) -> String {
  String::from_array(
    markdown
    .to_array()
    .map(fn(c) { if c == '\n' { NEWLINE_PLACEHOLDER } else { c } }),
  )
}

///|
fn markdown_of_input_text(value : String) -> String {
  String::from_array(
    value
    .to_array()
    .map(fn(c) { if c == NEWLINE_PLACEHOLDER { '\n' } else { c } }),
  )
}

/// Count formatting marker characters so an append cannot silently change the
/// retained rich-text run layout. Position changes are excluded by the
/// `has_prefix` check in `can_patch_input` below.
fn marker_count(value : String, marker : Char) -> Int {
  value.to_array().fold(init=0, fn(total, current) {
    if current == marker { total + 1 } else { total }
  })
}

/// A text-only append keeps the existing inline run ranges valid. Any edit
/// that changes structure, block kind, or marker counts uses the full rebuild
/// path so Markdown formatting remains correct for real user edits.
fn can_patch_input(previous : MarkdownBlock, updated : MarkdownBlock) -> Bool {
  previous.kind == updated.kind &&
    updated.markdown.length() >= previous.markdown.length() &&
    updated.markdown.has_prefix(previous.markdown) &&
    marker_count(previous.markdown, '*') == marker_count(updated.markdown, '*') &&
    marker_count(previous.markdown, '_') == marker_count(updated.markdown, '_') &&
    marker_count(previous.markdown, '`') == marker_count(updated.markdown, '`')
}

///|
fn sync_active_input(view : Int) -> Unit {
  let current = model.get(store)
  if current.active_block >= 0 && current.active_block < current.blocks.length() {
    ignore(
      @gpui.input_set_text(
        view,
        editor_input.to_int(),
        input_text_of_markdown(current.blocks[current.active_block].markdown),
      ),
    )
  }
}

///|
let editor_input : @gpui.InputId = {
  let id = handlers.new_input_id()
  handlers.on_input_changed(id, fn(view) {
    incremental_input.val = false
    match @gpui.input_text(view, id.to_int()) {
      Ok(value) => {
        // Typing reaches us with placeholders from sync_active_input; a paste
        // can land raw newlines in the buffer. Map both directions and push a
        // placeholder copy back so single-line shaping stays valid (the
        // queued write applies at prepaint, before the frame shapes text).
        let model_text = markdown_of_input_text(value)
        let sanitized = input_text_of_markdown(model_text)
        if sanitized != value {
          ignore(@gpui.input_set_text(view, id.to_int(), sanitized))
        }
        let current = model.get(store)
        let previous = current.blocks[current.active_block]
        let old_length = previous.markdown.length()
        replace_block(current.blocks, current.active_block, model_text)
        let updated = current.blocks[current.active_block]
        // Formatting markers can change the block's visual structure. Patch
        // only a stable text append; syntax edits use the full rebuild path.
        incremental_input.val = can_patch_input(previous, updated)
        current.source_length = current.source_length +
          model_text.length() -
          old_length
        current.dirty = true
        current.status = ""
        model.set(store, current)
      }
      Err(_) => ()
    }
  })
  id
}

///|
fn activate_block(index : Int, view : Int) -> Unit {
  let current = model.get(store)
  if index >= 0 && index < current.blocks.length() {
    current.active_block = index
    current.status = ""
    model.set(store, current)
    sync_active_input(view)
  }
}

///|
// Keep handlers sparse: jumping to a distant row must not allocate one
// closure for every block between the old and new viewport.
let block_handlers : Ref[Map[Int, @gpui.HandlerId]] = { val: Map([]) }

///|
fn block_handler(index : Int) -> @gpui.HandlerId {
  match block_handlers.val.get(index) {
    Some(handler) => handler
    None => {
      let handler = handlers.on_click(fn(view) { activate_block(index, view) })
      block_handlers.val[index] = handler
      handler
    }
  }
}

///|
let new_document : @gpui.HandlerId = handlers.on_click(fn(view) {
  scroll_y_live.val = 0.0
  model.set(store, EditorModel::from_source("# Untitled\n\n", ""))
  sync_active_input(view)
})

///|
let open_document : @gpui.HandlerId = handlers.on_click(fn(view) {
  let current = model.get(store)
  if current.path == "" {
    current.status = "Open a file by passing its path on the command line"
    model.set(store, current)
    return
  }
  let source = @fs.read_file_to_string(current.path) catch {
    _ => {
      current.status = "Could not read " + current.path
      model.set(store, current)
      return
    }
  }
  scroll_y_live.val = 0.0
  model.set(store, EditorModel::from_source(source, current.path))
  sync_active_input(view)
})

///|
let save_document : @gpui.HandlerId = handlers.on_click(fn(_view) {
  let current = model.get(store)
  let target = if current.path == "" { "untitled.md" } else { current.path }
  let serialized = serialize_markdown_blocks(current.blocks)
  try @fs.write_string_to_file(target, serialized) catch {
    _ => {
      current.status = "Could not save " + target
      model.set(store, current)
    }
  } noraise {
    _ => {
      current.source_length = serialized.length()
      current.dirty = false
      current.path = target
      current.status = "Saved " + target
      model.set(store, current)
    }
  }
})

///|
/// Fixed-height rows keep the scroll extent predictable while allowing the
/// renderer to submit only the rows around the current viewport.
const BLOCK_HEIGHT : Float = 78.0

///|
const DOCUMENT_VIEWPORT_HEIGHT : Float = 650.0

///|
const VIEWPORT_OVERSCAN : Int = 6

///|
/// Native scrolling can move many times before the virtual window changes.
/// Keep that hot-path offset outside the reactive model so the GPUI scroll
/// handle does not force a full MoonBit command-buffer rebuild for every wheel
/// tick. The model is synchronized only when the rendered row window changes.
let scroll_y_live : Ref[Float] = { val: 0.0 }

///|
fn virtual_window_start(scroll_y : Float) -> Int {
  let start = (scroll_y / BLOCK_HEIGHT).to_int() - VIEWPORT_OVERSCAN
  if start < 0 { 0 } else { start }
}

///|
/// Convert the GPUI scroll-space offset (negative while scrolled down) into
/// the non-negative model coordinate used for virtualization.
let scroll_id : @gpui.ScrollId = {
  let id = handlers.new_scroll_id()
  handlers.on_scroll(id, fn(view) {
    match @gpui.scroll_state(view, id.to_int()) {
      Ok(state) => {
        let next : Float = (-state.offset_y).max(0.0)
        let current = model.get(store)
        let previous_live = scroll_y_live.val
        scroll_y_live.val = next
        // ScrollHandle owns the actual translation. Rebuild only when the
        // windowed row range changes; small wheel deltas otherwise stay within
        // the already committed spacer/row set.
        if current.scroll_y != next &&
          virtual_window_start(previous_live) != virtual_window_start(next) {
          current.scroll_y = next
          model.set(store, current)
        }
      }
      Err(_) => ()
    }
  })
  id
}

///|
let ctx : @gpui.RenderCtx = { view: 0, store, handlers }

///|
pub fn initialize(source : String, path : String) -> Unit {
  scroll_y_live.val = 0.0
  model.set(store, EditorModel::from_source(source, path))
}

///|
fn toolbar_button(
  cb : @gpui.CommandBuffer,
  key : String,
  label : String,
  handler : @gpui.HandlerId,
) -> Unit {
  cb.div()
  cb.set_key(key)
  cb.set_on_click(handler.to_int())
  cb.set_cursor(@gpui.CURSOR_POINTER)
  cb.set_padding_sides(7, 12, 7, 12)
  cb.set_rounded(4.0)
  cb.set_border_color(1.0, @gpui.Color::rgb(200, 206, 214))
  cb.set_bg_color(@gpui.Color::white())
  cb.text(label, 39, 47, 57, 14.0)
  cb.add_child()
}

///|
fn build_header(cb : @gpui.CommandBuffer, current : EditorModel) -> Unit {
  cb.div()
  cb.set_size(1280.0, 52.0)
  cb.set_flex_row()
  cb.set_center()
  cb.set_gap(12.0)
  cb.set_padding_sides(0, 18, 0, 18)
  cb.set_bg_color(@gpui.Color::white())
  cb.set_border_color(1.0, @gpui.Color::rgb(216, 220, 226))
  cb.text("GPUI MoonBit Markdown Editor", 32, 36, 42, 17.0)
  cb.add_child()
  cb.div()
  cb.set_flex(1.0, 1.0, -1.0)
  cb.text(
    if current.path == "" {
      "Untitled.md"
    } else {
      current.path
    },
    102,
    113,
    125,
    14.0,
  )
  cb.add_child()
  cb.add_child()
  toolbar_button(cb, "new", "New", new_document)
  cb.add_child()
  toolbar_button(cb, "open", "Open", open_document)
  cb.add_child()
  toolbar_button(cb, "save", "Save", save_document)
  cb.add_child()
}

///|
fn build_preview(cb : @gpui.CommandBuffer, block : MarkdownBlock) -> Unit {
  let (size, red, green, blue, weight) : (Float, Int, Int, Int, Int) = match
    block.kind {
    Heading(1) => (28.0, 32, 36, 42, 700)
    Heading(2) => (23.0, 32, 36, 42, 700)
    Heading(_) => (19.0, 32, 36, 42, 700)
    Quote => (16.0, 89, 99, 110, 400)
    Code => (15.0, 55, 65, 81, 400)
    ListItem | Paragraph => (16.0, 32, 36, 42, 400)
  }
  cb.div()
  cb.set_key("block-\{block.id}")
  cb.set_on_click(block_handler(block.id).to_int())
  cb.set_cursor(@gpui.CURSOR_TEXT)
  cb.set_size(940.0, BLOCK_HEIGHT)
  cb.set_min_size(900, 58)
  cb.set_padding_sides(10, 20, 10, 20)
  cb.set_font_weight(weight)
  if block.kind is Code {
    cb.set_bg_color(@gpui.Color::rgb(240, 242, 244))
    cb.set_rounded(4.0)
    cb.set_font_family("monospace")
  }
  cb.rich_text(inline_runs(visible_markdown(block)), red, green, blue, size)
  cb.add_child()
}

///|
fn build_active_editor(cb : @gpui.CommandBuffer, block : MarkdownBlock) -> Unit {
  let (size, red, green, blue, weight) : (Float, Int, Int, Int, Int) = match
    block.kind {
    Heading(1) => (28.0, 32, 36, 42, 700)
    Heading(2) => (23.0, 32, 36, 42, 700)
    Heading(_) => (19.0, 32, 36, 42, 700)
    Quote => (16.0, 89, 99, 110, 400)
    Code => (15.0, 55, 65, 81, 400)
    ListItem | Paragraph => (16.0, 32, 36, 42, 400)
  }
  cb.div()
  cb.set_key("active-block-\{block.id}")
  cb.set_position(@gpui.POSITION_RELATIVE)
  cb.set_size(940.0, BLOCK_HEIGHT)
  cb.set_min_size(920, 58)
  cb.set_bg_color(@gpui.Color::rgb(250, 251, 253))

  // A transparent native input owns selection and IME above this formatted
  // layer, keeping the UI composition and Markdown presentation in MoonBit.
  cb.div()
  cb.set_key("active-markdown-content")
  cb.set_position(@gpui.POSITION_ABSOLUTE)
  cb.set_inset(0, 0, 0, 0)
  cb.set_padding_sides(10, 20, 10, 20)
  cb.set_font_weight(weight)
  if block.kind is Code {
    cb.set_bg_color(@gpui.Color::rgb(240, 242, 244))
    cb.set_rounded(4.0)
    cb.set_font_family("monospace")
  }
  cb.rich_text(inline_runs(visible_markdown(block)), red, green, blue, size)
  cb.add_child()
  cb.add_child()

  cb.div()
  cb.set_key("markdown-block-input")
  cb.set_position(@gpui.POSITION_ABSOLUTE)
  cb.set_inset(0, 0, 0, 0)
  cb.set_min_size(900, 58)
  cb.set_padding_sides(10, 20, 10, 20)
  cb.set_font_weight(weight)
  cb.set_text_size(size.to_int())
  cb.set_text_color(@gpui.Color::rgba(0, 0, 0, 0))
  cb.set_cursor(@gpui.CURSOR_TEXT)
  cb.text_input(editor_input.to_int(), "Write Markdown...")
  cb.add_child()
  cb.add_child()
}

///|
fn build_document(cb : @gpui.CommandBuffer, current : EditorModel) -> Unit {
  cb.div()
  cb.set_key("document-scroll")
  cb.set_size(960.0, DOCUMENT_VIEWPORT_HEIGHT)
  cb.set_flex_col()
  cb.set_overflow(@gpui.OVERFLOW_HIDDEN, @gpui.OVERFLOW_SCROLL)
  cb.set_scroll_id(scroll_id.to_int())
  cb.set_bg_color(@gpui.Color::white())
  cb.set_border_color(1.0, @gpui.Color::rgb(214, 217, 222))
  cb.set_rounded(4.0)
  let block_count = current.blocks.length()
  let start = virtual_window_start(current.scroll_y)
  let mut end = ((current.scroll_y + DOCUMENT_VIEWPORT_HEIGHT) / BLOCK_HEIGHT).to_int() +
    1 +
    VIEWPORT_OVERSCAN
  if end > block_count {
    end = block_count
  }
  if end < start {
    end = start
  }

  // Preserve the full scroll extent with two cheap, non-text spacer nodes.
  cb.div()
  cb.set_size(940.0, Float::from_int(start) * BLOCK_HEIGHT)
  cb.set_flex(0.0, 0.0, Float::from_int(start) * BLOCK_HEIGHT)
  cb.add_child()

  for index in start..<end {
    let block = current.blocks[index]
    if block.id == current.active_block {
      build_active_editor(cb, block)
      cb.add_child()
    } else {
      build_preview(cb, block)
      cb.add_child()
    }
  }

  cb.div()
  cb.set_size(940.0, Float::from_int(block_count - end) * BLOCK_HEIGHT)
  cb.set_flex(0.0, 0.0, Float::from_int(block_count - end) * BLOCK_HEIGHT)
  cb.add_child()
}

///|
fn build_footer(cb : @gpui.CommandBuffer, current : EditorModel) -> Unit {
  let status = if current.status != "" {
    current.status
  } else if !current.dirty {
    "Saved"
  } else {
    "Unsaved changes"
  }
  cb.div()
  cb.set_size(1280.0, 34.0)
  cb.set_flex_row()
  cb.set_center()
  cb.set_padding_sides(0, 18, 0, 18)
  cb.set_bg_color(@gpui.Color::white())
  cb.set_border_color(1.0, @gpui.Color::rgb(216, 220, 226))
  cb.div()
  cb.set_key("editor-status")
  cb.text(status, 102, 113, 125, 13.0)
  cb.add_child()
  cb.add_child()
  cb.div()
  cb.set_key("editor-metrics")
  cb.set_flex(1.0, 1.0, -1.0)
  cb.text(
    "{current.source_length} chars | {current.blocks.length()} blocks | MoonBit UI + GPUI",
    102, 113, 125, 13.0,
  )
  cb.add_child()
  cb.add_child()
}

///|
pub fn build_tree(view : Int) -> Result[Unit, Int] {
  let current = model.get(store)
  let cb = @gpui.CommandBuffer::new()
  cb.div()
  cb.set_size(1280.0, 800.0)
  cb.set_flex_col()
  cb.set_bg_color(@gpui.Color::rgb(245, 246, 248))
  build_header(cb, current)
  cb.add_child()
  cb.div()
  cb.set_flex(1.0, 1.0, -1.0)
  cb.set_center()
  cb.set_padding(16.0)
  build_document(cb, current)
  cb.add_child()
  cb.add_child()
  build_footer(cb, current)
  cb.add_child()
  cb.set_root()
  @gpui.build_tree(view, cb)
}

///|
pub fn sync_input(view : Int) -> Unit {
  sync_active_input(view)
}

///|
pub fn dispatch(
  version : Int,
  kind : Int,
  view : Int,
  data_a : Int,
  data_b : Int,
) -> Int {
  @gpui.framework_dispatch_with_patch(
    ctx,
    version,
    kind,
    view,
    data_a,
    data_b,
    fn(v) {
      if !incremental_input.val {
        false
      } else {
        incremental_input.val = false
        let current = model.get(store)
        let content = visible_markdown(current.blocks[current.active_block])
        let status = if current.status != "" {
          current.status
        } else if current.dirty {
          "Unsaved changes"
        } else {
          "Saved"
        }
        let metrics = "{current.source_length} chars | {current.blocks.length()} blocks | MoonBit UI + GPUI"
        match @gpui.update_text(v, "active-markdown-content", content) {
          Ok(_) =>
            match @gpui.update_text(v, "editor-status", status) {
              Ok(_) =>
                match @gpui.update_text(v, "editor-metrics", metrics) {
                  Ok(_) => true
                  Err(_) => false
                }
              Err(_) => false
            }
          Err(_) => false
        }
      }
    },
    fn(v) { build_tree(v) },
  )
}
