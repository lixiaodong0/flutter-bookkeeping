import 'package:bookkeeping/util/date_util.dart';

import '../widget/date_piacker_widget.dart';

class PickerDateCache {
  //私有构造函数
  PickerDateCache._();

  // 静态变量保存唯一实例
  static final PickerDateCache _instance = PickerDateCache._();

  // 工厂构造函数，提供全局访问点
  factory PickerDateCache() => _instance;

  late List<DateBean> list;

  void create() async {
    List<DateBean> list = [];

    //最多可选一年内
    var now = DateTime.now();
    var lastYear = now.copyWith(year: now.year - 1);

    for (int i = lastYear.month; i <= 12; i++) {
      var next = lastYear.copyWith(month: i);
      list.add(
        DateBean(
          year: next.year,
          month: next.month,
          days: _getDays(next, now, true),
        ),
      );
    }

    for (int i = 1; i <= now.month; i++) {
      var next = now.copyWith(month: i);
      list.add(
        DateBean(
          year: next.year,
          month: next.month,
          days: _getDays(next, now, true),
        ),
      );
    }

    //翻转元素
    this.list = list.reversed.toList();
    // this.list = list;
  }

  List<DaysBean> _getDays(DateTime date, DateTime now, bool isAlignWeek) {
    var daysCount = DateUtil.calculateMonthDays(date.year, date.month);
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
    if (isAlignWeek) {
      var firstDay = date.copyWith(day: 1);
      if (firstDay.weekday != DateTime.sunday) {
        for (int i = 0; i < firstDay.weekday; i++) {
          list.insert(0, DaysBean.placeholder());
        }
      }
    }
    return list;
  }
}
