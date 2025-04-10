//账本表
final class AccountBookEntry {
  int? id; //主键 自动生成
  final String name; //  账本的名称
  final String? description; //账本的描述
  final DateTime createDate; //账本的创建时间
  final int sysDefault; // 系统默认账本（可能用来后续默认的不允许删除） 0否 1是
  final int show; //是否显示  0不显示 1显示

  AccountBookEntry({
    this.id,
    this.sysDefault = 0,
    required this.name,
    this.description,
    required this.createDate,
    this.show = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      tableColumnId: id,
      tableColumnName: name,
      tableColumnCreateDate: createDate.toIso8601String(),
      tableColumnDescription: description,
      tableColumnSysDefault: sysDefault,
      tableColumnShow: show,
    };
  }

  static final table = "account_book_entry";
  static final tableColumnId = "id";
  static final tableColumnName = "name";
  static final tableColumnCreateDate = "createDate";
  static final tableColumnDescription = "description";
  static final tableColumnSysDefault = "sys_default";
  static final tableColumnShow = "show";

  static String createTableSql() {
    return '''
      CREATE TABLE $table (
        $tableColumnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $tableColumnSysDefault INTEGER NOT NULL,
        $tableColumnShow INTEGER NOT NULL,
        $tableColumnName TEXT NOT NULL,
        $tableColumnCreateDate TEXT NOT NULL,
        $tableColumnDescription TEXT
      )
    ''';
  }
}
