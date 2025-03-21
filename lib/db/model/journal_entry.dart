/*
 * 每月收入支出表
 */
import 'package:bookkeeping/db/model/journal_project_entry.dart';

final class JournalEntry {
  final int? id; //主键可为空
  final String type; // 'income' 或 'expense'
  final String amount;
  final DateTime date;
  final String? description;
  final int journalProjectId;

  JournalEntry({
    this.id,
    required this.type,
    required this.amount,
    required this.date,
    this.description,
    required this.journalProjectId,
  });


  Map<String, dynamic> toMap() {
    return {
      tableColumnId: id,
      tableColumnType: type,
      tableColumnAmount: amount,
      tableColumnDate: date.toIso8601String(),
      tableColumnDescription: description,
      tableColumnJournalProjectId: journalProjectId,
    };
  }

  static final table = "journal_entry";
  static final tableColumnId = "id";
  static final tableColumnType = "type";
  static final tableColumnAmount = "amount";
  static final tableColumnDate = "date";
  static final tableColumnDescription = "description";
  static final tableColumnJournalProjectId = "journal_project_id";

  static String createTableSql() {
    return '''
      CREATE TABLE $table (
        $tableColumnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $tableColumnType TEXT NOT NULL,
        $tableColumnAmount TEXT NOT NULL,
        $tableColumnDate TEXT NOT NULL,
        $tableColumnDescription TEXT,
        $tableColumnJournalProjectId INTEGER NOT NULL,
        FOREIGN KEY ($tableColumnJournalProjectId) REFERENCES ${JournalProjectEntry.table} (id)
      )
    ''';
  }
}
