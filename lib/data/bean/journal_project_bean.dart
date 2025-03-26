import 'package:bookkeeping/db/model/journal_project_entry.dart';

import 'journal_type.dart';

final class JournalProjectBean {
  final int id; //
  final JournalType journalType;
  final String name; //类型名称
  final String source; //来源
  final int sort; //排序

  const JournalProjectBean({
    required this.id,
    required this.journalType,
    required this.name,
    this.source = "",
    this.sort = 0,
  });

  factory JournalProjectBean.fromJson(Map<String, dynamic> json) =>
      JournalProjectBean(
        id: json[JournalProjectEntry.tableColumnId],
        journalType: JournalType.fromName(
          json[JournalProjectEntry.tableColumnJournalType],
        ),
        name: json[JournalProjectEntry.tableColumnName],
        source: json[JournalProjectEntry.tableColumnSource] ?? "",
        sort: json[JournalProjectEntry.tableColumnSort] ?? 0,
      );

  static JournalProjectBean allItemBean() {
    return const JournalProjectBean(
      id: 0,
      journalType: JournalType.expense,
      name: "全部类型",
    );
  }

  bool isAllItemBean() {
    return id == 0 && name == "全部类型";
  }
}
