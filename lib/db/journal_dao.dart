import 'package:bookkeeping/data/bean/journal_bean.dart';
import 'package:bookkeeping/db/model/journal_project_entry.dart';
import 'package:sqflite/sqflite.dart';

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

  //插入数据
  Future<List<JournalBean>> queryAll() async {
    String sql = '''
      SELECT 
      ${JournalEntry.table}.${JournalEntry.tableColumnId},
      ${JournalEntry.table}.${JournalEntry.tableColumnType},
      ${JournalEntry.table}.${JournalEntry.tableColumnAmount},
      ${JournalEntry.table}.${JournalEntry.tableColumnDate},
      ${JournalEntry.table}.${JournalEntry.tableColumnDescription},
      ${JournalEntry.table}.${JournalEntry.tableColumnJournalProjectId},
      ${JournalProjectEntry.table}.${JournalProjectEntry.tableColumnName}
      FROM ${JournalEntry.table}
      JOIN
      ${JournalProjectEntry.table} ON ${JournalEntry.table}.${JournalEntry.tableColumnJournalProjectId} = ${JournalProjectEntry.table}.${JournalProjectEntry.tableColumnId}
    ''';
    // 获取数据库实例
    Database db = DatabaseHelper().db;
    final List<Map<String, dynamic>> results = await db.rawQuery(sql);
    print(results);
    return results.map((e) => JournalBean.fromJson(e)).toList();
  }
}
