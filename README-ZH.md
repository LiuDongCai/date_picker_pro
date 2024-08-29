<h1 align="center">flutter_date_picker</h1>
<h4 align="center">
  日期选择器，目前提供日期范围选择，未来将提供更多功能
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
  <a href="#license">License</a>
</p>

> [Feedback welcome](https://github.com/LiuDongCai/flutter_date_picker/issues) and [Pull Requests](https://github.com/LiuDongCai/flutter_date_picker/pulls) are most welcome!

[**English**](https://github.com/LiuDongCai/flutter_date_picker/blob/master/README-ZH.md) | 中文

## Usage

### Import the package

要使用这个库，点击[**pub.dev-flutter_date_picker**](https://pub.dev/packages/flutter_date_picker).

### Use

使用示例如下：

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

| API               | 描述                                        |
|-------------------|-------------------------------------------|
| controller        | 控制器，提供 reset() and getDateTimeRange()  方法 |
| initialDateRange  | 初始化所选日期范围                                 |
| firstDate         | 第一个可以选择的日期                                |
| lastDate          | 最后一个可以选择的日期                               |
| intervalColor     | 所选日期范围区间的颜色                               |
| selectedColor     | 选中日期的颜色                                   |
| selectedTextColor | 选中日期的文本颜色                                 |
| enableTextColor   | 可选日期的文本颜色                                 |
| disableTextColor  | 不可选日期的文本颜色                                |
| selectedShape     | 选中日期的形状，含矩形、圆形                            |


## Issues and Feedback

请[**提交问题**](https://github.com/LiuDongCai/flutter_date_picker/issues) 以发送反馈或报告错误。谢谢！

## License

MIT