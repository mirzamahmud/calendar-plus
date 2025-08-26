import 'package:calendar_plus/src/helper/calendar_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ShowYearAndMonthPicker {
  static Future<void> showYearMonthPicker(
    BuildContext context, {
    required CalendarHelper calendarHelper,
  }) async {
    // Step 1: Pick Year
    final pickedYear = await showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Year'),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: 50, // +/- 25 years
              itemBuilder: (context, index) {
                final year = DateTime.now().year - 25 + index;
                final isSelected = year == calendarHelper.focusedMonth.year;

                return GestureDetector(
                  onTap: () => Navigator.pop(context, year),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$year',
                      style: TextStyle(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );

    if (pickedYear != null) {
      // Step 2: Pick Month
      final pickedMonth = await showDialog<int>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Select Month ($pickedYear)'),
            content: SizedBox(
              width: double.maxFinite,
              height: 250,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: 12,
                itemBuilder: (context, index) {
                  final month = index + 1;
                  final isSelected =
                      month == calendarHelper.focusedMonth.month &&
                      pickedYear == calendarHelper.focusedMonth.year;

                  return GestureDetector(
                    onTap: () => Navigator.pop(context, month),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        DateFormat.MMM().format(DateTime(0, month)),
                        style: TextStyle(
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      );

      if (pickedMonth != null) {
        calendarHelper.setMonth(DateTime(pickedYear, pickedMonth));
      }
    }
  }
}
