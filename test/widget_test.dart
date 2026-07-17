import 'package:flutter_test/flutter_test.dart';
import 'package:simple_task_tracker/app.dart';

void main() {
  testWidgets('shows the task tracker shell', (WidgetTester tester) async {
    await tester.pumpWidget(const SimpleTaskTrackerApp());

    expect(find.text('Simple Task Tracker'), findsOneWidget);
  });
}
