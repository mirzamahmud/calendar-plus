import 'package:flutter/material.dart';

class CalendarEventModel {
  final String title;
  final DateTime date;
  final String? description;
  final Color? color;

  CalendarEventModel({
    required this.title,
    required this.date,
    this.description,
    this.color,
  });
}
