import 'package:bookkeeping/data/bean/journal_month_bean.dart';
import 'package:flutter/material.dart';

class YearPickerWidget extends StatelessWidget {
  final DateTime? currentDate;
  final List<JournalMonthGroupBean> allDate;
  final ValueChanged<DateTime> onChanged;

  const YearPickerWidget({
    super.key,
    this.currentDate,
    required this.allDate,
    required this.onChanged,
  });

  static showDatePicker(
    BuildContext context, {
    DateTime? currentDate,
    required List<JournalMonthGroupBean> allDate,
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
        return YearPickerWidget(
          currentDate: currentDate,
          allDate: allDate,
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
    List<Widget> children = [];
    children.add(
      Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: _yearGridContainer(context, allDate),
      ),
    );
    return Column(
      children: [
        _topToolbarContainer(context),
        Divider(height: 1),
        Expanded(
          child: SingleChildScrollView(child: Column(children: children)),
        ),
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
