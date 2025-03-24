/*
 * 每月收入支出表
 */

final class JournalMonthEntry {
  final int? id; //主键可为空
  final int year;
  final int month;

  JournalMonthEntry({
    this.id,
    required this.year,
    required this.month,
  });


  Map<String, dynamic> toMap() {
    return {
      tableColumnId: id,
      tableColumnYear: year,
      tableColumnMonth: month,
    };
  }

  static final table = "journal_month_entry";
  static final tableColumnId = "id";
  static final tableColumnYear = "year";
  static final tableColumnMonth = "month";

  static String createTableSql() {
    return '''
      CREATE TABLE $table (
        $tableColumnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $tableColumnYear INTEGER NOT NULL,
        $tableColumnMonth INTEGER NOT NULL
      )
    ''';
  }
}
