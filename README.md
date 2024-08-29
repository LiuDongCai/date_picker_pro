<h1 align="center">date_picker_pro</h1>
<h4 align="center">
  date_picker_pro,Provide date range select,More will be provided in the future
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

### How to use

Add the following import to your Dart code:

```dart
    import 'package:date_picker_pro/date_picker.dart';

    DateRangePicker(
        controller: dateRangePickerController,
        initialDateRange: DateTimeRange(
          start: DateTime(2024,8,1),
          end: DateTime(2024,8,30),
        ),
        firstDate: DateTime(2023),
        lastDate: DateTime(2025),
        intervalColor: Colors.blueGrey.shade50,
        selectedColor: Colors.blue,
        selectedTextColor: Colors.white,
        enableTextColor: Colors.black,
        disableTextColor: Colors.grey,
        selectedShape: BoxShape.rectangle,
    )
```

| API               | description                                                |
|-------------------|------------------------------------------------------------|
| controller        | Controller, provide reset() and getDateTimeRange() methods |
| initialDateRange  | Initialize the selected range                              |
| firstDate         | The first date that can be selected                        |
| lastDate          | The last date that can be selected                         |
| intervalColor     | The color of the selected range's interval                 |
| selectedColor     | Selected date color                                        |
| selectedTextColor | The text color of the selected date                        |
| enableTextColor   | The text color of selectable dates                         |
| disableTextColor  | The text color of dates that cannot be selected            |
| selectedShape     | Select the shape of the date                               |

##### Sample([Source Code](/example/lib/main.dart))
https://github.com/user-attachments/assets/4c0620ca-43c9-4c94-b06f-8b8ed43b1c05

## Issues and Feedback

Please [**file**](https://github.com/LiuDongCai/date_picker_pro/issues) issues to send feedback or report a bug. Thank you !

## License

MIT
