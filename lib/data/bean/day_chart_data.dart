import 'package:bookkeeping/util/date_util.dart';
import 'package:bookkeeping/util/format_util.dart';

class DayChartData {
  DayChartData(this.date, this.amount);

  final DateTime date;
  final num amount;

  num get formatDateStr => num.parse("${date.month}.${date.day}");

  String get formatDateStr2 => "${date.month}.${date.day}";

  @override
  String toString() {
    return "date:$formatDateStr,amount:$amount";
  }
}
