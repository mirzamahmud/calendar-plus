import 'package:flex_calendar_plus/flex_calendar_plus.dart';
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

  final EventContext Function(
    CalendarSelectionMode selectionMode,
    ScrollController? scrollController,
    List<CalendarEventModel> events,
    DateTime day,
  )?
  eventContextBuilder;

  /// Selection mode: single date or multiple dates.
  final CalendarSelectionMode selectionMode;

  /// Calendar helper: external helper.
  final CalendarHelper? controller;

  const CalendarPlus({
    super.key,
    this.isHeaderVisible = false,
    this.headerBuilder,
    this.selectionMode = CalendarSelectionMode.SINGLE,
    this.controller,
    this.eventContextBuilder,
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
    calendarHelper = widget.controller ?? CalendarHelper();
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
                    onTap: () {
                      calendarHelper.onDayTap(
                        day,
                        isCurrentMonth,
                        widget.selectionMode,
                      );

                      List<CalendarEventModel> events = [];

                      if (widget.selectionMode ==
                          CalendarSelectionMode.SINGLE) {
                        events = calendarHelper.getEventsForDay(day);
                      } else {
                        for (final d in calendarHelper.selectedDates) {
                          events.addAll(calendarHelper.getEventsForDay(d));
                        }
                      }

                      if (events.isNotEmpty) {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          builder: (context) {
                            return DraggableScrollableSheet(
                              expand: false,
                              initialChildSize: 0.4,
                              minChildSize: 0.2,
                              maxChildSize: 0.8,
                              builder: (context, scrollController) {
                                if (widget.eventContextBuilder != null) {
                                  return Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          width: 40,
                                          height: 4,
                                          margin: const EdgeInsets.only(
                                            top: 12,
                                            bottom: 20,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[400],
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                      ),

                                      Expanded(
                                        child: widget.eventContextBuilder!(
                                          widget.selectionMode,
                                          scrollController,
                                          events,
                                          day,
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          width: 40,
                                          height: 4,
                                          margin: const EdgeInsets.only(
                                            top: 12,
                                            bottom: 20,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[400],
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: EventContext(
                                          selectionMode: widget.selectionMode,
                                          day: day,
                                          eventListView: ListView.separated(
                                            controller: scrollController,
                                            padding: EdgeInsets.zero,
                                            itemCount: events.length,
                                            separatorBuilder:
                                                (context, index) =>
                                                    const Divider(),
                                            itemBuilder:
                                                (context, index) =>
                                                    Text(events[index].title),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              },
                            );
                          },
                        );
                      }
                    },
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
                                  calendarHelper.isSelected(
                                        day,
                                        widget.selectionMode,
                                      )
                                      ? Colors.white
                                      : isCurrentMonth
                                      ? Colors.black
                                      : Colors.grey,
                              fontWeight:
                                  calendarHelper.isSelected(
                                        day,
                                        widget.selectionMode,
                                      )
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                            ),
                          ),
                          if (calendarHelper.hasEvents(day))
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:
                                    calendarHelper
                                        .getEventsForDay(day)
                                        .take(3) // max 3 dots
                                        .map(
                                          (event) => Container(
                                            margin: const EdgeInsets.symmetric(
                                              horizontal: 1,
                                            ),
                                            width: 6,
                                            height: 6,
                                            decoration: BoxDecoration(
                                              color: event.color ?? Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        )
                                        .toList(),
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
