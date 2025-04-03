import 'package:bookkeeping/db/model/remark_entry.dart';
import 'package:sqflite/sqflite.dart';

import '../data/bean/remark_bean.dart';
import 'database.dart';

class RemarkDao {
  Future<int> insert(RemarkEntry entry) async {
    Database db = DatabaseHelper().db;
    var id = await findByRemark(entry.remark);
    if (id > 0) {
      entry.id = id;
      return await db.update(
        RemarkEntry.table,
        entry.toMap(),
        where: '${RemarkEntry.tableColumnId} = ?',
        whereArgs: [id],
      );
    }
    return await db.insert(RemarkEntry.table, entry.toMap());
  }

  Future<int> findByRemark(String remark) async {
    Database db = DatabaseHelper().db;
    var results = await db.query(
      RemarkEntry.table,
      where: '${RemarkEntry.tableColumnRemark} = ?',
      whereArgs: [remark],
    );
    return _convert(results).firstOrNull?.id ?? 0;
  }

  List<RemarkBean> _convert(List<Map<String, Object?>> list) {
    return list.map((e) => RemarkBean.fromJson(e)).toList();
  }

  Future<List<RemarkBean>> take(int maxCount) async {
    Database db = DatabaseHelper().db;
    var results = await db.query(
      RemarkEntry.table,
      limit: maxCount,
      orderBy: '${RemarkEntry.tableColumnDate} DESC',
    );
    return _convert(results);
  }
}
