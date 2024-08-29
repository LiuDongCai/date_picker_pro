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

  /// Set the initial date range
  setInitialDateRange(DateTimeRange dateRange) {
    _state?.setInitialDateRange(dateRange);
  }

  /// Set the Interval Color
  setIntervalColor(Color color) {
    _state?.setIntervalColor(color);
  }

  /// Set the Selected Color
  setSelectedColor(Color color) {
    _state?.setSelectedColor(color);
  }

  /// Set the Selected Text Color
  setSelectedTextColor(Color color) {
    _state?.setSelectedTextColor(color);
  }

  /// Set the Enable Text Color
  setEnableTextColor(Color color) {
    _state?.setEnableTextColor(color);
  }

  /// Set the Disable Text Color
  setDisableTextColor(Color color) {
    _state?.setDisableTextColor(color);
  }

  /// Set the Selected Shape
  setSelectedShape(BoxShape shape) {
    _state?.setSelectedShape(shape);
  }
}
