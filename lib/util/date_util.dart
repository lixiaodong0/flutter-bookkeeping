class DateUtil {
  static String format(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  static String formatMonth(DateTime date) {
    return "${date.month}月${date.day}日 ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }

  static String formatMonthDay(DateTime date) {
    return "${date.month}月${date.day}号";
  }

  static DateTime parse(String dateStr) {
    return DateTime.parse(dateStr);
  }

  //2025年4月1日 20:15:17
  static String simpleFormat(DateTime date) {
    return "${date.year}年${date.month}月${date.day}日 ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}";
  }

  static bool isSameDay(int year, int month, int day, DateTime date) {
    if (date.year == year && date.month == month && date.day == day) {
      return true;
    }
    return false;
  }

  static bool isSameMonth(DateTime date1, DateTime? date2) {
    if (date1.year == date2?.year && date1.month == date2?.month) {
      return true;
    }
    return false;
  }

  //根据年月计算每月的天数
  static int calculateMonthDays(int year, int month) {
    var days = 0;
    if (month == 2) {
      if (year % 4 == 0) {
        days = 29;
      } else {
        days = 28;
      }
    } else {
      if (month == 1 ||
          month == 3 ||
          month == 5 ||
          month == 7 ||
          month == 8 ||
          month == 10 ||
          month == 12) {
        days = 31;
      } else if (month == 4 || month == 6 || month == 9 || month == 11) {
        days = 30;
      }
    }
    return days;
  }
}
