import 'dart:convert';
import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';

void main(List<String> args) {
  if (args.isNotEmpty && args.first == '--benchmark') {
    _runBenchmark(args.skip(1).toList());
    return;
  }
  runApp(MarkdownApp(initialPath: args.isEmpty ? null : args.first));
}

void _runBenchmark(List<String> args) {
  if (args.length < 2) exit(64);
  final source = File(args[0]).readAsStringSync();
  final scenario = args[1];
  final samples = <double>[];
  String render(String value) => _MarkdownAppState()._blocks(value).map((block) => block.text).join('\n');
  if (scenario == 'open') {
    final watch = Stopwatch()..start();
    render(source);
    samples.add(watch.elapsedMicroseconds / 1000);
  } else {
    final count = scenario == 'scroll' ? 120 : 10;
    for (var i = 0; i < count; i++) {
      final watch = Stopwatch()..start();
      render(scenario == 'input' ? '$source$i' : source);
      samples.add(watch.elapsedMicroseconds / 1000);
    }
  }
  samples.sort();
  final mean = samples.reduce((a, b) => a + b) / samples.length;
  double at(double ratio) => samples[((samples.length - 1) * ratio).round()];
  stdout.writeln(jsonEncode({
    'adapter': 'flutter',
    'measurement_scope': 'headless-render',
    'scenario': scenario,
    'samples_ms': samples,
    'mean_ms': mean,
    'p95_ms': at(.95),
    'p99_ms': at(.99),
    'dropped_frames': samples.where((value) => value > 16.667).length,
    'input_latency_ms': scenario == 'input' ? mean : null,
  }));
}

class MarkdownApp extends StatefulWidget {
  const MarkdownApp({super.key, this.initialPath});
  final String? initialPath;

  @override
  State<MarkdownApp> createState() => _MarkdownAppState();
}

class _MarkdownAppState extends State<MarkdownApp> {
  final _controller = TextEditingController();
  String? _path;
  bool _dirty = false;

  @override
  void initState() {
    super.initState();
    _path = widget.initialPath;
    _controller.text = '# Flutter Markdown Editor\n\n'
        'Edit **Markdown** on the left and watch the formatted preview update.\n\n'
        '- Open a .md file\n- Type normally\n- Scroll either pane\n\n'
        '> The saved value is always Markdown source.\n';
    if (_path != null) {
      final file = File(_path!);
      if (file.existsSync()) _controller.text = file.readAsStringSync();
    }
    _controller.addListener(() => setState(() => _dirty = true));
  }

  String get _title => _path == null ? 'Untitled.md' : _path!.split(Platform.pathSeparator).last;

  List<_MarkdownBlock> _blocks(String source) {
    final result = <_MarkdownBlock>[];
    final paragraph = <String>[];
    final code = <String>[];
    var inCode = false;
    void flushParagraph() {
      if (paragraph.isNotEmpty) {
        result.add(_MarkdownBlock(_BlockKind.paragraph, paragraph.join(' ')));
        paragraph.clear();
      }
    }

    for (final raw in source.split('\n')) {
      final line = raw.trimRight();
      if (line.trimLeft().startsWith('```')) {
        if (inCode) {
          result.add(_MarkdownBlock(_BlockKind.code, code.join('\n')));
          code.clear();
          inCode = false;
        } else {
          flushParagraph();
          inCode = true;
        }
        continue;
      }
      if (inCode) {
        code.add(line);
        continue;
      }
      final value = line.trim();
      if (value.isEmpty) {
        flushParagraph();
      } else if (value.startsWith('> ')) {
        flushParagraph();
        result.add(_MarkdownBlock(_BlockKind.quote, value.substring(2)));
      } else if (RegExp(r'^[-*] ').hasMatch(value)) {
        flushParagraph();
        result.add(_MarkdownBlock(_BlockKind.list, value.substring(2)));
      } else {
        final heading = RegExp(r'^(#{1,6})\s+(.*)$').firstMatch(value);
        if (heading != null) {
          flushParagraph();
          result.add(_MarkdownBlock(
            _BlockKind.heading,
            heading.group(2)!,
            level: heading.group(1)!.length,
          ));
        } else {
          paragraph.add(value);
        }
      }
    }
    if (inCode) result.add(_MarkdownBlock(_BlockKind.code, code.join('\n')));
    flushParagraph();
    return result;
  }

  List<TextSpan> _inlineSpans(String value, TextStyle base) {
    final spans = <TextSpan>[];
    final pattern = RegExp(r'(\*\*|__)(.+?)\1|(\*)(.+?)\3|(`)(.+?)\5');
    var cursor = 0;
    for (final match in pattern.allMatches(value)) {
      if (match.start > cursor) spans.add(TextSpan(text: value.substring(cursor, match.start), style: base));
      if (match.group(2) != null) {
        spans.add(TextSpan(text: match.group(2), style: base.copyWith(fontWeight: FontWeight.w700)));
      } else if (match.group(4) != null) {
        spans.add(TextSpan(text: match.group(4), style: base.copyWith(fontStyle: FontStyle.italic)));
      } else {
        spans.add(TextSpan(text: match.group(6), style: base.copyWith(fontFamily: 'monospace', backgroundColor: Colors.black12)));
      }
      cursor = match.end;
    }
    if (cursor < value.length) spans.add(TextSpan(text: value.substring(cursor), style: base));
    return spans;
  }

  Widget _preview(BuildContext context) {
    final base = Theme.of(context).textTheme.bodyLarge ?? const TextStyle(fontSize: 16);
    final blocks = _blocks(_controller.text);
    return ListView.separated(
      padding: const EdgeInsets.all(18),
      itemCount: blocks.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final block = blocks[index];
        switch (block.kind) {
          case _BlockKind.heading:
            final size = block.level == 1 ? 28.0 : block.level == 2 ? 23.0 : 19.0;
            final headingStyle = base.copyWith(fontSize: size, fontWeight: FontWeight.w700);
            return Text.rich(TextSpan(children: _inlineSpans(block.text, headingStyle)));
          case _BlockKind.list:
            return Text.rich(TextSpan(children: [
              TextSpan(text: '• ', style: base.copyWith(fontWeight: FontWeight.w700)),
              ..._inlineSpans(block.text, base),
            ]));
          case _BlockKind.quote:
            return Container(
              padding: const EdgeInsets.only(left: 10),
              decoration: const BoxDecoration(border: Border(left: BorderSide(color: Colors.blueGrey, width: 3))),
              child: Text.rich(
                TextSpan(children: _inlineSpans(block.text, base.copyWith(color: Colors.blueGrey.shade700))),
              ),
            );
          case _BlockKind.code:
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              color: Colors.black12,
              child: Text(block.text, style: base.copyWith(fontFamily: 'monospace')),
            );
          case _BlockKind.paragraph:
            return Text.rich(TextSpan(children: _inlineSpans(block.text, base)));
        }
      },
    );
  }

  Future<void> _open() async {
    const group = XTypeGroup(label: 'Markdown', extensions: <String>['md', 'markdown']);
    final file = await openFile(acceptedTypeGroups: <XTypeGroup>[group]);
    if (file == null) return;
    _path = file.path;
    _controller.text = await File(file.path).readAsString();
    setState(() => _dirty = false);
  }

  void _newDocument() {
    _path = null;
    _controller.text = '# Untitled\n\n';
    setState(() => _dirty = false);
  }

  Future<void> _save() async {
    var path = _path;
    if (path == null) {
      final location = await getSaveLocation(suggestedName: 'untitled.md');
      path = location?.path;
    }
    if (path == null) return;
    await File(path).writeAsString(_controller.text);
    setState(() {
      _path = path;
      _dirty = false;
    });
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Flutter Markdown Editor'),
            actions: <Widget>[
              Text(_title),
              const SizedBox(width: 12),
              TextButton(onPressed: _newDocument, child: const Text('New')),
              TextButton(onPressed: _open, child: const Text('Open')),
              TextButton(onPressed: _save, child: const Text('Save')),
              const SizedBox(width: 12),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(children: <Widget>[
              Expanded(child: TextField(
                controller: _controller,
                expands: true,
                maxLines: null,
                minLines: null,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Write Markdown...'),
              )),
              const SizedBox(width: 16),
              Expanded(child: Container(
                decoration: BoxDecoration(border: Border.all(color: Colors.black26), borderRadius: BorderRadius.circular(4)),
                child: _preview(context),
              )),
            ]),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text('${_dirty ? 'Unsaved changes' : 'Saved'}  |  ${_controller.text.length} bytes  |  Flutter Skia/Impeller'),
          ),
        ),
      );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

enum _BlockKind { heading, paragraph, list, quote, code }

class _MarkdownBlock {
  const _MarkdownBlock(this.kind, this.text, {this.level = 0});
  final _BlockKind kind;
  final String text;
  final int level;
}
