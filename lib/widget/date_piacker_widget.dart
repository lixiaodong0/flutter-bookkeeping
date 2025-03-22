import 'package:bookkeeping/util/date_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class DateBean {
  final int year;
  final int month;
  List<DaysBean> days = [];

  DateBean({required this.year, required this.month, required this.days});
}

class DaysBean {
  final int year;
  final int month;
  final int day;
  bool isPlaceholder;
  bool isEnabled;

  DaysBean({
    required this.year,
    required this.month,
    required this.day,
    this.isPlaceholder = false,
    this.isEnabled = true,
  });

  static DaysBean placeholder() {
    return DaysBean(year: 0, month: 0, day: 0, isPlaceholder: true);
  }
}

class DatePickerWidget extends StatefulWidget {
  final DateTime defaultDate;
  final ValueChanged<DateTime> onChanged;

  const DatePickerWidget({
    super.key,
    required this.defaultDate,
    required this.onChanged,
  });

  void _onSelectedDate(BuildContext context, DateTime date) {
    onChanged(date);
    Navigator.of(context).pop();
  }

  void _onClose(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  State<DatePickerWidget> createState() => _DatePickerWidgetState();

  static showDatePicker(
    BuildContext context, {
    required DateTime defaultDate,
    required ValueChanged<DateTime> onChanged,
  }) {
    var rootContext = Navigator.of(context, rootNavigator: true).context;
    showModalBottomSheet(
      context: rootContext,
      backgroundColor: Color.fromRGBO(237, 237, 237, 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      scrollControlDisabledMaxHeightRatio: 0.6,
      builder: (BuildContext context) {
        return DatePickerWidget(defaultDate: defaultDate, onChanged: onChanged);
      },
    );
  }
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  final ScrollController _scrollController = ScrollController();
  List<DateBean> _list = [];

  @override
  void initState() {
    super.initState();
    // 确保在布局完成后滚动到底部
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
    _initData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _initData() async {
    List<DateBean> list = [];

    //最多可选一年内
    var now = DateTime.now();
    var lastYear = now.copyWith(year: now.year - 1);

    for (int i = lastYear.month; i <= 12; i++) {
      var next = lastYear.copyWith(month: i);
      list.add(
        DateBean(year: next.year, month: next.month, days: getDays(next, now)),
      );
    }

    for (int i = 1; i <= now.month; i++) {
      var next = now.copyWith(month: i);
      list.add(
        DateBean(year: next.year, month: next.month, days: getDays(next, now)),
      );
    }

    setState(() {
      _list = list;
    });
  }

  List<DaysBean> getDays(DateTime date, DateTime now) {
    var daysCount = 0;

    if (date.month == 2) {
      if (date.year % 4 == 0) {
        daysCount = 29;
      } else {
        daysCount = 28;
      }
    } else {
      if (date.month == 1 ||
          date.month == 3 ||
          date.month == 5 ||
          date.month == 7 ||
          date.month == 8 ||
          date.month == 10 ||
          date.month == 12) {
        daysCount = 31;
      } else if (date.month == 4 ||
          date.month == 6 ||
          date.month == 9 ||
          date.month == 11) {
        daysCount = 30;
      }
    }

    List<DaysBean> list = [];
    for (int i = 1; i <= daysCount; i++) {
      date.copyWith(day: i);

      var isEnabled = true;
      if (date.year == now.year && date.month == now.month) {
        if (i > now.day) {
          isEnabled = false;
        }
      }
      list.add(
        DaysBean(
          year: date.year,
          month: date.month,
          day: i,
          isEnabled: isEnabled,
        ),
      );
    }

    //美观 排序对其作用
    var firstDay = date.copyWith(day: 1);
    if (firstDay.weekday != DateTime.sunday) {
      for (int i = 0; i < firstDay.weekday; i++) {
        list.insert(0, DaysBean.placeholder());
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          _topToolbarContainer(),
          Padding(padding: EdgeInsets.symmetric(vertical: 4)),
          _weekContainer(),
          Divider(height: 1),
          Expanded(child: _dateContainer()),
        ],
      ),
    );
  }

  Widget _topToolbarContainer() {
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
                widget._onClose(context);
              },
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Text(
            "请选择时间",
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _weekContainer() {
    return SizedBox(
      height: 30,
      child: GridView.count(
        crossAxisCount: 7,
        childAspectRatio: 1,
        padding: EdgeInsets.symmetric(horizontal: 16),
        crossAxisSpacing: 10,
        children: [
          Text(
            "日",
            style: TextStyle(color: Colors.grey, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          Text(
            "一",
            style: TextStyle(color: Colors.grey, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          Text(
            "二",
            style: TextStyle(color: Colors.grey, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          Text(
            "三",
            style: TextStyle(color: Colors.grey, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          Text(
            "四",
            style: TextStyle(color: Colors.grey, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          Text(
            "五",
            style: TextStyle(color: Colors.grey, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          Text(
            "六",
            style: TextStyle(color: Colors.grey, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _dateContainer() {
    return ListView.builder(
      controller: _scrollController,

      itemCount: _list.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        var item = _list[index];
        return Column(
          children: [
            Padding(padding: EdgeInsets.all(10)),
            Text(
              "${item.year}年${item.month}月",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            Padding(padding: EdgeInsets.all(10)),
            _monthGridContainer(item.days),
          ],
        );
      },
    );
  }

  Widget _monthGridContainer(List<DaysBean> list) {
    List<Widget> children = [];
    for (var value in list) {
      if (value.isPlaceholder) {
        children.add(_dayPlaceholderItem());
      } else {
        children.add(_dayItem(value));
      }
    }
    return GridView.count(
      crossAxisCount: 7,
      childAspectRatio: 1,
      padding: EdgeInsets.symmetric(horizontal: 16),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      // 禁用滚动
      children: children,
    );
  }

  Widget _dayPlaceholderItem() {
    return Spacer();
  }

  Widget _dayItem(DaysBean data) {
    var isSameDay = DateUtil.isSameDay(
      data.year,
      data.month,
      data.day,
      widget.defaultDate,
    );
    Color color = data.isEnabled ? Colors.black : Colors.grey;
    if (isSameDay) {
      color = Colors.white;
    }
    Color backgroundColor = isSameDay ? Colors.green : Colors.white;
    return TextButton(
      onPressed: () {
        widget._onSelectedDate(
          context,
          DateTime(data.year, data.month, data.day),
        );
      },
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      child: Text("${data.day}", style: TextStyle(color: color, fontSize: 14)),
    );
  }
}
