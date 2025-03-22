class FormatUtil {
  static String formatAmount(String amount) {
    return num.parse(amount).toStringAsFixed(2);
  }

  static String formatTime(int time) {
    return time.toString().padLeft(2, '0');
  }
}
