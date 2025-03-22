class DateUtil {
  static String format(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  static DateTime parse(String dateStr) {
    return DateTime.parse(dateStr);
  }
}
