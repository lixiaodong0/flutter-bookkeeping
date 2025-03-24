import 'package:bookkeeping/db/model/journal_month_entry.dart';
import 'package:sqflite/sqflite.dart';

import '../data/bean/journal_month_bean.dart';
import 'database.dart';

class JournalMonthDao {
  //插入数据
  Future<int> insert(JournalMonthEntry entry) async {
    Database db = DatabaseHelper().db;
    if (await _contains(entry)) {
      return 0;
    }
    return db.insert(JournalMonthEntry.table, entry.toMap());
  }

  //判断数据是否存在
  Future<bool> _contains(JournalMonthEntry entry) async {
    Database db = DatabaseHelper().db;
    var result = await db.query(
      JournalMonthEntry.table,
      where:
          '${JournalMonthEntry.tableColumnYear} = ? AND ${JournalMonthEntry.tableColumnMonth} = ?',
      whereArgs: [entry.year, entry.month],
    );
    return result.isNotEmpty;
  }

  //查询所有数据
  Future<List<JournalMonthBean>> queryAll() async {
    Database db = DatabaseHelper().db;
    final List<Map<String, dynamic>> results = await db.query(
      JournalMonthEntry.table,
    );
    return results.map((e) => JournalMonthBean.fromJson(e)).toList();
  }
}
