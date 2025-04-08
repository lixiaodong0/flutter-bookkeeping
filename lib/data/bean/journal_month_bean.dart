import 'package:bookkeeping/db/model/journal_month_entry.dart';

class JournalMonthBean {
  final int id;
  final int year;
  final int month;
  final int maxDay;

  JournalMonthBean({
    required this.id,
    required this.year,
    required this.month,
    required this.maxDay,
  });

  factory JournalMonthBean.fromJson(Map<String, dynamic> json) =>
      JournalMonthBean(
        id: json[JournalMonthEntry.tableColumnId],
        year: json[JournalMonthEntry.tableColumnYear],
        month: json[JournalMonthEntry.tableColumnMonth],
        maxDay: json[JournalMonthEntry.tableColumnMaxDay],
      );
}

class JournalMonthGroupBean {
  final int year;
  final List<JournalMonthBean> list;

  JournalMonthGroupBean({required this.year, required this.list});
}
