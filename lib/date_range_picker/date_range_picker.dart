import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_date_picker/date_range_picker/date_range_picker_controller.dart';

const Duration _dialogSizeAnimationDuration = Duration(milliseconds: 200);
const double _kMaxTextScaleFactor = 1.3;
const double _monthItemHeaderHeight = 58.0;
const double _monthItemFooterHeight = 12.0;
const Duration _monthScrollDuration = Duration(milliseconds: 200);

const double _monthItemRowHeight = 42.0;
const double _monthItemSpaceBetweenRows = 8.0;
const double _horizontalPadding = 8.0;
const double _maxCalendarWidthLandscape = 384.0;
const double _maxCalendarWidthPortrait = 480.0;

const _MonthItemGridDelegate _monthItemGridDelegate = _MonthItemGridDelegate();

enum _HighlightPainterStyle {
  /// Paints nothing.
  none,

  /// Paints a rectangle that occupies the leading half of the space.
  highlightLeading,

  /// Paints a rectangle that occupies the trailing half of the space.
  highlightTrailing,

  /// Paints a rectangle that occupies all available space.
  highlightAll,
}

class _HighlightPainter extends CustomPainter {
  _HighlightPainter({
    required this.color,
    this.style = _HighlightPainterStyle.none,
    this.textDirection,
  });

  final Color color;
  final _HighlightPainterStyle style;
  final TextDirection? textDirection;

  @override
  void paint(Canvas canvas, Size size) {
    if (style == _HighlightPainterStyle.none) {
      return;
    }

    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final bool rtl = switch (textDirection) {
      TextDirection.rtl || null => true,
      TextDirection.ltr => false,
    };

    switch (style) {
      case _HighlightPainterStyle.highlightLeading when rtl:
      case _HighlightPainterStyle.highlightTrailing when !rtl:
        canvas.drawRect(
            Rect.fromLTWH(size.width / 2, 0, size.width / 2, size.height),
            paint);
      case _HighlightPainterStyle.highlightLeading:
      case _HighlightPainterStyle.highlightTrailing:
        canvas.drawRect(
            Rect.fromLTWH(0, 0, size.width / 2, size.height), paint);
      case _HighlightPainterStyle.highlightAll:
        canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
      case _HighlightPainterStyle.none:
        break;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class DateRangePicker extends StatefulWidget {
  const DateRangePicker({
    super.key,
    this.initialDateRange,
    required this.firstDate,
    required this.lastDate,
    this.currentDate,
    this.restorationId,
    this.intervalColor,
    this.selectedColor,
    this.selectedTextColor,
    this.enableTextColor,
    this.disableTextColor,
    this.controller,
    this.selectedShape = BoxShape.rectangle,
  });

  final DateTimeRange? initialDateRange;

  final DateTime firstDate;

  final DateTime lastDate;

  final DateTime? currentDate;

  final String? restorationId;

  final Color? intervalColor;

  final Color? selectedColor;

  final Color? selectedTextColor;

  final Color? enableTextColor;

  final Color? disableTextColor;

  final DateRangePickerController? controller;

  final BoxShape selectedShape;

  @override
  State<DateRangePicker> createState() => DateRangePickerState();
}

class DateRangePickerState extends State<DateRangePicker>
    with RestorationMixin {
  late final RestorableDateTimeN _selectedStart =
      RestorableDateTimeN(widget.initialDateRange?.start);
  late final RestorableDateTimeN _selectedEnd =
      RestorableDateTimeN(widget.initialDateRange?.end);
  final RestorableBool _autoValidate = RestorableBool(false);
  final GlobalKey _calendarPickerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    widget.controller?.attach(this);
  }

  @override
  String? get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedStart, 'selected_start');
    registerForRestoration(_selectedEnd, 'selected_end');
    registerForRestoration(_autoValidate, 'autovalidate');
  }

  @override
  void dispose() {
    _selectedStart.dispose();
    _selectedEnd.dispose();
    _autoValidate.dispose();
    super.dispose();
  }

  void reset() {
    setState(() {
      _selectedStart.value = null;
      _selectedEnd.value = null;
    });
  }

  DateTimeRange? getDateTimeRange() {
    final DateTimeRange? selectedRange = _hasSelectedDateRange
        ? DateTimeRange(start: _selectedStart.value!, end: _selectedEnd.value!)
        : null;
    return selectedRange;
  }

  void _handleStartDateChanged(DateTime? date) {
    setState(() => _selectedStart.value = date);
  }

  void _handleEndDateChanged(DateTime? date) {
    setState(() => _selectedEnd.value = date);
  }

  bool get _hasSelectedDateRange =>
      _selectedStart.value != null && _selectedEnd.value != null;

  @override
  Widget build(BuildContext context) {
    final DatePickerThemeData datePickerTheme = DatePickerTheme.of(context);
    final DatePickerThemeData defaults = DatePickerTheme.defaults(context);

    final Widget contents;
    final Size size;
    final double? elevation;
    final Color? shadowColor;
    final Color? surfaceTintColor;
    final ShapeBorder? shape;
    final EdgeInsets insetPadding;

    contents = _CalendarRangePickerDialog(
      key: _calendarPickerKey,
      selectedStartDate: _selectedStart.value,
      selectedEndDate: _selectedEnd.value,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
      currentDate: widget.currentDate,
      intervalColor: widget.intervalColor,
      selectedColor: widget.selectedColor,
      selectedTextColor: widget.selectedTextColor,
      enableTextColor: widget.enableTextColor,
      disableTextColor: widget.disableTextColor,
      selectedShape: widget.selectedShape,
      onStartDateChanged: _handleStartDateChanged,
      onEndDateChanged: _handleEndDateChanged,
    );
    size = MediaQuery.sizeOf(context);
    insetPadding = EdgeInsets.zero;
    elevation =
        datePickerTheme.rangePickerElevation ?? defaults.rangePickerElevation!;
    shadowColor = datePickerTheme.rangePickerShadowColor ??
        defaults.rangePickerShadowColor!;
    surfaceTintColor = datePickerTheme.rangePickerSurfaceTintColor ??
        defaults.rangePickerSurfaceTintColor!;
    shape = datePickerTheme.rangePickerShape ?? defaults.rangePickerShape;

    return Dialog(
      insetPadding: insetPadding,
      backgroundColor:
          datePickerTheme.backgroundColor ?? defaults.backgroundColor,
      elevation: elevation,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      shape: shape,
      clipBehavior: Clip.antiAlias,
      child: AnimatedContainer(
        width: size.width,
        height: size.height,
        duration: _dialogSizeAnimationDuration,
        curve: Curves.easeIn,
        child: MediaQuery.withClampedTextScaling(
          maxScaleFactor: _kMaxTextScaleFactor,
          child: Builder(builder: (BuildContext context) {
            return contents;
          }),
        ),
      ),
    );
  }
}

class _CalendarRangePickerDialog extends StatelessWidget {
  const _CalendarRangePickerDialog({
    super.key,
    required this.selectedStartDate,
    required this.selectedEndDate,
    required this.firstDate,
    required this.lastDate,
    required this.currentDate,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
    required this.intervalColor,
    required this.selectedColor,
    required this.selectedTextColor,
    required this.enableTextColor,
    required this.disableTextColor,
    required this.selectedShape,
  });

  final DateTime? selectedStartDate;
  final DateTime? selectedEndDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime? currentDate;
  final ValueChanged<DateTime> onStartDateChanged;
  final ValueChanged<DateTime?> onEndDateChanged;
  final Color? intervalColor;
  final Color? selectedColor;
  final Color? selectedTextColor;
  final Color? enableTextColor;
  final Color? disableTextColor;
  final BoxShape selectedShape;

  @override
  Widget build(BuildContext context) {
    final DatePickerThemeData themeData = DatePickerTheme.of(context);
    final DatePickerThemeData defaults = DatePickerTheme.defaults(context);
    final Color? dialogBackground = themeData.rangePickerBackgroundColor ??
        defaults.rangePickerBackgroundColor;

    return SafeArea(
      top: false,
      left: false,
      right: false,
      child: Scaffold(
        backgroundColor: dialogBackground,
        body: _CalendarDateRangePicker(
          initialStartDate: selectedStartDate,
          initialEndDate: selectedEndDate,
          firstDate: firstDate,
          lastDate: lastDate,
          currentDate: currentDate,
          onStartDateChanged: onStartDateChanged,
          onEndDateChanged: onEndDateChanged,
          intervalColor: intervalColor,
          selectedColor: selectedColor,
          selectedTextColor: selectedTextColor,
          enableTextColor: enableTextColor,
          disableTextColor: disableTextColor,
          selectedShape: selectedShape,
        ),
      ),
    );
  }
}

class _CalendarDateRangePicker extends StatefulWidget {
  _CalendarDateRangePicker({
    DateTime? initialStartDate,
    DateTime? initialEndDate,
    required DateTime firstDate,
    required DateTime lastDate,
    DateTime? currentDate,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
    Color? intervalColor,
    Color? selectedColor,
    Color? selectedTextColor,
    Color? enableTextColor,
    Color? disableTextColor,
    required this.selectedShape,
  })  : initialStartDate = initialStartDate != null
            ? DateUtils.dateOnly(initialStartDate)
            : null,
        initialEndDate =
            initialEndDate != null ? DateUtils.dateOnly(initialEndDate) : null,
        firstDate = DateUtils.dateOnly(firstDate),
        lastDate = DateUtils.dateOnly(lastDate),
        currentDate = DateUtils.dateOnly(currentDate ?? DateTime.now()),
        intervalColor = intervalColor ?? Colors.blueGrey.shade50,
        selectedColor = selectedColor ?? Colors.blue,
        selectedTextColor = selectedTextColor ?? Colors.white,
        enableTextColor = enableTextColor ?? Colors.black,
        disableTextColor = disableTextColor ?? Colors.grey {
    assert(
      this.initialStartDate == null ||
          this.initialEndDate == null ||
          !this.initialStartDate!.isAfter(initialEndDate!),
      'initialStartDate must be on or before initialEndDate.',
    );
    assert(
      !this.lastDate.isBefore(this.firstDate),
      'firstDate must be on or before lastDate.',
    );
  }

  final DateTime? initialStartDate;

  final DateTime? initialEndDate;

  final DateTime firstDate;

  final DateTime lastDate;

  final DateTime currentDate;

  final ValueChanged<DateTime>? onStartDateChanged;

  final ValueChanged<DateTime?>? onEndDateChanged;

  final Color intervalColor;

  final Color selectedColor;

  final Color selectedTextColor;

  final Color enableTextColor;

  final Color disableTextColor;

  final BoxShape selectedShape;

  @override
  _CalendarDateRangePickerState createState() =>
      _CalendarDateRangePickerState();
}

class _CalendarDateRangePickerState extends State<_CalendarDateRangePicker> {
  final GlobalKey _scrollViewKey = GlobalKey();
  DateTime? _startDate;
  DateTime? _endDate;
  int _initialMonthIndex = 0;
  late ScrollController _controller;
  late bool _showWeekBottomDivider;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);

    _startDate = widget.initialStartDate;
    _endDate = widget.initialEndDate;

    final DateTime initialDate = widget.initialStartDate ?? widget.currentDate;
    if (!initialDate.isBefore(widget.firstDate) &&
        !initialDate.isAfter(widget.lastDate)) {
      _initialMonthIndex = DateUtils.monthDelta(widget.firstDate, initialDate);
    }

    _showWeekBottomDivider = _initialMonthIndex != 0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_controller.offset <= _controller.position.minScrollExtent) {
      setState(() {
        _showWeekBottomDivider = false;
      });
    } else if (!_showWeekBottomDivider) {
      setState(() {
        _showWeekBottomDivider = true;
      });
    }
  }

  int get _numberOfMonths =>
      DateUtils.monthDelta(widget.firstDate, widget.lastDate) + 1;

  void _vibrate() {
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        HapticFeedback.vibrate();
      case TargetPlatform.iOS:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        break;
    }
  }

  void _updateSelection(DateTime date) {
    _vibrate();
    setState(() {
      if (_startDate != null &&
          _endDate == null &&
          !date.isBefore(_startDate!)) {
        _endDate = date;
        widget.onEndDateChanged?.call(_endDate);
      } else {
        _startDate = date;
        widget.onStartDateChanged?.call(_startDate!);
        if (_endDate != null) {
          _endDate = null;
          widget.onEndDateChanged?.call(_endDate);
        }
      }
    });
  }

  Widget _buildMonthItem(
      BuildContext context, int index, bool beforeInitialMonth) {
    final int monthIndex = beforeInitialMonth
        ? _initialMonthIndex - index - 1
        : _initialMonthIndex + index;
    final DateTime month =
        DateUtils.addMonthsToMonthDate(widget.firstDate, monthIndex);
    return _MonthItem(
      selectedDateStart: _startDate,
      selectedDateEnd: _endDate,
      currentDate: widget.currentDate,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
      displayedMonth: month,
      onChanged: _updateSelection,
      intervalColor: widget.intervalColor,
      selectedColor: widget.selectedColor,
      selectedTextColor: widget.selectedTextColor,
      enableTextColor: widget.enableTextColor,
      disableTextColor: widget.disableTextColor,
      selectedShape: widget.selectedShape,
    );
  }

  @override
  Widget build(BuildContext context) {
    const Key sliverAfterKey = Key('sliverAfterKey');

    return Column(
      children: <Widget>[
        const _DayHeaders(),
        if (_showWeekBottomDivider) const Divider(height: 0),
        Expanded(
          child: _CalendarKeyboardNavigator(
            firstDate: widget.firstDate,
            lastDate: widget.lastDate,
            initialFocusedDay:
                _startDate ?? widget.initialStartDate ?? widget.currentDate,
            // In order to prevent performance issues when displaying the
            // correct initial month, 2 `SliverList`s are used to split the
            // months. The first item in the second SliverList is the initial
            // month to be displayed.
            child: CustomScrollView(
              key: _scrollViewKey,
              controller: _controller,
              center: sliverAfterKey,
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) =>
                        _buildMonthItem(context, index, true),
                    childCount: _initialMonthIndex,
                  ),
                ),
                SliverList(
                  key: sliverAfterKey,
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) =>
                        _buildMonthItem(context, index, false),
                    childCount: _numberOfMonths - _initialMonthIndex,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MonthItem extends StatefulWidget {
  /// Creates a month item.
  _MonthItem({
    required this.selectedDateStart,
    required this.selectedDateEnd,
    required this.currentDate,
    required this.onChanged,
    required this.firstDate,
    required this.lastDate,
    required this.displayedMonth,
    required this.intervalColor,
    required this.selectedColor,
    required this.selectedTextColor,
    required this.enableTextColor,
    required this.disableTextColor,
    required this.selectedShape,
  })  : assert(!firstDate.isAfter(lastDate)),
        assert(selectedDateStart == null ||
            !selectedDateStart.isBefore(firstDate)),
        assert(selectedDateEnd == null || !selectedDateEnd.isBefore(firstDate)),
        assert(
            selectedDateStart == null || !selectedDateStart.isAfter(lastDate)),
        assert(selectedDateEnd == null || !selectedDateEnd.isAfter(lastDate)),
        assert(selectedDateStart == null ||
            selectedDateEnd == null ||
            !selectedDateStart.isAfter(selectedDateEnd));

  final DateTime? selectedDateStart;

  final DateTime? selectedDateEnd;

  final DateTime currentDate;

  final ValueChanged<DateTime> onChanged;

  final DateTime firstDate;

  final DateTime lastDate;

  final DateTime displayedMonth;

  final Color intervalColor;

  final Color selectedColor;

  final Color selectedTextColor;

  final Color enableTextColor;

  final Color disableTextColor;

  final BoxShape selectedShape;

  @override
  _MonthItemState createState() => _MonthItemState();
}

class _MonthItemState extends State<_MonthItem> {
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
    final DateTime? focusedDate = _FocusedDate.maybeOf(context)?.date;
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

  void _dayFocusChanged(bool focused) {
    if (focused) {
      final TraversalDirection? focusDirection =
          _FocusedDate.maybeOf(context)?.scrollDirection;
      if (focusDirection != null) {
        ScrollPositionAlignmentPolicy policy =
            ScrollPositionAlignmentPolicy.explicit;
        switch (focusDirection) {
          case TraversalDirection.up:
          case TraversalDirection.left:
            policy = ScrollPositionAlignmentPolicy.keepVisibleAtStart;
          case TraversalDirection.right:
          case TraversalDirection.down:
            policy = ScrollPositionAlignmentPolicy.keepVisibleAtEnd;
        }
        Scrollable.ensureVisible(
          primaryFocus!.context!,
          duration: _monthScrollDuration,
          alignmentPolicy: policy,
        );
      }
    }
  }

  Widget _buildDayItem(BuildContext context, DateTime dayToBuild,
      int firstDayOffset, int daysInMonth) {
    final int day = dayToBuild.day;

    final bool isDisabled = dayToBuild.isAfter(widget.lastDate) ||
        dayToBuild.isBefore(widget.firstDate);
    final bool isRangeSelected =
        widget.selectedDateStart != null && widget.selectedDateEnd != null;
    final bool isSelectedDayStart = widget.selectedDateStart != null &&
        dayToBuild.isAtSameMomentAs(widget.selectedDateStart!);
    final bool isSelectedDayEnd = widget.selectedDateEnd != null &&
        dayToBuild.isAtSameMomentAs(widget.selectedDateEnd!);
    final bool isInRange = isRangeSelected &&
        dayToBuild.isAfter(widget.selectedDateStart!) &&
        dayToBuild.isBefore(widget.selectedDateEnd!);
    final bool isOneDayRange =
        isRangeSelected && widget.selectedDateStart == widget.selectedDateEnd;
    final bool isToday = DateUtils.isSameDay(widget.currentDate, dayToBuild);

    return _DayItem(
      day: dayToBuild,
      focusNode: _dayFocusNodes[day - 1],
      onChanged: widget.onChanged,
      onFocusChange: _dayFocusChanged,
      intervalColor: widget.intervalColor,
      selectedColor: widget.selectedColor,
      selectedTextColor: widget.selectedTextColor,
      enableTextColor: widget.enableTextColor,
      disableTextColor: widget.disableTextColor,
      selectedShape: widget.selectedShape,
      isDisabled: isDisabled,
      isRangeSelected: isRangeSelected,
      isSelectedDayStart: isSelectedDayStart,
      isSelectedDayEnd: isSelectedDayEnd,
      isInRange: isInRange,
      isOneDayRange: isOneDayRange,
      isToday: isToday,
    );
  }

  Widget _buildEdgeContainer(BuildContext context, bool isHighlighted) {
    return Container(color: isHighlighted ? widget.intervalColor : null);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final int year = widget.displayedMonth.year;
    final int month = widget.displayedMonth.month;
    final int daysInMonth = DateUtils.getDaysInMonth(year, month);
    final int dayOffset = DateUtils.firstDayOffset(year, month, localizations);
    final int weeks = ((daysInMonth + dayOffset) / DateTime.daysPerWeek).ceil();
    final double gridHeight =
        weeks * _monthItemRowHeight + (weeks - 1) * _monthItemSpaceBetweenRows;
    final List<Widget> dayItems = <Widget>[];

    // 1-based day of month, e.g. 1-31 for January, and 1-29 for February on
    // a leap year.
    for (int day = 0 - dayOffset + 1; day <= daysInMonth; day += 1) {
      if (day < 1) {
        dayItems.add(Container());
      } else {
        final DateTime dayToBuild = DateTime(year, month, day);
        final Widget dayItem = _buildDayItem(
          context,
          dayToBuild,
          dayOffset,
          daysInMonth,
        );
        dayItems.add(dayItem);
      }
    }

    // Add the leading/trailing edge containers to each week in order to
    // correctly extend the range highlight.
    final List<Widget> paddedDayItems = <Widget>[];
    for (int i = 0; i < weeks; i++) {
      final int start = i * DateTime.daysPerWeek;
      final int end = math.min(
        start + DateTime.daysPerWeek,
        dayItems.length,
      );
      final List<Widget> weekList = dayItems.sublist(start, end);

      final DateTime dateAfterLeadingPadding =
          DateTime(year, month, start - dayOffset + 1);
      // Only color the edge container if it is after the start date and
      // on/before the end date.
      final bool isLeadingInRange = !(dayOffset > 0 && i == 0) &&
          widget.selectedDateStart != null &&
          widget.selectedDateEnd != null &&
          dateAfterLeadingPadding.isAfter(widget.selectedDateStart!) &&
          !dateAfterLeadingPadding.isAfter(widget.selectedDateEnd!);
      weekList.insert(0, _buildEdgeContainer(context, isLeadingInRange));

      // Only add a trailing edge container if it is for a full week and not a
      // partial week.
      if (end < dayItems.length ||
          (end == dayItems.length &&
              dayItems.length % DateTime.daysPerWeek == 0)) {
        final DateTime dateBeforeTrailingPadding =
            DateTime(year, month, end - dayOffset);
        // Only color the edge container if it is on/after the start date and
        // before the end date.
        final bool isTrailingInRange = widget.selectedDateStart != null &&
            widget.selectedDateEnd != null &&
            !dateBeforeTrailingPadding.isBefore(widget.selectedDateStart!) &&
            dateBeforeTrailingPadding.isBefore(widget.selectedDateEnd!);
        weekList.add(_buildEdgeContainer(context, isTrailingInRange));
      }

      paddedDayItems.addAll(weekList);
    }

    final double maxWidth =
        MediaQuery.orientationOf(context) == Orientation.landscape
            ? _maxCalendarWidthLandscape
            : _maxCalendarWidthPortrait;
    return Column(
      children: <Widget>[
        Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          height: _monthItemHeaderHeight,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: AlignmentDirectional.centerStart,
          child: ExcludeSemantics(
            child: Text(
              localizations.formatMonthYear(widget.displayedMonth),
              style: textTheme.bodyMedium!
                  .apply(color: themeData.colorScheme.onSurface),
            ),
          ),
        ),
        Container(
          constraints: BoxConstraints(
            maxWidth: maxWidth,
            maxHeight: gridHeight,
          ),
          child: GridView.custom(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: _monthItemGridDelegate,
            childrenDelegate: SliverChildListDelegate(
              paddedDayItems,
              addRepaintBoundaries: false,
            ),
          ),
        ),
        const SizedBox(height: _monthItemFooterHeight),
      ],
    );
  }
}

class _DayItem extends StatefulWidget {
  const _DayItem({
    required this.day,
    required this.focusNode,
    required this.onChanged,
    required this.onFocusChange,
    required this.intervalColor,
    required this.selectedColor,
    required this.selectedTextColor,
    required this.enableTextColor,
    required this.disableTextColor,
    required this.isDisabled,
    required this.isRangeSelected,
    required this.isSelectedDayStart,
    required this.isSelectedDayEnd,
    required this.isInRange,
    required this.isOneDayRange,
    required this.isToday,
    required this.selectedShape,
  });

  final DateTime day;

  final FocusNode focusNode;

  final ValueChanged<DateTime> onChanged;

  final ValueChanged<bool> onFocusChange;

  final Color intervalColor;

  final Color selectedColor;

  final Color selectedTextColor;

  final Color enableTextColor;

  final Color disableTextColor;

  final bool isDisabled;

  final bool isRangeSelected;

  final bool isSelectedDayStart;

  final bool isSelectedDayEnd;

  final bool isInRange;

  final bool isOneDayRange;

  final bool isToday;

  final BoxShape selectedShape;

  @override
  State<_DayItem> createState() => _DayItemState();
}

class _DayItemState extends State<_DayItem> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final TextDirection textDirection = Directionality.of(context);
    final Color intervalColor = widget.intervalColor;

    BoxDecoration? decoration;
    TextStyle? itemStyle = textTheme.bodyMedium;

    _HighlightPainter? highlightPainter;

    itemStyle = textTheme.bodyMedium?.apply(color: widget.enableTextColor);

    if (widget.isSelectedDayStart || widget.isSelectedDayEnd) {
      itemStyle = textTheme.bodyMedium?.apply(color: widget.selectedTextColor);
      decoration = BoxDecoration(
        color: widget.selectedColor,
        shape: widget.selectedShape,
        borderRadius: widget.selectedShape == BoxShape.rectangle
            ? BorderRadius.circular(4)
            : null,
      );

      if (widget.isRangeSelected && !widget.isOneDayRange) {
        final _HighlightPainterStyle style = widget.isSelectedDayStart
            ? _HighlightPainterStyle.highlightTrailing
            : _HighlightPainterStyle.highlightLeading;
        highlightPainter = _HighlightPainter(
          color: intervalColor,
          style: style,
          textDirection: textDirection,
        );
      }
    } else if (widget.isInRange) {
      // The days within the range get a light background highlight.
      highlightPainter = _HighlightPainter(
        color: intervalColor,
        style: _HighlightPainterStyle.highlightAll,
        textDirection: textDirection,
      );
    } else if (widget.isDisabled) {
      itemStyle = textTheme.bodyMedium?.apply(color: widget.disableTextColor);
    } else if (widget.isToday) {
      // The current day gets a different text color and a circle stroke
      // border.
      itemStyle = textTheme.bodyMedium?.apply(color: widget.selectedColor);
      decoration = BoxDecoration(
        border: Border.all(color: widget.selectedColor),
        shape: widget.selectedShape,
        borderRadius: widget.selectedShape == BoxShape.rectangle
            ? BorderRadius.circular(4)
            : null,
      );
    }

    final String dayText = localizations.formatDecimal(widget.day.day);

    final String semanticLabelSuffix =
        widget.isToday ? ', ${localizations.currentDateLabel}' : '';
    String semanticLabel =
        '$dayText, ${localizations.formatFullDate(widget.day)}$semanticLabelSuffix';
    if (widget.isSelectedDayStart) {
      semanticLabel =
          localizations.dateRangeStartDateSemanticLabel(semanticLabel);
    } else if (widget.isSelectedDayEnd) {
      semanticLabel =
          localizations.dateRangeEndDateSemanticLabel(semanticLabel);
    }

    Widget dayWidget = Container(
      decoration: decoration,
      child: Center(
        child: Semantics(
          label: semanticLabel,
          selected: widget.isSelectedDayStart || widget.isSelectedDayEnd,
          child: ExcludeSemantics(
            child: Text(dayText, style: itemStyle),
          ),
        ),
      ),
    );

    if (highlightPainter != null) {
      dayWidget = CustomPaint(
        painter: highlightPainter,
        child: dayWidget,
      );
    }

    if (!widget.isDisabled) {
      dayWidget = InkResponse(
        focusNode: widget.focusNode,
        onTap: () => widget.onChanged(widget.day),
        radius: _monthItemRowHeight / 2 + 4,
        onFocusChange: widget.onFocusChange,
        child: dayWidget,
      );
    }

    return dayWidget;
  }
}

class _FocusedDate extends InheritedWidget {
  const _FocusedDate({
    required super.child,
    this.date,
    this.scrollDirection,
  });

  final DateTime? date;
  final TraversalDirection? scrollDirection;

  @override
  bool updateShouldNotify(_FocusedDate oldWidget) {
    return !DateUtils.isSameDay(date, oldWidget.date) ||
        scrollDirection != oldWidget.scrollDirection;
  }

  static _FocusedDate? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_FocusedDate>();
  }
}

class _DayHeaders extends StatelessWidget {
  const _DayHeaders();

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
  List<Widget> _getDayHeaders(
      TextStyle headerStyle, MaterialLocalizations localizations) {
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
    final ThemeData themeData = Theme.of(context);
    final ColorScheme colorScheme = themeData.colorScheme;
    final TextStyle textStyle =
        themeData.textTheme.titleSmall!.apply(color: colorScheme.onSurface);
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final List<Widget> labels = _getDayHeaders(textStyle, localizations);

    // Add leading and trailing containers for edges of the custom grid layout.
    labels.insert(0, Container());
    labels.add(Container());

    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.orientationOf(context) == Orientation.landscape
            ? _maxCalendarWidthLandscape
            : _maxCalendarWidthPortrait,
        maxHeight: _monthItemRowHeight,
      ),
      child: GridView.custom(
        shrinkWrap: true,
        gridDelegate: _monthItemGridDelegate,
        childrenDelegate: SliverChildListDelegate(
          labels,
          addRepaintBoundaries: false,
        ),
      ),
    );
  }
}

class _CalendarKeyboardNavigator extends StatefulWidget {
  const _CalendarKeyboardNavigator({
    required this.child,
    required this.firstDate,
    required this.lastDate,
    required this.initialFocusedDay,
  });

  final Widget child;
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime initialFocusedDay;

  @override
  _CalendarKeyboardNavigatorState createState() =>
      _CalendarKeyboardNavigatorState();
}

class _CalendarKeyboardNavigatorState
    extends State<_CalendarKeyboardNavigator> {
  final Map<ShortcutActivator, Intent> _shortcutMap =
      const <ShortcutActivator, Intent>{
    SingleActivator(LogicalKeyboardKey.arrowLeft):
        DirectionalFocusIntent(TraversalDirection.left),
    SingleActivator(LogicalKeyboardKey.arrowRight):
        DirectionalFocusIntent(TraversalDirection.right),
    SingleActivator(LogicalKeyboardKey.arrowDown):
        DirectionalFocusIntent(TraversalDirection.down),
    SingleActivator(LogicalKeyboardKey.arrowUp):
        DirectionalFocusIntent(TraversalDirection.up),
  };
  late Map<Type, Action<Intent>> _actionMap;
  late FocusNode _dayGridFocus;
  TraversalDirection? _dayTraversalDirection;
  DateTime? _focusedDay;

  @override
  void initState() {
    super.initState();

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
  void dispose() {
    _dayGridFocus.dispose();
    super.dispose();
  }

  void _handleGridFocusChange(bool focused) {
    setState(() {
      if (focused) {
        _focusedDay ??= widget.initialFocusedDay;
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
        _dayTraversalDirection = intent.direction;
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
    final DateTime nextDate = DateUtils.addDaysToDate(
        date, _dayDirectionOffset(direction, textDirection));
    if (!nextDate.isBefore(widget.firstDate) &&
        !nextDate.isAfter(widget.lastDate)) {
      return nextDate;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      shortcuts: _shortcutMap,
      actions: _actionMap,
      focusNode: _dayGridFocus,
      onFocusChange: _handleGridFocusChange,
      child: _FocusedDate(
        date: _dayGridFocus.hasFocus ? _focusedDay : null,
        scrollDirection: _dayGridFocus.hasFocus ? _dayTraversalDirection : null,
        child: widget.child,
      ),
    );
  }
}

class _MonthItemGridDelegate extends SliverGridDelegate {
  const _MonthItemGridDelegate();

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    final double tileWidth =
        (constraints.crossAxisExtent - 2 * _horizontalPadding) /
            DateTime.daysPerWeek;
    return _MonthSliverGridLayout(
      crossAxisCount: DateTime.daysPerWeek + 2,
      dayChildWidth: tileWidth,
      edgeChildWidth: _horizontalPadding,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(_MonthItemGridDelegate oldDelegate) => false;
}

class _MonthSliverGridLayout extends SliverGridLayout {
  /// Creates a layout that uses equally sized and spaced tiles for each day of
  /// the week and an additional edge tile for padding at the start and end of
  /// each row.
  ///
  /// This is necessary to facilitate the painting of the range highlight
  /// correctly.
  const _MonthSliverGridLayout({
    required this.crossAxisCount,
    required this.dayChildWidth,
    required this.edgeChildWidth,
    required this.reverseCrossAxis,
  })  : assert(crossAxisCount > 0),
        assert(dayChildWidth >= 0),
        assert(edgeChildWidth >= 0);

  /// The number of children in the cross axis.
  final int crossAxisCount;

  /// The width in logical pixels of the day child widgets.
  final double dayChildWidth;

  /// The width in logical pixels of the edge child widgets.
  final double edgeChildWidth;

  /// Whether the children should be placed in the opposite order of increasing
  /// coordinates in the cross axis.
  ///
  /// For example, if the cross axis is horizontal, the children are placed from
  /// left to right when [reverseCrossAxis] is false and from right to left when
  /// [reverseCrossAxis] is true.
  ///
  /// Typically set to the return value of [axisDirectionIsReversed] applied to
  /// the [SliverConstraints.crossAxisDirection].
  final bool reverseCrossAxis;

  /// The number of logical pixels from the leading edge of one row to the
  /// leading edge of the next row.
  double get _rowHeight {
    return _monthItemRowHeight + _monthItemSpaceBetweenRows;
  }

  /// The height in logical pixels of the children widgets.
  double get _childHeight {
    return _monthItemRowHeight;
  }

  @override
  int getMinChildIndexForScrollOffset(double scrollOffset) {
    return crossAxisCount * (scrollOffset ~/ _rowHeight);
  }

  @override
  int getMaxChildIndexForScrollOffset(double scrollOffset) {
    final int mainAxisCount = (scrollOffset / _rowHeight).ceil();
    return math.max(0, crossAxisCount * mainAxisCount - 1);
  }

  double _getCrossAxisOffset(double crossAxisStart, bool isPadding) {
    if (reverseCrossAxis) {
      return ((crossAxisCount - 2) * dayChildWidth + 2 * edgeChildWidth) -
          crossAxisStart -
          (isPadding ? edgeChildWidth : dayChildWidth);
    }
    return crossAxisStart;
  }

  @override
  SliverGridGeometry getGeometryForChildIndex(int index) {
    final int adjustedIndex = index % crossAxisCount;
    final bool isEdge =
        adjustedIndex == 0 || adjustedIndex == crossAxisCount - 1;
    final double crossAxisStart =
        math.max(0, (adjustedIndex - 1) * dayChildWidth + edgeChildWidth);

    return SliverGridGeometry(
      scrollOffset: (index ~/ crossAxisCount) * _rowHeight,
      crossAxisOffset: _getCrossAxisOffset(crossAxisStart, isEdge),
      mainAxisExtent: _childHeight,
      crossAxisExtent: isEdge ? edgeChildWidth : dayChildWidth,
    );
  }

  @override
  double computeMaxScrollOffset(int childCount) {
    assert(childCount >= 0);
    final int mainAxisCount = ((childCount - 1) ~/ crossAxisCount) + 1;
    final double mainAxisSpacing = _rowHeight - _childHeight;
    return _rowHeight * mainAxisCount - mainAxisSpacing;
  }
}
