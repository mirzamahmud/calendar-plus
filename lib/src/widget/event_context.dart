import 'package:calendar_plus/calendar_plus.dart';
import 'package:flutter/material.dart';

class EventContext extends StatelessWidget {
  /// A custom title widget displayed above the event list.
  ///
  /// If `null`, a default title will be shown:
  ///  - For [CalendarSelectionMode.SINGLE], it shows "Events on <day-month-year>".
  ///  - For [CalendarSelectionMode.MULTIPLE], it shows "Events for selected dates".
  final Widget? title;

  /// The widget that renders the list of events.
  ///
  /// Typically, this will be a `ListView` or `ListView.separated`
  /// containing the event items. It is required.
  final Widget eventListView;

  /// Defines the selection mode of the calendar.
  ///
  /// - [CalendarSelectionMode.SINGLE]: events shown for a single tapped date.
  /// - [CalendarSelectionMode.MULTIPLE]: events shown for all selected dates.
  final CalendarSelectionMode selectionMode;

  /// The currently tapped day.
  ///
  /// Used only when [selectionMode] is [CalendarSelectionMode.SINGLE]
  /// to display the default title text. In multiple selection mode,
  /// this value is still passed but typically ignored in the UI.
  final DateTime day;

  /// A default container widget for displaying calendar events in the bottom sheet.
  ///
  /// This widget is shown when a day (or multiple days) is tapped in the calendar.
  /// It includes an optional [title] section, and the event list view provided by the user
  /// or built internally by `CalendarPlus`.
  const EventContext({
    super.key,
    this.title,
    required this.eventListView,
    required this.selectionMode,
    required this.day,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title ??
              Text(
                selectionMode == CalendarSelectionMode.SINGLE
                    ? 'Events on ${day.day}-${day.month}-${day.year}'
                    : 'Events for selected dates',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),

          Expanded(child: eventListView),
        ],
      ),
    );
  }
}
