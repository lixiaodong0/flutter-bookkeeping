import 'package:bookkeeping/util/date_util.dart';
import 'package:bookkeeping/widget/datewheel/date_wheel_dialog.dart';
import 'package:bookkeeping/widget/datewheel/date_wheel_scroll_view.dart';
import 'package:bookkeeping/widget/toast_action_widget.dart';
import 'package:flutter/material.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';

typedef OnDateRangeChangeCallback =
    void Function(DateTime startDate, DateTime endDate);

class ExportDateRangePickerDialog extends StatefulWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final List<YearWheel> years;
  final OnDateRangeChangeCallback onChanged;

  const ExportDateRangePickerDialog({
    super.key,
    this.startDate,
    this.endDate,
    required this.onChanged,
    required this.years,
  });

  static showDatePicker(
    BuildContext context, {
    DateTime? startDate,
    DateTime? endDate,
    required List<YearWheel> years,
    required OnDateRangeChangeCallback onChanged,
    required VoidCallback onClose,
  }) {
    var rootContext = Navigator.of(context, rootNavigator: true).context;
    showModalBottomSheet(
      context: rootContext,
      backgroundColor: Color.fromRGBO(237, 237, 237, 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      scrollControlDisabledMaxHeightRatio: 0.4,
      builder: (BuildContext context) {
        return ExportDateRangePickerDialog(
          startDate: startDate,
          endDate: endDate,
          years: years,
          onChanged: onChanged,
        );
      },
    ).then((value) {
      onClose();
    });
  }

  @override
  State<StatefulWidget> createState() => _DateRangePickerDialogState();
}

class _DateRangePickerDialogState extends State<ExportDateRangePickerDialog> {
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    startDate = widget.startDate;
    endDate = widget.endDate;
    super.initState();
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    if (date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day) {
      return true;
    }
    return false;
  }

  void _onSelectedDate(BuildContext context) {
    if (startDate == null && endDate == null) {
      showErrorActionToast("请选择开始日期或结束日期");
      return;
    }

    DateTime finalStartData;
    DateTime finalEndData;

    if (startDate != null && endDate != null) {
      if (_isSameDay(startDate!, endDate!)) {
        //同一天
        finalStartData = startDate!.copyWith(hour: 0, minute: 0, second: 0);
        finalEndData = endDate!.copyWith(hour: 23, minute: 59, second: 59);
      } else {
        //比大小
        if (startDate!.isBefore(endDate!)) {
          //开始日期>结束日期
          finalStartData = startDate!.copyWith(hour: 0, minute: 0, second: 0);
          finalEndData = endDate!.copyWith(hour: 23, minute: 59, second: 59);
        } else {
          //开始日期>结束日期
          finalStartData = endDate!.copyWith(hour: 0, minute: 0, second: 0);
          finalEndData = startDate!.copyWith(hour: 23, minute: 59, second: 59);
        }
      }
    } else {
      if (startDate == null) {
        //开始日期未填写，取结束日期
        finalStartData = endDate!.copyWith(hour: 0, minute: 0, second: 0);
        finalEndData = endDate!.copyWith(hour: 23, minute: 59, second: 59);
      } else {
        //结束日期未填写，取开始日期
        finalStartData = startDate!.copyWith(hour: 0, minute: 0, second: 0);
        finalEndData = startDate!.copyWith(hour: 23, minute: 59, second: 59);
      }
    }
    widget.onChanged(finalStartData, finalEndData);
    Navigator.of(context).pop();
  }

  void _onClose(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _topToolbarContainer(context),
        Divider(height: 1),

        SizedBox(height: 20),

        _buildDateRangeContainer(
          context,
          "开始日期",
          currentDate: startDate,
          onClick: () {
            DateWheelDialog.showDatePicker(
              context,
              years: widget.years,
              initSelectedDate: startDate,
              onChanged: (data) {
                setState(() {
                  startDate = data;
                });
              },
              onClose: () {},
            );
          },
        ),

        _buildDateRangeContainer(
          context,
          "结束日期",
          currentDate: endDate,
          onClick: () {
            DateWheelDialog.showDatePicker(
              context,
              years: widget.years,
              initSelectedDate: endDate,
              onChanged: (data) {
                setState(() {
                  endDate = data;
                });
              },
              onClose: () {},
            );
          },
        ),
        SizedBox(height: 30),
        TextButton(
          onPressed: () {
            _onSelectedDate(context);
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.green,
            minimumSize: Size(200, 40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          child: Text(
            "确定",
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildDateRangeContainer(
    BuildContext context,
    String title, {
    DateTime? currentDate,
    VoidCallback? onClick,
  }) {
    var dateString =
        currentDate != null
            ? DateUtil.formatYearMonthDay(currentDate)
            : "请选择日期";
    var dateTextColor = currentDate != null ? Colors.green : Colors.grey;
    return InkWell(
      onTap: () {
        onClick?.call();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Row(
          children: [
            Text(title, style: TextStyle(color: Colors.black, fontSize: 16)),
            Spacer(),
            Text(
              dateString,
              style: TextStyle(color: dateTextColor, fontSize: 14),
            ),
            Icon(Icons.navigate_next_rounded),
          ],
        ),
      ),
    );
  }

  Widget _topToolbarContainer(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              padding: EdgeInsets.symmetric(horizontal: 4),
              onPressed: () {
                _onClose(context);
              },
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Text(
            "请选择日期范围",
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
        ),
      ],
    );
  }
}
