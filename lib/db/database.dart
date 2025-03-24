import 'dart:developer';

import 'package:bookkeeping/db/journal_dao.dart';
import 'package:bookkeeping/db/model/journal_entry.dart';
import 'package:bookkeeping/db/model/journal_month_entry.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'generate/journal_project_generate.dart';
import 'journal_project_dao.dart';
import 'model/journal_project_entry.dart';

class DatabaseHelper {
  //私有构造函数
  DatabaseHelper._();

  // 静态变量保存唯一实例
  static final DatabaseHelper _instance = DatabaseHelper._();

  // 工厂构造函数，提供全局访问点
  factory DatabaseHelper() => _instance;

  late Database db;

  Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    db = await openDatabase(
      join(await getDatabasesPath(), "bookkeeping_database.db"),
      onCreate: (db, version) {
        var start = DateTime.now().millisecondsSinceEpoch;
        //数据库创建
        log("database onCreate");
        db.execute(JournalEntry.createTableSql());
        db.execute(JournalProjectEntry.createTableSql());
        db.execute(JournalMonthEntry.createTableSql());
        JournalProjectGenerate.generate(db);
        var end = DateTime.now().millisecondsSinceEpoch - start;
        log("database onCreate finish ${end / 1000}ms");
      },
      onUpgrade: (db, oldVersion, newVersion) {
        //数据库升级
        log("database onUpgrade");
      },
      version: 1,
    );
  }
}
