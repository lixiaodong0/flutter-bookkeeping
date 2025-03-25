import 'package:bookkeeping/cache/picker_date_cache.dart';
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

class CalendarPickerWidget extends StatefulWidget {
  final DateTime defaultDate;
  final ValueChanged<DateTime> onChanged;

  const CalendarPickerWidget({
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
  State<CalendarPickerWidget> createState() => _CalendarPickerWidgetState();

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
        return CalendarPickerWidget(defaultDate: defaultDate, onChanged: onChanged);
      },
    );
  }
}

class _CalendarPickerWidgetState extends State<CalendarPickerWidget> {
  final ScrollController _scrollController = ScrollController();
  List<DateBean> _list = [];

  @override
  void initState() {
    super.initState();
    // 确保在布局完成后滚动到底部
    // fix: 使用reverse: true 方式 解决_scrollController.jumpTo 数据量大有延迟卡顿问题
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   // _scrollController.jumpTo(_list.length-1);
    // });
    _initData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _initData() async {
    List<DateBean> list = PickerDateCache().list;
    setState(() {
      _list = list;
    });
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
      reverse: true,
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
