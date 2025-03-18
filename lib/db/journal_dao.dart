
import 'package:sqflite/sqflite.dart';

import '../model/journal_entry.dart';
import 'database.dart';

class JournalDao {
  static String table = "journal_entry";

  //插入数据
  Future<int> insert(JournalEntry journalEntry) async {
    // 获取数据库实例
    Database db = DatabaseHelper().db;
    // 执行插入操作
    return await db.insert(table, journalEntry.toMap());
  }

  //插入数据
  Future<List<JournalEntry>> queryAll() async {
    // 获取数据库实例
    Database db = DatabaseHelper().db;
    final List<Map<String, dynamic>> results = await db.query(table);
    return results.map((e) => JournalEntry.fromJson(e)).toList();
  }
}
