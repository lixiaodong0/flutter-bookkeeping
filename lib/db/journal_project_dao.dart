import 'package:bookkeeping/data/bean/journal_type.dart';
import 'package:sqflite/sqflite.dart';

import '../data/bean/journal_project_bean.dart';
import 'database.dart';
import 'model/journal_project_entry.dart';

class JournalProjectDao {
  //插入数据
  Future<int> insert(JournalProjectEntry entry) async {
    // 获取数据库实例
    Database db = DatabaseHelper().db;
    // 执行插入操作
    return await db.insert(JournalProjectEntry.table, entry.toMap());
  }

  Future<List<JournalProjectBean>> queryAll() async {
    // 获取数据库实例
    Database db = DatabaseHelper().db;
    final List<Map<String, dynamic>> results = await db.query(
      JournalProjectEntry.table,
    );
    return results.map((e) => JournalProjectBean.fromJson(e)).toList();
  }

  Future<List<JournalProjectBean>> queryByJournalType(JournalType type) async {
    // 获取数据库实例
    Database db = DatabaseHelper().db;
    final List<Map<String, dynamic>> results = await db.query(
      JournalProjectEntry.table,
      where: '${JournalProjectEntry.tableColumnJournalType} = ?',
      whereArgs: [type.name],
    );
    return results.map((e) => JournalProjectBean.fromJson(e)).toList();
  }
}
