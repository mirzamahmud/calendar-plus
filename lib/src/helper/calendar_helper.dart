import 'package:calendar_plus/src/enum/calendar_selection_mode.dart';
import 'package:flutter/material.dart';

class CalendarHelper extends ChangeNotifier {
  List<String> weekDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  DateTime focusedMonth = DateTime.now();
  DateTime? selectedDate;

  // Range selection for multi-select
  DateTime? rangeStart;
  DateTime? rangeEnd;

  final Set<DateTime> selectedDates = {};

  /// Get all days to display in the current month grid
  List<DateTime> daysInMonth(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    final firstWeekday = firstDay.weekday % 7;
    final totalDays = firstWeekday + lastDay.day;

    return List.generate(totalDays, (index) {
      return DateTime(month.year, month.month, index - firstWeekday + 1);
    });
  }

  void nextMonth() {
    focusedMonth = DateTime(focusedMonth.year, focusedMonth.month + 1);
    notifyListeners();
  }

  void prevMonth() {
    focusedMonth = DateTime(focusedMonth.year, focusedMonth.month - 1);
    notifyListeners();
  }

  void setMonth(DateTime month) {
    focusedMonth = month;
    notifyListeners();
  }

  bool isSelected(DateTime day, CalendarSelectionMode selectionMode) {
    if (selectionMode == CalendarSelectionMode.SINGLE) {
      return selectedDate != null &&
          day.year == selectedDate!.year &&
          day.month == selectedDate!.month &&
          day.day == selectedDate!.day;
    } else {
      return selectedDates.any(
        (d) => d.year == day.year && d.month == day.month && d.day == day.day,
      );
    }
  }

  Color getCellColor(DateTime day, CalendarSelectionMode selectionMode) {
    final isToday =
        day.year == DateTime.now().year &&
        day.month == DateTime.now().month &&
        day.day == DateTime.now().day;

    if (isSelected(day, selectionMode)) return Colors.blue;
    if (isToday) return Colors.blue.withValues(alpha: 0.2);
    return Colors.transparent;
  }

  /// Handle day taps for single or range selection
  void onDayTap(
    DateTime day,
    bool isCurrentMonth,
    CalendarSelectionMode selectionMode,
  ) {
    if (!isCurrentMonth) return;

    if (selectionMode == CalendarSelectionMode.SINGLE) {
      selectedDate = day;
      selectedDates.clear();
      rangeStart = null;
      rangeEnd = null;
    } else {
      // Range selection logic
      if (rangeStart == null || (rangeStart != null && rangeEnd != null)) {
        rangeStart = day;
        rangeEnd = null;
        selectedDates.clear();
        selectedDates.add(day);
      } else {
        rangeEnd = day;
        selectedDates.clear();
        final start = rangeStart!;
        final end = rangeEnd!;
        final from = start.isBefore(end) ? start : end;
        final to = start.isBefore(end) ? end : start;

        DateTime current = from;
        while (!current.isAfter(to)) {
          selectedDates.add(current);
          current = current.add(const Duration(days: 1));
        }
      }
    }

    notifyListeners();
  }
}
