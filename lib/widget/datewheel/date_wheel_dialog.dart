import 'package:bookkeeping/data/bean/journal_month_bean.dart';
import 'package:bookkeeping/widget/datewheel/date_wheel_scroll_view.dart';
import 'package:flutter/material.dart';

class DateWheelDialog extends StatefulWidget {
  final DateTime? initSelectedDate;
  final List<YearWheel> years;
  final ValueChanged<DateTime> onChanged;

  const DateWheelDialog({
    super.key,
    this.initSelectedDate,
    required this.onChanged,
    required this.years,
  });

  @override
  State<DateWheelDialog> createState() => _DateWheelDialogState();

  static showDatePicker(
    BuildContext context, {
    DateTime? initSelectedDate,
    required List<YearWheel> years,
    required ValueChanged<DateTime> onChanged,
    required VoidCallback onClose,
  }) {
    var rootContext = Navigator.of(context, rootNavigator: true).context;
    showModalBottomSheet(
      context: rootContext,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      scrollControlDisabledMaxHeightRatio: 0.4,
      builder: (BuildContext context) {
        return DateWheelDialog(
          initSelectedDate: initSelectedDate,
          years: years,
          onChanged: onChanged,
        );
      },
    ).then((value) {
      onClose();
    });
  }
}

class _DateWheelDialogState extends State<DateWheelDialog> {
  DateTime? changeDateTime;

  @override
  void initState() {
    changeDateTime = widget.initSelectedDate;
    super.initState();
  }

  void _onDateChangeCallback(int year, int month, int day) {
    setState(() {
      changeDateTime = DateTime(year, month, day);
    });
  }

  void _onSelectedDate(BuildContext context, DateTime data) {
    widget.onChanged(data);
    Navigator.of(context).pop();
  }

  void _onClose(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        Expanded(
          child: DateWheelScrollView(
            years: widget.years,
            initSelectedDate: widget.initSelectedDate,
            onDateChangeCallback: _onDateChangeCallback,
          ),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                _onClose(context);
              },
              style: TextButton.styleFrom(
                backgroundColor: Color(0xFFF5F5F5),
                minimumSize: Size(120, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: Text(
                "取消",
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
            ),
            SizedBox(width: 8),
            TextButton(
              onPressed: () {
                _onSelectedDate(context, changeDateTime!);
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: Size(120, 40),
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
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
