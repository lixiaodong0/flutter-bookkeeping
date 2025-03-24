import 'package:bookkeeping/db/model/journal_month_entry.dart';

class JournalMonthBean {
  final int id;
  final int year;
  final int month;

  JournalMonthBean({required this.id, required this.year, required this.month});

  factory JournalMonthBean.fromJson(Map<String, dynamic> json) =>
      JournalMonthBean(
        id: json[JournalMonthEntry.tableColumnId],
        year: json[JournalMonthEntry.tableColumnYear],
        month: json[JournalMonthEntry.tableColumnMonth],
      );
}
