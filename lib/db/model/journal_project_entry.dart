import 'package:bookkeeping/data/bean/journal_type.dart';

class JournalProjectEntry {
  final int? id; //主键可为空，自动生成
  final JournalType journalType;
  final String name; //类型名称
  final String source; //来源
  final int sort; //排序

  JournalProjectEntry({
    this.id,
    required this.journalType,
    required this.name,
    this.source = "",
    this.sort = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      tableColumnId: id,
      tableColumnJournalType: journalType.name,
      tableColumnName: name,
      tableColumnSource: source,
      tableColumnSort: sort,
    };
  }

  static final table = "journal_project_entry";
  static final tableColumnId = "id";
  static final tableColumnJournalType = "journal_type";
  static final tableColumnName = "name";
  static final tableColumnSource = "source";
  static final tableColumnSort = "sort";

  static String createTableSql() {
    return '''
      CREATE TABLE $table (
        $tableColumnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $tableColumnJournalType TEXT NOT NULL,
        $tableColumnName TEXT NOT NULL,
        $tableColumnSource TEXT,
        $tableColumnSort INTEGER
      )
    ''';
  }
}
