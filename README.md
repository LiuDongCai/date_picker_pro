<h1 align="center">flutter_date_picker</h1>
<h4 align="center">
  flutter_date_picker,Provide date range select,More will be provided in the future
</h4>

<div align="center">
  <a href="https://pub.dev/packages/flutter_date_picker">
    <img src="https://img.shields.io/pub/v/flutter_date_picker.svg" />
  </a>
  <img src="https://img.shields.io/github/license/LiuDongCai/flutter_date_picker" />
</div>

<p align="center">
  <a href="#usage">Usage</a> •
  <a href="#issues-and-feedback">Issues and Feedback</a> •
  <a href="#author">Author</a> •
  <a href="#license">License</a>
</p>

> [Feedback welcome](https://github.com/LiuDongCai/flutter_date_picker/issues) and [Pull Requests](https://github.com/LiuDongCai/flutter_date_picker/pulls) are most welcome!

## Usage

### Import the package

To use this plugin, follow the [**pub.dev**](https://pub.dev/packages/flutter_date_picker).

### Use

Add the following import to your Dart code:

```dart
    import 'package:flutter_date_picker/date_picker.dart';

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

Initialize ScreenshotCallback with the scopes you want:

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


## Issues and Feedback

Please [**file**](https://github.com/LiuDongCai/flutter_date_picker/issues) issues to send feedback or report a bug. Thank you !

## License

MIT
