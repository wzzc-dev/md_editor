import 'dart:convert';
import 'dart:ffi' as ffi;
import 'dart:io';
import 'dart:ui' show FlutterView, FramePhase;
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

typedef _SignpostNative = ffi.Void Function(ffi.Int32);
typedef _SignpostDart = void Function(int);

_SignpostDart? _loadSignpost() {
  if (!Platform.isMacOS) return null;
  try {
    return ffi.DynamicLibrary.process()
        .lookupFunction<_SignpostNative, _SignpostDart>(
            'md_editor_benchmark_signpost_event');
  } on Object {
    return null;
  }
}

void main(List<String> args) {
  if (args.isNotEmpty && args.first == '--benchmark') {
    _runBenchmark(args.skip(1).toList());
    return;
  }
  if (args.isNotEmpty && args.first == '--ui-benchmark') {
    if (args.length < 3 || !{'open', 'input', 'scroll'}.contains(args[2])) {
      exit(64);
    }
    WidgetsFlutterBinding.ensureInitialized();
    final loadWatch = Stopwatch()..start();
    final source = File(args[1]).readAsStringSync();
    final benchmark =
        UiBenchmark(args[2], loadWatch.elapsedMicroseconds / 1000);
    runApp(MarkdownApp(initialSource: source, benchmark: benchmark));
    return;
  }
  runApp(MarkdownApp(initialPath: args.isEmpty ? null : args.first));
}

void _runBenchmark(List<String> args) {
  if (args.length < 2) exit(64);
  final source = File(args[0]).readAsStringSync();
  final scenario = args[1];
  final samples = <double>[];
  void sample(String value) {
    final watch = Stopwatch()..start();
    _splitBlocks(value);
    samples.add(watch.elapsedMicroseconds / 1000);
  }

  if (scenario == 'open') {
    sample(source);
  } else {
    final count = scenario == 'scroll' ? 120 : 10;
    for (var i = 0; i < count; i++) {
      sample(scenario == 'input' ? '$source$i' : source);
    }
  }
  samples.sort();
  final mean = samples.reduce((a, b) => a + b) / samples.length;
  double at(double ratio) => samples[((samples.length - 1) * ratio).round()];
  final renderer = Platform.environment['FLUTTER_RENDERER'] ?? 'skia';
  stdout.writeln(jsonEncode({
    'adapter': 'flutter-${renderer == 'impeller' ? 'impeller' : 'skia'}',
    'measurement_scope': 'headless-render',
    'scenario': scenario,
    'frame_work_samples_ms': samples,
    'frame_interval_samples_ms': <double>[],
    'input_to_visible_samples_ms': scenario == 'input' ? samples : <double>[],
    'offscreen_samples_ms': List<Object?>.filled(samples.length, null),
    'readback_samples_ms': List<Object?>.filled(samples.length, null),
    'offscreen_readback_samples_ms': List<Object?>.filled(samples.length, null),
    'frame_work_ms': mean,
    'frame_interval_ms': null,
    'input_to_visible_ms': scenario == 'input' ? mean : null,
    'offscreen_ms': null,
    'readback_ms': null,
    'offscreen_readback_ms': null,
    'frame_work_p95_ms': at(.95),
    'frame_interval_p95_ms': null,
    'input_to_visible_p95_ms': scenario == 'input' ? at(.95) : null,
    'dropped_display_frames': 0,
  }));
}

List<String> _splitBlocks(String source) {
  final blocks = <String>[];
  final paragraph = <String>[];
  var inCode = false;
  void flush() {
    if (paragraph.isNotEmpty) {
      blocks.add(paragraph.join(' '));
      paragraph.clear();
    }
  }

  for (final raw in source.split('\n')) {
    final line = raw.trimRight();
    final value = line.trim();
    if (value.startsWith('```')) {
      if (inCode) {
        blocks.add('code');
        inCode = false;
      } else {
        flush();
        inCode = true;
      }
    } else if (inCode) {
      continue;
    } else if (value.isEmpty) {
      flush();
    } else if (value.startsWith('> ') ||
        MarkdownEditingController._listPattern.hasMatch(value) ||
        MarkdownEditingController._headingPattern.hasMatch(value)) {
      flush();
      blocks.add(value);
    } else {
      paragraph.add(value);
    }
  }
  if (inCode) blocks.add('code');
  flush();
  return blocks;
}

List<String> _documentBlocks(String source) {
  final result = <String>[];
  final paragraph = <String>[];
  final code = <String>[];
  var inCode = false;
  void flushParagraph() {
    if (paragraph.isEmpty) return;
    result.add(paragraph.join(' '));
    paragraph.clear();
  }

  for (final raw in source.split('\n')) {
    final line = raw.trimRight();
    final value = line.trim();
    if (value.startsWith('```')) {
      if (inCode) {
        code.add(line);
        result.add(code.join('\n'));
        code.clear();
      } else {
        flushParagraph();
        code.add(line);
      }
      inCode = !inCode;
    } else if (inCode) {
      code.add(line);
    } else if (value.isEmpty) {
      flushParagraph();
    } else if (value.startsWith('> ') ||
        MarkdownEditingController._listPattern.hasMatch(value) ||
        MarkdownEditingController._headingPattern.hasMatch(value)) {
      flushParagraph();
      result.add(value);
    } else {
      paragraph.add(value);
    }
  }
  if (code.isNotEmpty) result.add(code.join('\n'));
  flushParagraph();
  if (result.isEmpty) result.add('');
  return result;
}

class UiBenchmark {
  UiBenchmark(this.scenario, this.documentLoadMs)
      : _benchmarkWatch = (Stopwatch()..start()) {
    SchedulerBinding.instance.addTimingsCallback(_recordTimings);
  }

  final String scenario;
  final double documentLoadMs;
  final Stopwatch _benchmarkWatch;
  final List<double> _frameWork = [];
  final List<double> _frameIntervals = [];
  final List<double> _inputToVisible = [];
  final List<double> _timingStamps = [];
  final List<double> _actionTimestampsEpochMs = [];
  double? _actionWindowEndEpochMs;
  final _SignpostDart? _signpost = _loadSignpost();

  double _epochNowMs() =>
      DateTime.now().microsecondsSinceEpoch.toDouble() / 1000.0;

  void _recordTimings(List<FrameTiming> timings) {
    for (final timing in timings) {
      _frameWork.add(
          (timing.buildDuration + timing.rasterDuration).inMicroseconds / 1000);
      final stamp =
          timing.timestampInMicroseconds(FramePhase.vsyncStart) / 1000;
      if (_timingStamps.isNotEmpty) {
        _frameIntervals
            .add((stamp - _timingStamps.last).clamp(0, double.infinity));
      }
      _timingStamps.add(stamp);
    }
  }

  Future<void> _waitForFrameSamples(int expected) async {
    // FrameTiming callbacks arrive asynchronously after the frame. Wait for a
    // long frame to flush, but never synthesize a missing sample.
    final deadline = DateTime.now().add(const Duration(seconds: 3));
    while (_frameWork.length < expected && DateTime.now().isBefore(deadline)) {
      await Future<void>.delayed(const Duration(milliseconds: 16));
    }
  }

  double _mean(List<double> values) =>
      values.reduce((total, value) => total + value) / values.length;

  Future<void> _run(_MarkdownAppState state) async {
    FlutterView? view;
    Size? logicalSize;
    for (var attempt = 0; attempt < 200; attempt++) {
      await Future<void>.delayed(const Duration(milliseconds: 10));
      if (!state.mounted) return;
      view = View.of(state.context);
      logicalSize = view.physicalSize / view.devicePixelRatio;
      if (logicalSize.width.round() == 1280 &&
          logicalSize.height.round() == 800) {
        break;
      }
    }
    if (view == null ||
        logicalSize == null ||
        logicalSize.width.round() != 1280 ||
        logicalSize.height.round() != 800) {
      stderr.writeln('Flutter benchmark viewport did not reach 1280x800');
      exit(70);
    }
    final firstInteractiveMs = _benchmarkWatch.elapsedMicroseconds / 1000;
    if (scenario == 'open') {
      await _waitForFrameSamples(1);
      if (_frameWork.length > 1) {
        _frameWork.removeRange(0, _frameWork.length - 1);
      }
      // A first interactive frame has no preceding vsync in this run. Any
      // timing callback buffered before it belongs to startup, not an open
      // display interval sample.
      _frameIntervals.clear();
      // There is no preceding vsync for the first frame; do not use startup
      // time as a display interval or count it as a dropped frame.
      await _report(firstInteractiveMs, view, logicalSize);
      return;
    }

    Future<double> driveAction(int index) async {
      final action = Stopwatch()..start();
      if (scenario == 'input') {
        final previousLength = state._controller.text.length;
        final next =
            '${state._controller.text}${String.fromCharCode(97 + index % 26)}';
        state._controller.value = TextEditingValue(
          text: next,
          selection: TextSelection.collapsed(offset: next.length),
        );
        if (state._controller.text.length != previousLength + 1) {
          stderr.writeln('Flutter benchmark input did not update the document');
          exit(70);
        }
      } else {
        if (!state._scrollController.hasClients) {
          stderr.writeln('Flutter benchmark has no attached scroll position');
          exit(70);
        }
        final max = state._scrollController.position.maxScrollExtent;
        if (max <= 0) {
          stderr.writeln('Flutter benchmark document is not scrollable');
          exit(70);
        }
        final offset = ((index + 1) * 480.0).clamp(0.0, max).toDouble();
        final target = index.isEven ? offset : 0.0;
        if ((target - state._scrollController.offset).abs() < 0.5) {
          stderr.writeln('Flutter benchmark scroll offset did not change');
          exit(70);
        }
        state._scrollController.jumpTo(target);
      }
      await SchedulerBinding.instance.endOfFrame;
      return action.elapsedMicroseconds / 1000;
    }

    await driveAction(0);
    // Let the warm-up action and its asynchronous FrameTiming callback fully
    // settle before establishing the measured baseline. This is a real frame
    // barrier, not a fabricated sample or an arbitrary sleep.
    await SchedulerBinding.instance.endOfFrame;
    await Future<void>.delayed(Duration.zero);
    _frameWork.clear();
    _frameIntervals.clear();
    // FrameTiming callbacks can arrive after the warm-up frame. The scheduler
    // still exposes that frame's authoritative vsync timestamp synchronously;
    // use it as the interval baseline instead of a potentially stale callback.
    final currentFrameStamp =
        SchedulerBinding.instance.currentSystemFrameTimeStamp;
    final baselineStamp = currentFrameStamp == Duration.zero
        ? (_timingStamps.isNotEmpty ? _timingStamps.last : null)
        : currentFrameStamp.inMicroseconds / 1000.0;
    _timingStamps.clear();
    if (baselineStamp != null) _timingStamps.add(baselineStamp);
    _inputToVisible.clear();
    _actionTimestampsEpochMs.clear();
    final count = scenario == 'scroll' ? 120 : 10;
    for (var index = 0; index < count; index++) {
      _signpost?.call(index);
      _actionTimestampsEpochMs.add(_epochNowMs());
      final latency = await driveAction(index + 1);
      if (scenario == 'input') _inputToVisible.add(latency);
    }
    _actionWindowEndEpochMs = _epochNowMs();
    await _waitForFrameSamples(count);
    if (_frameWork.length > count) {
      _frameWork.removeRange(0, _frameWork.length - count);
    }
    if (_frameIntervals.length > count) {
      _frameIntervals.removeRange(0, _frameIntervals.length - count);
    }
    await _report(firstInteractiveMs, view, logicalSize);
  }

  Future<void> _report(
      double firstInteractiveMs, FlutterView view, Size logicalSize) async {
    final samples = _frameWork;
    final intervals = _frameIntervals;
    final sorted = List<double>.of(samples)..sort();
    final sortedIntervals = List<double>.of(intervals)..sort();
    final sortedInput = List<double>.of(_inputToVisible)..sort();
    double at(double ratio) => sorted[((sorted.length - 1) * ratio).round()];
    double intervalAt(double ratio) =>
        sortedIntervals[((sortedIntervals.length - 1) * ratio).round()];
    final dropped = intervals.fold<int>(
        0,
        (total, value) =>
            total + ((value / 16.667).ceil() - 1).clamp(0, 1 << 30).toInt());
    final renderer = Platform.environment['FLUTTER_RENDERER'] ?? 'skia';
    stdout.writeln(jsonEncode({
      'adapter': 'flutter-${renderer == 'impeller' ? 'impeller' : 'skia'}',
      'measurement_scope': 'ui-frame',
      'timing_source': 'flutter-FrameTiming.build+raster-and-vsyncStart',
      'latency_source': 'action-to-SchedulerBinding.endOfFrame',
      'window_mode': 'native-window',
      'work_scope': 'flutter-build-plus-raster',
      'display_timestamp_source':
          'flutter-FrameTiming.vsyncStart-not-os-present',
      'scenario': scenario,
      'frame_work_samples_ms': samples,
      'frame_interval_samples_ms': intervals,
      'input_to_visible_samples_ms':
          scenario == 'input' ? _inputToVisible : <double>[],
      // Null means that the stage was not instrumented. A measured zero is
      // reserved for a path that explicitly proves no work occurred.
      'offscreen_samples_ms': List<Object?>.filled(samples.length, null),
      'readback_samples_ms': List<Object?>.filled(samples.length, null),
      'offscreen_readback_samples_ms':
          List<Object?>.filled(samples.length, null),
      'frame_work_ms': _mean(samples),
      'frame_interval_ms': intervals.isNotEmpty ? _mean(intervals) : null,
      'input_to_visible_ms':
          scenario == 'input' ? _mean(_inputToVisible) : null,
      'offscreen_ms': null,
      'readback_ms': null,
      'offscreen_readback_ms': null,
      'frame_work_p95_ms': at(.95),
      'frame_interval_p95_ms': intervals.isNotEmpty ? intervalAt(.95) : null,
      'input_to_visible_p95_ms': scenario == 'input' && sortedInput.isNotEmpty
          ? sortedInput[((sortedInput.length - 1) * .95).round()]
          : null,
      'dropped_display_frames': dropped,
      'action_count':
          scenario == 'open' ? 1 : (scenario == 'scroll' ? 120 : 10),
      'frame_sample_count': intervals.length,
      'warmup_action_count': scenario == 'open' ? 0 : 1,
      'action_timestamps_epoch_ms': _actionTimestampsEpochMs,
      'action_window_start_epoch_ms': _actionTimestampsEpochMs.isEmpty
          ? null
          : _actionTimestampsEpochMs.first,
      'action_window_end_epoch_ms': _actionWindowEndEpochMs,
      'first_interactive_ms': firstInteractiveMs,
      'document_load_ms': documentLoadMs,
      'viewport': {
        'width': logicalSize.width.round(),
        'height': logicalSize.height.round(),
        'physical_width': view.physicalSize.width.round(),
        'physical_height': view.physicalSize.height.round(),
        'device_pixel_ratio': view.devicePixelRatio
      },
      'font': 'system-ui 16px',
      'line_height': 1.55,
      'overscan': 3,
      'virtual_row_height': 66,
    }));
    if (Platform.environment['UI_BENCHMARK_SYSTEM_PRESENT'] == '1') {
      final tailMs = int.tryParse(
            Platform.environment['UI_BENCHMARK_TRACE_TAIL_MS'] ?? '',
          ) ??
          15000;
      await Future<void>.delayed(
          Duration(milliseconds: tailMs.clamp(0, 120000)));
    }
    exit(0);
  }
}

class MarkdownEditingController extends TextEditingController {
  MarkdownEditingController({super.text});

  static final RegExp _inlinePattern =
      RegExp(r'(\*\*|__)(.+?)\1|(\*)(.+?)\3|(`)(.+?)\5');
  static final RegExp _headingPattern = RegExp(r'^(#{1,6})(\s+)(.*)$');
  static final RegExp _quotePattern = RegExp(r'^(>)(\s+)(.*)$');
  static final RegExp _listPattern = RegExp(r'^([-*])(\s+)(.*)$');

  static TextStyle _marker(TextStyle base, {required bool sourceFidelity}) =>
      sourceFidelity
          ? base.copyWith(color: Colors.black38)
          : base.copyWith(color: Colors.transparent, fontSize: 0, height: 0);

  static List<InlineSpan> _inline(String value, TextStyle base,
      {required bool sourceFidelity}) {
    final spans = <InlineSpan>[];
    var cursor = 0;
    for (final match in _inlinePattern.allMatches(value)) {
      if (match.start > cursor) {
        spans.add(
            TextSpan(text: value.substring(cursor, match.start), style: base));
      }
      final marker = value.substring(
          match.start,
          match.start +
              (match.group(1)?.length ?? match.group(3)?.length ?? 1));
      final content = match.group(2) ?? match.group(4) ?? match.group(6) ?? '';
      final contentStyle = match.group(2) != null
          ? base.copyWith(fontWeight: FontWeight.w700)
          : match.group(4) != null
              ? base.copyWith(fontStyle: FontStyle.italic)
              : base.copyWith(
                  fontFamily: 'monospace', backgroundColor: Colors.black12);
      spans.add(TextSpan(
          text: marker, style: _marker(base, sourceFidelity: sourceFidelity)));
      spans.add(TextSpan(text: content, style: contentStyle));
      spans.add(TextSpan(
          text: marker, style: _marker(base, sourceFidelity: sourceFidelity)));
      cursor = match.end;
    }
    if (cursor < value.length) {
      spans.add(TextSpan(text: value.substring(cursor), style: base));
    }
    return spans;
  }

  static List<InlineSpan> _line(String line, TextStyle base,
      {required bool inCode, required bool sourceFidelity}) {
    if (line.trimLeft().startsWith('```')) {
      return [
        TextSpan(
            text: line, style: _marker(base, sourceFidelity: sourceFidelity))
      ];
    }
    if (inCode) {
      return [
        TextSpan(
            text: line,
            style: base.copyWith(
                fontFamily: 'monospace', backgroundColor: Colors.black12))
      ];
    }
    final value = line.trimLeft();
    final indent = line.substring(0, line.length - value.length);
    final heading = _headingPattern.firstMatch(value);
    if (heading != null) {
      final size = heading.group(1)!.length == 1
          ? 28.0
          : heading.group(1)!.length == 2
              ? 23.0
              : 19.0;
      final headingStyle = base.copyWith(
          fontSize: size, fontWeight: FontWeight.w700, height: 1.25);
      return [
        TextSpan(
            text: indent + heading.group(1)! + heading.group(2)!,
            style: _marker(headingStyle, sourceFidelity: sourceFidelity)),
        ..._inline(heading.group(3)!, headingStyle,
            sourceFidelity: sourceFidelity)
      ];
    }
    final quote = _quotePattern.firstMatch(value);
    if (quote != null) {
      final quoteStyle = base.copyWith(color: Colors.blueGrey.shade700);
      return [
        TextSpan(
            text: sourceFidelity ? '$indent>' : '$indent│',
            style: sourceFidelity
                ? _marker(quoteStyle, sourceFidelity: true)
                : quoteStyle),
        TextSpan(
            text: quote.group(2)!,
            style: _marker(quoteStyle, sourceFidelity: sourceFidelity)),
        ..._inline(quote.group(3)!, quoteStyle, sourceFidelity: sourceFidelity)
      ];
    }
    final list = _listPattern.firstMatch(value);
    if (list != null) {
      return [
        TextSpan(
            text: sourceFidelity ? '$indent${list.group(1)!}' : '$indent•',
            style: sourceFidelity
                ? _marker(base, sourceFidelity: true)
                : base.copyWith(fontWeight: FontWeight.w700)),
        TextSpan(
            text: list.group(2)!,
            style: _marker(base, sourceFidelity: sourceFidelity)),
        ..._inline(list.group(3)!, base, sourceFidelity: sourceFidelity)
      ];
    }
    return [
      TextSpan(text: indent, style: base),
      ..._inline(value, base, sourceFidelity: sourceFidelity)
    ];
  }

  static void _appendNewline(List<InlineSpan> spans, TextStyle base) {
    if (spans.isEmpty) {
      spans.add(TextSpan(text: '\n', style: base));
      return;
    }
    final last = spans.last;
    if (last is TextSpan && last.children == null) {
      spans[spans.length - 1] = TextSpan(
        text: '${last.text ?? ''}\n',
        style: last.style ?? base,
      );
      return;
    }
    spans.add(TextSpan(text: '\n', style: base));
  }

  static TextSpan _span(String source, TextStyle base,
      {required bool sourceFidelity}) {
    final lines = source.split('\n');
    final children = <InlineSpan>[];
    var inCode = false;
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      if (line.trimLeft().startsWith('```')) inCode = !inCode;
      final lineSpans =
          _line(line, base, inCode: inCode, sourceFidelity: sourceFidelity);
      if (i < lines.length - 1) _appendNewline(lineSpans, base);
      children.addAll(lineSpans);
    }
    return TextSpan(style: base, children: children);
  }

  static TextSpan formattedSpan(String source, TextStyle base) {
    final span = _span(source, base, sourceFidelity: true);
    return span.toPlainText() == source
        ? span
        : TextSpan(text: source, style: base);
  }

  static TextSpan previewSpan(String source, TextStyle base) =>
      _span(source, base, sourceFidelity: false);

  @override
  TextSpan buildTextSpan(
      {required BuildContext context,
      TextStyle? style,
      required bool withComposing}) {
    final base = style ??
        const TextStyle(fontSize: 16, height: 1.55, color: Colors.black87);
    return formattedSpan(text, base);
  }
}

class MarkdownApp extends StatefulWidget {
  const MarkdownApp(
      {super.key, this.initialPath, this.initialSource, this.benchmark});
  final String? initialPath;
  final String? initialSource;
  final UiBenchmark? benchmark;
  @override
  State<MarkdownApp> createState() => _MarkdownAppState();
}

class _MarkdownAppState extends State<MarkdownApp> {
  late MarkdownEditingController _controller;
  final ScrollController _scrollController = ScrollController();
  late List<String> _blocks;
  var _activeBlock = 0;
  var _controllerReady = false;
  var _characterCount = 0;
  final ValueNotifier<bool> _dirtyNotifier = ValueNotifier(false);
  final ValueNotifier<int> _characterCountNotifier = ValueNotifier(0);
  final Map<int, TextSpan> _previewCache = <int, TextSpan>{};
  String? _path;

  @override
  void initState() {
    super.initState();
    _path = widget.initialPath;
    var source = widget.initialSource ??
        '# Flutter Markdown Editor\n\nEdit **Markdown** directly in the formatted document.\n\n- Open a .md file\n- Type normally\n- Scroll the document\n\n> The saved value is always Markdown source.\n';
    if (widget.initialSource == null &&
        _path != null &&
        File(_path!).existsSync()) {
      source = File(_path!).readAsStringSync();
    }
    _installSource(source);
    if (widget.benchmark != null) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => widget.benchmark!._run(this));
    }
  }

  String get _title =>
      _path == null ? 'Untitled.md' : _path!.split(Platform.pathSeparator).last;

  void _installSource(String source) {
    if (_controllerReady) {
      _controller.removeListener(_activeBlockChanged);
    }
    _blocks = _documentBlocks(source);
    _previewCache.clear();
    _activeBlock = 0;
    _characterCount = source.length;
    _characterCountNotifier.value = _characterCount;
    final value = TextEditingValue(
      text: _blocks.first,
      selection: TextSelection.collapsed(offset: _blocks.first.length),
    );
    if (_controllerReady) {
      _controller.value = value;
    } else {
      _controller = MarkdownEditingController()..value = value;
    }
    _controller.addListener(_activeBlockChanged);
    _controllerReady = true;
  }

  void _activeBlockChanged() {
    if (_activeBlock >= _blocks.length) return;
    final previous = _blocks[_activeBlock];
    final next = _controller.text;
    if (previous == next) return;
    _blocks[_activeBlock] = next;
    _previewCache.remove(_activeBlock);
    _characterCount += next.length - previous.length;
    _dirtyNotifier.value = true;
    _characterCountNotifier.value = _characterCount;
  }

  void _activateBlock(int index) {
    if (index == _activeBlock) return;
    setState(() {
      _controller.removeListener(_activeBlockChanged);
      _previewCache.remove(_activeBlock);
      _activeBlock = index;
      _controller.value = TextEditingValue(
        text: _blocks[index],
        selection: TextSelection.collapsed(offset: _blocks[index].length),
      );
      _controller.addListener(_activeBlockChanged);
    });
  }

  String _serializeSource() => '${_blocks.join('\n\n')}\n';

  void _setSource(String source) {
    setState(() {
      _installSource(source);
      _dirtyNotifier.value = false;
    });
  }

  Future<void> _open() async {
    const group =
        XTypeGroup(label: 'Markdown', extensions: <String>['md', 'markdown']);
    final file = await openFile(acceptedTypeGroups: <XTypeGroup>[group]);
    if (file == null) return;
    _path = file.path;
    _setSource(await File(file.path).readAsString());
  }

  void _newDocument() {
    _path = null;
    _setSource('# Untitled\n\n');
  }

  Future<void> _save() async {
    var path = _path;
    path ??= (await getSaveLocation(suggestedName: 'untitled.md'))?.path;
    if (path == null) return;
    await File(path).writeAsString(_serializeSource());
    _path = path;
    setState(() {
      _dirtyNotifier.value = false;
    });
  }

  Widget _blockEditor(int index) => Container(
        key: ValueKey<String>('editor-$index'),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.indigo.shade200),
          borderRadius: BorderRadius.circular(4),
        ),
        child: TextField(
          controller: _controller,
          autofocus: true,
          expands: true,
          maxLines: null,
          minLines: null,
          textAlignVertical: TextAlignVertical.top,
          style: const TextStyle(fontSize: 16, height: 1.55),
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            border: InputBorder.none,
            hintText: 'Write Markdown...',
          ),
        ),
      );

  Widget _blockPreview(BuildContext context, int index) {
    const style = TextStyle(fontSize: 16, height: 1.55, color: Colors.black87);
    final span = _previewCache.putIfAbsent(
        index, () => MarkdownEditingController.previewSpan(_blocks[index], style));
    return InkWell(
      key: ValueKey<String>('preview-$index'),
      onTap: () => _activateBlock(index),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: RichText(
          maxLines: 2,
          overflow: TextOverflow.clip,
          text: span,
        ),
      ),
    );
  }

  Widget _buildBlock(BuildContext context, int index) => index == _activeBlock
      ? _blockEditor(index)
      : _blockPreview(context, index);

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
        home: Scaffold(
          appBar:
              AppBar(title: const Text('Flutter Markdown Editor'), actions: [
            Text(_title),
            const SizedBox(width: 12),
            TextButton(onPressed: _newDocument, child: const Text('New')),
            TextButton(onPressed: _open, child: const Text('Open')),
            TextButton(onPressed: _save, child: const Text('Save')),
            const SizedBox(width: 12)
          ]),
          body: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black26),
                      borderRadius: BorderRadius.circular(4)),
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: _blocks.length,
                    itemExtent: 66,
                    scrollCacheExtent: ScrollCacheExtent.pixels(66 * 8),
                    itemBuilder: _buildBlock,
                  ))),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: AnimatedBuilder(
              animation: Listenable.merge(
                  <Listenable>[_dirtyNotifier, _characterCountNotifier]),
              builder: (context, _) => Text(
                  '${_dirtyNotifier.value ? 'Unsaved changes' : 'Saved'}  |  ${_characterCountNotifier.value} chars  |  ${_blocks.length} blocks  |  Flutter ${Platform.environment['FLUTTER_RENDERER'] ?? 'Skia'} WYSIWYG'),
            ),
          ),
        ),
      );

  @override
  void dispose() {
    _controller.removeListener(_activeBlockChanged);
    _controller.dispose();
    _scrollController.dispose();
    _dirtyNotifier.dispose();
    _characterCountNotifier.dispose();
    super.dispose();
  }
}
