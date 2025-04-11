class FormatUtil {
  static String formatAmount(String amount) {
    return num.parse(amount).toStringAsFixed(2);
  }

  static String formatAmountWanYuan(String amount) {
    var value = num.parse(amount);
    if (value > 10000) {
      var newValue = value / 10000;
      return "${newValue.toStringAsFixed(2)}万";
    } else {
      return value.toStringAsFixed(2);
    }
  }

  static String formatTime(int time) {
    return time.toString().padLeft(2, '0');
  }
}
