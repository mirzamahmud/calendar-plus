import 'package:calendar_plus/calendar_plus.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const Example());
}

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalenderScreen(),
    );
  }
}

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({super.key});

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  final CalendarHelper calendarHelper = CalendarHelper();

  @override
  void initState() {
    super.initState();
    loadEvents(calendarHelper);
  }

  Future<void> loadEvents(CalendarHelper helper) async {
    // simulate API response
    final apiResponse = [
      {"title": "Meeting with Team", "date": "2025-08-26", "color": "#FF0000"},
      {"title": "Doctor Appointment", "date": "2025-08-26", "color": "#00FF00"},
      {"title": "Conference", "date": "2025-08-28", "color": "#0000FF"},
      {"title": "Conference", "date": "2025-08-01", "color": "#0000FF"},
      {"title": "Interview", "date": "2025-08-14", "color": "#0000FF"},
      {"title": "Tour", "date": "2025-08-31", "color": "#0000FF"},
    ];

    for (var item in apiResponse) {
      final date = DateTime.parse(item["date"] as String);

      helper.addEvent(
        date,
        CalendarEventModel(
          title: item["title"] as String,
          date: date,
          color: Color(
            int.parse((item["color"] as String).replaceFirst('#', '0xFF')),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text('Calender Plus'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsetsDirectional.symmetric(vertical: 20, horizontal: 16),
        child: CalendarPlus(
          isHeaderVisible: true,
          controller: calendarHelper,
          selectionMode: CalendarSelectionMode.SINGLE,
        ),
      ),
    );
  }
}
