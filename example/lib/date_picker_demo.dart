import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:date_picker_pro/date_picker.dart';

class DatePickerDemoPage extends StatefulWidget {
  @override
  _DatePickerDemoPageState createState() => _DatePickerDemoPageState();
}

class _DatePickerDemoPageState extends State<DatePickerDemoPage> {
  DatePickerController? datePickerController;

  @override
  void initState() {
    super.initState();
    datePickerController = DatePickerController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Date Picker Example'),
      ),
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 340,
            child: DatePicker(
              controller: datePickerController,
              initialDate: DateTime(2024, 8, 15),
              currentDate: DateTime(2024, 8, 16),
              firstDate: DateTime(2021, 8, 1),
              lastDate: DateTime(2024, 9, 28),
              selectableDayPredicate: (DateTime date) {
                // Only weekdays (Monday to Friday) are allowed to be selected
                if (date.weekday == DateTime.saturday ||
                    date.weekday == DateTime.sunday) {
                  return false;
                }
                return true;
              },
              onDateChanged: (DateTime date) {
                _toast('Selected date: $date');
              },
              onDisplayedMonthChanged: (DateTime date) {
                _toast('Displayed month: ${date.month}');
              },
              selectedColor: Colors.blue,
              selectedTextColor: Colors.white,
              enableTextColor: Colors.black,
              disableTextColor: Colors.grey,
              selectedShape: BoxShape.circle,
              monthHeaderItemHeight: 40,
              backgroundColor: Colors.white,
              monthTextStyle: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          Row(
            children: [
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    datePickerController?.setCurrentDate(DateTime(2024, 8, 20));
                    _toast('setCurrentDate');
                  },
                  child: const Text('setCurrentDate'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    datePickerController?.setSelectedDate(DateTime(2024, 8, 8));
                    _toast('setSelectedDate');
                  },
                  child: const Text('setSelectedDate'),
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
                    datePickerController?.setEnableTextColor(Colors.green);
                    _toast('setEnableTextColor');
                  },
                  child: const Text('setEnableTextColor'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    datePickerController
                        ?.setDisableTextColor(Colors.green.shade100);
                    _toast('setDisableTextColor');
                  },
                  child: const Text(
                    'setDisableTextColor',
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
                    datePickerController?.setSelectedTextColor(Colors.blue);
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
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    datePickerController?.setSelectedColor(Colors.red.shade300);
                    _toast('setSelectedColor');
                  },
                  child: const Text('setSelectedColor'),
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
                    datePickerController?.setSelectedShape(BoxShape.rectangle);
                    _toast('setSelectedShape');
                  },
                  child: const Text(
                    'setSelectedShape',
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    datePickerController
                        ?.setBackgroundColor(Colors.amberAccent);
                    _toast('setBackgroundColor');
                  },
                  child: const Text(
                    'setBackgroundColor',
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
                    datePickerController?.setMonthHeaderItemHeight(35);
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
                    datePickerController?.setMonthTextStyle(const TextStyle(
                      fontSize: 16,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ));
                    _toast('setMonthTextStyle');
                  },
                  child: const Text(
                    'setMonthTextStyle',
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
