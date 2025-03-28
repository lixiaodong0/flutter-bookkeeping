class MonthChartData {
  final DateTime date;
  String dateStr;
  final double amount;
  final String amountLabel;

  MonthChartData({
    required this.date,
    this.dateStr = "",
    required this.amount,
    required this.amountLabel,
  });
}
