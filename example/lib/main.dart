import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:date_picker_pro/date_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DateRangePickerController? dateRangePickerController;

  @override
  void initState() {
    super.initState();
    dateRangePickerController = DateRangePickerController();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Date Picker Example'),
        ),
        body: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 360,
              child: DateRangePicker(
                controller: dateRangePickerController,
                initialDateRange: DateTimeRange(
                  start: DateTime(2024, 8, 8),
                  end: DateTime(2024, 8, 28),
                ),
                firstDate: DateTime(2024, 8, 6),
                lastDate: DateTime(2024, 8, 30),
                intervalColor: Colors.blueGrey.shade50,
                selectedColor: Colors.blue,
                selectedTextColor: Colors.white,
                enableTextColor: Colors.black,
                disableTextColor: Colors.grey,
                selectedShape: BoxShape.circle,
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
                      dateRangePickerController
                          ?.setEnableTextColor(Colors.green);
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
                  child: Container(),
                ),
                const SizedBox(width: 16),
              ],
            ),
          ],
        ),
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
