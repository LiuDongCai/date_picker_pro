import 'package:date_picker_pro/date_picker.dart';
import 'package:flutter/material.dart';

/// Date picker controller
class DatePickerController {
  DatePickerState? _state;

  void attach(DatePickerState state) {
    _state = state;
  }

  /// Set the Current date
  setCurrentDate(DateTime date) {
    _state?.setCurrentDate(date);
  }

  /// Set the selected date
  setSelectedDate(DateTime date) {
    _state?.setSelectedDate(date);
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

  /// Set the Month Text Style
  setMonthTextStyle(TextStyle style) {
    _state?.setMonthTextStyle(style);
  }

  /// Set the Month Header Height
  setMonthHeaderItemHeight(double height) {
    _state?.setMonthHeaderItemHeight(height);
  }

  /// Set the BackgroundColor
  setBackgroundColor(Color color) {
    _state?.setBackgroundColor(color);
  }
}
