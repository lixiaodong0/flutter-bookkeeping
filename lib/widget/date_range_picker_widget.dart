import 'package:bookkeeping/data/bean/journal_month_bean.dart';
import 'package:bookkeeping/widget/date_wheel_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';

class DateRangePickerWidget extends StatelessWidget {
  final DateTime? currentDate;
  final DateWheel dateWheel;
  final ValueChanged<DateTime> onChanged;

  const DateRangePickerWidget({
    super.key,
    this.currentDate,
    required this.onChanged,
    required this.dateWheel,
  });

  static showDatePicker(
    BuildContext context, {
    DateTime? currentDate,
    required DateWheel dateWheel,
    required ValueChanged<DateTime> onChanged,
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
        return DateRangePickerWidget(
          currentDate: currentDate,
          dateWheel: dateWheel,
          onChanged: onChanged,
        );
      },
    ).then((value) {
      onClose();
    });
  }

  void _onSelectedDate(BuildContext context, DateTime data) {
    onChanged(data);
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
        SizedBox(height: 250, child: DateWheelScrollView(dateWheel: dateWheel)),
        // Expanded(
        //   child: SingleChildScrollView(child: Column(children: children)),
        // ),
      ],
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
            "请选择年份",
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _yearGridContainer(
    BuildContext context,
    List<JournalMonthGroupBean> list,
  ) {
    List<Widget> children = [];
    for (var value in list) {
      children.add(_yearItem(context, value));
    }
    return GridView.count(
      crossAxisCount: 4,
      childAspectRatio: 1 / 0.5,
      padding: EdgeInsets.symmetric(horizontal: 16),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      // 禁用滚动
      children: children,
    );
  }

  Widget _yearItem(BuildContext context, JournalMonthGroupBean data) {
    var isSelected = false;
    if (data.year == currentDate?.year) {
      isSelected = true;
    }
    Color textColor = isSelected ? Colors.white : Colors.black;
    Color backgroundColor = isSelected ? Colors.green : Colors.white;
    return TextButton(
      onPressed: () {
        _onSelectedDate(context, DateTime(data.year));
      },
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      child: Text(
        "${data.year}年",
        style: TextStyle(color: textColor, fontSize: 14),
      ),
    );
  }
}
