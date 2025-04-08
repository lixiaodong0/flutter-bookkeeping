/*
 * 每月收入支出表
 */

final class JournalMonthEntry {
  int? id; //主键可为空
  final int year;
  final int month;
  final int maxDay;

  JournalMonthEntry({
    this.id,
    required this.year,
    required this.month,
    required this.maxDay,
  });

  Map<String, dynamic> toMap() {
    return {
      tableColumnId: id,
      tableColumnYear: year,
      tableColumnMonth: month,
      tableColumnMaxDay: maxDay,
    };
  }

  static final table = "journal_month_entry";
  static final tableColumnId = "id";
  static final tableColumnYear = "year";
  static final tableColumnMonth = "month";
  static final tableColumnMaxDay = "max_day";

  static String createTableSql() {
    return '''
      CREATE TABLE $table (
        $tableColumnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $tableColumnYear INTEGER NOT NULL,
        $tableColumnMonth INTEGER NOT NULL,
        $tableColumnMaxDay INTEGER NOT NULL
      )
    ''';
  }
}
