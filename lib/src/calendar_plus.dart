import 'package:calendar_plus/calendar_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarPlus extends StatefulWidget {
  /// Controls whether the calendar header (month navigation) is shown.
  final bool isHeaderVisible;

  /// Custom builder for the header (if visible).
  /// Provides callbacks for prev/next month navigation and year/month picker.
  final Widget Function(
    BuildContext context,
    DateTime focusedMonth,
    VoidCallback onPrev,
    VoidCallback onNext,
    VoidCallback onHeaderTap,
  )?
  headerBuilder;

  /// Selection mode: single date or multiple dates
  final CalendarSelectionMode selectionMode;

  const CalendarPlus({
    super.key,
    this.isHeaderVisible = false,
    this.headerBuilder,
    this.selectionMode = CalendarSelectionMode.SINGLE,
  }) : assert(
         !(isHeaderVisible == false && headerBuilder != null),
         'You cannot provide a [headerBuilder] when [isHeaderVisible] is false',
       );

  @override
  State<CalendarPlus> createState() => _CalendarPlusState();
}

class _CalendarPlusState extends State<CalendarPlus> {
  late final CalendarHelper calendarHelper;

  @override
  void initState() {
    super.initState();
    calendarHelper = CalendarHelper();
  }

  /// Default header
  Widget _defaultHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: calendarHelper.prevMonth,
          icon: const Icon(Icons.arrow_back_ios_new_sharp),
        ),
        TextButton(
          onPressed:
              () => ShowYearAndMonthPicker.showYearMonthPicker(
                context,
                calendarHelper: calendarHelper,
              ),
          child: Text(
            DateFormat.yMMMM().format(calendarHelper.focusedMonth),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        IconButton(
          onPressed: calendarHelper.nextMonth,
          icon: const Icon(Icons.arrow_forward_ios_sharp),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: calendarHelper,
      builder: (context, _) {
        final days = calendarHelper.daysInMonth(calendarHelper.focusedMonth);

        return Column(
          children: [
            /// Header (conditionally visible)
            if (widget.isHeaderVisible)
              widget.headerBuilder?.call(
                    context,
                    calendarHelper.focusedMonth,
                    calendarHelper.prevMonth,
                    calendarHelper.nextMonth,
                    () => ShowYearAndMonthPicker.showYearMonthPicker(
                      context,
                      calendarHelper: calendarHelper,
                    ),
                  ) ??
                  _defaultHeader(context),

            /// Weekdays
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:
                  calendarHelper.weekDays
                      .map(
                        (e) => Expanded(
                          child: Center(
                            child: Text(
                              e,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
            ),
            const SizedBox(height: 8),

            /// Calendar Grid
            Expanded(
              child: GridView.builder(
                itemCount: days.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                ),
                itemBuilder: (context, index) {
                  final day = days[index];
                  final isCurrentMonth =
                      day.month == calendarHelper.focusedMonth.month;

                  return GestureDetector(
                    onTap:
                        () => calendarHelper.onDayTap(
                          day,
                          isCurrentMonth,
                          widget.selectionMode,
                        ),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: calendarHelper.getCellColor(
                          day,
                          widget.selectionMode,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${day.day}',
                            style: TextStyle(
                              color:
                                  isCurrentMonth ? Colors.black : Colors.grey,
                              fontWeight:
                                  calendarHelper.isSelected(
                                        day,
                                        widget.selectionMode,
                                      )
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
