import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:calendar_plus/calendar_plus.dart';

void main() {
  testWidgets('CalendarPlus shows bottom sheet with events when day tapped', (
    WidgetTester tester,
  ) async {
    final helper = CalendarHelper();

    // Add a fake event on today's date
    final today = DateTime.now();
    helper.addEvent(
      today,
      CalendarEventModel(title: 'Test Event', date: today, color: Colors.red),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CalendarPlus(isHeaderVisible: true, controller: helper),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Tap today's date cell
    await tester.tap(find.text('${today.day}'));
    await tester.pumpAndSettle();

    // Verify bottom sheet appears with event text
    expect(find.text('Test Event'), findsOneWidget);
  });
}
