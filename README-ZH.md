<h1 align="center">date_picker_pro</h1>
<h4 align="center">
  日期选择器，目前提供日期范围选择，未来将提供更多功能
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

[**English**](https://github.com/LiuDongCai/date_picker_pro/blob/master/README-ZH.md) | 中文

## Usage

### Import the package

要使用这个库，点击[**pub.dev-date_picker_pro**](https://pub.dev/packages/date_picker_pro).

### Use

使用示例如下：

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
    )
```

| API                                                             | 描述                    |
|-----------------------------------------------------------------|-----------------------|
| controller                                                      | 控制器                   |
| initialDateRange<br/>controller.setInitialDateRange()           | 初始化所选日期范围             |
| firstDate                                                       | 第一个可以选择的日期            |
| lastDate                                                        | 最后一个可以选择的日期           |
| intervalColor<br/>controller.setIntervalColor()                 | 所选日期范围区间的颜色           |
| selectedColor<br/>controller.setSelectedColor()                 | 选中日期的颜色               |
| selectedTextColor<br/>controller.setSelectedTextColor()         | 选中日期的文本颜色             |
| enableTextColor<br/>controller.setEnableTextColor()             | 可选日期的文本颜色             |
| disableTextColor<br/>controller.setDisableTextColor()           | 不可选日期的文本颜色            |
| selectedShape<br/>controller.setSelectedShape()                 | 选中日期的形状，含矩形、圆形        |
| onDateTimeRangeChanged                                          | 选中日期范围回调              |
| monthTextStyle<br/>controller.setMonthTextStyle()               | 设置月的文本样式              |
| monthHeaderColor<br/>controller.setMonthHeaderColor()           | 设置月的背景颜色              |
| monthHeaderItemHeight<br/>controller.setMonthHeaderItemHeight() | 设置月的标题高度              |
| backgroundColor<br/>controller.setBackgroundColor()             | 设置背景颜色                |
| controller.reset()                                              | 重置选中日期范围              |
| controller.getDateTimeRange()                                   | 获取选中的日期范围，如果没选返回 null |

##### Sample([Source Code](/example/lib/main.dart))
https://github.com/user-attachments/assets/3abd3861-6ea9-4875-aac5-1a44d9b529b2

## Issues and Feedback

请[**提交问题**](https://github.com/LiuDongCai/date_picker_pro/issues) 以发送反馈或报告错误。谢谢！

## License

MIT
