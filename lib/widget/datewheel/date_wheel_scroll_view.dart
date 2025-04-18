import 'package:flutter/material.dart';

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

typedef OnDateChangeCallback = void Function(int year, int month, int day);

class DateWheelScrollView extends StatefulWidget {
  final List<YearWheel> years;
  final DateTime? initSelectedDate;
  final OnDateChangeCallback onDateChangeCallback;

  const DateWheelScrollView({
    super.key,
    required this.years,
    required this.onDateChangeCallback,
    this.initSelectedDate,
  });

  @override
  State createState() => _DateWheelScrollViewState();
}

class _DateWheelScrollViewState extends State<DateWheelScrollView> {
  late List<YearWheel> years;
  late List<MonthWheel> months;
  late List<DayWheel> days;
  late YearWheel currentYear;
  late MonthWheel currentMonth;
  late DayWheel currentDay;
  double itemHeight = 50;
  Color backgroundLineColor = Colors.grey;

  ScrollController yearScrollController = FixedExtentScrollController();
  ScrollController monthScrollController = FixedExtentScrollController();
  ScrollController dayScrollController = FixedExtentScrollController();

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  void dispose() {
    yearScrollController.dispose();
    monthScrollController.dispose();
    dayScrollController.dispose();
    super.dispose();
  }

  void init() async {
    years = widget.years;

    currentYear = years[0];
    currentMonth = currentYear.months[0];
    currentDay = currentMonth.days[0];

    months = currentYear.months;
    days = currentMonth.days;

    callback();
    Future.microtask(() {
      initDefaultSelectedDate();
    });
  }

  void initDefaultSelectedDate() async {
    var initSelectedDate = widget.initSelectedDate;
    var initYearIndex = 0;
    var initMonthIndex = 0;
    var initDayIndex = 0;
    if (initSelectedDate != null) {
      var index = years.indexWhere(
        (element) => element.year == initSelectedDate.year,
      );
      if (index != -1) {
        initYearIndex = index;
        var selectedYear = years[initYearIndex];
        initMonthIndex = selectedYear.months.indexWhere(
          (element) => element.month == initSelectedDate.month,
        );
        var selectedMonth = selectedYear.months[initMonthIndex];
        initDayIndex = selectedMonth.days.indexWhere(
          (element) => element.day == initSelectedDate.day,
        );
        var selectedDay = selectedMonth.days[initDayIndex];
        setState(() {
          yearScrollController.jumpTo(initYearIndex * itemHeight);
          monthScrollController.jumpTo(initMonthIndex * itemHeight);
          dayScrollController.jumpTo(initDayIndex * itemHeight);
        });
      }
    }
  }

  void onYearSelectedItemChanged(int index) {
    var selectedYear = years[index];
    var months = selectedYear.months;
    var selectedMonth = months.first;
    var days = months.first.days;
    var selectedDay = days.first;

    setState(() {
      currentYear = selectedYear;
      currentMonth = selectedMonth;
      currentDay = selectedDay;

      this.months = months;
      this.days = days;

      monthScrollController.jumpTo(0);
      dayScrollController.jumpTo(0);

      callback();
    });
  }

  void onMonthSelectedItemChanged(int index) {
    var selectedMonth = months[index];
    var days = selectedMonth.days;
    var selectedDay = selectedMonth.days.first;

    setState(() {
      currentMonth = selectedMonth;
      currentDay = selectedDay;

      this.days = days;

      dayScrollController.jumpTo(0);

      callback();
    });
  }

  void onDaySelectedItemChanged(int index) {
    var selectedDay = days[index];
    setState(() {
      currentDay = selectedDay;

      callback();
    });
  }

  void callback() {
    Future.microtask(() {
      widget.onDateChangeCallback(
        currentYear.year,
        currentMonth.month,
        currentDay.day,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Align(
            child: Container(
              height: itemHeight,
              decoration: BoxDecoration(
                border: Border.symmetric(
                  horizontal: BorderSide(
                    color: backgroundLineColor,
                    width: 0.5,
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: _buildListView(
                  controller: yearScrollController,
                  children: years.map((e) => _buildItem("${e.year}年")).toList(),
                  onSelectedItemChanged: onYearSelectedItemChanged,
                ),
              ),
              Expanded(
                child: _buildListView(
                  controller: monthScrollController,
                  children:
                      currentYear.months
                          .map((e) => _buildItem("${e.month}月"))
                          .toList(),
                  onSelectedItemChanged: onMonthSelectedItemChanged,
                ),
              ),
              Expanded(
                child: _buildListView(
                  controller: dayScrollController,
                  children:
                      currentMonth.days
                          .map((e) => _buildItem("${e.day}日"))
                          .toList(),
                  onSelectedItemChanged: onDaySelectedItemChanged,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildListView({
    required List<Widget> children,
    ScrollController? controller,
    ValueChanged<int>? onSelectedItemChanged,
  }) {
    return ListWheelScrollView.useDelegate(
      controller: controller,
      itemExtent: itemHeight,
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
      childDelegate: ListWheelChildListDelegate(children: children),
      onSelectedItemChanged: onSelectedItemChanged,
    );
  }

  Widget _buildItem(String title) {
    return Center(
      child: Text(title, style: TextStyle(fontSize: 16, color: Colors.black)),
    );
  }
}
