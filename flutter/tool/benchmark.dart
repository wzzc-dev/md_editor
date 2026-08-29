import 'dart:convert';
import 'dart:io';

enum BlockKind { heading, paragraph, list, quote, code }

class Block {
  const Block(this.kind, this.text);
  final BlockKind kind;
  final String text;
}

String cleanInline(String value) => value
    .replaceAll('**', '')
    .replaceAll('__', '')
    .replaceAll('`', '')
    .replaceAll('*', '')
    .replaceAll('_', '');

List<Block> blocks(String source) {
  final result = <Block>[];
  final paragraph = <String>[];
  final code = <String>[];
  var inCode = false;
  void flushParagraph() {
    if (paragraph.isNotEmpty) {
      result.add(Block(BlockKind.paragraph, cleanInline(paragraph.join(' '))));
      paragraph.clear();
    }
  }

  for (final raw in source.split('\n')) {
    final line = raw.trimRight();
    final trimmed = line.trim();
    if (trimmed.startsWith('```')) {
      if (inCode) {
        result.add(Block(BlockKind.code, code.join('\n')));
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
    if (trimmed.isEmpty) {
      flushParagraph();
    } else if (trimmed.startsWith('> ')) {
      flushParagraph();
      result.add(Block(BlockKind.quote, cleanInline(trimmed.substring(2))));
    } else if (RegExp(r'^[-*] ').hasMatch(trimmed)) {
      flushParagraph();
      result.add(Block(BlockKind.list, cleanInline(trimmed.substring(2))));
    } else {
      final heading = RegExp(r'^(#{1,6})\s+(.*)$').firstMatch(trimmed);
      if (heading != null) {
        flushParagraph();
        result.add(Block(BlockKind.heading, cleanInline(heading.group(2)!)));
      } else {
        paragraph.add(trimmed);
      }
    }
  }
  if (inCode) result.add(Block(BlockKind.code, code.join('\n')));
  flushParagraph();
  return result;
}

void main(List<String> args) {
  if (args.length < 2) {
    stderr.writeln(
        'usage: dart run tool/benchmark.dart <fixture> <open|input|scroll>');
    exitCode = 64;
    return;
  }
  final source = File(args[0]).readAsStringSync();
  final scenario = args[1];
  final samples = <double>[];
  void sample(String value) {
    final watch = Stopwatch()..start();
    blocks(value);
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
    'first_interactive_ms': null,
    'document_load_ms': 0,
  }));
}
