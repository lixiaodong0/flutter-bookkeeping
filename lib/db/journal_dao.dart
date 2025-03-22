import 'package:bookkeeping/data/bean/journal_bean.dart';
import 'package:bookkeeping/db/model/journal_project_entry.dart';
import 'package:sqflite/sqflite.dart';

import '../data/bean/journal_type.dart';
import 'database.dart';
import 'model/journal_entry.dart';

class JournalDao {
  //插入数据
  Future<int> insert(JournalEntry journalEntry) async {
    // 获取数据库实例
    Database db = DatabaseHelper().db;
    // 执行插入操作
    return await db.insert(JournalEntry.table, journalEntry.toMap());
  }

  //查询所有数据 按照日期倒序
  Future<List<JournalBean>> queryAll() async {
    final String tableName = JournalEntry.table;
    final String projectTableName = JournalProjectEntry.table;

    final List<String> columns = [
      JournalEntry.tableColumnId,
      JournalEntry.tableColumnType,
      JournalEntry.tableColumnAmount,
      JournalEntry.tableColumnDate,
      JournalEntry.tableColumnDescription,
      JournalEntry.tableColumnJournalProjectId,

      '$projectTableName.${JournalProjectEntry.tableColumnName}',
    ];
    final List<String> selectFields =
        columns
            .map(
              (column) => column.contains('.') ? column : '$tableName.$column',
            )
            .toList();

    String sql = '''
      SELECT 
      ${selectFields.join(', ')}
      FROM $tableName
      JOIN
      $projectTableName ON $tableName.${JournalEntry.tableColumnJournalProjectId} = $projectTableName.${JournalProjectEntry.tableColumnId}
      ORDER BY $tableName.${JournalEntry.tableColumnDate} DESC
    ''';
    // 获取数据库实例
    Database db = DatabaseHelper().db;
    final List<Map<String, dynamic>> results = await db.rawQuery(sql);
    print(results);
    return results.map((e) => JournalBean.fromJson(e)).toList();
  }

  //查询分页数据 按照日期倒序
  Future<List<JournalBean>> queryPager({int pageSize = 20, int page = 1}) async {
    final String tableName = JournalEntry.table;
    final String projectTableName = JournalProjectEntry.table;

    final List<String> columns = [
      JournalEntry.tableColumnId,
      JournalEntry.tableColumnType,
      JournalEntry.tableColumnAmount,
      JournalEntry.tableColumnDate,
      JournalEntry.tableColumnDescription,
      JournalEntry.tableColumnJournalProjectId,

      '$projectTableName.${JournalProjectEntry.tableColumnName}',
    ];

    var offset = (page - 1) * pageSize;
    final List<String> selectFields =
        columns
            .map(
              (column) => column.contains('.') ? column : '$tableName.$column',
            )
            .toList();

    String sql = '''
      SELECT 
      ${selectFields.join(', ')}
      FROM $tableName
      JOIN
      $projectTableName ON $tableName.${JournalEntry.tableColumnJournalProjectId} = $projectTableName.${JournalProjectEntry.tableColumnId}
      ORDER BY $tableName.${JournalEntry.tableColumnDate} DESC
      LIMIT $pageSize OFFSET $offset
    ''';
    // 获取数据库实例
    Database db = DatabaseHelper().db;
    final List<Map<String, dynamic>> results = await db.rawQuery(sql);
    print(results);
    return results.map((e) => JournalBean.fromJson(e)).toList();
  }

  //查询当天总的金额
  Future<String> queryTodayTotalAmount(DateTime date, JournalType type) async {
    final String tableName = JournalEntry.table;
    final String columnAmount = JournalEntry.tableColumnAmount;
    final String columnType = JournalEntry.tableColumnType;
    final String columnDate = JournalEntry.tableColumnDate;

    String sql = '''
      SELECT SUM($tableName.$columnAmount) AS total_amount
      FROM $tableName WHERE $tableName.$columnType = ?
      AND $tableName.$columnDate BETWEEN ? AND ?
    ''';

    String startTime =
        DateTime(date.year, date.month, date.day).toIso8601String();
    String endTime =
        DateTime(date.year, date.month, date.day, 23, 59, 59).toIso8601String();

    // 获取数据库实例
    Database db = DatabaseHelper().db;
    final List<Map<String, dynamic>> results = await db.rawQuery(sql, [
      type.name,
      startTime,
      endTime,
    ]);

    print(results);

    // 检查查询结果并返回总金额
    if (results.isNotEmpty && results[0]['total_amount'] != null) {
      return results[0]['total_amount'].toString();
    } else {
      // 如果没有记录，返回 "0"
      return "0";
    }
  }
}
