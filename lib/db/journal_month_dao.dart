import 'package:bookkeeping/db/model/journal_month_entry.dart';
import 'package:sqflite/sqflite.dart';

import '../data/bean/journal_month_bean.dart';
import 'database.dart';

class JournalMonthDao {
  //插入数据
  Future<int> insert(JournalMonthEntry entry) async {
    Database db = DatabaseHelper().db;
    var result = await _contains(entry);
    if (result != null) {
      if (entry.maxDay > result.maxDay) {
        //更新操作
        entry.id = result.id;
        return db.update(
          JournalMonthEntry.table,
          entry.toMap(),
          where: '${JournalMonthEntry.tableColumnId} = ?',
          whereArgs: [result.id],
        );
      }
      return 0;
    }
    return db.insert(JournalMonthEntry.table, entry.toMap());
  }

  //判断数据是否存在
  Future<JournalMonthBean?> _contains(JournalMonthEntry entry) async {
    Database db = DatabaseHelper().db;
    final List<Map<String, dynamic>> results = await db.query(
      JournalMonthEntry.table,
      where:
          '${JournalMonthEntry.tableColumnYear} = ? AND ${JournalMonthEntry.tableColumnMonth} = ?',
      whereArgs: [entry.year, entry.month],
    );
    if (results.isEmpty) {
      return null;
    }
    var all = results.map((e) => JournalMonthBean.fromJson(e)).toList();
    return all.firstOrNull;
  }

  //查询所有数据
  Future<List<JournalMonthBean>> queryAll(int accountBookId) async {
    Database db = DatabaseHelper().db;
    final List<Map<String, dynamic>> results = await db.query(
      JournalMonthEntry.table,
      where: '${JournalMonthEntry.tableColumnAccountBookId} = ?',
      whereArgs: [accountBookId],
    );
    return results.map((e) => JournalMonthBean.fromJson(e)).toList();
  }
}
