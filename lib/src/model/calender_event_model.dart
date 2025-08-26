import 'package:flutter/material.dart';

class CalendarEventModel {
  /// The title of the event.
  ///
  /// Example: `"Meeting with Team"`.
  final String title;

  /// The date of the event.
  ///
  /// Only the `year, month, day` components are considered for matching
  /// events on the calendar.
  final DateTime date;

  /// A longer description or notes about the event (optional).
  ///
  /// Example: `"Discuss project roadmap and assign tasks."`
  final String? description;

  /// The color used to visually represent the event in the calendar (optional).
  ///
  /// If not provided, a default color may be used in the UI.
  final Color? color;

  /// A model class representing a calendar event.
  ///
  /// Stores basic information such as [title], [date], and optional
  /// [description] and [color] for customizing event display.
  ///
  /// Creates a [CalendarEventModel].
  ///
  /// [title] and [date] are required.
  /// [description] and [color] are optional.
  CalendarEventModel({
    required this.title,
    required this.date,
    this.description,
    this.color,
  });
}
