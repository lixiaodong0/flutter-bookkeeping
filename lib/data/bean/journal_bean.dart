import 'package:bookkeeping/data/bean/journal_type.dart';
import 'package:bookkeeping/db/model/journal_project_entry.dart';

import '../../db/model/journal_entry.dart';

final class JournalBean {
  int id;
  final JournalType type;
  final String amount;
  final DateTime date;
  final String description;

  final int journalProjectId;
  final String journalProjectName;

  JournalBean({
    required this.id,
    required this.type,
    required this.amount,
    required this.date,
    required this.description,
    required this.journalProjectId,
    required this.journalProjectName,
  });

  factory JournalBean.fromJson(Map<String, dynamic> json) => JournalBean(
    id: json[JournalEntry.tableColumnId],
    type: JournalType.fromName(JournalEntry.tableColumnType),
    amount: json[JournalEntry.tableColumnAmount],
    date: DateTime.parse(json[JournalEntry.tableColumnDate]),
    description: json[JournalEntry.tableColumnDescription],
    journalProjectId: json[JournalEntry.tableColumnJournalProjectId],
    journalProjectName: json[JournalProjectEntry.tableColumnName],
  );
}
