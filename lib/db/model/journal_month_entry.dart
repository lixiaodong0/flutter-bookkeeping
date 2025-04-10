/*
 * 每月收入支出表
 */

final class JournalMonthEntry {
  int? id; //主键可为空
  final int year;
  final int month;
  final int maxDay;
  final int accountBookId;

  JournalMonthEntry({
    this.id,
    required this.year,
    required this.month,
    required this.maxDay,
    required this.accountBookId,
  });

  Map<String, dynamic> toMap() {
    return {
      tableColumnId: id,
      tableColumnYear: year,
      tableColumnMonth: month,
      tableColumnMaxDay: maxDay,
      tableColumnAccountBookId: accountBookId,
    };
  }

  static final table = "journal_month_entry";
  static final tableColumnId = "id";
  static final tableColumnYear = "year";
  static final tableColumnMonth = "month";
  static final tableColumnMaxDay = "max_day";
  static final tableColumnAccountBookId = "account_book_id";

  static String createTableSql() {
    return '''
      CREATE TABLE $table (
        $tableColumnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $tableColumnYear INTEGER NOT NULL,
        $tableColumnMonth INTEGER NOT NULL,
        $tableColumnMaxDay INTEGER NOT NULL,
        $tableColumnAccountBookId INTEGER NOT NULL
      )
    ''';
  }
}
