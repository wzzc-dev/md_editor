import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cross_framework_markdown_flutter/main.dart';

void main() {
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
