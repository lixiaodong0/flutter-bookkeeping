class DateUtil {
  static String format(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  static DateTime parse(String dateStr) {
    return DateTime.parse(dateStr);
  }

  static bool isSameDay(int year, int month, int day, DateTime date) {
    if (date.year == year && date.month == month && date.day == day) {
      return true;
    }
    return false;
  }
}
