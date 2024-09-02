<h1 align="center">date_picker_pro</h1>
<h4 align="center">
  date_picker_pro,Provide date select(DatePicker) and date range select(DateRangePicker),More will be provided in the future,Welcome to provide suggestions
</h4>

<div align="center">
  <a href="https://pub.dev/packages/date_picker_pro">
    <img src="https://img.shields.io/pub/v/date_picker_pro.svg" />
  </a>
  <img src="https://img.shields.io/github/license/LiuDongCai/date_picker_pro" />
</div>

<p align="center">
  <a href="#usage">Usage</a> •
  <a href="#issues-and-feedback">Issues and Feedback</a> •
  <a href="#license">License</a>
</p>

> [Feedback welcome](https://github.com/LiuDongCai/date_picker_pro/issues) and [Pull Requests](https://github.com/LiuDongCai/date_picker_pro/pulls) are most welcome!

English | [**中文**](https://github.com/LiuDongCai/date_picker_pro/blob/master/README-ZH.md)

## Usage

### Import the package

To use this package, follow the [**pub.dev-date_picker_pro**](https://pub.dev/packages/date_picker_pro).

### DatePicker use

Add the following import to your Dart code(DatePicker):

```dart
    import 'package:date_picker_pro/date_picker.dart';

    DatePicker(
        controller: controller,
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
        onDateChanged: (DateTime date) {},
        onDisplayedMonthChanged: (DateTime date) {},
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
    )
```

| API                                                             | description                                              |
|-----------------------------------------------------------------|----------------------------------------------------------|
| controller                                                      | Controller                                               |
| initialDateRange<br/>controller.setInitialDateRange()           | Initialize the selected range                            |
| currentDate<br/>controller.setCurrentDate()                     | Set current date                                         |
| firstDate                                                       | The first date that can be selected                      |
| lastDate                                                        | The last date that can be selected                       |
| onDisplayedMonthChanged                                         | Selected month change callback                           |
| selectedColor<br/>controller.setSelectedColor()                 | Selected date color                                      |
| selectedTextColor<br/>controller.setSelectedTextColor()         | The text color of the selected date                      |
| enableTextColor<br/>controller.setEnableTextColor()             | The text color of selectable dates                       |
| disableTextColor<br/>controller.setDisableTextColor()           | The text color of dates that cannot be selected          |
| selectedShape<br/>controller.setSelectedShape()                 | Select the shape of the date                             |
| onDateChanged                                                   | Select date callback                                     |
| monthTextStyle<br/>controller.setMonthTextStyle()               | Set month text style                                     |
| selectableDayPredicate                                          | Set optional date rules                                  |
| monthHeaderItemHeight<br/>controller.setMonthHeaderItemHeight() | Set the head height of the month                         |
| backgroundColor<br/>controller.setBackgroundColor()             | Set background color                                     |

##### DateRangePicker Sample([Source Code](/example/lib/date_range_picker_demo.dart))
![image](./gif/date_picker.gif)

##### Demo video:
https://github.com/user-attachments/assets/cd3317ac-4cf6-4c99-8b68-a1df5519ac58

### DateRangePicker use

Add the following import to your Dart code(DateRangePicker):

```dart
    import 'package:date_picker_pro/date_picker.dart';

    DateRangePicker(
        controller: dateRangePickerController,
        initialDateRange: DateTimeRange(
          start: DateTime(2024,8,1),
          end: DateTime(2024,8,30),
        ),
        currentDate: DateTime.now(),
        firstDate: DateTime(2023),
        lastDate: DateTime(2025),
        intervalColor: Colors.blueGrey.shade50,
        selectedColor: Colors.blue,
        selectedTextColor: Colors.white,
        enableTextColor: Colors.black,
        disableTextColor: Colors.grey,
        selectedShape: BoxShape.rectangle,
        monthHeaderItemHeight: 40,
        monthHeaderColor: Colors.grey.shade300,
        backgroundColor: Colors.white,
        monthTextStyle: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.normal,
        ),
        onDateTimeRangeChanged: (DateTimeRange? dateTimeRange) {},
    )
```

| API                                                             | description                                              |
|-----------------------------------------------------------------|----------------------------------------------------------|
| controller                                                      | Controller                                               |
| initialDateRange<br/>controller.setInitialDateRange()           | Initialize the selected range                            |
| currentDate<br/>controller.setCurrentDate()                     | Set current date                                         |
| firstDate                                                       | The first date that can be selected                      |
| lastDate                                                        | The last date that can be selected                       |
| intervalColor<br/>controller.setIntervalColor()                 | The color of the selected range's interval               |
| selectedColor<br/>controller.setSelectedColor()                 | Selected date color                                      |
| selectedTextColor<br/>controller.setSelectedTextColor()         | The text color of the selected date                      |
| enableTextColor<br/>controller.setEnableTextColor()             | The text color of selectable dates                       |
| disableTextColor<br/>controller.setDisableTextColor()           | The text color of dates that cannot be selected          |
| selectedShape<br/>controller.setSelectedShape()                 | Select the shape of the date                             |
| onDateTimeRangeChanged                                          | Date range selection callback                            |
| monthTextStyle<br/>controller.setMonthTextStyle()               | Set month text style                                     |
| monthHeaderColor<br/>controller.setMonthHeaderColor()           | Set the background color for the head of the month       |
| monthHeaderItemHeight<br/>controller.setMonthHeaderItemHeight() | Set the head height of the month                         |
| backgroundColor<br/>controller.setBackgroundColor()             | Set background color                                     |
| controller.reset()                                              | Reset the selected date range                            |
| controller.getDateTimeRange()                                   | get the selected date range, return null if not selected |

##### DateRangePicker Sample([Source Code](/example/lib/date_range_picker_demo.dart))
![image](./gif/date_ranger_picker.gif)

##### Demo video:
https://github.com/user-attachments/assets/3abd3861-6ea9-4875-aac5-1a44d9b529b2

## Issues and Feedback

Please [**file**](https://github.com/LiuDongCai/date_picker_pro/issues) issues to send feedback or report a bug. Thank you !

## License

MIT
