import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:date_picker_pro/date_picker.dart';

class DateRangePickerDemoPage extends StatefulWidget {
  @override
  _DateRangePickerDemoPageState createState() =>
      _DateRangePickerDemoPageState();
}

class _DateRangePickerDemoPageState extends State<DateRangePickerDemoPage> {
  DateRangePickerController? dateRangePickerController;

  @override
  void initState() {
    super.initState();
    dateRangePickerController = DateRangePickerController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Date Range Picker Example'),
      ),
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 340,
            child: DateRangePicker(
              controller: dateRangePickerController,
              initialDateRange: DateTimeRange(
                start: DateTime(2024, 10, 8),
                end: DateTime(2024, 10, 28),
              ),
              currentDate: DateTime.now(),
              isShowToday: false,
              firstDate: DateTime(2024, 10, 6),
              lastDate: DateTime(2024, 10, 30),
              intervalColor: Colors.blueGrey.shade50,
              selectedColor: Colors.blue,
              selectedTextColor: Colors.white,
              enableTextColor: Colors.black,
              disableTextColor: Colors.grey,
              selectedShape: BoxShape.circle,
              monthHeaderItemHeight: 40,
              monthHeaderColor: Colors.grey.shade300,
              backgroundColor: Colors.white,
              monthTextStyle: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
              onDateTimeRangeChanged: (DateTimeRange? dateTimeRange) {
                debugPrint('$dateTimeRange');
              },
            ),
          ),
          Row(
            children: [
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    dateRangePickerController?.reset();
                    _toast('Reset');
                  },
                  child: const Text('Reset'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    final DateTimeRange? dateTimeRange =
                        dateRangePickerController?.getDateTimeRange();
                    if (dateTimeRange != null) {
                      _toast(
                        'Start date: ${dateTimeRange.start}\nEnd date: ${dateTimeRange.end}',
                      );
                    } else {
                      _toast('No date selected');
                    }
                  },
                  child: const Text('Get Date Range'),
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
          Row(
            children: [
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    dateRangePickerController?.setInitialDateRange(
                      DateTimeRange(
                        start: DateTime(2024, 8, 11),
                        end: DateTime(2024, 8, 17),
                      ),
                    );
                    _toast('setInitialDateRange');
                  },
                  child: const Text('setInitialDateRange\n8.11-8.17'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    dateRangePickerController
                        ?.setIntervalColor(Colors.red.shade50);
                    _toast('setIntervalColor');
                  },
                  child: const Text('setIntervalColor'),
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
          Row(
            children: [
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    dateRangePickerController
                        ?.setSelectedColor(Colors.red.shade300);
                    _toast('setSelectedColor');
                  },
                  child: const Text('setSelectedColor'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    dateRangePickerController
                        ?.setSelectedTextColor(Colors.blue);
                    _toast('setSelectedTextColor');
                  },
                  child: const Text(
                    'setSelectedTextColor',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
          Row(
            children: [
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    dateRangePickerController?.setEnableTextColor(Colors.green);
                    _toast('setEnableTextColor');
                  },
                  child: const Text('setEnableTextColor'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    dateRangePickerController
                        ?.setDisableTextColor(Colors.green.shade100);
                    _toast('setDisableTextColor');
                  },
                  child: const Text(
                    'setDisableTextColor',
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
          Row(
            children: [
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    dateRangePickerController
                        ?.setSelectedShape(BoxShape.rectangle);
                    _toast('setSelectedShape');
                  },
                  child: const Text('setSelectedShape'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    dateRangePickerController?.setBackgroundColor(Colors.amber);
                    _toast('setBackgroundColor');
                  },
                  child: const Text(
                    'setBackgroundColor',
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
          Row(
            children: [
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    dateRangePickerController?.setMonthHeaderItemHeight(50);
                    _toast('setMonthHeaderItemHeight');
                  },
                  child: const Text(
                    'setMonthHeaderItemHeight',
                    style: TextStyle(
                      fontSize: 9,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    dateRangePickerController
                        ?.setMonthHeaderColor(Colors.amber.shade100);
                    _toast('setMonthHeaderColor');
                  },
                  child: const Text(
                    'setMonthHeaderColors',
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
          Row(
            children: [
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    dateRangePickerController?.setMonthTextStyle(
                      const TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                    _toast('setMonthTextStyle');
                  },
                  child: const Text(
                    'setMonthTextStyle',
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    dateRangePickerController?.setCurrentDate(
                      DateTime(2024, 8, 29),
                    );
                    _toast('setCurrentDate');
                  },
                  child: const Text(
                    'setCurrentDate',
                  ),
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ],
      ),
    );
  }

  /// Show toast message
  _toast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
    );
  }
}
