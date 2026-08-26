// Copyright 2025 International Digital Economy Academy
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

///|
fn[T : Debug] show_via_debug(value : T, logger : &Logger) -> Unit {
  logger.write_string(@debug.to_string(value))
}

///|
pub(all) enum Role {
  Unknown
  TextRun
  Cell
  Label
  Image
  Link
  Row
  ListItem
  ListMarker
  TreeItem
  ListBoxOption
  MenuItem
  MenuListOption
  Paragraph
  GenericContainer
  CheckBox
  RadioButton
  TextInput
  Button
  DefaultButton
  Pane
  RowHeader
  ColumnHeader
  RowGroup
  List
  Table
  LayoutTableCell
  LayoutTableRow
  LayoutTable
  Switch
  Menu
  MultilineTextInput
  SearchInput
  DateInput
  DateTimeInput
  WeekInput
  MonthInput
  TimeInput
  EmailInput
  NumberInput
  PasswordInput
  PhoneNumberInput
  UrlInput
  Abbr
  Alert
  AlertDialog
  Application
  Article
  Audio
  Banner
  Blockquote
  Canvas
  Caption
  Caret
  Code
  ColorWell
  ComboBox
  EditableComboBox
  Complementary
  Comment
  ContentDeletion
  ContentInsertion
  ContentInfo
  Definition
  DescriptionList
  Details
  Dialog
  DisclosureTriangle
  Document
  EmbeddedObject
  Emphasis
  Feed
  FigureCaption
  Figure
  Footer
  Form
  Grid
  GridCell
  Group
  Header
  Heading
  Iframe
  IframePresentational
  ImeCandidate
  Keyboard
  Legend
  LineBreak
  ListBox
  Log
  Main
  Mark
  Marquee
  Math
  MenuBar
  MenuItemCheckBox
  MenuItemRadio
  MenuListPopup
  Meter
  Navigation
  Note
  PluginObject
  ProgressIndicator
  RadioGroup
  Region
  RootWebArea
  Ruby
  RubyAnnotation
  ScrollBar
  ScrollView
  Search
  Section
  SectionFooter
  SectionHeader
  Slider
  SpinButton
  Splitter
  Status
  Strong
  Suggestion
  SvgRoot
  Tab
  TabList
  TabPanel
  Term
  Time
  Timer
  TitleBar
  Toolbar
  Tooltip
  Tree
  TreeGrid
  Video
  WebView
  Window
  PdfActionableHighlight
  PdfRoot
  GraphicsDocument
  GraphicsObject
  GraphicsSymbol
  DocAbstract
  DocAcknowledgements
  DocAfterword
  DocAppendix
  DocBackLink
  DocBiblioEntry
  DocBibliography
  DocBiblioRef
  DocChapter
  DocColophon
  DocConclusion
  DocCover
  DocCredit
  DocCredits
  DocDedication
  DocEndnote
  DocEndnotes
  DocEpigraph
  DocEpilogue
  DocErrata
  DocExample
  DocFootnote
  DocForeword
  DocGlossary
  DocGlossRef
  DocIndex
  DocIntroduction
  DocNoteRef
  DocNotice
  DocPageBreak
  DocPageFooter
  DocPageHeader
  DocPageList
  DocPart
  DocPreface
  DocPrologue
  DocPullquote
  DocQna
  DocSubtitle
  DocTip
  DocToc
  ListGrid
  Terminal
} derive(Eq, Debug)

///|
pub(all) enum Action {
  Click
  Focus
  Blur
  Collapse
  Expand
  CustomAction
  Decrement
  Increment
  HideTooltip
  ShowTooltip
  ReplaceSelectedText
  ScrollDown
  ScrollLeft
  ScrollRight
  ScrollUp
  ScrollIntoView
  ScrollToPoint
  SetScrollOffset
  SetTextSelection
  SetSequentialFocusNavigationStartingPoint
  SetValue
  ShowContextMenu
} derive(Eq, Debug)

///|
pub(all) enum ScrollUnit {
  Item
  Page
} derive(Eq, Debug)

///|
pub(all) enum ScrollHint {
  TopLeft
  BottomRight
  TopEdge
  BottomEdge
  LeftEdge
  RightEdge
} derive(Eq, Debug)

///|
pub fn Action::n(value : Int) -> Action? {
  match value {
    0 => Some(Click)
    1 => Some(Focus)
    2 => Some(Blur)
    3 => Some(Collapse)
    4 => Some(Expand)
    5 => Some(CustomAction)
    6 => Some(Decrement)
    7 => Some(Increment)
    8 => Some(HideTooltip)
    9 => Some(ShowTooltip)
    10 => Some(ReplaceSelectedText)
    11 => Some(ScrollDown)
    12 => Some(ScrollLeft)
    13 => Some(ScrollRight)
    14 => Some(ScrollUp)
    15 => Some(ScrollIntoView)
    16 => Some(ScrollToPoint)
    17 => Some(SetScrollOffset)
    18 => Some(SetTextSelection)
    19 => Some(SetSequentialFocusNavigationStartingPoint)
    20 => Some(SetValue)
    21 => Some(ShowContextMenu)
    _ => None
  }
}

///|
pub fn Action::index(self : Action) -> Int {
  match self {
    Click => 0
    Focus => 1
    Blur => 2
    Collapse => 3
    Expand => 4
    CustomAction => 5
    Decrement => 6
    Increment => 7
    HideTooltip => 8
    ShowTooltip => 9
    ReplaceSelectedText => 10
    ScrollDown => 11
    ScrollLeft => 12
    ScrollRight => 13
    ScrollUp => 14
    ScrollIntoView => 15
    ScrollToPoint => 16
    SetScrollOffset => 17
    SetTextSelection => 18
    SetSequentialFocusNavigationStartingPoint => 19
    SetValue => 20
    ShowContextMenu => 21
  }
}

///|
pub fn Action::mask(self : Action) -> UInt {
  1U << self.index()
}

///|
pub fn action_mask_to_action_vec(mask : UInt) -> Array[Action] {
  let actions : Array[Action] = []
  let mut i = 0
  while Action::n(i) is Some(action) {
    if (mask & action.mask()) != 0U {
      actions.push(action)
    }
    i = i + 1
  }
  actions
}

///|
pub(all) enum TextDecorationStyle {
  Solid
  Dotted
  Dashed
  Double
  Wavy
} derive(Eq, Debug)

///|
pub(all) struct Color {
  red : Byte
  green : Byte
  blue : Byte
  alpha : Byte
} derive(Eq, Debug)

///|
pub fn Color::Color(
  red : Byte,
  green : Byte,
  blue : Byte,
  alpha : Byte,
) -> Color {
  { red, green, blue, alpha }
}

///|
pub(all) struct TextDecoration {
  style : TextDecorationStyle
  color : Color
} derive(Eq, Debug)

///|
pub fn TextDecoration::TextDecoration(
  style : TextDecorationStyle,
  color : Color,
) -> TextDecoration {
  { style, color }
}

///|
pub(all) enum Orientation {
  Horizontal
  Vertical
} derive(Eq, Debug)

///|
pub(all) enum TextDirection {
  LeftToRight
  RightToLeft
  TopToBottom
  BottomToTop
} derive(Eq, Debug)

///|
pub(all) enum Invalid {
  True
  Grammar
  Spelling
} derive(Eq, Debug)

///|
pub(all) enum Toggled {
  False
  True
  Mixed
} derive(Eq, Debug)

///|
pub fn Toggled::from_bool(value : Bool) -> Toggled {
  if value {
    Toggled::True
  } else {
    Toggled::False
  }
}

///|
pub(all) enum SortDirection {
  Ascending
  Descending
  Other
} derive(Eq, Debug)

///|
pub(all) enum AriaCurrent {
  False
  True
  Page
  Step
  Location
  Date
  Time
} derive(Eq, Debug)

///|
pub(all) enum AutoComplete {
  Inline
  List
  Both
} derive(Eq, Debug)

///|
pub(all) enum Live {
  Off
  Polite
  Assertive
} derive(Eq, Debug)

///|
pub(all) enum HasPopup {
  Menu
  Listbox
  Tree
  Grid
  Dialog
} derive(Eq, Debug)

///|
pub(all) enum ListStyle {
  Circle
  Disc
  Image
  Numeric
  Square
  Other
} derive(Eq, Debug)

///|
pub(all) enum TextAlign {
  Left
  Right
  Center
  Justify
} derive(Eq, Debug)

///|
pub(all) enum VerticalOffset {
  Subscript
  Superscript
} derive(Eq, Debug)

///|
pub(all) struct NodeId(UInt64) derive(Eq, Debug, Hash)

///|
pub fn NodeId::from_u64(value : UInt64) -> NodeId {
  NodeId(value)
}

///|
pub fn NodeId::root() -> NodeId {
  NodeId::from_u64(0UL)
}

///|
pub fn NodeId::to_u64(self : NodeId) -> UInt64 {
  self.0
}

///|
pub fn NodeId::debug(self : NodeId) -> String {
  "#" + self.0.to_string()
}

///|
pub(all) struct Uuid {
  high : UInt64
  low : UInt64
} derive(Eq, Debug, Hash)

///|
pub fn Uuid::nil() -> Uuid {
  { high: 0, low: 0 }
}

///|
pub(all) struct TreeId(Uuid) derive(Eq, Debug, Hash)

///|
pub fn TreeId::root() -> TreeId {
  TreeId(Uuid::nil())
}

///|
pub(all) struct TextPosition {
  node : NodeId
  character_index : Int
} derive(Eq, Debug)

///|
pub fn TextPosition::TextPosition(
  node : NodeId,
  character_index : Int,
) -> TextPosition {
  { node, character_index }
}

///|
pub(all) struct TextSelection {
  anchor : TextPosition
  focus : TextPosition
} derive(Eq, Debug)

///|
pub fn TextSelection::TextSelection(
  anchor : TextPosition,
  focus : TextPosition,
) -> TextSelection {
  { anchor, focus }
}

///|
pub(all) struct CustomAction {
  id : Int
  description : String
} derive(Eq, Debug)

///|
pub fn CustomAction::CustomAction(
  id : Int,
  description : String,
) -> CustomAction {
  { id, description }
}

///|
pub fn CustomAction::debug(self : CustomAction) -> String {
  "CustomAction { id: " +
  self.id.to_string() +
  ", description: \"" +
  self.description +
  "\" }"
}

///|
pub impl Show for Role with output(self, logger) {
  show_via_debug(self, logger)
}

///|
pub impl Show for Action with output(self, logger) {
  show_via_debug(self, logger)
}

///|
pub impl Show for ScrollUnit with output(self, logger) {
  show_via_debug(self, logger)
}

///|
pub impl Show for ScrollHint with output(self, logger) {
  show_via_debug(self, logger)
}

///|
pub impl Show for TextDecorationStyle with output(self, logger) {
  show_via_debug(self, logger)
}

///|
pub impl Show for Color with output(self, logger) {
  show_via_debug(self, logger)
}

///|
pub impl Show for TextDecoration with output(self, logger) {
  show_via_debug(self, logger)
}

///|
pub impl Show for Orientation with output(self, logger) {
  show_via_debug(self, logger)
}

///|
pub impl Show for TextDirection with output(self, logger) {
  show_via_debug(self, logger)
}

///|
pub impl Show for Invalid with output(self, logger) {
  show_via_debug(self, logger)
}

///|
pub impl Show for Toggled with output(self, logger) {
  show_via_debug(self, logger)
}

///|
pub impl Show for SortDirection with output(self, logger) {
  show_via_debug(self, logger)
}

///|
pub impl Show for AriaCurrent with output(self, logger) {
  show_via_debug(self, logger)
}

///|
pub impl Show for AutoComplete with output(self, logger) {
  show_via_debug(self, logger)
}

///|
pub impl Show for Live with output(self, logger) {
  show_via_debug(self, logger)
}

///|
pub impl Show for HasPopup with output(self, logger) {
  show_via_debug(self, logger)
}

///|
pub impl Show for ListStyle with output(self, logger) {
  show_via_debug(self, logger)
}

///|
pub impl Show for TextAlign with output(self, logger) {
  show_via_debug(self, logger)
}

///|
pub impl Show for VerticalOffset with output(self, logger) {
  show_via_debug(self, logger)
}

///|
pub impl Show for NodeId with output(self, logger) {
  show_via_debug(self, logger)
}

///|
pub impl Show for Uuid with output(self, logger) {
  show_via_debug(self, logger)
}

///|
pub impl Show for TreeId with output(self, logger) {
  show_via_debug(self, logger)
}

///|
pub impl Show for TextPosition with output(self, logger) {
  show_via_debug(self, logger)
}

///|
pub impl Show for TextSelection with output(self, logger) {
  show_via_debug(self, logger)
}

///|
pub impl Show for CustomAction with output(self, logger) {
  show_via_debug(self, logger)
}

///|
const PROPERTY_ID_COUNT : Int = 86

///|
const PID_CHILDREN : Int = 0

///|
const PID_CONTROLS : Int = 1

///|
const PID_DETAILS : Int = 2

///|
const PID_DESCRIBED_BY : Int = 3

///|
const PID_FLOW_TO : Int = 4

///|
const PID_LABELLED_BY : Int = 5

///|
const PID_OWNS : Int = 6

///|
const PID_RADIO_GROUP : Int = 7

///|
const PID_ACTIVE_DESCENDANT : Int = 8

///|
const PID_ERROR_MESSAGE : Int = 9

///|
const PID_IN_PAGE_LINK_TARGET : Int = 10

///|
const PID_MEMBER_OF : Int = 11

///|
const PID_NEXT_ON_LINE : Int = 12

///|
const PID_PREVIOUS_ON_LINE : Int = 13

///|
const PID_POPUP_FOR : Int = 14

///|
const PID_LABEL : Int = 15

///|
const PID_DESCRIPTION : Int = 16

///|
const PID_VALUE : Int = 17

///|
const PID_ACCESS_KEY : Int = 18

///|
const PID_AUTHOR_ID : Int = 19

///|
const PID_CLASS_NAME : Int = 20

///|
const PID_FONT_FAMILY : Int = 21

///|
const PID_HTML_TAG : Int = 22

///|
const PID_INNER_HTML : Int = 23

///|
const PID_KEYBOARD_SHORTCUT : Int = 24

///|
const PID_LANGUAGE : Int = 25

///|
const PID_PLACEHOLDER : Int = 26

///|
const PID_ROLE_DESCRIPTION : Int = 27

///|
const PID_STATE_DESCRIPTION : Int = 28

///|
const PID_TOOLTIP : Int = 29

///|
const PID_URL : Int = 30

///|
const PID_ROW_INDEX_TEXT : Int = 31

///|
const PID_COLUMN_INDEX_TEXT : Int = 32

///|
const PID_BRAILLE_LABEL : Int = 33

///|
const PID_BRAILLE_ROLE_DESCRIPTION : Int = 34

///|
const PID_SCROLL_X : Int = 35

///|
const PID_SCROLL_X_MIN : Int = 36

///|
const PID_SCROLL_X_MAX : Int = 37

///|
const PID_SCROLL_Y : Int = 38

///|
const PID_SCROLL_Y_MIN : Int = 39

///|
const PID_SCROLL_Y_MAX : Int = 40

///|
const PID_NUMERIC_VALUE : Int = 41

///|
const PID_MIN_NUMERIC_VALUE : Int = 42

///|
const PID_MAX_NUMERIC_VALUE : Int = 43

///|
const PID_NUMERIC_VALUE_STEP : Int = 44

///|
const PID_NUMERIC_VALUE_JUMP : Int = 45

///|
const PID_FONT_SIZE : Int = 46

///|
const PID_FONT_WEIGHT : Int = 47

///|
const PID_ROW_COUNT : Int = 48

///|
const PID_COLUMN_COUNT : Int = 49

///|
const PID_ROW_INDEX : Int = 50

///|
const PID_COLUMN_INDEX : Int = 51

///|
const PID_ROW_SPAN : Int = 52

///|
const PID_COLUMN_SPAN : Int = 53

///|
const PID_LEVEL : Int = 54

///|
const PID_SIZE_OF_SET : Int = 55

///|
const PID_POSITION_IN_SET : Int = 56

///|
const PID_COLOR_VALUE : Int = 57

///|
const PID_BACKGROUND_COLOR : Int = 58

///|
const PID_FOREGROUND_COLOR : Int = 59

///|
const PID_OVERLINE : Int = 60

///|
const PID_STRIKETHROUGH : Int = 61

///|
const PID_UNDERLINE : Int = 62

///|
const PID_CHARACTER_LENGTHS : Int = 63

///|
const PID_WORD_STARTS : Int = 64

///|
const PID_CHARACTER_POSITIONS : Int = 65

///|
const PID_CHARACTER_WIDTHS : Int = 66

///|
const PID_EXPANDED : Int = 67

///|
const PID_SELECTED : Int = 68

///|
const PID_INVALID : Int = 69

///|
const PID_TOGGLED : Int = 70

///|
const PID_LIVE : Int = 71

///|
const PID_TEXT_DIRECTION : Int = 72

///|
const PID_ORIENTATION : Int = 73

///|
const PID_SORT_DIRECTION : Int = 74

///|
const PID_ARIA_CURRENT : Int = 75

///|
const PID_AUTO_COMPLETE : Int = 76

///|
const PID_HAS_POPUP : Int = 77

///|
const PID_LIST_STYLE : Int = 78

///|
const PID_TEXT_ALIGN : Int = 79

///|
const PID_VERTICAL_OFFSET : Int = 80

///|
const PID_TRANSFORM : Int = 81

///|
const PID_BOUNDS : Int = 82

///|
const PID_TEXT_SELECTION : Int = 83

///|
const PID_CUSTOM_ACTIONS : Int = 84

///|
const PID_TREE_ID : Int = 85

///|
priv enum PropertyValue {
  None
  NodeIdVec(Array[NodeId])
  NodeId(NodeId)
  String(String)
  F64(Double)
  F32(Float)
  Usize(Int)
  Color(Color)
  TextDecoration(TextDecoration)
  LengthSlice(Array[Int])
  CoordSlice(Array[Float])
  Affine(Affine)
  Rect(Rect)
  TextSelection(TextSelection)
  Bool(Bool)
  Invalid(Invalid)
  Toggled(Toggled)
  Live(Live)
  TextDirection(TextDirection)
  Orientation(Orientation)
  SortDirection(SortDirection)
  AriaCurrent(AriaCurrent)
  AutoComplete(AutoComplete)
  HasPopup(HasPopup)
  ListStyle(ListStyle)
  TextAlign(TextAlign)
  VerticalOffset(VerticalOffset)
  TreeId(TreeId)
  CustomActionVec(Array[CustomAction])
}

///|
priv struct Properties {
  indices : Array[Int]
  values : Array[PropertyValue]
}

///|
fn Properties::Properties() -> Properties {
  { indices: Array::make(PROPERTY_ID_COUNT, -1), values: [] }
}

///|
fn Properties::get(self : Properties, id : Int) -> PropertyValue {
  let index = self.indices[id]
  if index < 0 {
    PropertyValue::None
  } else {
    self.values[index]
  }
}

///|
fn Properties::set(self : Properties, id : Int, value : PropertyValue) -> Unit {
  let index = self.indices[id]
  if index < 0 {
    self.values.push(value)
    self.indices[id] = self.values.length() - 1
  } else {
    self.values[index] = value
  }
}

///|
fn Properties::clear(self : Properties, id : Int) -> Unit {
  let index = self.indices[id]
  if index >= 0 {
    self.values[index] = PropertyValue::None
  }
}

///|
fn Properties::get_node_id_vec(self : Properties, id : Int) -> Array[NodeId] {
  match self.get(id) {
    NodeIdVec(v) => v
    _ => []
  }
}

///|
fn Properties::set_node_id_vec(
  self : Properties,
  id : Int,
  value : Array[NodeId],
) -> Unit {
  self.set(id, NodeIdVec(value))
}

///|
fn Properties::push_to_node_id_vec(
  self : Properties,
  id : Int,
  item : NodeId,
) -> Unit {
  match self.get(id) {
    NodeIdVec(v) => v.push(item)
    _ => self.set(id, NodeIdVec([item]))
  }
}

///|
fn Properties::get_node_id(self : Properties, id : Int) -> NodeId? {
  match self.get(id) {
    NodeId(v) => Some(v)
    _ => None
  }
}

///|
fn Properties::set_node_id(self : Properties, id : Int, value : NodeId) -> Unit {
  self.set(id, NodeId(value))
}

///|
fn Properties::get_color(self : Properties, id : Int) -> Color? {
  match self.get(id) {
    Color(v) => Some(v)
    _ => None
  }
}

///|
fn Properties::set_color(self : Properties, id : Int, value : Color) -> Unit {
  self.set(id, Color(value))
}

///|
fn Properties::get_text_decoration(
  self : Properties,
  id : Int,
) -> TextDecoration? {
  match self.get(id) {
    TextDecoration(v) => Some(v)
    _ => None
  }
}

///|
fn Properties::set_text_decoration(
  self : Properties,
  id : Int,
  value : TextDecoration,
) -> Unit {
  self.set(id, TextDecoration(value))
}

///|
fn Properties::get_length_slice(self : Properties, id : Int) -> Array[Int] {
  match self.get(id) {
    LengthSlice(v) => v
    _ => []
  }
}

///|
fn Properties::set_length_slice(
  self : Properties,
  id : Int,
  value : Array[Int],
) -> Unit {
  self.set(id, LengthSlice(value))
}

///|
fn Properties::get_coord_slice(self : Properties, id : Int) -> Array[Float]? {
  match self.get(id) {
    CoordSlice(v) => Some(v)
    _ => None
  }
}

///|
fn Properties::set_coord_slice(
  self : Properties,
  id : Int,
  value : Array[Float],
) -> Unit {
  self.set(id, CoordSlice(value))
}

///|
fn Properties::get_affine(self : Properties, id : Int) -> Affine? {
  match self.get(id) {
    Affine(v) => Some(v)
    _ => None
  }
}

///|
fn Properties::set_affine(self : Properties, id : Int, value : Affine) -> Unit {
  self.set(id, Affine(value))
}

///|
fn Properties::get_rect(self : Properties, id : Int) -> Rect? {
  match self.get(id) {
    Rect(v) => Some(v)
    _ => None
  }
}

///|
fn Properties::set_rect(self : Properties, id : Int, value : Rect) -> Unit {
  self.set(id, Rect(value))
}

///|
fn Properties::get_text_selection(
  self : Properties,
  id : Int,
) -> TextSelection? {
  match self.get(id) {
    TextSelection(v) => Some(v)
    _ => None
  }
}

///|
fn Properties::set_text_selection(
  self : Properties,
  id : Int,
  value : TextSelection,
) -> Unit {
  self.set(id, TextSelection(value))
}

///|
fn Properties::get_custom_action_vec(
  self : Properties,
  id : Int,
) -> Array[CustomAction] {
  match self.get(id) {
    CustomActionVec(v) => v
    _ => []
  }
}

///|
fn Properties::set_custom_action_vec(
  self : Properties,
  id : Int,
  value : Array[CustomAction],
) -> Unit {
  self.set(id, CustomActionVec(value))
}

///|
fn Properties::push_to_custom_action_vec(
  self : Properties,
  id : Int,
  action : CustomAction,
) -> Unit {
  match self.get(id) {
    CustomActionVec(v) => v.push(action)
    _ => self.set(id, CustomActionVec([action]))
  }
}

///|
fn Properties::get_string(self : Properties, id : Int) -> String? {
  match self.get(id) {
    String(v) => Some(v)
    _ => None
  }
}

///|
fn Properties::set_string(self : Properties, id : Int, value : String) -> Unit {
  self.set(id, String(value))
}

///|
fn Properties::get_f64(self : Properties, id : Int) -> Double? {
  match self.get(id) {
    F64(v) => Some(v)
    _ => None
  }
}

///|
fn Properties::set_f64(self : Properties, id : Int, value : Double) -> Unit {
  self.set(id, F64(value))
}

///|
fn Properties::get_f32(self : Properties, id : Int) -> Float? {
  match self.get(id) {
    F32(v) => Some(v)
    _ => None
  }
}

///|
fn Properties::set_f32(self : Properties, id : Int, value : Float) -> Unit {
  self.set(id, F32(value))
}

///|
fn Properties::get_usize(self : Properties, id : Int) -> Int? {
  match self.get(id) {
    Usize(v) => Some(v)
    _ => None
  }
}

///|
fn Properties::set_usize(self : Properties, id : Int, value : Int) -> Unit {
  self.set(id, Usize(value))
}

///|
fn Properties::get_bool(self : Properties, id : Int) -> Bool? {
  match self.get(id) {
    Bool(v) => Some(v)
    _ => None
  }
}

///|
fn Properties::set_bool(self : Properties, id : Int, value : Bool) -> Unit {
  self.set(id, Bool(value))
}

///|
fn Properties::get_invalid(self : Properties, id : Int) -> Invalid? {
  match self.get(id) {
    Invalid(v) => Some(v)
    _ => None
  }
}

///|
fn Properties::set_invalid(
  self : Properties,
  id : Int,
  value : Invalid,
) -> Unit {
  self.set(id, Invalid(value))
}

///|
fn Properties::get_toggled(self : Properties, id : Int) -> Toggled? {
  match self.get(id) {
    Toggled(v) => Some(v)
    _ => None
  }
}

///|
fn Properties::set_toggled(
  self : Properties,
  id : Int,
  value : Toggled,
) -> Unit {
  self.set(id, Toggled(value))
}

///|
fn Properties::get_live(self : Properties, id : Int) -> Live? {
  match self.get(id) {
    Live(v) => Some(v)
    _ => None
  }
}

///|
fn Properties::set_live(self : Properties, id : Int, value : Live) -> Unit {
  self.set(id, Live(value))
}

///|
fn Properties::get_text_direction(
  self : Properties,
  id : Int,
) -> TextDirection? {
  match self.get(id) {
    TextDirection(v) => Some(v)
    _ => None
  }
}

///|
fn Properties::set_text_direction(
  self : Properties,
  id : Int,
  value : TextDirection,
) -> Unit {
  self.set(id, TextDirection(value))
}

///|
fn Properties::get_orientation(self : Properties, id : Int) -> Orientation? {
  match self.get(id) {
    Orientation(v) => Some(v)
    _ => None
  }
}

///|
fn Properties::set_orientation(
  self : Properties,
  id : Int,
  value : Orientation,
) -> Unit {
  self.set(id, Orientation(value))
}

///|
fn Properties::get_sort_direction(
  self : Properties,
  id : Int,
) -> SortDirection? {
  match self.get(id) {
    SortDirection(v) => Some(v)
    _ => None
  }
}

///|
fn Properties::set_sort_direction(
  self : Properties,
  id : Int,
  value : SortDirection,
) -> Unit {
  self.set(id, SortDirection(value))
}

///|
fn Properties::get_aria_current(self : Properties, id : Int) -> AriaCurrent? {
  match self.get(id) {
    AriaCurrent(v) => Some(v)
    _ => None
  }
}

///|
fn Properties::set_aria_current(
  self : Properties,
  id : Int,
  value : AriaCurrent,
) -> Unit {
  self.set(id, AriaCurrent(value))
}

///|
fn Properties::get_auto_complete(self : Properties, id : Int) -> AutoComplete? {
  match self.get(id) {
    AutoComplete(v) => Some(v)
    _ => None
  }
}

///|
fn Properties::set_auto_complete(
  self : Properties,
  id : Int,
  value : AutoComplete,
) -> Unit {
  self.set(id, AutoComplete(value))
}

///|
fn Properties::get_has_popup(self : Properties, id : Int) -> HasPopup? {
  match self.get(id) {
    HasPopup(v) => Some(v)
    _ => None
  }
}

///|
fn Properties::set_has_popup(
  self : Properties,
  id : Int,
  value : HasPopup,
) -> Unit {
  self.set(id, HasPopup(value))
}

///|
fn Properties::get_list_style(self : Properties, id : Int) -> ListStyle? {
  match self.get(id) {
    ListStyle(v) => Some(v)
    _ => None
  }
}

///|
fn Properties::set_list_style(
  self : Properties,
  id : Int,
  value : ListStyle,
) -> Unit {
  self.set(id, ListStyle(value))
}

///|
fn Properties::get_text_align(self : Properties, id : Int) -> TextAlign? {
  match self.get(id) {
    TextAlign(v) => Some(v)
    _ => None
  }
}

///|
fn Properties::set_text_align(
  self : Properties,
  id : Int,
  value : TextAlign,
) -> Unit {
  self.set(id, TextAlign(value))
}

///|
fn Properties::get_vertical_offset(
  self : Properties,
  id : Int,
) -> VerticalOffset? {
  match self.get(id) {
    VerticalOffset(v) => Some(v)
    _ => None
  }
}

///|
fn Properties::set_vertical_offset(
  self : Properties,
  id : Int,
  value : VerticalOffset,
) -> Unit {
  self.set(id, VerticalOffset(value))
}

///|
fn Properties::get_tree_id(self : Properties, id : Int) -> TreeId? {
  match self.get(id) {
    TreeId(v) => Some(v)
    _ => None
  }
}

///|
fn Properties::set_tree_id(self : Properties, id : Int, value : TreeId) -> Unit {
  self.set(id, TreeId(value))
}

///|
fn join_with_sep(items : Array[String], sep : String) -> String {
  if items.length() == 0 {
    ""
  } else {
    let mut out = items[0]
    for i = 1; i < items.length(); i = i + 1 {
      out = out + sep + items[i]
    }
    out
  }
}

///|
fn action_vec_debug(actions : Array[Action]) -> String {
  let names = actions.map(fn(a : Action) { a.to_string() })
  join_with_sep(names, ", ")
}

///|
fn node_id_vec_debug(ids : Array[NodeId]) -> String {
  let parts = ids.map(fn(id : NodeId) { id.debug() })
  join_with_sep(parts, ", ")
}

///|
fn custom_action_vec_debug(actions : Array[CustomAction]) -> String {
  let parts = actions.map(fn(a : CustomAction) { a.debug() })
  join_with_sep(parts, ", ")
}

///|
fn debug_string_literal(value : String) -> String {
  let parts : Array[String] = []
  for c in value {
    match c {
      '\\' => parts.push("\\\\")
      '"' => parts.push("\\\"")
      '\n' => parts.push("\\n")
      '\r' => parts.push("\\r")
      '\t' => parts.push("\\t")
      _ => parts.push(c.to_string())
    }
  }
  "\"" + join_with_sep(parts, "") + "\""
}

///|
fn debug_double(value : Double) -> String {
  let s = value.to_string()
  if s.contains(".") ||
    s.contains("e") ||
    s.contains("E") ||
    s == "NaN" ||
    s == "inf" ||
    s == "-inf" {
    s
  } else {
    s + ".0"
  }
}

///|
fn debug_float(value : Float) -> String {
  let s = value.to_string()
  if s.contains(".") ||
    s.contains("e") ||
    s.contains("E") ||
    s == "NaN" ||
    s == "inf" ||
    s == "-inf" {
    s
  } else {
    s + ".0"
  }
}

///|
fn int_slice_debug(value : Array[Int]) -> String {
  if value.length() == 0 {
    "[]"
  } else {
    let parts = value.map(fn(v : Int) { v.to_string() })
    "[" + join_with_sep(parts, ", ") + "]"
  }
}

///|
fn float_slice_debug(value : Array[Float]) -> String {
  if value.length() == 0 {
    "[]"
  } else {
    let parts = value.map(fn(v : Float) { debug_float(v) })
    "[" + join_with_sep(parts, ", ") + "]"
  }
}

///|
fn color_debug(value : Color) -> String {
  "Color { red: " +
  value.red.to_int().to_string() +
  ", green: " +
  value.green.to_int().to_string() +
  ", blue: " +
  value.blue.to_int().to_string() +
  ", alpha: " +
  value.alpha.to_int().to_string() +
  " }"
}

///|
fn text_decoration_debug(value : TextDecoration) -> String {
  "TextDecoration { style: " +
  value.style.to_string() +
  ", color: " +
  color_debug(value.color) +
  " }"
}

///|
fn affine_debug(value : Affine) -> String {
  let parts = value.as_coeffs().map(fn(v : Double) { debug_double(v) })
  "Affine::Affine([" + join_with_sep(parts, ", ") + "])"
}

///|
fn rect_debug(value : Rect) -> String {
  "Rect { x0: " +
  debug_double(value.x0) +
  ", y0: " +
  debug_double(value.y0) +
  ", x1: " +
  debug_double(value.x1) +
  ", y1: " +
  debug_double(value.y1) +
  " }"
}

///|
fn text_position_debug(value : TextPosition) -> String {
  "TextPosition { node: " +
  value.node.debug() +
  ", character_index: " +
  value.character_index.to_string() +
  " }"
}

///|
fn text_selection_debug(value : TextSelection) -> String {
  "TextSelection { anchor: " +
  text_position_debug(value.anchor) +
  ", focus: " +
  text_position_debug(value.focus) +
  " }"
}

///|
fn uuid_hex_digit(value : UInt) -> Char {
  let v = value.reinterpret_as_int()
  if v < 10 {
    Int::unsafe_to_char(48 + v)
  } else {
    Int::unsafe_to_char(87 + v)
  }
}

///|
fn u64_hex_digits(value : UInt64) -> Array[Char] {
  let digits : Array[Char] = []
  let mut shift = 60
  while shift >= 0 {
    let digit = ((value >> shift) & 0xFUL).to_uint()
    digits.push(uuid_hex_digit(digit))
    shift = shift - 4
  }
  digits
}

///|
pub fn Uuid::debug(self : Uuid) -> String {
  let parts : Array[String] = []
  let mut i = 0
  let hi = u64_hex_digits(self.high)
  let lo = u64_hex_digits(self.low)
  for c in hi {
    if i == 8 || i == 12 {
      parts.push("-")
    }
    parts.push(c.to_string())
    i = i + 1
  }
  for c in lo {
    if i == 16 || i == 20 {
      parts.push("-")
    }
    parts.push(c.to_string())
    i = i + 1
  }
  join_with_sep(parts, "")
}

///|
pub fn TreeId::debug(self : TreeId) -> String {
  "TreeId(" + self.0.debug() + ")"
}

///|
pub(all) struct Node {
  priv mut role : Role
  priv mut actions : UInt
  priv mut child_actions : UInt
  priv mut flags : UInt
  priv properties : Properties
}

///|
pub fn Node::Node(role : Role) -> Node {
  {
    role,
    actions: 0U,
    child_actions: 0U,
    flags: 0U,
    properties: Properties::Properties(),
  }
}

///|
pub fn Node::role(self : Node) -> Role {
  self.role
}

///|
pub fn Node::set_role(self : Node, role : Role) -> Unit {
  self.role = role
}

///|
pub fn Node::supports_action(self : Node, action : Action) -> Bool {
  (self.actions & action.mask()) != 0U
}

///|
pub fn Node::child_supports_action(self : Node, action : Action) -> Bool {
  (self.child_actions & action.mask()) != 0U
}

///|
pub fn Node::add_action(self : Node, action : Action) -> Unit {
  self.actions = self.actions | action.mask()
}

///|
pub fn Node::add_child_action(self : Node, action : Action) -> Unit {
  self.child_actions = self.child_actions | action.mask()
}

///|
pub fn Node::actions_mask(self : Node) -> UInt {
  self.actions
}

///|
pub fn Node::child_actions_mask(self : Node) -> UInt {
  self.child_actions
}

///|
pub fn Node::remove_action(self : Node, action : Action) -> Unit {
  self.actions = self.actions & action.mask().lnot()
}

///|
pub fn Node::remove_child_action(self : Node, action : Action) -> Unit {
  self.child_actions = self.child_actions & action.mask().lnot()
}

///|
pub fn Node::clear_actions(self : Node) -> Unit {
  self.actions = 0U
}

///|
pub fn Node::clear_child_actions(self : Node) -> Unit {
  self.child_actions = 0U
}

///|
pub fn Node::is_hidden(self : Node) -> Bool {
  (self.flags & (1U << 0)) != 0U
}

///|
pub fn Node::set_hidden(self : Node) -> Unit {
  self.flags = self.flags | (1U << 0)
}

///|
pub fn Node::clear_hidden(self : Node) -> Unit {
  self.flags = self.flags & (1U << 0).lnot()
}

///|
pub fn Node::is_multiselectable(self : Node) -> Bool {
  (self.flags & (1U << 1)) != 0U
}

///|
pub fn Node::set_multiselectable(self : Node) -> Unit {
  self.flags = self.flags | (1U << 1)
}

///|
pub fn Node::clear_multiselectable(self : Node) -> Unit {
  self.flags = self.flags & (1U << 1).lnot()
}

///|
pub fn Node::is_required(self : Node) -> Bool {
  (self.flags & (1U << 2)) != 0U
}

///|
pub fn Node::set_required(self : Node) -> Unit {
  self.flags = self.flags | (1U << 2)
}

///|
pub fn Node::clear_required(self : Node) -> Unit {
  self.flags = self.flags & (1U << 2).lnot()
}

///|
pub fn Node::is_visited(self : Node) -> Bool {
  (self.flags & (1U << 3)) != 0U
}

///|
pub fn Node::set_visited(self : Node) -> Unit {
  self.flags = self.flags | (1U << 3)
}

///|
pub fn Node::clear_visited(self : Node) -> Unit {
  self.flags = self.flags & (1U << 3).lnot()
}

///|
pub fn Node::is_busy(self : Node) -> Bool {
  (self.flags & (1U << 4)) != 0U
}

///|
pub fn Node::set_busy(self : Node) -> Unit {
  self.flags = self.flags | (1U << 4)
}

///|
pub fn Node::clear_busy(self : Node) -> Unit {
  self.flags = self.flags & (1U << 4).lnot()
}

///|
pub fn Node::is_live_atomic(self : Node) -> Bool {
  (self.flags & (1U << 5)) != 0U
}

///|
pub fn Node::set_live_atomic(self : Node) -> Unit {
  self.flags = self.flags | (1U << 5)
}

///|
pub fn Node::clear_live_atomic(self : Node) -> Unit {
  self.flags = self.flags & (1U << 5).lnot()
}

///|
pub fn Node::is_modal(self : Node) -> Bool {
  (self.flags & (1U << 6)) != 0U
}

///|
pub fn Node::set_modal(self : Node) -> Unit {
  self.flags = self.flags | (1U << 6)
}

///|
pub fn Node::clear_modal(self : Node) -> Unit {
  self.flags = self.flags & (1U << 6).lnot()
}

///|
pub fn Node::is_touch_transparent(self : Node) -> Bool {
  (self.flags & (1U << 7)) != 0U
}

///|
pub fn Node::set_touch_transparent(self : Node) -> Unit {
  self.flags = self.flags | (1U << 7)
}

///|
pub fn Node::clear_touch_transparent(self : Node) -> Unit {
  self.flags = self.flags & (1U << 7).lnot()
}

///|
pub fn Node::is_read_only(self : Node) -> Bool {
  (self.flags & (1U << 8)) != 0U
}

///|
pub fn Node::set_read_only(self : Node) -> Unit {
  self.flags = self.flags | (1U << 8)
}

///|
pub fn Node::clear_read_only(self : Node) -> Unit {
  self.flags = self.flags & (1U << 8).lnot()
}

///|
pub fn Node::is_disabled(self : Node) -> Bool {
  (self.flags & (1U << 9)) != 0U
}

///|
pub fn Node::set_disabled(self : Node) -> Unit {
  self.flags = self.flags | (1U << 9)
}

///|
pub fn Node::clear_disabled(self : Node) -> Unit {
  self.flags = self.flags & (1U << 9).lnot()
}

///|
pub fn Node::is_italic(self : Node) -> Bool {
  (self.flags & (1U << 10)) != 0U
}

///|
pub fn Node::set_italic(self : Node) -> Unit {
  self.flags = self.flags | (1U << 10)
}

///|
pub fn Node::clear_italic(self : Node) -> Unit {
  self.flags = self.flags & (1U << 10).lnot()
}

///|
pub fn Node::clips_children(self : Node) -> Bool {
  (self.flags & (1U << 11)) != 0U
}

///|
pub fn Node::set_clips_children(self : Node) -> Unit {
  self.flags = self.flags | (1U << 11)
}

///|
pub fn Node::clear_clips_children(self : Node) -> Unit {
  self.flags = self.flags & (1U << 11).lnot()
}

///|
pub fn Node::is_line_breaking_object(self : Node) -> Bool {
  (self.flags & (1U << 12)) != 0U
}

///|
pub fn Node::set_is_line_breaking_object(self : Node) -> Unit {
  self.flags = self.flags | (1U << 12)
}

///|
pub fn Node::clear_is_line_breaking_object(self : Node) -> Unit {
  self.flags = self.flags & (1U << 12).lnot()
}

///|
pub fn Node::is_page_breaking_object(self : Node) -> Bool {
  (self.flags & (1U << 13)) != 0U
}

///|
pub fn Node::set_is_page_breaking_object(self : Node) -> Unit {
  self.flags = self.flags | (1U << 13)
}

///|
pub fn Node::clear_is_page_breaking_object(self : Node) -> Unit {
  self.flags = self.flags & (1U << 13).lnot()
}

///|
pub fn Node::is_spelling_error(self : Node) -> Bool {
  (self.flags & (1U << 14)) != 0U
}

///|
pub fn Node::set_is_spelling_error(self : Node) -> Unit {
  self.flags = self.flags | (1U << 14)
}

///|
pub fn Node::clear_is_spelling_error(self : Node) -> Unit {
  self.flags = self.flags & (1U << 14).lnot()
}

///|
pub fn Node::is_grammar_error(self : Node) -> Bool {
  (self.flags & (1U << 15)) != 0U
}

///|
pub fn Node::set_is_grammar_error(self : Node) -> Unit {
  self.flags = self.flags | (1U << 15)
}

///|
pub fn Node::clear_is_grammar_error(self : Node) -> Unit {
  self.flags = self.flags & (1U << 15).lnot()
}

///|
pub fn Node::is_search_match(self : Node) -> Bool {
  (self.flags & (1U << 16)) != 0U
}

///|
pub fn Node::set_is_search_match(self : Node) -> Unit {
  self.flags = self.flags | (1U << 16)
}

///|
pub fn Node::clear_is_search_match(self : Node) -> Unit {
  self.flags = self.flags & (1U << 16).lnot()
}

///|
pub fn Node::is_suggestion(self : Node) -> Bool {
  (self.flags & (1U << 17)) != 0U
}

///|
pub fn Node::set_is_suggestion(self : Node) -> Unit {
  self.flags = self.flags | (1U << 17)
}

///|
pub fn Node::clear_is_suggestion(self : Node) -> Unit {
  self.flags = self.flags & (1U << 17).lnot()
}

///|
pub fn Node::children(self : Node) -> Array[NodeId] {
  self.properties.get_node_id_vec(PID_CHILDREN)
}

///|
pub fn Node::set_children(self : Node, children : Array[NodeId]) -> Unit {
  self.properties.set_node_id_vec(PID_CHILDREN, children)
}

///|
pub fn Node::push_child(self : Node, child : NodeId) -> Unit {
  self.properties.push_to_node_id_vec(PID_CHILDREN, child)
}

///|
pub fn Node::clear_children(self : Node) -> Unit {
  self.properties.clear(PID_CHILDREN)
}

///|
pub fn Node::controls(self : Node) -> Array[NodeId] {
  self.properties.get_node_id_vec(PID_CONTROLS)
}

///|
pub fn Node::set_controls(self : Node, controls : Array[NodeId]) -> Unit {
  self.properties.set_node_id_vec(PID_CONTROLS, controls)
}

///|
pub fn Node::push_controlled(self : Node, node_id : NodeId) -> Unit {
  self.properties.push_to_node_id_vec(PID_CONTROLS, node_id)
}

///|
pub fn Node::clear_controls(self : Node) -> Unit {
  self.properties.clear(PID_CONTROLS)
}

///|
pub fn Node::details(self : Node) -> Array[NodeId] {
  self.properties.get_node_id_vec(PID_DETAILS)
}

///|
pub fn Node::set_details(self : Node, details : Array[NodeId]) -> Unit {
  self.properties.set_node_id_vec(PID_DETAILS, details)
}

///|
pub fn Node::push_detail(self : Node, node_id : NodeId) -> Unit {
  self.properties.push_to_node_id_vec(PID_DETAILS, node_id)
}

///|
pub fn Node::clear_details(self : Node) -> Unit {
  self.properties.clear(PID_DETAILS)
}

///|
pub fn Node::described_by(self : Node) -> Array[NodeId] {
  self.properties.get_node_id_vec(PID_DESCRIBED_BY)
}

///|
pub fn Node::set_described_by(
  self : Node,
  described_by : Array[NodeId],
) -> Unit {
  self.properties.set_node_id_vec(PID_DESCRIBED_BY, described_by)
}

///|
pub fn Node::push_described_by(self : Node, node_id : NodeId) -> Unit {
  self.properties.push_to_node_id_vec(PID_DESCRIBED_BY, node_id)
}

///|
pub fn Node::clear_described_by(self : Node) -> Unit {
  self.properties.clear(PID_DESCRIBED_BY)
}

///|
pub fn Node::flow_to(self : Node) -> Array[NodeId] {
  self.properties.get_node_id_vec(PID_FLOW_TO)
}

///|
pub fn Node::set_flow_to(self : Node, flow_to : Array[NodeId]) -> Unit {
  self.properties.set_node_id_vec(PID_FLOW_TO, flow_to)
}

///|
pub fn Node::push_flow_to(self : Node, node_id : NodeId) -> Unit {
  self.properties.push_to_node_id_vec(PID_FLOW_TO, node_id)
}

///|
pub fn Node::clear_flow_to(self : Node) -> Unit {
  self.properties.clear(PID_FLOW_TO)
}

///|
pub fn Node::labelled_by(self : Node) -> Array[NodeId] {
  self.properties.get_node_id_vec(PID_LABELLED_BY)
}

///|
pub fn Node::set_labelled_by(self : Node, labelled_by : Array[NodeId]) -> Unit {
  self.properties.set_node_id_vec(PID_LABELLED_BY, labelled_by)
}

///|
pub fn Node::push_labelled_by(self : Node, node_id : NodeId) -> Unit {
  self.properties.push_to_node_id_vec(PID_LABELLED_BY, node_id)
}

///|
pub fn Node::clear_labelled_by(self : Node) -> Unit {
  self.properties.clear(PID_LABELLED_BY)
}

///|
pub fn Node::owns(self : Node) -> Array[NodeId] {
  self.properties.get_node_id_vec(PID_OWNS)
}

///|
pub fn Node::set_owns(self : Node, owns : Array[NodeId]) -> Unit {
  self.properties.set_node_id_vec(PID_OWNS, owns)
}

///|
pub fn Node::push_owned(self : Node, node_id : NodeId) -> Unit {
  self.properties.push_to_node_id_vec(PID_OWNS, node_id)
}

///|
pub fn Node::clear_owns(self : Node) -> Unit {
  self.properties.clear(PID_OWNS)
}

///|
pub fn Node::radio_group(self : Node) -> Array[NodeId] {
  self.properties.get_node_id_vec(PID_RADIO_GROUP)
}

///|
pub fn Node::set_radio_group(self : Node, radio_group : Array[NodeId]) -> Unit {
  self.properties.set_node_id_vec(PID_RADIO_GROUP, radio_group)
}

///|
pub fn Node::push_to_radio_group(self : Node, node_id : NodeId) -> Unit {
  self.properties.push_to_node_id_vec(PID_RADIO_GROUP, node_id)
}

///|
pub fn Node::clear_radio_group(self : Node) -> Unit {
  self.properties.clear(PID_RADIO_GROUP)
}

///|
pub fn Node::active_descendant(self : Node) -> NodeId? {
  self.properties.get_node_id(PID_ACTIVE_DESCENDANT)
}

///|
pub fn Node::set_active_descendant(self : Node, id : NodeId) -> Unit {
  self.properties.set_node_id(PID_ACTIVE_DESCENDANT, id)
}

///|
pub fn Node::clear_active_descendant(self : Node) -> Unit {
  self.properties.clear(PID_ACTIVE_DESCENDANT)
}

///|
pub fn Node::error_message(self : Node) -> NodeId? {
  self.properties.get_node_id(PID_ERROR_MESSAGE)
}

///|
pub fn Node::set_error_message(self : Node, id : NodeId) -> Unit {
  self.properties.set_node_id(PID_ERROR_MESSAGE, id)
}

///|
pub fn Node::clear_error_message(self : Node) -> Unit {
  self.properties.clear(PID_ERROR_MESSAGE)
}

///|
pub fn Node::in_page_link_target(self : Node) -> NodeId? {
  self.properties.get_node_id(PID_IN_PAGE_LINK_TARGET)
}

///|
pub fn Node::set_in_page_link_target(self : Node, id : NodeId) -> Unit {
  self.properties.set_node_id(PID_IN_PAGE_LINK_TARGET, id)
}

///|
pub fn Node::clear_in_page_link_target(self : Node) -> Unit {
  self.properties.clear(PID_IN_PAGE_LINK_TARGET)
}

///|
pub fn Node::member_of(self : Node) -> NodeId? {
  self.properties.get_node_id(PID_MEMBER_OF)
}

///|
pub fn Node::set_member_of(self : Node, id : NodeId) -> Unit {
  self.properties.set_node_id(PID_MEMBER_OF, id)
}

///|
pub fn Node::clear_member_of(self : Node) -> Unit {
  self.properties.clear(PID_MEMBER_OF)
}

///|
pub fn Node::next_on_line(self : Node) -> NodeId? {
  self.properties.get_node_id(PID_NEXT_ON_LINE)
}

///|
pub fn Node::set_next_on_line(self : Node, id : NodeId) -> Unit {
  self.properties.set_node_id(PID_NEXT_ON_LINE, id)
}

///|
pub fn Node::clear_next_on_line(self : Node) -> Unit {
  self.properties.clear(PID_NEXT_ON_LINE)
}

///|
pub fn Node::previous_on_line(self : Node) -> NodeId? {
  self.properties.get_node_id(PID_PREVIOUS_ON_LINE)
}

///|
pub fn Node::set_previous_on_line(self : Node, id : NodeId) -> Unit {
  self.properties.set_node_id(PID_PREVIOUS_ON_LINE, id)
}

///|
pub fn Node::clear_previous_on_line(self : Node) -> Unit {
  self.properties.clear(PID_PREVIOUS_ON_LINE)
}

///|
pub fn Node::popup_for(self : Node) -> NodeId? {
  self.properties.get_node_id(PID_POPUP_FOR)
}

///|
pub fn Node::set_popup_for(self : Node, id : NodeId) -> Unit {
  self.properties.set_node_id(PID_POPUP_FOR, id)
}

///|
pub fn Node::clear_popup_for(self : Node) -> Unit {
  self.properties.clear(PID_POPUP_FOR)
}

///|
pub fn Node::label(self : Node) -> String? {
  self.properties.get_string(PID_LABEL)
}

///|
pub fn Node::set_label(self : Node, label : String) -> Unit {
  self.properties.set_string(PID_LABEL, label)
}

///|
pub fn Node::clear_label(self : Node) -> Unit {
  self.properties.clear(PID_LABEL)
}

///|
pub fn Node::description(self : Node) -> String? {
  self.properties.get_string(PID_DESCRIPTION)
}

///|
pub fn Node::set_description(self : Node, description : String) -> Unit {
  self.properties.set_string(PID_DESCRIPTION, description)
}

///|
pub fn Node::clear_description(self : Node) -> Unit {
  self.properties.clear(PID_DESCRIPTION)
}

///|
pub fn Node::value(self : Node) -> String? {
  self.properties.get_string(PID_VALUE)
}

///|
pub fn Node::set_value(self : Node, value : String) -> Unit {
  self.properties.set_string(PID_VALUE, value)
}

///|
pub fn Node::clear_value(self : Node) -> Unit {
  self.properties.clear(PID_VALUE)
}

///|
pub fn Node::access_key(self : Node) -> String? {
  self.properties.get_string(PID_ACCESS_KEY)
}

///|
pub fn Node::set_access_key(self : Node, access_key : String) -> Unit {
  self.properties.set_string(PID_ACCESS_KEY, access_key)
}

///|
pub fn Node::clear_access_key(self : Node) -> Unit {
  self.properties.clear(PID_ACCESS_KEY)
}

///|
pub fn Node::author_id(self : Node) -> String? {
  self.properties.get_string(PID_AUTHOR_ID)
}

///|
pub fn Node::set_author_id(self : Node, author_id : String) -> Unit {
  self.properties.set_string(PID_AUTHOR_ID, author_id)
}

///|
pub fn Node::clear_author_id(self : Node) -> Unit {
  self.properties.clear(PID_AUTHOR_ID)
}

///|
pub fn Node::class_name(self : Node) -> String? {
  self.properties.get_string(PID_CLASS_NAME)
}

///|
pub fn Node::set_class_name(self : Node, class_name : String) -> Unit {
  self.properties.set_string(PID_CLASS_NAME, class_name)
}

///|
pub fn Node::clear_class_name(self : Node) -> Unit {
  self.properties.clear(PID_CLASS_NAME)
}

///|
pub fn Node::font_family(self : Node) -> String? {
  self.properties.get_string(PID_FONT_FAMILY)
}

///|
pub fn Node::set_font_family(self : Node, font_family : String) -> Unit {
  self.properties.set_string(PID_FONT_FAMILY, font_family)
}

///|
pub fn Node::clear_font_family(self : Node) -> Unit {
  self.properties.clear(PID_FONT_FAMILY)
}

///|
pub fn Node::html_tag(self : Node) -> String? {
  self.properties.get_string(PID_HTML_TAG)
}

///|
pub fn Node::set_html_tag(self : Node, html_tag : String) -> Unit {
  self.properties.set_string(PID_HTML_TAG, html_tag)
}

///|
pub fn Node::clear_html_tag(self : Node) -> Unit {
  self.properties.clear(PID_HTML_TAG)
}

///|
pub fn Node::inner_html(self : Node) -> String? {
  self.properties.get_string(PID_INNER_HTML)
}

///|
pub fn Node::set_inner_html(self : Node, inner_html : String) -> Unit {
  self.properties.set_string(PID_INNER_HTML, inner_html)
}

///|
pub fn Node::clear_inner_html(self : Node) -> Unit {
  self.properties.clear(PID_INNER_HTML)
}

///|
pub fn Node::keyboard_shortcut(self : Node) -> String? {
  self.properties.get_string(PID_KEYBOARD_SHORTCUT)
}

///|
pub fn Node::set_keyboard_shortcut(
  self : Node,
  keyboard_shortcut : String,
) -> Unit {
  self.properties.set_string(PID_KEYBOARD_SHORTCUT, keyboard_shortcut)
}

///|
pub fn Node::clear_keyboard_shortcut(self : Node) -> Unit {
  self.properties.clear(PID_KEYBOARD_SHORTCUT)
}

///|
pub fn Node::language(self : Node) -> String? {
  self.properties.get_string(PID_LANGUAGE)
}

///|
pub fn Node::set_language(self : Node, language : String) -> Unit {
  self.properties.set_string(PID_LANGUAGE, language)
}

///|
pub fn Node::clear_language(self : Node) -> Unit {
  self.properties.clear(PID_LANGUAGE)
}

///|
pub fn Node::placeholder(self : Node) -> String? {
  self.properties.get_string(PID_PLACEHOLDER)
}

///|
pub fn Node::set_placeholder(self : Node, placeholder : String) -> Unit {
  self.properties.set_string(PID_PLACEHOLDER, placeholder)
}

///|
pub fn Node::clear_placeholder(self : Node) -> Unit {
  self.properties.clear(PID_PLACEHOLDER)
}

///|
pub fn Node::role_description(self : Node) -> String? {
  self.properties.get_string(PID_ROLE_DESCRIPTION)
}

///|
pub fn Node::set_role_description(
  self : Node,
  role_description : String,
) -> Unit {
  self.properties.set_string(PID_ROLE_DESCRIPTION, role_description)
}

///|
pub fn Node::clear_role_description(self : Node) -> Unit {
  self.properties.clear(PID_ROLE_DESCRIPTION)
}

///|
pub fn Node::state_description(self : Node) -> String? {
  self.properties.get_string(PID_STATE_DESCRIPTION)
}

///|
pub fn Node::set_state_description(
  self : Node,
  state_description : String,
) -> Unit {
  self.properties.set_string(PID_STATE_DESCRIPTION, state_description)
}

///|
pub fn Node::clear_state_description(self : Node) -> Unit {
  self.properties.clear(PID_STATE_DESCRIPTION)
}

///|
pub fn Node::tooltip(self : Node) -> String? {
  self.properties.get_string(PID_TOOLTIP)
}

///|
pub fn Node::set_tooltip(self : Node, tooltip : String) -> Unit {
  self.properties.set_string(PID_TOOLTIP, tooltip)
}

///|
pub fn Node::clear_tooltip(self : Node) -> Unit {
  self.properties.clear(PID_TOOLTIP)
}

///|
pub fn Node::url(self : Node) -> String? {
  self.properties.get_string(PID_URL)
}

///|
pub fn Node::set_url(self : Node, url : String) -> Unit {
  self.properties.set_string(PID_URL, url)
}

///|
pub fn Node::clear_url(self : Node) -> Unit {
  self.properties.clear(PID_URL)
}

///|
pub fn Node::row_index_text(self : Node) -> String? {
  self.properties.get_string(PID_ROW_INDEX_TEXT)
}

///|
pub fn Node::set_row_index_text(self : Node, row_index_text : String) -> Unit {
  self.properties.set_string(PID_ROW_INDEX_TEXT, row_index_text)
}

///|
pub fn Node::clear_row_index_text(self : Node) -> Unit {
  self.properties.clear(PID_ROW_INDEX_TEXT)
}

///|
pub fn Node::column_index_text(self : Node) -> String? {
  self.properties.get_string(PID_COLUMN_INDEX_TEXT)
}

///|
pub fn Node::set_column_index_text(
  self : Node,
  column_index_text : String,
) -> Unit {
  self.properties.set_string(PID_COLUMN_INDEX_TEXT, column_index_text)
}

///|
pub fn Node::clear_column_index_text(self : Node) -> Unit {
  self.properties.clear(PID_COLUMN_INDEX_TEXT)
}

///|
pub fn Node::braille_label(self : Node) -> String? {
  self.properties.get_string(PID_BRAILLE_LABEL)
}

///|
pub fn Node::set_braille_label(self : Node, braille_label : String) -> Unit {
  self.properties.set_string(PID_BRAILLE_LABEL, braille_label)
}

///|
pub fn Node::clear_braille_label(self : Node) -> Unit {
  self.properties.clear(PID_BRAILLE_LABEL)
}

///|
pub fn Node::braille_role_description(self : Node) -> String? {
  self.properties.get_string(PID_BRAILLE_ROLE_DESCRIPTION)
}

///|
pub fn Node::set_braille_role_description(
  self : Node,
  braille_role_description : String,
) -> Unit {
  self.properties.set_string(
    PID_BRAILLE_ROLE_DESCRIPTION,
    braille_role_description,
  )
}

///|
pub fn Node::clear_braille_role_description(self : Node) -> Unit {
  self.properties.clear(PID_BRAILLE_ROLE_DESCRIPTION)
}

///|
pub fn Node::scroll_x(self : Node) -> Double? {
  self.properties.get_f64(PID_SCROLL_X)
}

///|
pub fn Node::set_scroll_x(self : Node, value : Double) -> Unit {
  self.properties.set_f64(PID_SCROLL_X, value)
}

///|
pub fn Node::clear_scroll_x(self : Node) -> Unit {
  self.properties.clear(PID_SCROLL_X)
}

///|
pub fn Node::scroll_x_min(self : Node) -> Double? {
  self.properties.get_f64(PID_SCROLL_X_MIN)
}

///|
pub fn Node::set_scroll_x_min(self : Node, value : Double) -> Unit {
  self.properties.set_f64(PID_SCROLL_X_MIN, value)
}

///|
pub fn Node::clear_scroll_x_min(self : Node) -> Unit {
  self.properties.clear(PID_SCROLL_X_MIN)
}

///|
pub fn Node::scroll_x_max(self : Node) -> Double? {
  self.properties.get_f64(PID_SCROLL_X_MAX)
}

///|
pub fn Node::set_scroll_x_max(self : Node, value : Double) -> Unit {
  self.properties.set_f64(PID_SCROLL_X_MAX, value)
}

///|
pub fn Node::clear_scroll_x_max(self : Node) -> Unit {
  self.properties.clear(PID_SCROLL_X_MAX)
}

///|
pub fn Node::scroll_y(self : Node) -> Double? {
  self.properties.get_f64(PID_SCROLL_Y)
}

///|
pub fn Node::set_scroll_y(self : Node, value : Double) -> Unit {
  self.properties.set_f64(PID_SCROLL_Y, value)
}

///|
pub fn Node::clear_scroll_y(self : Node) -> Unit {
  self.properties.clear(PID_SCROLL_Y)
}

///|
pub fn Node::scroll_y_min(self : Node) -> Double? {
  self.properties.get_f64(PID_SCROLL_Y_MIN)
}

///|
pub fn Node::set_scroll_y_min(self : Node, value : Double) -> Unit {
  self.properties.set_f64(PID_SCROLL_Y_MIN, value)
}

///|
pub fn Node::clear_scroll_y_min(self : Node) -> Unit {
  self.properties.clear(PID_SCROLL_Y_MIN)
}

///|
pub fn Node::scroll_y_max(self : Node) -> Double? {
  self.properties.get_f64(PID_SCROLL_Y_MAX)
}

///|
pub fn Node::set_scroll_y_max(self : Node, value : Double) -> Unit {
  self.properties.set_f64(PID_SCROLL_Y_MAX, value)
}

///|
pub fn Node::clear_scroll_y_max(self : Node) -> Unit {
  self.properties.clear(PID_SCROLL_Y_MAX)
}

///|
pub fn Node::numeric_value(self : Node) -> Double? {
  self.properties.get_f64(PID_NUMERIC_VALUE)
}

///|
pub fn Node::set_numeric_value(self : Node, value : Double) -> Unit {
  self.properties.set_f64(PID_NUMERIC_VALUE, value)
}

///|
pub fn Node::clear_numeric_value(self : Node) -> Unit {
  self.properties.clear(PID_NUMERIC_VALUE)
}

///|
pub fn Node::min_numeric_value(self : Node) -> Double? {
  self.properties.get_f64(PID_MIN_NUMERIC_VALUE)
}

///|
pub fn Node::set_min_numeric_value(self : Node, value : Double) -> Unit {
  self.properties.set_f64(PID_MIN_NUMERIC_VALUE, value)
}

///|
pub fn Node::clear_min_numeric_value(self : Node) -> Unit {
  self.properties.clear(PID_MIN_NUMERIC_VALUE)
}

///|
pub fn Node::max_numeric_value(self : Node) -> Double? {
  self.properties.get_f64(PID_MAX_NUMERIC_VALUE)
}

///|
pub fn Node::set_max_numeric_value(self : Node, value : Double) -> Unit {
  self.properties.set_f64(PID_MAX_NUMERIC_VALUE, value)
}

///|
pub fn Node::clear_max_numeric_value(self : Node) -> Unit {
  self.properties.clear(PID_MAX_NUMERIC_VALUE)
}

///|
pub fn Node::numeric_value_step(self : Node) -> Double? {
  self.properties.get_f64(PID_NUMERIC_VALUE_STEP)
}

///|
pub fn Node::set_numeric_value_step(self : Node, value : Double) -> Unit {
  self.properties.set_f64(PID_NUMERIC_VALUE_STEP, value)
}

///|
pub fn Node::clear_numeric_value_step(self : Node) -> Unit {
  self.properties.clear(PID_NUMERIC_VALUE_STEP)
}

///|
pub fn Node::numeric_value_jump(self : Node) -> Double? {
  self.properties.get_f64(PID_NUMERIC_VALUE_JUMP)
}

///|
pub fn Node::set_numeric_value_jump(self : Node, value : Double) -> Unit {
  self.properties.set_f64(PID_NUMERIC_VALUE_JUMP, value)
}

///|
pub fn Node::clear_numeric_value_jump(self : Node) -> Unit {
  self.properties.clear(PID_NUMERIC_VALUE_JUMP)
}

///|
pub fn Node::font_size(self : Node) -> Float? {
  self.properties.get_f32(PID_FONT_SIZE)
}

///|
pub fn Node::set_font_size(self : Node, value : Float) -> Unit {
  self.properties.set_f32(PID_FONT_SIZE, value)
}

///|
pub fn Node::clear_font_size(self : Node) -> Unit {
  self.properties.clear(PID_FONT_SIZE)
}

///|
pub fn Node::font_weight(self : Node) -> Float? {
  self.properties.get_f32(PID_FONT_WEIGHT)
}

///|
pub fn Node::set_font_weight(self : Node, value : Float) -> Unit {
  self.properties.set_f32(PID_FONT_WEIGHT, value)
}

///|
pub fn Node::clear_font_weight(self : Node) -> Unit {
  self.properties.clear(PID_FONT_WEIGHT)
}

///|
pub fn Node::color_value(self : Node) -> Color? {
  self.properties.get_color(PID_COLOR_VALUE)
}

///|
pub fn Node::set_color_value(self : Node, color : Color) -> Unit {
  self.properties.set_color(PID_COLOR_VALUE, color)
}

///|
pub fn Node::clear_color_value(self : Node) -> Unit {
  self.properties.clear(PID_COLOR_VALUE)
}

///|
pub fn Node::background_color(self : Node) -> Color? {
  self.properties.get_color(PID_BACKGROUND_COLOR)
}

///|
pub fn Node::set_background_color(self : Node, color : Color) -> Unit {
  self.properties.set_color(PID_BACKGROUND_COLOR, color)
}

///|
pub fn Node::clear_background_color(self : Node) -> Unit {
  self.properties.clear(PID_BACKGROUND_COLOR)
}

///|
pub fn Node::foreground_color(self : Node) -> Color? {
  self.properties.get_color(PID_FOREGROUND_COLOR)
}

///|
pub fn Node::set_foreground_color(self : Node, color : Color) -> Unit {
  self.properties.set_color(PID_FOREGROUND_COLOR, color)
}

///|
pub fn Node::clear_foreground_color(self : Node) -> Unit {
  self.properties.clear(PID_FOREGROUND_COLOR)
}

///|
pub fn Node::overline(self : Node) -> TextDecoration? {
  self.properties.get_text_decoration(PID_OVERLINE)
}

///|
pub fn Node::set_overline(self : Node, decoration : TextDecoration) -> Unit {
  self.properties.set_text_decoration(PID_OVERLINE, decoration)
}

///|
pub fn Node::clear_overline(self : Node) -> Unit {
  self.properties.clear(PID_OVERLINE)
}

///|
pub fn Node::strikethrough(self : Node) -> TextDecoration? {
  self.properties.get_text_decoration(PID_STRIKETHROUGH)
}

///|
pub fn Node::set_strikethrough(
  self : Node,
  decoration : TextDecoration,
) -> Unit {
  self.properties.set_text_decoration(PID_STRIKETHROUGH, decoration)
}

///|
pub fn Node::clear_strikethrough(self : Node) -> Unit {
  self.properties.clear(PID_STRIKETHROUGH)
}

///|
pub fn Node::underline(self : Node) -> TextDecoration? {
  self.properties.get_text_decoration(PID_UNDERLINE)
}

///|
pub fn Node::set_underline(self : Node, decoration : TextDecoration) -> Unit {
  self.properties.set_text_decoration(PID_UNDERLINE, decoration)
}

///|
pub fn Node::clear_underline(self : Node) -> Unit {
  self.properties.clear(PID_UNDERLINE)
}

///|
pub fn Node::character_lengths(self : Node) -> Array[Int] {
  self.properties.get_length_slice(PID_CHARACTER_LENGTHS)
}

///|
pub fn Node::set_character_lengths(self : Node, value : Array[Int]) -> Unit {
  self.properties.set_length_slice(PID_CHARACTER_LENGTHS, value)
}

///|
pub fn Node::clear_character_lengths(self : Node) -> Unit {
  self.properties.clear(PID_CHARACTER_LENGTHS)
}

///|
pub fn Node::word_starts(self : Node) -> Array[Int] {
  self.properties.get_length_slice(PID_WORD_STARTS)
}

///|
pub fn Node::set_word_starts(self : Node, value : Array[Int]) -> Unit {
  self.properties.set_length_slice(PID_WORD_STARTS, value)
}

///|
pub fn Node::clear_word_starts(self : Node) -> Unit {
  self.properties.clear(PID_WORD_STARTS)
}

///|
pub fn Node::character_positions(self : Node) -> Array[Float]? {
  self.properties.get_coord_slice(PID_CHARACTER_POSITIONS)
}

///|
pub fn Node::set_character_positions(self : Node, value : Array[Float]) -> Unit {
  self.properties.set_coord_slice(PID_CHARACTER_POSITIONS, value)
}

///|
pub fn Node::clear_character_positions(self : Node) -> Unit {
  self.properties.clear(PID_CHARACTER_POSITIONS)
}

///|
pub fn Node::character_widths(self : Node) -> Array[Float]? {
  self.properties.get_coord_slice(PID_CHARACTER_WIDTHS)
}

///|
pub fn Node::set_character_widths(self : Node, value : Array[Float]) -> Unit {
  self.properties.set_coord_slice(PID_CHARACTER_WIDTHS, value)
}

///|
pub fn Node::clear_character_widths(self : Node) -> Unit {
  self.properties.clear(PID_CHARACTER_WIDTHS)
}

///|
pub fn Node::is_expanded(self : Node) -> Bool? {
  self.properties.get_bool(PID_EXPANDED)
}

///|
pub fn Node::set_expanded(self : Node, value : Bool) -> Unit {
  self.properties.set_bool(PID_EXPANDED, value)
}

///|
pub fn Node::clear_expanded(self : Node) -> Unit {
  self.properties.clear(PID_EXPANDED)
}

///|
pub fn Node::is_selected(self : Node) -> Bool? {
  self.properties.get_bool(PID_SELECTED)
}

///|
pub fn Node::set_selected(self : Node, value : Bool) -> Unit {
  self.properties.set_bool(PID_SELECTED, value)
}

///|
pub fn Node::clear_selected(self : Node) -> Unit {
  self.properties.clear(PID_SELECTED)
}

///|
pub fn Node::invalid(self : Node) -> Invalid? {
  self.properties.get_invalid(PID_INVALID)
}

///|
pub fn Node::set_invalid(self : Node, value : Invalid) -> Unit {
  self.properties.set_invalid(PID_INVALID, value)
}

///|
pub fn Node::clear_invalid(self : Node) -> Unit {
  self.properties.clear(PID_INVALID)
}

///|
pub fn Node::toggled(self : Node) -> Toggled? {
  self.properties.get_toggled(PID_TOGGLED)
}

///|
pub fn Node::set_toggled(self : Node, value : Toggled) -> Unit {
  self.properties.set_toggled(PID_TOGGLED, value)
}

///|
pub fn Node::clear_toggled(self : Node) -> Unit {
  self.properties.clear(PID_TOGGLED)
}

///|
pub fn Node::live(self : Node) -> Live? {
  self.properties.get_live(PID_LIVE)
}

///|
pub fn Node::set_live(self : Node, value : Live) -> Unit {
  self.properties.set_live(PID_LIVE, value)
}

///|
pub fn Node::clear_live(self : Node) -> Unit {
  self.properties.clear(PID_LIVE)
}

///|
pub fn Node::text_direction(self : Node) -> TextDirection? {
  self.properties.get_text_direction(PID_TEXT_DIRECTION)
}

///|
pub fn Node::set_text_direction(self : Node, value : TextDirection) -> Unit {
  self.properties.set_text_direction(PID_TEXT_DIRECTION, value)
}

///|
pub fn Node::clear_text_direction(self : Node) -> Unit {
  self.properties.clear(PID_TEXT_DIRECTION)
}

///|
pub fn Node::orientation(self : Node) -> Orientation? {
  self.properties.get_orientation(PID_ORIENTATION)
}

///|
pub fn Node::set_orientation(self : Node, value : Orientation) -> Unit {
  self.properties.set_orientation(PID_ORIENTATION, value)
}

///|
pub fn Node::clear_orientation(self : Node) -> Unit {
  self.properties.clear(PID_ORIENTATION)
}

///|
pub fn Node::sort_direction(self : Node) -> SortDirection? {
  self.properties.get_sort_direction(PID_SORT_DIRECTION)
}

///|
pub fn Node::set_sort_direction(self : Node, value : SortDirection) -> Unit {
  self.properties.set_sort_direction(PID_SORT_DIRECTION, value)
}

///|
pub fn Node::clear_sort_direction(self : Node) -> Unit {
  self.properties.clear(PID_SORT_DIRECTION)
}

///|
pub fn Node::aria_current(self : Node) -> AriaCurrent? {
  self.properties.get_aria_current(PID_ARIA_CURRENT)
}

///|
pub fn Node::set_aria_current(self : Node, value : AriaCurrent) -> Unit {
  self.properties.set_aria_current(PID_ARIA_CURRENT, value)
}

///|
pub fn Node::clear_aria_current(self : Node) -> Unit {
  self.properties.clear(PID_ARIA_CURRENT)
}

///|
pub fn Node::auto_complete(self : Node) -> AutoComplete? {
  self.properties.get_auto_complete(PID_AUTO_COMPLETE)
}

///|
pub fn Node::set_auto_complete(self : Node, value : AutoComplete) -> Unit {
  self.properties.set_auto_complete(PID_AUTO_COMPLETE, value)
}

///|
pub fn Node::clear_auto_complete(self : Node) -> Unit {
  self.properties.clear(PID_AUTO_COMPLETE)
}

///|
pub fn Node::has_popup(self : Node) -> HasPopup? {
  self.properties.get_has_popup(PID_HAS_POPUP)
}

///|
pub fn Node::set_has_popup(self : Node, value : HasPopup) -> Unit {
  self.properties.set_has_popup(PID_HAS_POPUP, value)
}

///|
pub fn Node::clear_has_popup(self : Node) -> Unit {
  self.properties.clear(PID_HAS_POPUP)
}

///|
pub fn Node::list_style(self : Node) -> ListStyle? {
  self.properties.get_list_style(PID_LIST_STYLE)
}

///|
pub fn Node::set_list_style(self : Node, value : ListStyle) -> Unit {
  self.properties.set_list_style(PID_LIST_STYLE, value)
}

///|
pub fn Node::clear_list_style(self : Node) -> Unit {
  self.properties.clear(PID_LIST_STYLE)
}

///|
pub fn Node::text_align(self : Node) -> TextAlign? {
  self.properties.get_text_align(PID_TEXT_ALIGN)
}

///|
pub fn Node::set_text_align(self : Node, value : TextAlign) -> Unit {
  self.properties.set_text_align(PID_TEXT_ALIGN, value)
}

///|
pub fn Node::clear_text_align(self : Node) -> Unit {
  self.properties.clear(PID_TEXT_ALIGN)
}

///|
pub fn Node::vertical_offset(self : Node) -> VerticalOffset? {
  self.properties.get_vertical_offset(PID_VERTICAL_OFFSET)
}

///|
pub fn Node::set_vertical_offset(self : Node, value : VerticalOffset) -> Unit {
  self.properties.set_vertical_offset(PID_VERTICAL_OFFSET, value)
}

///|
pub fn Node::clear_vertical_offset(self : Node) -> Unit {
  self.properties.clear(PID_VERTICAL_OFFSET)
}

///|
pub fn Node::transform(self : Node) -> Affine? {
  self.properties.get_affine(PID_TRANSFORM)
}

///|
pub fn Node::set_transform(self : Node, value : Affine) -> Unit {
  self.properties.set_affine(PID_TRANSFORM, value)
}

///|
pub fn Node::clear_transform(self : Node) -> Unit {
  self.properties.clear(PID_TRANSFORM)
}

///|
pub fn Node::bounds(self : Node) -> Rect? {
  self.properties.get_rect(PID_BOUNDS)
}

///|
pub fn Node::set_bounds(self : Node, value : Rect) -> Unit {
  self.properties.set_rect(PID_BOUNDS, value)
}

///|
pub fn Node::clear_bounds(self : Node) -> Unit {
  self.properties.clear(PID_BOUNDS)
}

///|
pub fn Node::text_selection(self : Node) -> TextSelection? {
  self.properties.get_text_selection(PID_TEXT_SELECTION)
}

///|
pub fn Node::set_text_selection(self : Node, value : TextSelection) -> Unit {
  self.properties.set_text_selection(PID_TEXT_SELECTION, value)
}

///|
pub fn Node::clear_text_selection(self : Node) -> Unit {
  self.properties.clear(PID_TEXT_SELECTION)
}

///|
pub fn Node::custom_actions(self : Node) -> Array[CustomAction] {
  self.properties.get_custom_action_vec(PID_CUSTOM_ACTIONS)
}

///|
pub fn Node::set_custom_actions(
  self : Node,
  value : Array[CustomAction],
) -> Unit {
  self.properties.set_custom_action_vec(PID_CUSTOM_ACTIONS, value)
}

///|
pub fn Node::push_custom_action(self : Node, action : CustomAction) -> Unit {
  self.properties.push_to_custom_action_vec(PID_CUSTOM_ACTIONS, action)
}

///|
pub fn Node::clear_custom_actions(self : Node) -> Unit {
  self.properties.clear(PID_CUSTOM_ACTIONS)
}

///|
pub fn Node::tree_id(self : Node) -> TreeId? {
  self.properties.get_tree_id(PID_TREE_ID)
}

///|
pub fn Node::set_tree_id(self : Node, value : TreeId) -> Unit {
  self.properties.set_tree_id(PID_TREE_ID, value)
}

///|
pub fn Node::clear_tree_id(self : Node) -> Unit {
  self.properties.clear(PID_TREE_ID)
}

///|
pub fn Node::row_count(self : Node) -> Int? {
  self.properties.get_usize(PID_ROW_COUNT)
}

///|
pub fn Node::set_row_count(self : Node, value : Int) -> Unit {
  self.properties.set_usize(PID_ROW_COUNT, value)
}

///|
pub fn Node::clear_row_count(self : Node) -> Unit {
  self.properties.clear(PID_ROW_COUNT)
}

///|
pub fn Node::column_count(self : Node) -> Int? {
  self.properties.get_usize(PID_COLUMN_COUNT)
}

///|
pub fn Node::set_column_count(self : Node, value : Int) -> Unit {
  self.properties.set_usize(PID_COLUMN_COUNT, value)
}

///|
pub fn Node::clear_column_count(self : Node) -> Unit {
  self.properties.clear(PID_COLUMN_COUNT)
}

///|
pub fn Node::row_index(self : Node) -> Int? {
  self.properties.get_usize(PID_ROW_INDEX)
}

///|
pub fn Node::set_row_index(self : Node, value : Int) -> Unit {
  self.properties.set_usize(PID_ROW_INDEX, value)
}

///|
pub fn Node::clear_row_index(self : Node) -> Unit {
  self.properties.clear(PID_ROW_INDEX)
}

///|
pub fn Node::column_index(self : Node) -> Int? {
  self.properties.get_usize(PID_COLUMN_INDEX)
}

///|
pub fn Node::set_column_index(self : Node, value : Int) -> Unit {
  self.properties.set_usize(PID_COLUMN_INDEX, value)
}

///|
pub fn Node::clear_column_index(self : Node) -> Unit {
  self.properties.clear(PID_COLUMN_INDEX)
}

///|
pub fn Node::row_span(self : Node) -> Int? {
  self.properties.get_usize(PID_ROW_SPAN)
}

///|
pub fn Node::set_row_span(self : Node, value : Int) -> Unit {
  self.properties.set_usize(PID_ROW_SPAN, value)
}

///|
pub fn Node::clear_row_span(self : Node) -> Unit {
  self.properties.clear(PID_ROW_SPAN)
}

///|
pub fn Node::column_span(self : Node) -> Int? {
  self.properties.get_usize(PID_COLUMN_SPAN)
}

///|
pub fn Node::set_column_span(self : Node, value : Int) -> Unit {
  self.properties.set_usize(PID_COLUMN_SPAN, value)
}

///|
pub fn Node::clear_column_span(self : Node) -> Unit {
  self.properties.clear(PID_COLUMN_SPAN)
}

///|
pub fn Node::level(self : Node) -> Int? {
  self.properties.get_usize(PID_LEVEL)
}

///|
pub fn Node::set_level(self : Node, value : Int) -> Unit {
  self.properties.set_usize(PID_LEVEL, value)
}

///|
pub fn Node::clear_level(self : Node) -> Unit {
  self.properties.clear(PID_LEVEL)
}

///|
pub fn Node::size_of_set(self : Node) -> Int? {
  self.properties.get_usize(PID_SIZE_OF_SET)
}

///|
pub fn Node::set_size_of_set(self : Node, value : Int) -> Unit {
  self.properties.set_usize(PID_SIZE_OF_SET, value)
}

///|
pub fn Node::clear_size_of_set(self : Node) -> Unit {
  self.properties.clear(PID_SIZE_OF_SET)
}

///|
pub fn Node::position_in_set(self : Node) -> Int? {
  self.properties.get_usize(PID_POSITION_IN_SET)
}

///|
pub fn Node::set_position_in_set(self : Node, value : Int) -> Unit {
  self.properties.set_usize(PID_POSITION_IN_SET, value)
}

///|
pub fn Node::clear_position_in_set(self : Node) -> Unit {
  self.properties.clear(PID_POSITION_IN_SET)
}

///|
pub fn Node::debug(self : Node) -> String {
  let mut out = "Node { role: " + self.role().to_string()
  let supported_actions = action_mask_to_action_vec(self.actions)
  if supported_actions.length() != 0 {
    out = out + ", actions: [" + action_vec_debug(supported_actions) + "]"
  }
  let child_supported_actions = action_mask_to_action_vec(self.child_actions)
  if child_supported_actions.length() != 0 {
    out = out +
      ", child_actions: [" +
      action_vec_debug(child_supported_actions) +
      "]"
  }
  if self.is_hidden() {
    out = out + ", is_hidden: true"
  }
  if self.is_multiselectable() {
    out = out + ", is_multiselectable: true"
  }
  if self.is_required() {
    out = out + ", is_required: true"
  }
  if self.is_visited() {
    out = out + ", is_visited: true"
  }
  if self.is_busy() {
    out = out + ", is_busy: true"
  }
  if self.is_live_atomic() {
    out = out + ", is_live_atomic: true"
  }
  if self.is_modal() {
    out = out + ", is_modal: true"
  }
  if self.is_touch_transparent() {
    out = out + ", is_touch_transparent: true"
  }
  if self.is_read_only() {
    out = out + ", is_read_only: true"
  }
  if self.is_disabled() {
    out = out + ", is_disabled: true"
  }
  if self.is_italic() {
    out = out + ", is_italic: true"
  }
  if self.clips_children() {
    out = out + ", clips_children: true"
  }
  if self.is_line_breaking_object() {
    out = out + ", is_line_breaking_object: true"
  }
  if self.is_page_breaking_object() {
    out = out + ", is_page_breaking_object: true"
  }
  if self.is_spelling_error() {
    out = out + ", is_spelling_error: true"
  }
  if self.is_grammar_error() {
    out = out + ", is_grammar_error: true"
  }
  if self.is_search_match() {
    out = out + ", is_search_match: true"
  }
  if self.is_suggestion() {
    out = out + ", is_suggestion: true"
  }
  let children = self.children()
  if children.length() != 0 {
    out = out + ", children: [" + node_id_vec_debug(children) + "]"
  }
  let controls = self.controls()
  if controls.length() != 0 {
    out = out + ", controls: [" + node_id_vec_debug(controls) + "]"
  }
  let details = self.details()
  if details.length() != 0 {
    out = out + ", details: [" + node_id_vec_debug(details) + "]"
  }
  let described_by = self.described_by()
  if described_by.length() != 0 {
    out = out + ", described_by: [" + node_id_vec_debug(described_by) + "]"
  }
  let flow_to = self.flow_to()
  if flow_to.length() != 0 {
    out = out + ", flow_to: [" + node_id_vec_debug(flow_to) + "]"
  }
  let labelled_by = self.labelled_by()
  if labelled_by.length() != 0 {
    out = out + ", labelled_by: [" + node_id_vec_debug(labelled_by) + "]"
  }
  let owns = self.owns()
  if owns.length() != 0 {
    out = out + ", owns: [" + node_id_vec_debug(owns) + "]"
  }
  let radio_group = self.radio_group()
  if radio_group.length() != 0 {
    out = out + ", radio_group: [" + node_id_vec_debug(radio_group) + "]"
  }
  if self.active_descendant() is Some(id) {
    out = out + ", active_descendant: " + id.debug()
  }
  if self.error_message() is Some(id) {
    out = out + ", error_message: " + id.debug()
  }
  if self.in_page_link_target() is Some(id) {
    out = out + ", in_page_link_target: " + id.debug()
  }
  if self.member_of() is Some(id) {
    out = out + ", member_of: " + id.debug()
  }
  if self.next_on_line() is Some(id) {
    out = out + ", next_on_line: " + id.debug()
  }
  if self.previous_on_line() is Some(id) {
    out = out + ", previous_on_line: " + id.debug()
  }
  if self.popup_for() is Some(id) {
    out = out + ", popup_for: " + id.debug()
  }
  if self.label() is Some(value) {
    out = out + ", label: " + debug_string_literal(value)
  }
  if self.description() is Some(value) {
    out = out + ", description: " + debug_string_literal(value)
  }
  if self.value() is Some(value) {
    out = out + ", value: " + debug_string_literal(value)
  }
  if self.access_key() is Some(value) {
    out = out + ", access_key: " + debug_string_literal(value)
  }
  if self.author_id() is Some(value) {
    out = out + ", author_id: " + debug_string_literal(value)
  }
  if self.class_name() is Some(value) {
    out = out + ", class_name: " + debug_string_literal(value)
  }
  if self.font_family() is Some(value) {
    out = out + ", font_family: " + debug_string_literal(value)
  }
  if self.html_tag() is Some(value) {
    out = out + ", html_tag: " + debug_string_literal(value)
  }
  if self.inner_html() is Some(value) {
    out = out + ", inner_html: " + debug_string_literal(value)
  }
  if self.keyboard_shortcut() is Some(value) {
    out = out + ", keyboard_shortcut: " + debug_string_literal(value)
  }
  if self.language() is Some(value) {
    out = out + ", language: " + debug_string_literal(value)
  }
  if self.placeholder() is Some(value) {
    out = out + ", placeholder: " + debug_string_literal(value)
  }
  if self.role_description() is Some(value) {
    out = out + ", role_description: " + debug_string_literal(value)
  }
  if self.state_description() is Some(value) {
    out = out + ", state_description: " + debug_string_literal(value)
  }
  if self.tooltip() is Some(value) {
    out = out + ", tooltip: " + debug_string_literal(value)
  }
  if self.url() is Some(value) {
    out = out + ", url: " + debug_string_literal(value)
  }
  if self.row_index_text() is Some(value) {
    out = out + ", row_index_text: " + debug_string_literal(value)
  }
  if self.column_index_text() is Some(value) {
    out = out + ", column_index_text: " + debug_string_literal(value)
  }
  if self.braille_label() is Some(value) {
    out = out + ", braille_label: " + debug_string_literal(value)
  }
  if self.braille_role_description() is Some(value) {
    out = out + ", braille_role_description: " + debug_string_literal(value)
  }
  if self.scroll_x() is Some(value) {
    out = out + ", scroll_x: " + debug_double(value)
  }
  if self.scroll_x_min() is Some(value) {
    out = out + ", scroll_x_min: " + debug_double(value)
  }
  if self.scroll_x_max() is Some(value) {
    out = out + ", scroll_x_max: " + debug_double(value)
  }
  if self.scroll_y() is Some(value) {
    out = out + ", scroll_y: " + debug_double(value)
  }
  if self.scroll_y_min() is Some(value) {
    out = out + ", scroll_y_min: " + debug_double(value)
  }
  if self.scroll_y_max() is Some(value) {
    out = out + ", scroll_y_max: " + debug_double(value)
  }
  if self.numeric_value() is Some(value) {
    out = out + ", numeric_value: " + debug_double(value)
  }
  if self.min_numeric_value() is Some(value) {
    out = out + ", min_numeric_value: " + debug_double(value)
  }
  if self.max_numeric_value() is Some(value) {
    out = out + ", max_numeric_value: " + debug_double(value)
  }
  if self.numeric_value_step() is Some(value) {
    out = out + ", numeric_value_step: " + debug_double(value)
  }
  if self.numeric_value_jump() is Some(value) {
    out = out + ", numeric_value_jump: " + debug_double(value)
  }
  if self.font_size() is Some(value) {
    out = out + ", font_size: " + debug_float(value)
  }
  if self.font_weight() is Some(value) {
    out = out + ", font_weight: " + debug_float(value)
  }
  if self.row_count() is Some(value) {
    out = out + ", row_count: " + value.to_string()
  }
  if self.column_count() is Some(value) {
    out = out + ", column_count: " + value.to_string()
  }
  if self.row_index() is Some(value) {
    out = out + ", row_index: " + value.to_string()
  }
  if self.column_index() is Some(value) {
    out = out + ", column_index: " + value.to_string()
  }
  if self.row_span() is Some(value) {
    out = out + ", row_span: " + value.to_string()
  }
  if self.column_span() is Some(value) {
    out = out + ", column_span: " + value.to_string()
  }
  if self.level() is Some(value) {
    out = out + ", level: " + value.to_string()
  }
  if self.size_of_set() is Some(value) {
    out = out + ", size_of_set: " + value.to_string()
  }
  if self.position_in_set() is Some(value) {
    out = out + ", position_in_set: " + value.to_string()
  }
  if self.color_value() is Some(value) {
    out = out + ", color_value: " + color_debug(value)
  }
  if self.background_color() is Some(value) {
    out = out + ", background_color: " + color_debug(value)
  }
  if self.foreground_color() is Some(value) {
    out = out + ", foreground_color: " + color_debug(value)
  }
  if self.overline() is Some(value) {
    out = out + ", overline: " + text_decoration_debug(value)
  }
  if self.strikethrough() is Some(value) {
    out = out + ", strikethrough: " + text_decoration_debug(value)
  }
  if self.underline() is Some(value) {
    out = out + ", underline: " + text_decoration_debug(value)
  }
  let character_lengths = self.character_lengths()
  if character_lengths.length() != 0 {
    out = out + ", character_lengths: " + int_slice_debug(character_lengths)
  }
  let word_starts = self.word_starts()
  if word_starts.length() != 0 {
    out = out + ", word_starts: " + int_slice_debug(word_starts)
  }
  if self.character_positions() is Some(value) {
    out = out + ", character_positions: " + float_slice_debug(value)
  }
  if self.character_widths() is Some(value) {
    out = out + ", character_widths: " + float_slice_debug(value)
  }
  if self.is_expanded() is Some(value) {
    out = out + ", is_expanded: " + value.to_string()
  }
  if self.is_selected() is Some(value) {
    out = out + ", is_selected: " + value.to_string()
  }
  if self.invalid() is Some(value) {
    out = out + ", invalid: " + value.to_string()
  }
  if self.toggled() is Some(value) {
    out = out + ", toggled: " + value.to_string()
  }
  if self.live() is Some(value) {
    out = out + ", live: " + value.to_string()
  }
  if self.text_direction() is Some(value) {
    out = out + ", text_direction: " + value.to_string()
  }
  if self.orientation() is Some(value) {
    out = out + ", orientation: " + value.to_string()
  }
  if self.sort_direction() is Some(value) {
    out = out + ", sort_direction: " + value.to_string()
  }
  if self.aria_current() is Some(value) {
    out = out + ", aria_current: " + value.to_string()
  }
  if self.auto_complete() is Some(value) {
    out = out + ", auto_complete: " + value.to_string()
  }
  if self.has_popup() is Some(value) {
    out = out + ", has_popup: " + value.to_string()
  }
  if self.list_style() is Some(value) {
    out = out + ", list_style: " + value.to_string()
  }
  if self.text_align() is Some(value) {
    out = out + ", text_align: " + value.to_string()
  }
  if self.vertical_offset() is Some(value) {
    out = out + ", vertical_offset: " + value.to_string()
  }
  if self.transform() is Some(value) {
    out = out + ", transform: " + affine_debug(value)
  }
  if self.bounds() is Some(value) {
    out = out + ", bounds: " + rect_debug(value)
  }
  if self.text_selection() is Some(value) {
    out = out + ", text_selection: " + text_selection_debug(value)
  }
  if self.tree_id() is Some(value) {
    out = out + ", tree_id: " + value.debug()
  }
  let custom_actions = self.custom_actions()
  if custom_actions.length() != 0 {
    out = out +
      ", custom_actions: [" +
      custom_action_vec_debug(custom_actions) +
      "]"
  }
  out + " }"
}

///|
fn[T] json_decode_error(
  path : @json.JsonPath,
  msg : String,
) -> T raise @json.JsonDecodeError {
  raise @json.JsonDecodeError((path, msg))
}

///|
fn ascii_lower(c : Char) -> Char {
  let i = c.to_int()
  if i >= 65 && i <= 90 {
    Int::unsafe_to_char(i + 32)
  } else {
    c
  }
}

///|
fn lower_first_ascii(s : String) -> String {
  let buf = StringBuilder::new()
  let mut first = true
  for c in s {
    if first {
      buf.write_char(ascii_lower(c))
      first = false
    } else {
      buf.write_char(c)
    }
  }
  buf.to_string()
}

///|
fn strip_enum_prefix(s : String) -> String {
  let len = s.length()
  if len < 3 {
    return s
  }
  let mut start = 0
  for i in 0..<(len - 1) {
    if s.code_unit_at(i) == 58 && s.code_unit_at(i + 1) == 58 {
      start = i + 2
    }
  }
  if start == 0 {
    s
  } else {
    s[start:len].to_owned()
  }
}

///|
fn enum_tag(value_repr : String) -> String {
  lower_first_ascii(strip_enum_prefix(value_repr))
}

///|
pub impl ToJson for NodeId with to_json(self : NodeId) -> Json {
  Json::number(self.0.to_double(), repr=self.0.to_string())
}

///|
pub impl @json.FromJson for NodeId with from_json(json, path) {
  guard json is Number(_, repr=Some(repr)) else {
    json_decode_error(path, "NodeId::from_json: expected integer")
  }
  let value : UInt64 = @string.parse_uint64(repr) catch {
    _ => json_decode_error(path, "NodeId::from_json: invalid integer")
  }
  NodeId::from_u64(value)
}

///|
fn uuid_hex_value(c : Char) -> UInt? {
  let v = c.to_int()
  if v >= 48 && v <= 57 {
    Some((v - 48).reinterpret_as_uint())
  } else if v >= 97 && v <= 102 {
    Some((v - 87).reinterpret_as_uint())
  } else if v >= 65 && v <= 70 {
    Some((v - 55).reinterpret_as_uint())
  } else {
    None
  }
}

///|
fn uuid_from_string(s : String) -> Uuid? {
  let mut hi : UInt64 = 0UL
  let mut lo : UInt64 = 0UL
  let mut i = 0
  for c in s {
    if c == '-' {
      continue
    }
    guard uuid_hex_value(c) is Some(digit) else { return None }
    let d = digit.to_uint64()
    if i < 16 {
      hi = (hi << 4) | d
    } else if i < 32 {
      lo = (lo << 4) | d
    } else {
      return None
    }
    i = i + 1
  }
  if i != 32 {
    None
  } else {
    Some({ high: hi, low: lo })
  }
}

///|
pub impl ToJson for Uuid with to_json(self : Uuid) -> Json {
  Json::string(self.debug())
}

///|
pub impl @json.FromJson for Uuid with from_json(json, path) {
  guard json is String(str) else {
    json_decode_error(path, "Uuid::from_json: expected string")
  }
  match uuid_from_string(str) {
    Some(uuid) => uuid
    None => json_decode_error(path, "Uuid::from_json: invalid uuid")
  }
}

///|
pub impl ToJson for TreeId with to_json(self : TreeId) -> Json {
  self.0.to_json()
}

///|
pub impl @json.FromJson for TreeId with from_json(json, path) {
  let uuid : Uuid = @json.FromJson::from_json(json, path)
  TreeId(uuid)
}

///|
pub impl ToJson for Color with to_json(self : Color) -> Json {
  Json::object({
    "red": Json::number(self.red.to_int().to_double()),
    "green": Json::number(self.green.to_int().to_double()),
    "blue": Json::number(self.blue.to_int().to_double()),
    "alpha": Json::number(self.alpha.to_int().to_double()),
  })
}

///|
fn json_to_byte(
  json : Json,
  path : @json.JsonPath,
  what : String,
) -> Byte raise @json.JsonDecodeError {
  let n : Int = @json.FromJson::from_json(json, path)
  if n < 0 || n > 255 {
    json_decode_error(path, "\{what}: expected byte")
  }
  n.to_byte()
}

///|
pub impl @json.FromJson for Color with from_json(json, path) {
  guard json is Object(obj) else {
    json_decode_error(path, "Color::from_json: expected object")
  }
  for key, _ in obj {
    if key != "red" && key != "green" && key != "blue" && key != "alpha" {
      json_decode_error(path, "Color::from_json: unknown field \{key}")
    }
  }
  guard obj.get("red") is Some(r_json) else {
    json_decode_error(path, "Color::from_json: missing field red")
  }
  guard obj.get("green") is Some(g_json) else {
    json_decode_error(path, "Color::from_json: missing field green")
  }
  guard obj.get("blue") is Some(b_json) else {
    json_decode_error(path, "Color::from_json: missing field blue")
  }
  guard obj.get("alpha") is Some(a_json) else {
    json_decode_error(path, "Color::from_json: missing field alpha")
  }
  let red = json_to_byte(r_json, path.add_key("red"), "Color::from_json")
  let green = json_to_byte(g_json, path.add_key("green"), "Color::from_json")
  let blue = json_to_byte(b_json, path.add_key("blue"), "Color::from_json")
  let alpha = json_to_byte(a_json, path.add_key("alpha"), "Color::from_json")
  Color::Color(red, green, blue, alpha)
}

///|
fn text_decoration_style_tag(value : TextDecorationStyle) -> String {
  enum_tag(to_repr(value).to_string())
}

///|
fn text_decoration_style_from_tag(tag : String) -> TextDecorationStyle? {
  match tag {
    "solid" => Some(TextDecorationStyle::Solid)
    "dotted" => Some(TextDecorationStyle::Dotted)
    "dashed" => Some(TextDecorationStyle::Dashed)
    "double" => Some(TextDecorationStyle::Double)
    "wavy" => Some(TextDecorationStyle::Wavy)
    _ => None
  }
}

///|
pub impl ToJson for TextDecorationStyle with to_json(self : TextDecorationStyle) -> Json {
  Json::string(text_decoration_style_tag(self))
}

///|
pub impl @json.FromJson for TextDecorationStyle with from_json(json, path) {
  guard json is String(tag) else {
    json_decode_error(path, "TextDecorationStyle::from_json: expected string")
  }
  match text_decoration_style_from_tag(tag) {
    Some(v) => v
    None =>
      json_decode_error(path, "TextDecorationStyle::from_json: invalid value")
  }
}

///|
pub impl ToJson for TextDecoration with to_json(self : TextDecoration) -> Json {
  Json::object({ "style": self.style.to_json(), "color": self.color.to_json() })
}

///|
pub impl @json.FromJson for TextDecoration with from_json(json, path) {
  guard json is Object(obj) else {
    json_decode_error(path, "TextDecoration::from_json: expected object")
  }
  for key, _ in obj {
    if key != "style" && key != "color" {
      json_decode_error(path, "TextDecoration::from_json: unknown field \{key}")
    }
  }
  guard obj.get("style") is Some(style_json) else {
    json_decode_error(path, "TextDecoration::from_json: missing field style")
  }
  guard obj.get("color") is Some(color_json) else {
    json_decode_error(path, "TextDecoration::from_json: missing field color")
  }
  let style : TextDecorationStyle = @json.FromJson::from_json(
    style_json,
    path.add_key("style"),
  )
  let color : Color = @json.FromJson::from_json(
    color_json,
    path.add_key("color"),
  )
  TextDecoration::TextDecoration(style, color)
}

///|
pub impl ToJson for CustomAction with to_json(self : CustomAction) -> Json {
  Json::object({
    "id": self.id.to_json(),
    "description": Json::string(self.description),
  })
}

///|
pub impl @json.FromJson for CustomAction with from_json(json, path) {
  guard json is Object(obj) else {
    json_decode_error(path, "CustomAction::from_json: expected object")
  }
  for key, _ in obj {
    if key != "id" && key != "description" {
      json_decode_error(path, "CustomAction::from_json: unknown field \{key}")
    }
  }
  guard obj.get("id") is Some(id_json) else {
    json_decode_error(path, "CustomAction::from_json: missing field id")
  }
  guard obj.get("description") is Some(desc_json) else {
    json_decode_error(
      path, "CustomAction::from_json: missing field description",
    )
  }
  let id : Int = @json.FromJson::from_json(id_json, path.add_key("id"))
  guard desc_json is String(desc) else {
    json_decode_error(
      path.add_key("description"),
      "CustomAction::from_json: expected string",
    )
  }
  CustomAction::CustomAction(id, desc)
}

///|
pub impl ToJson for TextPosition with to_json(self : TextPosition) -> Json {
  Json::object({
    "node": self.node.to_json(),
    "characterIndex": self.character_index.to_json(),
  })
}

///|
pub impl @json.FromJson for TextPosition with from_json(json, path) {
  guard json is Object(obj) else {
    json_decode_error(path, "TextPosition::from_json: expected object")
  }
  for key, _ in obj {
    if key != "node" && key != "characterIndex" {
      json_decode_error(path, "TextPosition::from_json: unknown field \{key}")
    }
  }
  guard obj.get("node") is Some(node_json) else {
    json_decode_error(path, "TextPosition::from_json: missing field node")
  }
  guard obj.get("characterIndex") is Some(index_json) else {
    json_decode_error(
      path, "TextPosition::from_json: missing field characterIndex",
    )
  }
  let node : NodeId = @json.FromJson::from_json(node_json, path.add_key("node"))
  let index : Int = @json.FromJson::from_json(
    index_json,
    path.add_key("characterIndex"),
  )
  TextPosition::TextPosition(node, index)
}

///|
pub impl ToJson for TextSelection with to_json(self : TextSelection) -> Json {
  Json::object({
    "anchor": self.anchor.to_json(),
    "focus": self.focus.to_json(),
  })
}

///|
pub impl @json.FromJson for TextSelection with from_json(json, path) {
  guard json is Object(obj) else {
    json_decode_error(path, "TextSelection::from_json: expected object")
  }
  for key, _ in obj {
    if key != "anchor" && key != "focus" {
      json_decode_error(path, "TextSelection::from_json: unknown field \{key}")
    }
  }
  guard obj.get("anchor") is Some(anchor_json) else {
    json_decode_error(path, "TextSelection::from_json: missing field anchor")
  }
  guard obj.get("focus") is Some(focus_json) else {
    json_decode_error(path, "TextSelection::from_json: missing field focus")
  }
  let anchor : TextPosition = @json.FromJson::from_json(
    anchor_json,
    path.add_key("anchor"),
  )
  let focus : TextPosition = @json.FromJson::from_json(
    focus_json,
    path.add_key("focus"),
  )
  TextSelection::TextSelection(anchor, focus)
}

///|
fn role_tag(value : Role) -> String {
  enum_tag(to_repr(value).to_string())
}

///|
fn all_roles() -> Array[Role] {
  [
    Role::Unknown,
    Role::TextRun,
    Role::Cell,
    Role::Label,
    Role::Image,
    Role::Link,
    Role::Row,
    Role::ListItem,
    Role::ListMarker,
    Role::TreeItem,
    Role::ListBoxOption,
    Role::MenuItem,
    Role::MenuListOption,
    Role::Paragraph,
    Role::GenericContainer,
    Role::CheckBox,
    Role::RadioButton,
    Role::TextInput,
    Role::Button,
    Role::DefaultButton,
    Role::Pane,
    Role::RowHeader,
    Role::ColumnHeader,
    Role::RowGroup,
    Role::List,
    Role::Table,
    Role::LayoutTableCell,
    Role::LayoutTableRow,
    Role::LayoutTable,
    Role::Switch,
    Role::Menu,
    Role::MultilineTextInput,
    Role::SearchInput,
    Role::DateInput,
    Role::DateTimeInput,
    Role::WeekInput,
    Role::MonthInput,
    Role::TimeInput,
    Role::EmailInput,
    Role::NumberInput,
    Role::PasswordInput,
    Role::PhoneNumberInput,
    Role::UrlInput,
    Role::Abbr,
    Role::Alert,
    Role::AlertDialog,
    Role::Application,
    Role::Article,
    Role::Audio,
    Role::Banner,
    Role::Blockquote,
    Role::Canvas,
    Role::Caption,
    Role::Caret,
    Role::Code,
    Role::ColorWell,
    Role::ComboBox,
    Role::EditableComboBox,
    Role::Complementary,
    Role::Comment,
    Role::ContentDeletion,
    Role::ContentInsertion,
    Role::ContentInfo,
    Role::Definition,
    Role::DescriptionList,
    Role::Details,
    Role::Dialog,
    Role::DisclosureTriangle,
    Role::Document,
    Role::EmbeddedObject,
    Role::Emphasis,
    Role::Feed,
    Role::FigureCaption,
    Role::Figure,
    Role::Footer,
    Role::Form,
    Role::Grid,
    Role::GridCell,
    Role::Group,
    Role::Header,
    Role::Heading,
    Role::Iframe,
    Role::IframePresentational,
    Role::ImeCandidate,
    Role::Keyboard,
    Role::Legend,
    Role::LineBreak,
    Role::ListBox,
    Role::Log,
    Role::Main,
    Role::Mark,
    Role::Marquee,
    Role::Math,
    Role::MenuBar,
    Role::MenuItemCheckBox,
    Role::MenuItemRadio,
    Role::MenuListPopup,
    Role::Meter,
    Role::Navigation,
    Role::Note,
    Role::PluginObject,
    Role::ProgressIndicator,
    Role::RadioGroup,
    Role::Region,
    Role::RootWebArea,
    Role::Ruby,
    Role::RubyAnnotation,
    Role::ScrollBar,
    Role::ScrollView,
    Role::Search,
    Role::Section,
    Role::SectionFooter,
    Role::SectionHeader,
    Role::Slider,
    Role::SpinButton,
    Role::Splitter,
    Role::Status,
    Role::Strong,
    Role::Suggestion,
    Role::SvgRoot,
    Role::Tab,
    Role::TabList,
    Role::TabPanel,
    Role::Term,
    Role::Time,
    Role::Timer,
    Role::TitleBar,
    Role::Toolbar,
    Role::Tooltip,
    Role::Tree,
    Role::TreeGrid,
    Role::Video,
    Role::WebView,
    Role::Window,
    Role::PdfActionableHighlight,
    Role::PdfRoot,
    Role::GraphicsDocument,
    Role::GraphicsObject,
    Role::GraphicsSymbol,
    Role::DocAbstract,
    Role::DocAcknowledgements,
    Role::DocAfterword,
    Role::DocAppendix,
    Role::DocBackLink,
    Role::DocBiblioEntry,
    Role::DocBibliography,
    Role::DocBiblioRef,
    Role::DocChapter,
    Role::DocColophon,
    Role::DocConclusion,
    Role::DocCover,
    Role::DocCredit,
    Role::DocCredits,
    Role::DocDedication,
    Role::DocEndnote,
    Role::DocEndnotes,
    Role::DocEpigraph,
    Role::DocEpilogue,
    Role::DocErrata,
    Role::DocExample,
    Role::DocFootnote,
    Role::DocForeword,
    Role::DocGlossary,
    Role::DocGlossRef,
    Role::DocIndex,
    Role::DocIntroduction,
    Role::DocNoteRef,
    Role::DocNotice,
    Role::DocPageBreak,
    Role::DocPageFooter,
    Role::DocPageHeader,
    Role::DocPageList,
    Role::DocPart,
    Role::DocPreface,
    Role::DocPrologue,
    Role::DocPullquote,
    Role::DocQna,
    Role::DocSubtitle,
    Role::DocTip,
    Role::DocToc,
    Role::ListGrid,
    Role::Terminal,
  ]
}

///|
fn role_from_tag(tag : String) -> Role? {
  for role in all_roles() {
    if role_tag(role) == tag {
      return Some(role)
    }
  }
  None
}

///|
pub impl ToJson for Role with to_json(self : Role) -> Json {
  Json::string(role_tag(self))
}

///|
pub impl @json.FromJson for Role with from_json(json, path) {
  guard json is String(tag) else {
    json_decode_error(path, "Role::from_json: expected string")
  }
  match role_from_tag(tag) {
    Some(role) => role
    None => json_decode_error(path, "Role::from_json: invalid value")
  }
}

///|
fn action_tag(value : Action) -> String {
  enum_tag(to_repr(value).to_string())
}

///|
fn all_actions() -> Array[Action] {
  [
    Action::Click,
    Action::Focus,
    Action::Blur,
    Action::Collapse,
    Action::Expand,
    Action::CustomAction,
    Action::Decrement,
    Action::Increment,
    Action::HideTooltip,
    Action::ShowTooltip,
    Action::ReplaceSelectedText,
    Action::ScrollDown,
    Action::ScrollLeft,
    Action::ScrollRight,
    Action::ScrollUp,
    Action::ScrollIntoView,
    Action::ScrollToPoint,
    Action::SetScrollOffset,
    Action::SetTextSelection,
    Action::SetSequentialFocusNavigationStartingPoint,
    Action::SetValue,
    Action::ShowContextMenu,
  ]
}

///|
fn action_from_tag(tag : String) -> Action? {
  for action in all_actions() {
    if action_tag(action) == tag {
      return Some(action)
    }
  }
  None
}

///|
pub impl ToJson for Action with to_json(self : Action) -> Json {
  Json::string(action_tag(self))
}

///|
pub impl @json.FromJson for Action with from_json(json, path) {
  guard json is String(tag) else {
    json_decode_error(path, "Action::from_json: expected string")
  }
  match action_from_tag(tag) {
    Some(action) => action
    None => json_decode_error(path, "Action::from_json: invalid value")
  }
}

///|
fn scroll_unit_tag(value : ScrollUnit) -> String {
  enum_tag(to_repr(value).to_string())
}

///|
fn all_scroll_units() -> Array[ScrollUnit] {
  [ScrollUnit::Item, ScrollUnit::Page]
}

///|
fn scroll_unit_from_tag(tag : String) -> ScrollUnit? {
  for unit in all_scroll_units() {
    if scroll_unit_tag(unit) == tag {
      return Some(unit)
    }
  }
  None
}

///|
pub impl ToJson for ScrollUnit with to_json(self : ScrollUnit) -> Json {
  Json::string(scroll_unit_tag(self))
}

///|
pub impl @json.FromJson for ScrollUnit with from_json(json, path) {
  guard json is String(tag) else {
    json_decode_error(path, "ScrollUnit::from_json: expected string")
  }
  match scroll_unit_from_tag(tag) {
    Some(v) => v
    None => json_decode_error(path, "ScrollUnit::from_json: invalid value")
  }
}

///|
fn scroll_hint_tag(value : ScrollHint) -> String {
  enum_tag(to_repr(value).to_string())
}

///|
fn all_scroll_hints() -> Array[ScrollHint] {
  [
    ScrollHint::TopLeft,
    ScrollHint::BottomRight,
    ScrollHint::TopEdge,
    ScrollHint::BottomEdge,
    ScrollHint::LeftEdge,
    ScrollHint::RightEdge,
  ]
}

///|
fn scroll_hint_from_tag(tag : String) -> ScrollHint? {
  for hint in all_scroll_hints() {
    if scroll_hint_tag(hint) == tag {
      return Some(hint)
    }
  }
  None
}

///|
pub impl ToJson for ScrollHint with to_json(self : ScrollHint) -> Json {
  Json::string(scroll_hint_tag(self))
}

///|
pub impl @json.FromJson for ScrollHint with from_json(json, path) {
  guard json is String(tag) else {
    json_decode_error(path, "ScrollHint::from_json: expected string")
  }
  match scroll_hint_from_tag(tag) {
    Some(v) => v
    None => json_decode_error(path, "ScrollHint::from_json: invalid value")
  }
}

///|
fn orientation_tag(value : Orientation) -> String {
  enum_tag(to_repr(value).to_string())
}

///|
fn all_orientations() -> Array[Orientation] {
  [Orientation::Horizontal, Orientation::Vertical]
}

///|
fn orientation_from_tag(tag : String) -> Orientation? {
  for v in all_orientations() {
    if orientation_tag(v) == tag {
      return Some(v)
    }
  }
  None
}

///|
pub impl ToJson for Orientation with to_json(self : Orientation) -> Json {
  Json::string(orientation_tag(self))
}

///|
pub impl @json.FromJson for Orientation with from_json(json, path) {
  guard json is String(tag) else {
    json_decode_error(path, "Orientation::from_json: expected string")
  }
  match orientation_from_tag(tag) {
    Some(v) => v
    None => json_decode_error(path, "Orientation::from_json: invalid value")
  }
}

///|
fn text_direction_tag(value : TextDirection) -> String {
  enum_tag(to_repr(value).to_string())
}

///|
fn all_text_directions() -> Array[TextDirection] {
  [
    TextDirection::LeftToRight,
    TextDirection::RightToLeft,
    TextDirection::TopToBottom,
    TextDirection::BottomToTop,
  ]
}

///|
fn text_direction_from_tag(tag : String) -> TextDirection? {
  for v in all_text_directions() {
    if text_direction_tag(v) == tag {
      return Some(v)
    }
  }
  None
}

///|
pub impl ToJson for TextDirection with to_json(self : TextDirection) -> Json {
  Json::string(text_direction_tag(self))
}

///|
pub impl @json.FromJson for TextDirection with from_json(json, path) {
  guard json is String(tag) else {
    json_decode_error(path, "TextDirection::from_json: expected string")
  }
  match text_direction_from_tag(tag) {
    Some(v) => v
    None => json_decode_error(path, "TextDirection::from_json: invalid value")
  }
}

///|
fn invalid_tag(value : Invalid) -> String {
  enum_tag(to_repr(value).to_string())
}

///|
fn all_invalid() -> Array[Invalid] {
  [Invalid::True, Invalid::Grammar, Invalid::Spelling]
}

///|
fn invalid_from_tag(tag : String) -> Invalid? {
  for v in all_invalid() {
    if invalid_tag(v) == tag {
      return Some(v)
    }
  }
  None
}

///|
pub impl ToJson for Invalid with to_json(self : Invalid) -> Json {
  Json::string(invalid_tag(self))
}

///|
pub impl @json.FromJson for Invalid with from_json(json, path) {
  guard json is String(tag) else {
    json_decode_error(path, "Invalid::from_json: expected string")
  }
  match invalid_from_tag(tag) {
    Some(v) => v
    None => json_decode_error(path, "Invalid::from_json: invalid value")
  }
}

///|
fn toggled_tag(value : Toggled) -> String {
  enum_tag(to_repr(value).to_string())
}

///|
fn all_toggled() -> Array[Toggled] {
  [Toggled::False, Toggled::True, Toggled::Mixed]
}

///|
fn toggled_from_tag(tag : String) -> Toggled? {
  for v in all_toggled() {
    if toggled_tag(v) == tag {
      return Some(v)
    }
  }
  None
}

///|
pub impl ToJson for Toggled with to_json(self : Toggled) -> Json {
  Json::string(toggled_tag(self))
}

///|
pub impl @json.FromJson for Toggled with from_json(json, path) {
  guard json is String(tag) else {
    json_decode_error(path, "Toggled::from_json: expected string")
  }
  match toggled_from_tag(tag) {
    Some(v) => v
    None => json_decode_error(path, "Toggled::from_json: invalid value")
  }
}

///|
fn sort_direction_tag(value : SortDirection) -> String {
  enum_tag(to_repr(value).to_string())
}

///|
fn all_sort_directions() -> Array[SortDirection] {
  [SortDirection::Ascending, SortDirection::Descending, SortDirection::Other]
}

///|
fn sort_direction_from_tag(tag : String) -> SortDirection? {
  for v in all_sort_directions() {
    if sort_direction_tag(v) == tag {
      return Some(v)
    }
  }
  None
}

///|
pub impl ToJson for SortDirection with to_json(self : SortDirection) -> Json {
  Json::string(sort_direction_tag(self))
}

///|
pub impl @json.FromJson for SortDirection with from_json(json, path) {
  guard json is String(tag) else {
    json_decode_error(path, "SortDirection::from_json: expected string")
  }
  match sort_direction_from_tag(tag) {
    Some(v) => v
    None => json_decode_error(path, "SortDirection::from_json: invalid value")
  }
}

///|
fn aria_current_tag(value : AriaCurrent) -> String {
  enum_tag(to_repr(value).to_string())
}

///|
fn all_aria_current() -> Array[AriaCurrent] {
  [
    AriaCurrent::False,
    AriaCurrent::True,
    AriaCurrent::Page,
    AriaCurrent::Step,
    AriaCurrent::Location,
    AriaCurrent::Date,
    AriaCurrent::Time,
  ]
}

///|
fn aria_current_from_tag(tag : String) -> AriaCurrent? {
  for v in all_aria_current() {
    if aria_current_tag(v) == tag {
      return Some(v)
    }
  }
  None
}

///|
pub impl ToJson for AriaCurrent with to_json(self : AriaCurrent) -> Json {
  Json::string(aria_current_tag(self))
}

///|
pub impl @json.FromJson for AriaCurrent with from_json(json, path) {
  guard json is String(tag) else {
    json_decode_error(path, "AriaCurrent::from_json: expected string")
  }
  match aria_current_from_tag(tag) {
    Some(v) => v
    None => json_decode_error(path, "AriaCurrent::from_json: invalid value")
  }
}

///|
fn auto_complete_tag(value : AutoComplete) -> String {
  enum_tag(to_repr(value).to_string())
}

///|
fn all_auto_complete() -> Array[AutoComplete] {
  [AutoComplete::Inline, AutoComplete::List, AutoComplete::Both]
}

///|
fn auto_complete_from_tag(tag : String) -> AutoComplete? {
  for v in all_auto_complete() {
    if auto_complete_tag(v) == tag {
      return Some(v)
    }
  }
  None
}

///|
pub impl ToJson for AutoComplete with to_json(self : AutoComplete) -> Json {
  Json::string(auto_complete_tag(self))
}

///|
pub impl @json.FromJson for AutoComplete with from_json(json, path) {
  guard json is String(tag) else {
    json_decode_error(path, "AutoComplete::from_json: expected string")
  }
  match auto_complete_from_tag(tag) {
    Some(v) => v
    None => json_decode_error(path, "AutoComplete::from_json: invalid value")
  }
}

///|
fn live_tag(value : Live) -> String {
  enum_tag(to_repr(value).to_string())
}

///|
fn all_live() -> Array[Live] {
  [Live::Off, Live::Polite, Live::Assertive]
}

///|
fn live_from_tag(tag : String) -> Live? {
  for v in all_live() {
    if live_tag(v) == tag {
      return Some(v)
    }
  }
  None
}

///|
pub impl ToJson for Live with to_json(self : Live) -> Json {
  Json::string(live_tag(self))
}

///|
pub impl @json.FromJson for Live with from_json(json, path) {
  guard json is String(tag) else {
    json_decode_error(path, "Live::from_json: expected string")
  }
  match live_from_tag(tag) {
    Some(v) => v
    None => json_decode_error(path, "Live::from_json: invalid value")
  }
}

///|
fn has_popup_tag(value : HasPopup) -> String {
  enum_tag(to_repr(value).to_string())
}

///|
fn all_has_popup() -> Array[HasPopup] {
  [
    HasPopup::Menu,
    HasPopup::Listbox,
    HasPopup::Tree,
    HasPopup::Grid,
    HasPopup::Dialog,
  ]
}

///|
fn has_popup_from_tag(tag : String) -> HasPopup? {
  for v in all_has_popup() {
    if has_popup_tag(v) == tag {
      return Some(v)
    }
  }
  None
}

///|
pub impl ToJson for HasPopup with to_json(self : HasPopup) -> Json {
  Json::string(has_popup_tag(self))
}

///|
pub impl @json.FromJson for HasPopup with from_json(json, path) {
  guard json is String(tag) else {
    json_decode_error(path, "HasPopup::from_json: expected string")
  }
  match has_popup_from_tag(tag) {
    Some(v) => v
    None => json_decode_error(path, "HasPopup::from_json: invalid value")
  }
}

///|
fn list_style_tag(value : ListStyle) -> String {
  enum_tag(to_repr(value).to_string())
}

///|
fn all_list_styles() -> Array[ListStyle] {
  [
    ListStyle::Circle,
    ListStyle::Disc,
    ListStyle::Image,
    ListStyle::Numeric,
    ListStyle::Square,
    ListStyle::Other,
  ]
}

///|
fn list_style_from_tag(tag : String) -> ListStyle? {
  for v in all_list_styles() {
    if list_style_tag(v) == tag {
      return Some(v)
    }
  }
  None
}

///|
pub impl ToJson for ListStyle with to_json(self : ListStyle) -> Json {
  Json::string(list_style_tag(self))
}

///|
pub impl @json.FromJson for ListStyle with from_json(json, path) {
  guard json is String(tag) else {
    json_decode_error(path, "ListStyle::from_json: expected string")
  }
  match list_style_from_tag(tag) {
    Some(v) => v
    None => json_decode_error(path, "ListStyle::from_json: invalid value")
  }
}

///|
fn text_align_tag(value : TextAlign) -> String {
  enum_tag(to_repr(value).to_string())
}

///|
fn all_text_align() -> Array[TextAlign] {
  [TextAlign::Left, TextAlign::Right, TextAlign::Center, TextAlign::Justify]
}

///|
fn text_align_from_tag(tag : String) -> TextAlign? {
  for v in all_text_align() {
    if text_align_tag(v) == tag {
      return Some(v)
    }
  }
  None
}

///|
pub impl ToJson for TextAlign with to_json(self : TextAlign) -> Json {
  Json::string(text_align_tag(self))
}

///|
pub impl @json.FromJson for TextAlign with from_json(json, path) {
  guard json is String(tag) else {
    json_decode_error(path, "TextAlign::from_json: expected string")
  }
  match text_align_from_tag(tag) {
    Some(v) => v
    None => json_decode_error(path, "TextAlign::from_json: invalid value")
  }
}

///|
fn vertical_offset_tag(value : VerticalOffset) -> String {
  enum_tag(to_repr(value).to_string())
}

///|
fn all_vertical_offsets() -> Array[VerticalOffset] {
  [VerticalOffset::Subscript, VerticalOffset::Superscript]
}

///|
fn vertical_offset_from_tag(tag : String) -> VerticalOffset? {
  for v in all_vertical_offsets() {
    if vertical_offset_tag(v) == tag {
      return Some(v)
    }
  }
  None
}

///|
pub impl ToJson for VerticalOffset with to_json(self : VerticalOffset) -> Json {
  Json::string(vertical_offset_tag(self))
}

///|
pub impl @json.FromJson for VerticalOffset with from_json(json, path) {
  guard json is String(tag) else {
    json_decode_error(path, "VerticalOffset::from_json: expected string")
  }
  match vertical_offset_from_tag(tag) {
    Some(v) => v
    None => json_decode_error(path, "VerticalOffset::from_json: invalid value")
  }
}

///|
fn property_json_key(id : Int) -> String {
  match id {
    PID_CHILDREN => "children"
    PID_CONTROLS => "controls"
    PID_DETAILS => "details"
    PID_DESCRIBED_BY => "describedBy"
    PID_FLOW_TO => "flowTo"
    PID_LABELLED_BY => "labelledBy"
    PID_OWNS => "owns"
    PID_RADIO_GROUP => "radioGroup"
    PID_ACTIVE_DESCENDANT => "activeDescendant"
    PID_ERROR_MESSAGE => "errorMessage"
    PID_IN_PAGE_LINK_TARGET => "inPageLinkTarget"
    PID_MEMBER_OF => "memberOf"
    PID_NEXT_ON_LINE => "nextOnLine"
    PID_PREVIOUS_ON_LINE => "previousOnLine"
    PID_POPUP_FOR => "popupFor"
    PID_LABEL => "label"
    PID_DESCRIPTION => "description"
    PID_VALUE => "value"
    PID_ACCESS_KEY => "accessKey"
    PID_AUTHOR_ID => "authorId"
    PID_CLASS_NAME => "className"
    PID_FONT_FAMILY => "fontFamily"
    PID_HTML_TAG => "htmlTag"
    PID_INNER_HTML => "innerHtml"
    PID_KEYBOARD_SHORTCUT => "keyboardShortcut"
    PID_LANGUAGE => "language"
    PID_PLACEHOLDER => "placeholder"
    PID_ROLE_DESCRIPTION => "roleDescription"
    PID_STATE_DESCRIPTION => "stateDescription"
    PID_TOOLTIP => "tooltip"
    PID_URL => "url"
    PID_ROW_INDEX_TEXT => "rowIndexText"
    PID_COLUMN_INDEX_TEXT => "columnIndexText"
    PID_BRAILLE_LABEL => "brailleLabel"
    PID_BRAILLE_ROLE_DESCRIPTION => "brailleRoleDescription"
    PID_SCROLL_X => "scrollX"
    PID_SCROLL_X_MIN => "scrollXMin"
    PID_SCROLL_X_MAX => "scrollXMax"
    PID_SCROLL_Y => "scrollY"
    PID_SCROLL_Y_MIN => "scrollYMin"
    PID_SCROLL_Y_MAX => "scrollYMax"
    PID_NUMERIC_VALUE => "numericValue"
    PID_MIN_NUMERIC_VALUE => "minNumericValue"
    PID_MAX_NUMERIC_VALUE => "maxNumericValue"
    PID_NUMERIC_VALUE_STEP => "numericValueStep"
    PID_NUMERIC_VALUE_JUMP => "numericValueJump"
    PID_FONT_SIZE => "fontSize"
    PID_FONT_WEIGHT => "fontWeight"
    PID_ROW_COUNT => "rowCount"
    PID_COLUMN_COUNT => "columnCount"
    PID_ROW_INDEX => "rowIndex"
    PID_COLUMN_INDEX => "columnIndex"
    PID_ROW_SPAN => "rowSpan"
    PID_COLUMN_SPAN => "columnSpan"
    PID_LEVEL => "level"
    PID_SIZE_OF_SET => "sizeOfSet"
    PID_POSITION_IN_SET => "positionInSet"
    PID_COLOR_VALUE => "colorValue"
    PID_BACKGROUND_COLOR => "backgroundColor"
    PID_FOREGROUND_COLOR => "foregroundColor"
    PID_OVERLINE => "overline"
    PID_STRIKETHROUGH => "strikethrough"
    PID_UNDERLINE => "underline"
    PID_CHARACTER_LENGTHS => "characterLengths"
    PID_WORD_STARTS => "wordStarts"
    PID_CHARACTER_POSITIONS => "characterPositions"
    PID_CHARACTER_WIDTHS => "characterWidths"
    PID_EXPANDED => "expanded"
    PID_SELECTED => "selected"
    PID_INVALID => "invalid"
    PID_TOGGLED => "toggled"
    PID_LIVE => "live"
    PID_TEXT_DIRECTION => "textDirection"
    PID_ORIENTATION => "orientation"
    PID_SORT_DIRECTION => "sortDirection"
    PID_ARIA_CURRENT => "ariaCurrent"
    PID_AUTO_COMPLETE => "autoComplete"
    PID_HAS_POPUP => "hasPopup"
    PID_LIST_STYLE => "listStyle"
    PID_TEXT_ALIGN => "textAlign"
    PID_VERTICAL_OFFSET => "verticalOffset"
    PID_TRANSFORM => "transform"
    PID_BOUNDS => "bounds"
    PID_TEXT_SELECTION => "textSelection"
    PID_CUSTOM_ACTIONS => "customActions"
    PID_TREE_ID => "treeId"
    _ => abort("invalid property id")
  }
}

///|
fn property_json_value(value : PropertyValue) -> Json {
  match value {
    PropertyValue::None => Json::null()
    NodeIdVec(ids) => {
      let arr : Array[Json] = []
      for id in ids {
        arr.push(id.to_json())
      }
      Json::array(arr)
    }
    NodeId(id) => id.to_json()
    String(s) => Json::string(s)
    F64(v) => v.to_json()
    F32(v) => v.to_json()
    Usize(v) => v.to_json()
    Color(c) => c.to_json()
    TextDecoration(t) => t.to_json()
    LengthSlice(v) => {
      let arr : Array[Json] = []
      for item in v {
        arr.push(item.to_json())
      }
      Json::array(arr)
    }
    CoordSlice(v) => {
      let arr : Array[Json] = []
      for item in v {
        arr.push(item.to_json())
      }
      Json::array(arr)
    }
    Bool(v) => v.to_json()
    Invalid(v) => v.to_json()
    Toggled(v) => v.to_json()
    Live(v) => v.to_json()
    TextDirection(v) => v.to_json()
    Orientation(v) => v.to_json()
    SortDirection(v) => v.to_json()
    AriaCurrent(v) => v.to_json()
    AutoComplete(v) => v.to_json()
    HasPopup(v) => v.to_json()
    ListStyle(v) => v.to_json()
    TextAlign(v) => v.to_json()
    VerticalOffset(v) => v.to_json()
    Affine(v) => v.to_json()
    Rect(v) => v.to_json()
    TextSelection(v) => v.to_json()
    TreeId(v) => v.to_json()
    CustomActionVec(actions) => {
      let arr : Array[Json] = []
      for action in actions {
        arr.push(action.to_json())
      }
      Json::array(arr)
    }
  }
}

///|
fn properties_to_json(props : Properties) -> Json {
  let map = Map([])
  for id in 0..<PROPERTY_ID_COUNT {
    let index = props.indices[id]
    if index < 0 {
      continue
    }
    match props.values[index] {
      PropertyValue::None => ()
      value => map[property_json_key(id)] = property_json_value(value)
    }
  }
  Json::object(map)
}

///|
pub impl ToJson for Node with to_json(self : Node) -> Json {
  Json::object({
    "role": self.role.to_json(),
    "actions": self.actions.to_json(),
    "childActions": self.child_actions.to_json(),
    "flags": self.flags.to_json(),
    "properties": properties_to_json(self.properties),
  })
}

///|
fn node_apply_property(
  node : Node,
  key : String,
  value : Json,
  path : @json.JsonPath,
) -> Unit raise @json.JsonDecodeError {
  let value_path = path.add_key(key)
  match key {
    "children" =>
      node.set_children(@json.FromJson::from_json(value, value_path))
    "controls" =>
      node.set_controls(@json.FromJson::from_json(value, value_path))
    "details" => node.set_details(@json.FromJson::from_json(value, value_path))
    "describedBy" =>
      node.set_described_by(@json.FromJson::from_json(value, value_path))
    "flowTo" => node.set_flow_to(@json.FromJson::from_json(value, value_path))
    "labelledBy" =>
      node.set_labelled_by(@json.FromJson::from_json(value, value_path))
    "owns" => node.set_owns(@json.FromJson::from_json(value, value_path))
    "radioGroup" =>
      node.set_radio_group(@json.FromJson::from_json(value, value_path))
    "activeDescendant" =>
      node.set_active_descendant(@json.FromJson::from_json(value, value_path))
    "errorMessage" =>
      node.set_error_message(@json.FromJson::from_json(value, value_path))
    "inPageLinkTarget" =>
      node.set_in_page_link_target(@json.FromJson::from_json(value, value_path))
    "memberOf" =>
      node.set_member_of(@json.FromJson::from_json(value, value_path))
    "nextOnLine" =>
      node.set_next_on_line(@json.FromJson::from_json(value, value_path))
    "previousOnLine" =>
      node.set_previous_on_line(@json.FromJson::from_json(value, value_path))
    "popupFor" =>
      node.set_popup_for(@json.FromJson::from_json(value, value_path))
    "label" => node.set_label(@json.FromJson::from_json(value, value_path))
    "description" =>
      node.set_description(@json.FromJson::from_json(value, value_path))
    "value" => node.set_value(@json.FromJson::from_json(value, value_path))
    "accessKey" =>
      node.set_access_key(@json.FromJson::from_json(value, value_path))
    "authorId" =>
      node.set_author_id(@json.FromJson::from_json(value, value_path))
    "className" =>
      node.set_class_name(@json.FromJson::from_json(value, value_path))
    "fontFamily" =>
      node.set_font_family(@json.FromJson::from_json(value, value_path))
    "htmlTag" => node.set_html_tag(@json.FromJson::from_json(value, value_path))
    "innerHtml" =>
      node.set_inner_html(@json.FromJson::from_json(value, value_path))
    "keyboardShortcut" =>
      node.set_keyboard_shortcut(@json.FromJson::from_json(value, value_path))
    "language" =>
      node.set_language(@json.FromJson::from_json(value, value_path))
    "placeholder" =>
      node.set_placeholder(@json.FromJson::from_json(value, value_path))
    "roleDescription" =>
      node.set_role_description(@json.FromJson::from_json(value, value_path))
    "stateDescription" =>
      node.set_state_description(@json.FromJson::from_json(value, value_path))
    "tooltip" => node.set_tooltip(@json.FromJson::from_json(value, value_path))
    "url" => node.set_url(@json.FromJson::from_json(value, value_path))
    "rowIndexText" =>
      node.set_row_index_text(@json.FromJson::from_json(value, value_path))
    "columnIndexText" =>
      node.set_column_index_text(@json.FromJson::from_json(value, value_path))
    "brailleLabel" =>
      node.set_braille_label(@json.FromJson::from_json(value, value_path))
    "brailleRoleDescription" =>
      node.set_braille_role_description(
        @json.FromJson::from_json(value, value_path),
      )
    "scrollX" => node.set_scroll_x(@json.FromJson::from_json(value, value_path))
    "scrollXMin" =>
      node.set_scroll_x_min(@json.FromJson::from_json(value, value_path))
    "scrollXMax" =>
      node.set_scroll_x_max(@json.FromJson::from_json(value, value_path))
    "scrollY" => node.set_scroll_y(@json.FromJson::from_json(value, value_path))
    "scrollYMin" =>
      node.set_scroll_y_min(@json.FromJson::from_json(value, value_path))
    "scrollYMax" =>
      node.set_scroll_y_max(@json.FromJson::from_json(value, value_path))
    "numericValue" =>
      node.set_numeric_value(@json.FromJson::from_json(value, value_path))
    "minNumericValue" =>
      node.set_min_numeric_value(@json.FromJson::from_json(value, value_path))
    "maxNumericValue" =>
      node.set_max_numeric_value(@json.FromJson::from_json(value, value_path))
    "numericValueStep" =>
      node.set_numeric_value_step(@json.FromJson::from_json(value, value_path))
    "numericValueJump" =>
      node.set_numeric_value_jump(@json.FromJson::from_json(value, value_path))
    "fontSize" =>
      node.set_font_size(@json.FromJson::from_json(value, value_path))
    "fontWeight" =>
      node.set_font_weight(@json.FromJson::from_json(value, value_path))
    "rowCount" =>
      node.set_row_count(@json.FromJson::from_json(value, value_path))
    "columnCount" =>
      node.set_column_count(@json.FromJson::from_json(value, value_path))
    "rowIndex" =>
      node.set_row_index(@json.FromJson::from_json(value, value_path))
    "columnIndex" =>
      node.set_column_index(@json.FromJson::from_json(value, value_path))
    "rowSpan" => node.set_row_span(@json.FromJson::from_json(value, value_path))
    "columnSpan" =>
      node.set_column_span(@json.FromJson::from_json(value, value_path))
    "level" => node.set_level(@json.FromJson::from_json(value, value_path))
    "sizeOfSet" =>
      node.set_size_of_set(@json.FromJson::from_json(value, value_path))
    "positionInSet" =>
      node.set_position_in_set(@json.FromJson::from_json(value, value_path))
    "colorValue" =>
      node.set_color_value(@json.FromJson::from_json(value, value_path))
    "backgroundColor" =>
      node.set_background_color(@json.FromJson::from_json(value, value_path))
    "foregroundColor" =>
      node.set_foreground_color(@json.FromJson::from_json(value, value_path))
    "overline" =>
      node.set_overline(@json.FromJson::from_json(value, value_path))
    "strikethrough" =>
      node.set_strikethrough(@json.FromJson::from_json(value, value_path))
    "underline" =>
      node.set_underline(@json.FromJson::from_json(value, value_path))
    "characterLengths" =>
      node.set_character_lengths(@json.FromJson::from_json(value, value_path))
    "wordStarts" =>
      node.set_word_starts(@json.FromJson::from_json(value, value_path))
    "characterPositions" =>
      node.set_character_positions(@json.FromJson::from_json(value, value_path))
    "characterWidths" =>
      node.set_character_widths(@json.FromJson::from_json(value, value_path))
    "expanded" =>
      node.set_expanded(@json.FromJson::from_json(value, value_path))
    "selected" =>
      node.set_selected(@json.FromJson::from_json(value, value_path))
    "invalid" => node.set_invalid(@json.FromJson::from_json(value, value_path))
    "toggled" => node.set_toggled(@json.FromJson::from_json(value, value_path))
    "live" => node.set_live(@json.FromJson::from_json(value, value_path))
    "textDirection" =>
      node.set_text_direction(@json.FromJson::from_json(value, value_path))
    "orientation" =>
      node.set_orientation(@json.FromJson::from_json(value, value_path))
    "sortDirection" =>
      node.set_sort_direction(@json.FromJson::from_json(value, value_path))
    "ariaCurrent" =>
      node.set_aria_current(@json.FromJson::from_json(value, value_path))
    "autoComplete" =>
      node.set_auto_complete(@json.FromJson::from_json(value, value_path))
    "hasPopup" =>
      node.set_has_popup(@json.FromJson::from_json(value, value_path))
    "listStyle" =>
      node.set_list_style(@json.FromJson::from_json(value, value_path))
    "textAlign" =>
      node.set_text_align(@json.FromJson::from_json(value, value_path))
    "verticalOffset" =>
      node.set_vertical_offset(@json.FromJson::from_json(value, value_path))
    "transform" =>
      node.set_transform(@json.FromJson::from_json(value, value_path))
    "bounds" => node.set_bounds(@json.FromJson::from_json(value, value_path))
    "textSelection" =>
      node.set_text_selection(@json.FromJson::from_json(value, value_path))
    "customActions" =>
      node.set_custom_actions(@json.FromJson::from_json(value, value_path))
    "treeId" => node.set_tree_id(@json.FromJson::from_json(value, value_path))
    _ => () // Ignore unknown properties (Rust serde does this).
  }
}

///|
pub impl @json.FromJson for Node with from_json(json, path) {
  guard json is Object(obj) else {
    json_decode_error(path, "Node::from_json: expected object")
  }
  for key, _ in obj {
    if key != "role" &&
      key != "actions" &&
      key != "childActions" &&
      key != "flags" &&
      key != "properties" {
      json_decode_error(path, "Node::from_json: unknown field \{key}")
    }
  }
  guard obj.get("role") is Some(role_json) else {
    json_decode_error(path, "Node::from_json: missing field role")
  }
  guard obj.get("actions") is Some(actions_json) else {
    json_decode_error(path, "Node::from_json: missing field actions")
  }
  guard obj.get("childActions") is Some(child_actions_json) else {
    json_decode_error(path, "Node::from_json: missing field childActions")
  }
  guard obj.get("flags") is Some(flags_json) else {
    json_decode_error(path, "Node::from_json: missing field flags")
  }
  guard obj.get("properties") is Some(properties_json) else {
    json_decode_error(path, "Node::from_json: missing field properties")
  }
  let role : Role = @json.FromJson::from_json(role_json, path.add_key("role"))
  let actions : UInt = @json.FromJson::from_json(
    actions_json,
    path.add_key("actions"),
  )
  let child_actions : UInt = @json.FromJson::from_json(
    child_actions_json,
    path.add_key("childActions"),
  )
  let flags : UInt = @json.FromJson::from_json(
    flags_json,
    path.add_key("flags"),
  )
  guard properties_json is Object(props_obj) else {
    json_decode_error(
      path.add_key("properties"),
      "Node::from_json: expected object",
    )
  }
  let node = Node::Node(role)
  node.actions = actions
  node.child_actions = child_actions
  node.flags = flags
  let props_path = path.add_key("properties")
  for key, value in props_obj {
    node_apply_property(node, key, value, props_path)
  }
  node
}
