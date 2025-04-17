import 'package:flutter/material.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';

class DateWheel {
  List<YearWheel> years;

  DateWheel({required this.years});
}

class YearWheel {
  int year;
  List<MonthWheel> months;

  YearWheel({required this.year, required this.months});
}

class MonthWheel {
  int year;
  int month;
  List<DayWheel> days;

  MonthWheel({required this.year, required this.month, required this.days});
}

class DayWheel {
  int year;
  int month;
  int day;

  DayWheel({required this.year, required this.month, required this.day});
}

class DateWheelScrollView extends StatefulWidget {
  final DateWheel dateWheel;

  const DateWheelScrollView({super.key, required this.dateWheel});

  @override
  State createState() => _DateWheelScrollViewState();
}

class _DateWheelScrollViewState extends State<DateWheelScrollView> {
  late DateWheel dateWheel;
  late YearWheel currentYear;
  late MonthWheel currentMonth;
  late DayWheel currentDay;

  @override
  void initState() {
    dateWheel = widget.dateWheel;
    init();
    super.initState();
  }

  void init() async {
    currentYear = dateWheel.years.first;
    currentMonth = currentYear.months.first;
    currentDay = currentMonth.days.first;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: ListWheelScrollView.useDelegate(
              perspective: 0.006,
              // 控制可见项数量
              diameterRatio: 6,
              // 调整滚动偏移量
              offAxisFraction: 0.5,
              physics: FixedExtentScrollPhysics(),
              itemExtent: 50,
              childDelegate: ListWheelChildListDelegate(
                children:
                    dateWheel.years
                        .map((e) => _buildItem("${e.year}年"))
                        .toList(),
              ),
              onSelectedItemChanged: (index) {},
            ),
          ),
          Expanded(
            child: ListWheelScrollView.useDelegate(
              itemExtent: 50,
              // 控制可见项数量
              diameterRatio: 6,
              // 调整滚动偏移量
              offAxisFraction: 0.5,
              physics: FixedExtentScrollPhysics(),
              perspective: 0.006,
              childDelegate: ListWheelChildListDelegate(
                children:
                    currentYear.months
                        .map((e) => _buildItem("${e.month}月"))
                        .toList(),
              ),
              onSelectedItemChanged: (index) {},
            ),
          ),
          Expanded(
            child: ListWheelScrollView.useDelegate(
              itemExtent: 50,
              // 控制可见项数量
              diameterRatio: 6,
              // 调整滚动偏移量
              offAxisFraction: 1,
              //保证滚动后。准确的停留在某个cell上
              physics: FixedExtentScrollPhysics(),
              perspective: 0.006,
              //放大镜
              useMagnifier: true,
              //设置除中间的一个外。其他的的透明度，设置了透明度后放大镜效果自动打开。如果没有设置透明度
              overAndUnderCenterOpacity: 0.2,
              //放大镜的效果。放大中间的那块
              // magnification: 1.5,
              childDelegate: ListWheelChildListDelegate(
                children:
                    currentMonth.days
                        .map((e) => _buildItem("${e.day}日"))
                        .toList(),
              ),
              onSelectedItemChanged: (index) {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(String title) {
    return Center(child: Text(title));
  }
}
