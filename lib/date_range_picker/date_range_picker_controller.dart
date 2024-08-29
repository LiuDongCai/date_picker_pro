import 'package:flutter/material.dart';
import 'package:flutter_date_picker/date_range_picker/date_range_picker.dart';

/// Date range picker controller
class DateRangePickerController {
  DateRangePickerState? _state;

  void attach(DateRangePickerState state) {
    _state = state;
  }

  /// Reset the selected date range
  void reset() {
    _state?.reset();
  }

  /// Get the selected date range
  DateTimeRange? getDateTimeRange() {
    return _state?.getDateTimeRange();
  }
}
