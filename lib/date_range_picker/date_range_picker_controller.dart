import 'package:flutter/material.dart';
import 'package:flutter_date_picker/date_range_picker/date_range_picker.dart';

class DateRangePickerController {
  DateRangePickerState? _state;

  void attach(DateRangePickerState state) {
    _state = state;
  }

  void reset() {
    _state?.reset();
  }

  DateTimeRange? getDateTimeRange() {
    return _state?.getDateTimeRange();
  }
}
