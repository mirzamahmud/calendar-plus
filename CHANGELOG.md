# Changelog

All notable changes to this project will be documented in this file.

---

## 1.0.1 - (2025-08-26)

- Update Document

---

## 1.0.0 - (2025-08-26)

### Added

- Initial release of `flex_calendar_plus`.
- Display calendar grid for a given month.
- Support for **single** and **multiple (range)** date selection modes.
- Customizable **header** with optional builder.
- Year & month picker dialog for quick navigation.
- Event management:
  - Add, remove, and clear events for specific dates.
  - Show event indicators (dots) under days.
- **Draggable bottom sheet** to view events for selected dates.
- Builder hooks for customization:
  - `headerBuilder`
  - `eventContextBuilder`
- Helper methods:
  - `daysInMonth`
  - Navigation: `nextMonth`, `prevMonth`, `setMonth`
  - Selection handling with `onDayTap`
