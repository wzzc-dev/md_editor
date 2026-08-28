import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cross_framework_markdown_flutter/main.dart';

void main() {
  test('editable Markdown spans preserve the exact source text', () {
    const source =
        '# Heading\n\n> quote\n- item with **bold** and `code`\n```dart\nvoid main() {}\n```';
    const style = TextStyle(fontSize: 16, height: 1.55);

    expect(
      MarkdownEditingController.formattedSpan(source, style).toPlainText(),
      source,
    );
  });

  testWidgets('renders the formatted Markdown editor',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MarkdownApp());

    expect(find.text('Flutter Markdown Editor'), findsOneWidget);
    expect(find.textContaining('Saved'), findsOneWidget);
  });

  testWidgets('editing the active block marks the document dirty',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MarkdownApp(initialSource: '# First\n\nSecond'),
    );

    await tester.enterText(find.byType(TextField), '# Changed');
    await tester.pump();

    expect(find.textContaining('Unsaved changes'), findsOneWidget);
    expect(find.textContaining('2 blocks'), findsOneWidget);
  });

  testWidgets('switching blocks reuses the editor controller',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MarkdownApp(initialSource: '# First\n\nSecond'),
    );

    final first = tester.widget<TextField>(find.byType(TextField)).controller;
    await tester.tap(find.byKey(const ValueKey<String>('preview-1')));
    await tester.pump();
    final second = tester.widget<TextField>(find.byType(TextField)).controller;

    expect(identical(first, second), isTrue);
    await tester.enterText(find.byType(TextField), 'Changed second');
    await tester.tap(find.byKey(const ValueKey<String>('preview-0')));
    await tester.pump();
    expect(find.textContaining('Unsaved changes'), findsOneWidget);
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      '# First',
    );
  });

  testWidgets('long documents build later blocks while scrolling',
      (WidgetTester tester) async {
    final source =
        List<String>.generate(40, (index) => '# Row $index').join('\n\n');
    await tester.pumpWidget(MarkdownApp(initialSource: source));

    expect(find.byKey(const ValueKey<String>('editor-0')), findsOneWidget);
    final target = find.byKey(const ValueKey<String>('preview-14'));
    final scrollable = find.descendant(
      of: find.byType(ListView),
      matching: find.byType(Scrollable),
    );
    await tester.scrollUntilVisible(target, 400, scrollable: scrollable.first);

    expect(target, findsOneWidget);
  });
}
