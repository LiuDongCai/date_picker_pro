import 'dart:math' as math;

import 'package:date_picker_pro/date_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

const Duration _monthScrollDuration = Duration(milliseconds: 200);

const double _dayPickerRowHeight = 42.0;
const int _maxDayPickerRowCount = 6; // A 31 day month that starts on Saturday.
const double _maxDayPickerHeight =
    _dayPickerRowHeight * (_maxDayPickerRowCount + 1);
const double _monthPickerHorizontalPadding = 8.0;

const double _subHeaderHeight = 52.0;
const double _monthNavButtonsWidth = 108.0;

class DatePicker extends StatefulWidget {
  DatePicker({
    super.key,
    required DateTime? initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
    DateTime? currentDate,
    required this.onDateChanged,
    this.controller,
    this.onDisplayedMonthChanged,
    this.enableTextColor,
    this.disableTextColor,
    this.selectedTextColor,
    this.selectedColor,
    this.backgroundColor,
    this.monthTextStyle,
    this.monthHeaderItemHeight,
    this.selectedShape = BoxShape.circle,
    this.selectableDayPredicate,
  })  : initialDate =
            initialDate == null ? null : DateUtils.dateOnly(initialDate),
        firstDate = DateUtils.dateOnly(firstDate),
        lastDate = DateUtils.dateOnly(lastDate),
        currentDate = DateUtils.dateOnly(currentDate ?? DateTime.now()) {
    assert(
      !this.lastDate.isBefore(this.firstDate),
      'lastDate ${this.lastDate} must be on or after firstDate ${this.firstDate}.',
    );
    assert(
      this.initialDate == null || !this.initialDate!.isBefore(this.firstDate),
      'initialDate ${this.initialDate} must be on or after firstDate ${this.firstDate}.',
    );
    assert(
      this.initialDate == null || !this.initialDate!.isAfter(this.lastDate),
      'initialDate ${this.initialDate} must be on or before lastDate ${this.lastDate}.',
    );
    assert(
      selectableDayPredicate == null ||
          this.initialDate == null ||
          selectableDayPredicate!(this.initialDate!),
      'Provided initialDate ${this.initialDate} must satisfy provided selectableDayPredicate.',
    );
  }

  final DateTime? initialDate;

  final DateTime firstDate;

  final DateTime lastDate;

  final DateTime currentDate;

  final ValueChanged<DateTime> onDateChanged;

  final ValueChanged<DateTime>? onDisplayedMonthChanged;

  final SelectableDayPredicate? selectableDayPredicate;

  final DatePickerController? controller;

  final Color? enableTextColor;

  final Color? disableTextColor;

  final Color? selectedTextColor;

  final Color? selectedColor;

  final Color? backgroundColor;

  final BoxShape selectedShape;

  final TextStyle? monthTextStyle;

  final double? monthHeaderItemHeight;

  @override
  State<DatePicker> createState() => DatePickerState();
}

class DatePickerState extends State<DatePicker> {
  bool _announcedInitialDate = false;
  DatePickerMode _mode = DatePickerMode.day;
  late DateTime _currentDisplayedMonthDate;
  DateTime? _selectedDate;
  final GlobalKey _monthPickerKey = GlobalKey();
  final GlobalKey _yearPickerKey = GlobalKey();
  late MaterialLocalizations _localizations;
  late TextDirection _textDirection;

  late DateTime _currentDate;
  Color? enableTextColor;
  Color? disableTextColor;
  Color? selectedTextColor;
  Color? selectedColor;
  Color? backgroundColor;
  BoxShape selectedShape = BoxShape.circle;
  TextStyle? monthTextStyle;
  double? monthHeaderItemHeight;

  @override
  void initState() {
    super.initState();
    widget.controller?.attach(this);

    // init
    _currentDate = widget.currentDate;
    enableTextColor = widget.enableTextColor;
    disableTextColor = widget.disableTextColor;
    selectedTextColor = widget.selectedTextColor;
    selectedColor = widget.selectedColor;
    backgroundColor = widget.backgroundColor;
    selectedShape = widget.selectedShape;
    monthTextStyle = widget.monthTextStyle;
    monthHeaderItemHeight = widget.monthHeaderItemHeight;

    final DateTime currentDisplayedDate = widget.initialDate ?? _currentDate;
    _currentDisplayedMonthDate =
        DateTime(currentDisplayedDate.year, currentDisplayedDate.month);
    if (widget.initialDate != null) {
      _selectedDate = widget.initialDate;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    assert(debugCheckHasMaterial(context));
    assert(debugCheckHasMaterialLocalizations(context));
    assert(debugCheckHasDirectionality(context));
    _localizations = MaterialLocalizations.of(context);
    _textDirection = Directionality.of(context);
    if (!_announcedInitialDate && widget.initialDate != null) {
      assert(_selectedDate != null);
      _announcedInitialDate = true;
      final bool isToday = DateUtils.isSameDay(_currentDate, _selectedDate);
      final String semanticLabelSuffix =
          isToday ? ', ${_localizations.currentDateLabel}' : '';
      SemanticsService.announce(
        '${_localizations.formatFullDate(_selectedDate!)}$semanticLabelSuffix',
        _textDirection,
      );
    }
  }

  void _vibrate() {
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        HapticFeedback.vibrate();
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        break;
    }
  }

  void _handleModeChanged(DatePickerMode mode) {
    _vibrate();
    setState(() {
      _mode = mode;
      if (_selectedDate != null) {
        if (_mode == DatePickerMode.day) {
          SemanticsService.announce(
            _localizations.formatMonthYear(_selectedDate!),
            _textDirection,
          );
        } else {
          SemanticsService.announce(
            _localizations.formatYear(_selectedDate!),
            _textDirection,
          );
        }
      }
    });
  }

  void _handleMonthChanged(DateTime date) {
    setState(() {
      if (_currentDisplayedMonthDate.year != date.year ||
          _currentDisplayedMonthDate.month != date.month) {
        _currentDisplayedMonthDate = DateTime(date.year, date.month);
        widget.onDisplayedMonthChanged?.call(_currentDisplayedMonthDate);
      }
    });
  }

  void _handleYearChanged(DateTime value) {
    _vibrate();

    final int daysInMonth = DateUtils.getDaysInMonth(value.year, value.month);
    final int preferredDay = math.min(_selectedDate?.day ?? 1, daysInMonth);
    value = value.copyWith(day: preferredDay);

    if (value.isBefore(widget.firstDate)) {
      value = widget.firstDate;
    } else if (value.isAfter(widget.lastDate)) {
      value = widget.lastDate;
    }

    setState(() {
      _mode = DatePickerMode.day;
      _handleMonthChanged(value);

      if (_isSelectable(value)) {
        _selectedDate = value;
        widget.onDateChanged(_selectedDate!);
      }
    });
  }

  void _handleDayChanged(DateTime value) {
    _vibrate();
    setState(() {
      _selectedDate = value;
      widget.onDateChanged(_selectedDate!);
      switch (Theme.of(context).platform) {
        case TargetPlatform.linux:
        case TargetPlatform.macOS:
        case TargetPlatform.windows:
          final bool isToday = DateUtils.isSameDay(_currentDate, _selectedDate);
          final String semanticLabelSuffix =
              isToday ? ', ${_localizations.currentDateLabel}' : '';
          SemanticsService.announce(
            '${_localizations.selectedDateLabel} ${_localizations.formatFullDate(_selectedDate!)}$semanticLabelSuffix',
            _textDirection,
          );
        case TargetPlatform.android:
        case TargetPlatform.iOS:
        case TargetPlatform.fuchsia:
          break;
      }
    });
  }

  bool _isSelectable(DateTime date) {
    return widget.selectableDayPredicate == null ||
        widget.selectableDayPredicate!.call(date);
  }

  /// Set the current date
  setCurrentDate(DateTime date) {
    setState(() {
      _currentDate = date;
    });
  }

  /// Set the selected date
  setSelectedDate(DateTime date) {
    setState(() {
      _selectedDate = date;
      widget.onDateChanged(_selectedDate!);
    });
  }

  /// Set the Enable Text Color
  setEnableTextColor(Color color) {
    setState(() {
      enableTextColor = color;
    });
  }

  /// Set the Disable Text Color
  setDisableTextColor(Color color) {
    setState(() {
      disableTextColor = color;
    });
  }

  /// Set the Selected Text Color
  setSelectedTextColor(Color color) {
    setState(() {
      selectedTextColor = color;
    });
  }

  /// Set the Selected Color
  void setSelectedColor(Color color) {
    setState(() {
      selectedColor = color;
    });
  }

  /// Set the Selected Shape
  setSelectedShape(BoxShape shape) {
    setState(() {
      selectedShape = shape;
    });
  }

  /// Set the Month Text Style
  setMonthTextStyle(TextStyle style) {
    setState(() {
      monthTextStyle = style;
    });
  }

  /// Set the Month Header Height
  setMonthHeaderItemHeight(double height) {
    setState(() {
      monthHeaderItemHeight = height;
    });
  }

  /// Set the BackgroundColor
  setBackgroundColor(Color color) {
    setState(() {
      backgroundColor = color;
    });
  }

  Widget _buildPicker() {
    switch (_mode) {
      case DatePickerMode.day:
        return _MonthPicker(
          key: _monthPickerKey,
          initialMonth: _currentDisplayedMonthDate,
          currentDate: _currentDate,
          firstDate: widget.firstDate,
          lastDate: widget.lastDate,
          selectedDate: _selectedDate,
          enableTextColor: enableTextColor,
          disableTextColor: disableTextColor,
          selectedTextColor: selectedTextColor,
          monthHeaderItemHeight: monthHeaderItemHeight,
          selectedColor: selectedColor,
          selectedShape: selectedShape,
          onChanged: _handleDayChanged,
          onDisplayedMonthChanged: _handleMonthChanged,
          selectableDayPredicate: widget.selectableDayPredicate,
        );
      case DatePickerMode.year:
        return Padding(
          padding: EdgeInsets.only(
            top: monthHeaderItemHeight ?? _subHeaderHeight,
          ),
          child: YearPicker(
            key: _yearPickerKey,
            currentDate: _currentDate,
            firstDate: widget.firstDate,
            lastDate: widget.lastDate,
            selectedDate: _currentDisplayedMonthDate,
            onChanged: _handleYearChanged,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    assert(debugCheckHasMaterialLocalizations(context));
    assert(debugCheckHasDirectionality(context));
    return Container(
      color: backgroundColor,
      child: Stack(
        children: <Widget>[
          SizedBox(
            height: (monthHeaderItemHeight ?? _subHeaderHeight) +
                _maxDayPickerHeight,
            child: _buildPicker(),
          ),
          // Put the mode toggle button on top so that it won't be covered up by the _MonthPicker
          _DatePickerModeToggleButton(
            mode: _mode,
            title: _localizations.formatMonthYear(_currentDisplayedMonthDate),
            monthTextStyle: monthTextStyle,
            monthHeaderItemHeight: monthHeaderItemHeight,
            onTitlePressed: () {
              // Toggle the day/year mode.
              _handleModeChanged(
                _mode == DatePickerMode.day
                    ? DatePickerMode.year
                    : DatePickerMode.day,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _MonthPicker extends StatefulWidget {
  /// Creates a month picker.
  _MonthPicker({
    super.key,
    required this.initialMonth,
    required this.currentDate,
    required this.firstDate,
    required this.lastDate,
    required this.selectedDate,
    required this.onChanged,
    required this.onDisplayedMonthChanged,
    required this.selectedShape,
    this.selectableDayPredicate,
    Color? enableTextColor,
    Color? disableTextColor,
    Color? selectedTextColor,
    Color? selectedColor,
    double? monthHeaderItemHeight,
  })  : enableTextColor = enableTextColor ?? Colors.black,
        disableTextColor = disableTextColor ?? Colors.grey,
        selectedTextColor = selectedTextColor ?? Colors.white,
        selectedColor = selectedColor ?? Colors.blue,
        monthHeaderItemHeight = monthHeaderItemHeight ?? _subHeaderHeight {
    assert(!firstDate.isAfter(lastDate));
    assert(selectedDate == null || !selectedDate!.isBefore(firstDate));
    assert(selectedDate == null || !selectedDate!.isAfter(lastDate));
  }

  final DateTime initialMonth;

  final DateTime currentDate;

  final DateTime firstDate;

  final DateTime lastDate;

  final DateTime? selectedDate;

  final ValueChanged<DateTime> onChanged;

  final ValueChanged<DateTime> onDisplayedMonthChanged;

  final SelectableDayPredicate? selectableDayPredicate;

  final Color enableTextColor;

  final Color disableTextColor;

  final Color selectedTextColor;

  final Color selectedColor;

  final BoxShape selectedShape;

  final double monthHeaderItemHeight;

  @override
  _MonthPickerState createState() => _MonthPickerState();
}

class _MonthPickerState extends State<_MonthPicker> {
  final GlobalKey _pageViewKey = GlobalKey();
  late DateTime _currentMonth;
  late PageController _pageController;
  late MaterialLocalizations _localizations;
  late TextDirection _textDirection;
  Map<ShortcutActivator, Intent>? _shortcutMap;
  Map<Type, Action<Intent>>? _actionMap;
  late FocusNode _dayGridFocus;
  DateTime? _focusedDay;

  @override
  void initState() {
    super.initState();
    _currentMonth = widget.initialMonth;
    _pageController = PageController(
        initialPage: DateUtils.monthDelta(widget.firstDate, _currentMonth));
    _shortcutMap = const <ShortcutActivator, Intent>{
      SingleActivator(LogicalKeyboardKey.arrowLeft):
          DirectionalFocusIntent(TraversalDirection.left),
      SingleActivator(LogicalKeyboardKey.arrowRight):
          DirectionalFocusIntent(TraversalDirection.right),
      SingleActivator(LogicalKeyboardKey.arrowDown):
          DirectionalFocusIntent(TraversalDirection.down),
      SingleActivator(LogicalKeyboardKey.arrowUp):
          DirectionalFocusIntent(TraversalDirection.up),
    };
    _actionMap = <Type, Action<Intent>>{
      NextFocusIntent:
          CallbackAction<NextFocusIntent>(onInvoke: _handleGridNextFocus),
      PreviousFocusIntent: CallbackAction<PreviousFocusIntent>(
          onInvoke: _handleGridPreviousFocus),
      DirectionalFocusIntent: CallbackAction<DirectionalFocusIntent>(
          onInvoke: _handleDirectionFocus),
    };
    _dayGridFocus = FocusNode(debugLabel: 'Day Grid');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _localizations = MaterialLocalizations.of(context);
    _textDirection = Directionality.of(context);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _dayGridFocus.dispose();
    super.dispose();
  }

  void _handleDateSelected(DateTime selectedDate) {
    _focusedDay = selectedDate;
    widget.onChanged(selectedDate);
  }

  void _handleMonthPageChanged(int monthPage) {
    setState(() {
      final DateTime monthDate =
          DateUtils.addMonthsToMonthDate(widget.firstDate, monthPage);
      if (!DateUtils.isSameMonth(_currentMonth, monthDate)) {
        _currentMonth = DateTime(monthDate.year, monthDate.month);
        widget.onDisplayedMonthChanged(_currentMonth);
        if (_focusedDay != null &&
            !DateUtils.isSameMonth(_focusedDay, _currentMonth)) {
          // We have navigated to a new month with the grid focused, but the
          // focused day is not in this month. Choose a new one trying to keep
          // the same day of the month.
          _focusedDay = _focusableDayForMonth(_currentMonth, _focusedDay!.day);
        }
        SemanticsService.announce(
          _localizations.formatMonthYear(_currentMonth),
          _textDirection,
        );
      }
    });
  }

  /// Returns a focusable date for the given month.
  ///
  /// If the preferredDay is available in the month it will be returned,
  /// otherwise the first selectable day in the month will be returned. If
  /// no dates are selectable in the month, then it will return null.
  DateTime? _focusableDayForMonth(DateTime month, int preferredDay) {
    final int daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);

    // Can we use the preferred day in this month?
    if (preferredDay <= daysInMonth) {
      final DateTime newFocus = DateTime(month.year, month.month, preferredDay);
      if (_isSelectable(newFocus)) {
        return newFocus;
      }
    }

    // Start at the 1st and take the first selectable date.
    for (int day = 1; day <= daysInMonth; day++) {
      final DateTime newFocus = DateTime(month.year, month.month, day);
      if (_isSelectable(newFocus)) {
        return newFocus;
      }
    }
    return null;
  }

  /// Navigate to the next month.
  void _handleNextMonth() {
    if (!_isDisplayingLastMonth) {
      _pageController.nextPage(
        duration: _monthScrollDuration,
        curve: Curves.ease,
      );
    }
  }

  /// Navigate to the previous month.
  void _handlePreviousMonth() {
    if (!_isDisplayingFirstMonth) {
      _pageController.previousPage(
        duration: _monthScrollDuration,
        curve: Curves.ease,
      );
    }
  }

  /// Navigate to the given month.
  void _showMonth(DateTime month, {bool jump = false}) {
    final int monthPage = DateUtils.monthDelta(widget.firstDate, month);
    if (jump) {
      _pageController.jumpToPage(monthPage);
    } else {
      _pageController.animateToPage(
        monthPage,
        duration: _monthScrollDuration,
        curve: Curves.ease,
      );
    }
  }

  /// True if the earliest allowable month is displayed.
  bool get _isDisplayingFirstMonth {
    return !_currentMonth.isAfter(
      DateTime(widget.firstDate.year, widget.firstDate.month),
    );
  }

  /// True if the latest allowable month is displayed.
  bool get _isDisplayingLastMonth {
    return !_currentMonth.isBefore(
      DateTime(widget.lastDate.year, widget.lastDate.month),
    );
  }

  /// Handler for when the overall day grid obtains or loses focus.
  void _handleGridFocusChange(bool focused) {
    setState(() {
      if (focused && _focusedDay == null) {
        if (DateUtils.isSameMonth(widget.selectedDate, _currentMonth)) {
          _focusedDay = widget.selectedDate;
        } else if (DateUtils.isSameMonth(widget.currentDate, _currentMonth)) {
          _focusedDay =
              _focusableDayForMonth(_currentMonth, widget.currentDate.day);
        } else {
          _focusedDay = _focusableDayForMonth(_currentMonth, 1);
        }
      }
    });
  }

  /// Move focus to the next element after the day grid.
  void _handleGridNextFocus(NextFocusIntent intent) {
    _dayGridFocus.requestFocus();
    _dayGridFocus.nextFocus();
  }

  /// Move focus to the previous element before the day grid.
  void _handleGridPreviousFocus(PreviousFocusIntent intent) {
    _dayGridFocus.requestFocus();
    _dayGridFocus.previousFocus();
  }

  /// Move the internal focus date in the direction of the given intent.
  ///
  /// This will attempt to move the focused day to the next selectable day in
  /// the given direction. If the new date is not in the current month, then
  /// the page view will be scrolled to show the new date's month.
  ///
  /// For horizontal directions, it will move forward or backward a day (depending
  /// on the current [TextDirection]). For vertical directions it will move up and
  /// down a week at a time.
  void _handleDirectionFocus(DirectionalFocusIntent intent) {
    assert(_focusedDay != null);
    setState(() {
      final DateTime? nextDate =
          _nextDateInDirection(_focusedDay!, intent.direction);
      if (nextDate != null) {
        _focusedDay = nextDate;
        if (!DateUtils.isSameMonth(_focusedDay, _currentMonth)) {
          _showMonth(_focusedDay!);
        }
      }
    });
  }

  static const Map<TraversalDirection, int> _directionOffset =
      <TraversalDirection, int>{
    TraversalDirection.up: -DateTime.daysPerWeek,
    TraversalDirection.right: 1,
    TraversalDirection.down: DateTime.daysPerWeek,
    TraversalDirection.left: -1,
  };

  int _dayDirectionOffset(
      TraversalDirection traversalDirection, TextDirection textDirection) {
    // Swap left and right if the text direction if RTL
    if (textDirection == TextDirection.rtl) {
      if (traversalDirection == TraversalDirection.left) {
        traversalDirection = TraversalDirection.right;
      } else if (traversalDirection == TraversalDirection.right) {
        traversalDirection = TraversalDirection.left;
      }
    }
    return _directionOffset[traversalDirection]!;
  }

  DateTime? _nextDateInDirection(DateTime date, TraversalDirection direction) {
    final TextDirection textDirection = Directionality.of(context);
    DateTime nextDate = DateUtils.addDaysToDate(
        date, _dayDirectionOffset(direction, textDirection));
    while (!nextDate.isBefore(widget.firstDate) &&
        !nextDate.isAfter(widget.lastDate)) {
      if (_isSelectable(nextDate)) {
        return nextDate;
      }
      nextDate = DateUtils.addDaysToDate(
          nextDate, _dayDirectionOffset(direction, textDirection));
    }
    return null;
  }

  bool _isSelectable(DateTime date) {
    return widget.selectableDayPredicate == null ||
        widget.selectableDayPredicate!.call(date);
  }

  Widget _buildItems(BuildContext context, int index) {
    final DateTime month =
        DateUtils.addMonthsToMonthDate(widget.firstDate, index);
    return _DayPicker(
      key: ValueKey<DateTime>(month),
      selectedDate: widget.selectedDate,
      currentDate: widget.currentDate,
      onChanged: _handleDateSelected,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
      displayedMonth: month,
      selectableDayPredicate: widget.selectableDayPredicate,
      enableTextColor: widget.enableTextColor,
      disableTextColor: widget.disableTextColor,
      selectedTextColor: widget.selectedTextColor,
      selectedColor: widget.selectedColor,
      selectedShape: widget.selectedShape,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color controlColor =
        Theme.of(context).colorScheme.onSurface.withOpacity(0.60);

    return Semantics(
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsetsDirectional.only(start: 16, end: 4),
            height: widget.monthHeaderItemHeight,
            child: Row(
              children: <Widget>[
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  color: controlColor,
                  tooltip: _isDisplayingFirstMonth
                      ? null
                      : _localizations.previousMonthTooltip,
                  onPressed:
                      _isDisplayingFirstMonth ? null : _handlePreviousMonth,
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  color: controlColor,
                  tooltip: _isDisplayingLastMonth
                      ? null
                      : _localizations.nextMonthTooltip,
                  onPressed: _isDisplayingLastMonth ? null : _handleNextMonth,
                ),
              ],
            ),
          ),
          Expanded(
            child: FocusableActionDetector(
              shortcuts: _shortcutMap,
              actions: _actionMap,
              focusNode: _dayGridFocus,
              onFocusChange: _handleGridFocusChange,
              child: _FocusedDate(
                date: _dayGridFocus.hasFocus ? _focusedDay : null,
                child: PageView.builder(
                  key: _pageViewKey,
                  controller: _pageController,
                  itemBuilder: _buildItems,
                  itemCount:
                      DateUtils.monthDelta(widget.firstDate, widget.lastDate) +
                          1,
                  onPageChanged: _handleMonthPageChanged,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DatePickerModeToggleButton extends StatefulWidget {
  const _DatePickerModeToggleButton({
    required this.mode,
    required this.title,
    required this.onTitlePressed,
    this.monthTextStyle,
    this.monthHeaderItemHeight,
  });

  /// The current display of the calendar picker.
  final DatePickerMode mode;

  /// The text that displays the current month/year being viewed.
  final String title;

  /// The callback when the title is pressed.
  final VoidCallback onTitlePressed;

  final TextStyle? monthTextStyle;

  final double? monthHeaderItemHeight;

  @override
  _DatePickerModeToggleButtonState createState() =>
      _DatePickerModeToggleButtonState();
}

class _DatePickerModeToggleButtonState
    extends State<_DatePickerModeToggleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  TextStyle? monthTextStyle;
  late double monthHeaderItemHeight;

  @override
  void initState() {
    super.initState();
    monthTextStyle = widget.monthTextStyle;
    monthHeaderItemHeight = widget.monthHeaderItemHeight ?? _subHeaderHeight;

    _controller = AnimationController(
      value: widget.mode == DatePickerMode.year ? 0.5 : 0,
      upperBound: 0.5,
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(_DatePickerModeToggleButton oldWidget) {
    // update
    monthTextStyle = widget.monthTextStyle;
    monthHeaderItemHeight = widget.monthHeaderItemHeight ?? _subHeaderHeight;

    super.didUpdateWidget(oldWidget);
    if (oldWidget.mode == widget.mode) {
      return;
    }

    if (widget.mode == DatePickerMode.year) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final controllerColor = colorScheme.onSurface.withOpacity(0.60);
    final textStyle = widget.monthTextStyle ??
        textTheme.titleSmall?.copyWith(
          color: controllerColor,
        );

    return Container(
      padding: const EdgeInsetsDirectional.only(start: 16, end: 4),
      height: monthHeaderItemHeight,
      child: Row(
        children: <Widget>[
          Flexible(
            child: Semantics(
              label: MaterialLocalizations.of(context).selectYearSemanticsLabel,
              excludeSemantics: true,
              button: true,
              container: true,
              child: SizedBox(
                height: monthHeaderItemHeight,
                child: InkWell(
                  onTap: widget.onTitlePressed,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            widget.title,
                            overflow: TextOverflow.ellipsis,
                            style: textStyle,
                          ),
                        ),
                        RotationTransition(
                          turns: _controller,
                          child: Icon(
                            Icons.arrow_drop_down,
                            color: controllerColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (widget.mode == DatePickerMode.day)
            // Give space for the prev/next month buttons that are underneath this row
            const SizedBox(width: _monthNavButtonsWidth),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _DayPicker extends StatefulWidget {
  /// Creates a day picker.
  _DayPicker({
    super.key,
    required this.currentDate,
    required this.displayedMonth,
    required this.firstDate,
    required this.lastDate,
    required this.selectedDate,
    required this.onChanged,
    required this.enableTextColor,
    required this.disableTextColor,
    required this.selectedTextColor,
    required this.selectedColor,
    required this.selectedShape,
    this.selectableDayPredicate,
  })  : assert(!firstDate.isAfter(lastDate)),
        assert(selectedDate == null || !selectedDate.isBefore(firstDate)),
        assert(selectedDate == null || !selectedDate.isAfter(lastDate));

  final DateTime? selectedDate;

  final DateTime currentDate;

  final ValueChanged<DateTime> onChanged;

  final DateTime firstDate;

  final DateTime lastDate;

  final DateTime displayedMonth;

  final SelectableDayPredicate? selectableDayPredicate;

  final Color enableTextColor;

  final Color disableTextColor;

  final Color selectedTextColor;

  final Color selectedColor;

  final BoxShape selectedShape;

  @override
  _DayPickerState createState() => _DayPickerState();
}

class _DayPickerState extends State<_DayPicker> {
  /// List of [FocusNode]s, one for each day of the month.
  late List<FocusNode> _dayFocusNodes;

  @override
  void initState() {
    super.initState();
    final int daysInMonth = DateUtils.getDaysInMonth(
        widget.displayedMonth.year, widget.displayedMonth.month);
    _dayFocusNodes = List<FocusNode>.generate(
      daysInMonth,
      (int index) =>
          FocusNode(skipTraversal: true, debugLabel: 'Day ${index + 1}'),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check to see if the focused date is in this month, if so focus it.
    final DateTime? focusedDate = _FocusedDate.maybeOf(context);
    if (focusedDate != null &&
        DateUtils.isSameMonth(widget.displayedMonth, focusedDate)) {
      _dayFocusNodes[focusedDate.day - 1].requestFocus();
    }
  }

  @override
  void dispose() {
    for (final FocusNode node in _dayFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  /// Builds widgets showing abbreviated days of week. The first widget in the
  /// returned list corresponds to the first day of week for the current locale.
  ///
  /// Examples:
  ///
  ///     ┌ Sunday is the first day of week in the US (en_US)
  ///     |
  ///     S M T W T F S  ← the returned list contains these widgets
  ///     _ _ _ _ _ 1 2
  ///     3 4 5 6 7 8 9
  ///
  ///     ┌ But it's Monday in the UK (en_GB)
  ///     |
  ///     M T W T F S S  ← the returned list contains these widgets
  ///     _ _ _ _ 1 2 3
  ///     4 5 6 7 8 9 10
  ///
  List<Widget> _dayHeaders(
      TextStyle? headerStyle, MaterialLocalizations localizations) {
    final List<Widget> result = <Widget>[];
    for (int i = localizations.firstDayOfWeekIndex;
        result.length < DateTime.daysPerWeek;
        i = (i + 1) % DateTime.daysPerWeek) {
      final String weekday = localizations.narrowWeekdays[i];
      result.add(ExcludeSemantics(
        child: Center(child: Text(weekday, style: headerStyle)),
      ));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final DatePickerThemeData datePickerTheme = DatePickerTheme.of(context);
    final DatePickerThemeData defaults = DatePickerTheme.defaults(context);
    final TextStyle? weekdayStyle =
        datePickerTheme.weekdayStyle ?? defaults.weekdayStyle;

    final int year = widget.displayedMonth.year;
    final int month = widget.displayedMonth.month;

    final int daysInMonth = DateUtils.getDaysInMonth(year, month);
    final int dayOffset = DateUtils.firstDayOffset(year, month, localizations);

    final List<Widget> dayItems = _dayHeaders(weekdayStyle, localizations);
    // 1-based day of month, e.g. 1-31 for January, and 1-29 for February on
    // a leap year.
    int day = -dayOffset;
    while (day < daysInMonth) {
      day++;
      if (day < 1) {
        dayItems.add(Container());
      } else {
        final DateTime dayToBuild = DateTime(year, month, day);
        final bool isDisabled = dayToBuild.isAfter(widget.lastDate) ||
            dayToBuild.isBefore(widget.firstDate) ||
            (widget.selectableDayPredicate != null &&
                !widget.selectableDayPredicate!(dayToBuild));
        final bool isSelectedDay =
            DateUtils.isSameDay(widget.selectedDate, dayToBuild);
        final bool isToday =
            DateUtils.isSameDay(widget.currentDate, dayToBuild);

        dayItems.add(
          _Day(
            dayToBuild,
            key: ValueKey<DateTime>(dayToBuild),
            isDisabled: isDisabled,
            isSelectedDay: isSelectedDay,
            isToday: isToday,
            onChanged: widget.onChanged,
            focusNode: _dayFocusNodes[day - 1],
            enableTextColor: widget.enableTextColor,
            disableTextColor: widget.disableTextColor,
            selectedTextColor: widget.selectedTextColor,
            selectedColor: widget.selectedColor,
            selectedShape: widget.selectedShape,
          ),
        );
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: _monthPickerHorizontalPadding,
      ),
      child: GridView.custom(
        physics: const ClampingScrollPhysics(),
        gridDelegate: _dayPickerGridDelegate,
        childrenDelegate: SliverChildListDelegate(
          dayItems,
          addRepaintBoundaries: false,
        ),
      ),
    );
  }
}

class _DayPickerGridDelegate extends SliverGridDelegate {
  const _DayPickerGridDelegate();

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    const int columnCount = DateTime.daysPerWeek;
    final double tileWidth = constraints.crossAxisExtent / columnCount;
    final double tileHeight = math.min(
      _dayPickerRowHeight,
      constraints.viewportMainAxisExtent / (_maxDayPickerRowCount + 1),
    );
    return SliverGridRegularTileLayout(
      childCrossAxisExtent: tileWidth,
      childMainAxisExtent: tileHeight,
      crossAxisCount: columnCount,
      crossAxisStride: tileWidth,
      mainAxisStride: tileHeight,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(_DayPickerGridDelegate oldDelegate) => false;
}

const _DayPickerGridDelegate _dayPickerGridDelegate = _DayPickerGridDelegate();

class _FocusedDate extends InheritedWidget {
  const _FocusedDate({
    required super.child,
    this.date,
  });

  final DateTime? date;

  @override
  bool updateShouldNotify(_FocusedDate oldWidget) {
    return !DateUtils.isSameDay(date, oldWidget.date);
  }

  static DateTime? maybeOf(BuildContext context) {
    final _FocusedDate? focusedDate =
        context.dependOnInheritedWidgetOfExactType<_FocusedDate>();
    return focusedDate?.date;
  }
}

class _Day extends StatefulWidget {
  const _Day(
    this.day, {
    super.key,
    required this.isDisabled,
    required this.isSelectedDay,
    required this.isToday,
    required this.onChanged,
    required this.focusNode,
    required this.enableTextColor,
    required this.disableTextColor,
    required this.selectedTextColor,
    required this.selectedColor,
    required this.selectedShape,
  });

  final DateTime day;
  final bool isDisabled;
  final bool isSelectedDay;
  final bool isToday;
  final ValueChanged<DateTime> onChanged;
  final FocusNode? focusNode;
  final Color enableTextColor;
  final Color disableTextColor;
  final Color selectedTextColor;
  final Color selectedColor;
  final BoxShape selectedShape;

  @override
  State<_Day> createState() => _DayState();
}

class _DayState extends State<_Day> {
  final WidgetStatesController _statesController = WidgetStatesController();

  @override
  Widget build(BuildContext context) {
    final DatePickerThemeData defaults = DatePickerTheme.defaults(context);
    final DatePickerThemeData datePickerTheme = DatePickerTheme.of(context);
    final TextStyle? dayStyle = datePickerTheme.dayStyle ?? defaults.dayStyle;
    T? effectiveValue<T>(T? Function(DatePickerThemeData? theme) getProperty) {
      return getProperty(datePickerTheme) ?? getProperty(defaults);
    }

    T? resolve<T>(
        WidgetStateProperty<T>? Function(DatePickerThemeData? theme)
            getProperty,
        Set<WidgetState> states) {
      return effectiveValue(
        (DatePickerThemeData? theme) {
          return getProperty(theme)?.resolve(states);
        },
      );
    }

    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final String semanticLabelSuffix =
        widget.isToday ? ', ${localizations.currentDateLabel}' : '';

    final Set<WidgetState> states = <WidgetState>{
      if (widget.isDisabled) WidgetState.disabled,
      if (widget.isSelectedDay) WidgetState.selected,
    };

    _statesController.value = states;

    final Color? dayBackgroundColor = resolve<Color?>(
        (DatePickerThemeData? theme) => widget.isToday
            ? theme?.todayBackgroundColor
            : theme?.dayBackgroundColor,
        states);
    final WidgetStateProperty<Color?> dayOverlayColor =
        WidgetStateProperty.resolveWith<Color?>(
      (Set<WidgetState> states) => effectiveValue(
          (DatePickerThemeData? theme) =>
              theme?.dayOverlayColor?.resolve(states)),
    );
    final OutlinedBorder dayShape = resolve<OutlinedBorder?>(
        (DatePickerThemeData? theme) => theme?.dayShape, states)!;
    final BoxDecoration decoration = widget.isSelectedDay
        ? BoxDecoration(
            color: widget.selectedColor,
            shape: widget.selectedShape,
            borderRadius: widget.selectedShape == BoxShape.rectangle
                ? BorderRadius.circular(4)
                : null,
          )
        : widget.isToday
            ? BoxDecoration(
                color: dayBackgroundColor,
                border: Border.all(color: widget.selectedColor),
                shape: widget.selectedShape,
                borderRadius: widget.selectedShape == BoxShape.rectangle
                    ? BorderRadius.circular(4)
                    : null,
              )
            : BoxDecoration(
                color: dayBackgroundColor,
                shape: widget.selectedShape,
                borderRadius: widget.selectedShape == BoxShape.rectangle
                    ? BorderRadius.circular(4)
                    : null,
              );

    Widget dayWidget = DecoratedBox(
      decoration: decoration,
      child: Center(
        child: Text(
          localizations.formatDecimal(widget.day.day),
          style: dayStyle?.apply(
            color: widget.isDisabled
                ? widget.disableTextColor
                : widget.isSelectedDay
                    ? widget.selectedTextColor
                    : widget.enableTextColor,
          ),
        ),
      ),
    );

    if (widget.isDisabled) {
      dayWidget = ExcludeSemantics(
        child: dayWidget,
      );
    } else {
      dayWidget = InkResponse(
        focusNode: widget.focusNode,
        onTap: () => widget.onChanged(widget.day),
        statesController: _statesController,
        overlayColor: dayOverlayColor,
        customBorder: dayShape,
        containedInkWell: true,
        child: Semantics(
          // We want the day of month to be spoken first irrespective of the
          // locale-specific preferences or TextDirection. This is because
          // an accessibility user is more likely to be interested in the
          // day of month before the rest of the date, as they are looking
          // for the day of month. To do that we prepend day of month to the
          // formatted full date.
          label:
              '${localizations.formatDecimal(widget.day.day)}, ${localizations.formatFullDate(widget.day)}$semanticLabelSuffix',
          // Set button to true to make the date selectable.
          button: true,
          selected: widget.isSelectedDay,
          excludeSemantics: true,
          child: dayWidget,
        ),
      );
    }

    return dayWidget;
  }

  @override
  void dispose() {
    _statesController.dispose();
    super.dispose();
  }
}
