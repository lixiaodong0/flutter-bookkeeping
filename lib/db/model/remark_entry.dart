final class RemarkEntry {
  int? id; //主键可为空
  final String remark; //备注
  final DateTime date; //备注时间
  RemarkEntry({this.id, required this.date, required this.remark});

  Map<String, dynamic> toMap() {
    return {
      tableColumnId: id,
      tableColumnRemark: remark,
      tableColumnDate: date.toIso8601String(),
    };
  }

  static final table = "remark_entry";
  static final tableColumnId = "id";
  static final tableColumnRemark = "remark";
  static final tableColumnDate = "date";

  static String createTableSql() {
    return '''
      CREATE TABLE $table (
        $tableColumnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $tableColumnRemark TEXT NOT NULL,
        $tableColumnDate TEXT NOT NULL
      )
    ''';
  }
}
