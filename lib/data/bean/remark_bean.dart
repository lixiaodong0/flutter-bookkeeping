import 'package:bookkeeping/db/model/journal_month_entry.dart';
import 'package:bookkeeping/db/model/remark_entry.dart';

class RemarkBean {
  final int id;
  final DateTime dateTime;
  final String remark;

  RemarkBean({required this.id, required this.dateTime, required this.remark});

  factory RemarkBean.fromJson(Map<String, dynamic> json) => RemarkBean(
    id: json[RemarkEntry.tableColumnId],
    remark: json[RemarkEntry.tableColumnRemark],
    dateTime: DateTime.parse(json[RemarkEntry.tableColumnDate]),
  );
}
