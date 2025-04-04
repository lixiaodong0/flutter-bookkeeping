import 'package:bookkeeping/data/bean/journal_type.dart';
import 'package:bookkeeping/db/model/journal_project_entry.dart';

import '../../db/model/journal_entry.dart';
import 'daily_date_amount.dart';

final class JournalBean {
  int id;
  final JournalType type;
  final String amount;
  final DateTime date;
  final String? description;

  final int journalProjectId;
  final String journalProjectName;

  DailyDateAmount? dailyAmount;

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
    type: JournalType.fromName(json[JournalEntry.tableColumnType]),
    amount: json[JournalEntry.tableColumnAmount],
    date: DateTime.parse(json[JournalEntry.tableColumnDate]),
    description: json[JournalEntry.tableColumnDescription],
    journalProjectId: json[JournalEntry.tableColumnJournalProjectId],
    journalProjectName: json[JournalProjectEntry.tableColumnName],
  );
}
