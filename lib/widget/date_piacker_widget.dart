import 'package:flutter/cupertino.dart';

class DatePickerWidget extends StatefulWidget {
  final DateTime date;
  final ValueChanged<DateTime> onChanged;

  const DatePickerWidget({
    super.key,
    required this.date,
    required this.onChanged,
  });

  @override
  State<DatePickerWidget> createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Text("");
  }
}