import 'package:bookkeeping/data/bean/account_book_bean.dart';
import 'package:sqflite/sqflite.dart';

import 'database.dart';
import 'model/account_book_entry.dart';

class AccountBookDao {
  //新增
  Future<int> insert(AccountBookEntry entry) async {
    Database db = DatabaseHelper().db;
    return db.insert(AccountBookEntry.table, entry.toMap());
  }

  //设置当前正常显示的账本
  Future<int> setCurrentShowId(int id) async {
    Database db = DatabaseHelper().db;
    //先更新所有数据为不展示
    db.update(AccountBookEntry.table, {AccountBookEntry.tableColumnShow: 0});
    //设置当前展示
    return db.update(
      AccountBookEntry.table,
      {AccountBookEntry.tableColumnShow: 1},
      where: '${AccountBookEntry.tableColumnId} = ?',
      whereArgs: [id],
    );
  }

  //删除
  Future<int> delete(int id) async {
    Database db = DatabaseHelper().db;
    return db.delete(
      AccountBookEntry.table,
      where: '${AccountBookEntry.tableColumnId} = ?',
      whereArgs: [id],
    );
  }

  //查找所有
  Future<List<AccountBookBean>> findAll() async {
    Database db = DatabaseHelper().db;
    final List<Map<String, dynamic>> findResult = await db.query(
      AccountBookEntry.table,
      orderBy: '${AccountBookEntry.tableColumnCreateDate} DESC',
    );
    return findResult.map((e) => AccountBookBean.fromJson(e)).toList();
  }

  //查找昵称是否重复
  Future<AccountBookBean?> findAccountBookByName(String name) async {
    Database db = DatabaseHelper().db;
    final List<Map<String, dynamic>> findResult = await db.query(
      AccountBookEntry.table,
      where: "${AccountBookEntry.tableColumnName} = ?",
      whereArgs: [name],
    );
    if (findResult.isEmpty) {
      return null;
    }
    var all = findResult.map((e) => AccountBookBean.fromJson(e)).toList();
    return all.firstOrNull;
  }
}
