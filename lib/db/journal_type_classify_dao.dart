
import 'package:sqflite/sqflite.dart';

import 'database.dart';
import 'model/journal_type_classify_entry.dart';

class JournalTypeClassifyDao {
  static String table = "journal_type_classify_entry";

  //插入数据
  Future<int> insert(JournalTypeClassifyEntry entry) async {
    // 获取数据库实例
    Database db = DatabaseHelper().db;
    // 执行插入操作
    return await db.insert(table, entry.toMap());
  }

  //插入数据
  Future<List<JournalTypeClassifyEntry>> queryAll() async {
    // 获取数据库实例
    Database db = DatabaseHelper().db;
    final List<Map<String, dynamic>> results = await db.query(table);
    return results.map((e) => JournalTypeClassifyEntry.fromJson(e)).toList();
  }
}
