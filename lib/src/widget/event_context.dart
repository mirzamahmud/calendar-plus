import 'package:calendar_plus/calendar_plus.dart';
import 'package:flutter/material.dart';

class EventContext extends StatelessWidget {
  final Widget? title;
  final Widget eventListView;
  final CalendarSelectionMode selectionMode;
  final DateTime day;

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
