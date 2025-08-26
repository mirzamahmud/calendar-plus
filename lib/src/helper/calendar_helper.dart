import 'package:calendar_plus/calendar_plus.dart';
import 'package:flutter/material.dart';

/// A helper/controller class for [CalendarPlus].
///
/// Manages calendar state such as the current focused month, selection modes,
/// and event storage. It also provides utility methods for generating days
/// in a month or week, handling user taps, and managing events.
class CalendarHelper extends ChangeNotifier {
  /// Abbreviated names of weekdays (starting from Sunday).
  ///
  /// You can override or localize this list if needed.
  List<String> weekDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  /// The currently focused month (used for rendering).
  DateTime focusedMonth = DateTime.now();

  /// The currently selected date when in [CalendarSelectionMode.SINGLE].
  DateTime? selectedDate;

  /// The starting date of a selection range (used for multiple/range mode).
  DateTime? rangeStart;

  /// The ending date of a selection range (used for multiple/range mode).
  DateTime? rangeEnd;

  /// A set of all selected dates in [CalendarSelectionMode.MULTIPLE].
  final Set<DateTime> selectedDates = {};

  /// Stores all events, grouped by day.
  ///
  /// Each [DateTime] key is normalized to `year, month, day` (time ignored).
  final Map<DateTime, List<CalendarEventModel>> calenderEvent = {};

  /* ===========================================================================
    Calendar Days
  =========================================================================== */

  /// Returns all [DateTime]s required to render the current month grid.
  ///
  /// Includes "leading" days from the previous month if the first day of the
  /// month does not start on Sunday (index 0).
  List<DateTime> daysInMonth(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    final firstWeekday = firstDay.weekday % 7;
    final totalDays = firstWeekday + lastDay.day;

    return List.generate(totalDays, (index) {
      return DateTime(month.year, month.month, index - firstWeekday + 1);
    });
  }

  /* ===========================================================================
    Navigation
  =========================================================================== */

  /// Moves the calendar forward by one month.
  void nextMonth() {
    focusedMonth = DateTime(focusedMonth.year, focusedMonth.month + 1);
    notifyListeners();
  }

  /// Moves the calendar backward by one month.
  void prevMonth() {
    focusedMonth = DateTime(focusedMonth.year, focusedMonth.month - 1);
    notifyListeners();
  }

  /// Updates the focused month to [month].
  void setMonth(DateTime month) {
    focusedMonth = month;
    notifyListeners();
  }

  /* ===========================================================================
    Selection
  =========================================================================== */

  /// Returns `true` if the given [day] is selected, depending on [selectionMode].
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

  /// Returns the background color for a given [day].
  ///
  /// - Blue if selected
  /// - Light blue if today
  /// - Transparent otherwise
  Color getCellColor(DateTime day, CalendarSelectionMode selectionMode) {
    final isToday =
        day.year == DateTime.now().year &&
        day.month == DateTime.now().month &&
        day.day == DateTime.now().day;

    if (isSelected(day, selectionMode)) return Colors.blue;
    if (isToday) return Colors.blue.withValues(alpha: 0.2);
    return Colors.transparent;
  }

  /// Handles day taps for [CalendarSelectionMode.SINGLE] or range/multiple mode.
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

  /* ===========================================================================
    Events
  =========================================================================== */

  /// Returns all events for the given [day].
  List<CalendarEventModel> getEventsForDay(DateTime day) {
    final dateKey = DateTime(day.year, day.month, day.day);
    return calenderEvent[dateKey] ?? [];
  }

  /// Adds a new [event] for the given [day].
  void addEvent(DateTime day, CalendarEventModel event) {
    final dateKey = DateTime(day.year, day.month, day.day);
    if (calenderEvent[dateKey] == null) {
      calenderEvent[dateKey] = [];
    }
    calenderEvent[dateKey]!.add(event);
    notifyListeners();
  }

  /// Removes an [event] from the given [day].
  ///
  /// If no events remain for that date, the entry is removed entirely.
  void removeEvent(DateTime day, CalendarEventModel event) {
    final dateKey = DateTime(day.year, day.month, day.day);
    calenderEvent[dateKey]?.remove(event);
    if (calenderEvent[dateKey]?.isEmpty ?? false) {
      calenderEvent.remove(dateKey);
    }
    notifyListeners();
  }

  /// Clears all events for the given [day].
  void clearEvents(DateTime day) {
    final dateKey = DateTime(day.year, day.month, day.day);
    calenderEvent.remove(dateKey);
    notifyListeners();
  }

  /// Returns `true` if [day] has at least one event.
  bool hasEvents(DateTime day) => getEventsForDay(day).isNotEmpty;
}
