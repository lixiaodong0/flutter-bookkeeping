
import 'package:sqflite/sqflite.dart';

import 'database.dart';
import 'model/journal_project_entry.dart';

class JournalProjectDao {
  static String table = "journal_project_entry";

  //插入数据
  Future<int> insert(JournalProjectEntry entry) async {
    // 获取数据库实例
    Database db = DatabaseHelper().db;
    // 执行插入操作
    return await db.insert(table, entry.toMap());
  }

  //插入数据
  Future<List<JournalProjectEntry>> queryAll() async {
    // 获取数据库实例
    Database db = DatabaseHelper().db;
    final List<Map<String, dynamic>> results = await db.query(table);
    return results.map((e) => JournalProjectEntry.fromJson(e)).toList();
  }
}
