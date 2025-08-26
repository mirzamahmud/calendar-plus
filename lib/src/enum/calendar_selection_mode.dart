/// Defines how the calendar handles date selection.
enum CalendarSelectionMode {
  /// Allows selecting a **single date** at a time.
  ///
  /// When a new date is tapped, the previously selected date (if any)
  /// will be cleared.
  SINGLE,

  /// Allows selecting **multiple dates** (a range).
  ///
  /// - First tap sets the start date (`rangeStart`).
  /// - Second tap sets the end date (`rangeEnd`).
  /// - All dates between start and end are automatically selected.
  /// - Tapping again starts a new range selection.
  MULTIPLE,
}
