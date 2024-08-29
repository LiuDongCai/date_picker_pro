import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_date_picker/date_picker.dart';

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
          title: const Text('Detect Screenshot Callback Example'),
        ),
        body: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 360,
              child: DateRangePicker(
                controller: dateRangePickerController,
                initialDateRange: DateTimeRange(
                  start: DateTime(2024, 8, 1),
                  end: DateTime(2024, 8, 30),
                ),
                firstDate: DateTime(2023),
                lastDate: DateTime(2025),
                intervalColor: Colors.blueGrey.shade50,
                selectedColor: Colors.blue,
                selectedTextColor: Colors.white,
                enableTextColor: Colors.black,
                disableTextColor: Colors.grey,
                selectedShape: BoxShape.circle,
              ),
            ),
            Row(
              children: [
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      dateRangePickerController?.reset();
                      Fluttertoast.showToast(
                        msg: 'Reset',
                      );
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
                        Fluttertoast.showToast(
                          msg:
                              'Start date: ${dateTimeRange.start}\nEnd date: ${dateTimeRange.end}',
                        );
                      } else {
                        Fluttertoast.showToast(
                          msg: 'No date selected',
                        );
                      }
                    },
                    child: const Text('Get Date Range'),
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
