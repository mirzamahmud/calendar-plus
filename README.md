# 📅 flex_calendar_plus

---

A highly customizable Flutter calendar widget with support for single/multiple date selection, events, draggable bottom sheet, and full builder hooks to let you design it as you want.

---

## ✨ Features

- 📆 Month view calendar
- 🔀 **Selection modes**
  - `SINGLE` → pick one date
  - `MULTIPLE` → pick a date range
- 🎨 Fully customizable with builder hooks:
  - Custom header (`headerBuilder`)
  - Custom event bottom sheet (`eventContextBuilder`)
- 🗓️ **Year & Month Picker** for quick navigation
- 🟢 Event management:
  - Add, remove, clear events
  - Dot indicators under event days
  - Draggable modal bottom sheet for event list
- 🛠 Helper methods:
  - `daysInMonth()`
  - Navigation: `nextMonth()`, `prevMonth()`, `setMonth()`

---

## 🚀 Installation

Add this line to your `pubspec.yaml`:

```yaml
dependencies:
  flex_calendar_plus: ^1.0.2
```

Or write in the terminal:

```bash
flutter pub add flex_calendar_plus
```

Then run:

```bash
flutter pub get
```

---

## 🧑‍💻 Usage

Basic Calendar

```dart
import 'package:flex_calendar_plus/flex_calendar_plus.dart';

class MyCalendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CalendarPlus(
      isHeaderVisible: true,
      selectionMode: CalendarSelectionMode.SINGLE,
    );
  }
}
```

Adding Events

```dart
final helper = CalendarHelper();

// Add events (could be from API)
helper.addEvent(
  DateTime(2025, 8, 26),
  CalendarEventModel(
    title: "Meeting with Team",
    date: DateTime(2025, 8, 26),
    color: Colors.red,
  ),
);
```

Custom Header Example

```dart
CalendarPlus(
  isHeaderVisible: true,
  headerBuilder: (context, focusedMonth, onPrev, onNext, onHeaderTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(onPressed: onPrev, icon: Icon(Icons.chevron_left)),
        Text(DateFormat.yMMM().format(focusedMonth)),
        IconButton(onPressed: onNext, icon: Icon(Icons.chevron_right)),
      ],
    );
  },
)
```

Custom Event Context Builder

```dart
CalendarPlus(
  eventContextBuilder: (mode, scrollController, events, day) {
    return ListView.builder(
      controller: scrollController,
      itemCount: events.length,
      itemBuilder: (context, index) {
        final e = events[index];
        return ListTile(
          leading: CircleAvatar(backgroundColor: e.color),
          title: Text(e.title),
          subtitle: Text(e.description ?? ''),
        );
      },
    );
  },
)
```

---

## 📖 API Overview

`CalendarPlus` Props

- isHeaderVisible → toggle default/custom header
- headerBuilder → custom header widget
- eventContextBuilder → custom bottom sheet UI
- selectionMode → SINGLE or MULTIPLE
- controller → inject your own CalendarHelper

`CalendarHelper` Methods

- daysInMonth(DateTime)
- nextMonth(), prevMonth(), setMonth(DateTime)
- onDayTap()
- Event handling: addEvent(), removeEvent(), clearEvents(), hasEvents()

---

## 📷 Screenshots

---

## 📄 License

This project is licensed under the MIT License.

---

## ❤️ Contributing

Contributions, issues, and feature requests are welcome!
Feel free to open an issue.
