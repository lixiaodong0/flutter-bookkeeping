import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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
        //数据库创建
        log("database onCreate");
        return db.execute(
          "CREATE TABLE journal_entry(id INTEGER PRIMARY KEY AUTOINCREMENT, type TEXT, amount TEXT, date TEXT, description TEXT)",
        );
      },
      onUpgrade: (db, oldVersion, newVersion) {
        //数据库升级
        log("database onUpgrade");
      },
      version: 1,
    );
  }
}
