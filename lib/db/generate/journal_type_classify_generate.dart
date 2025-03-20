import 'package:bookkeeping/data/bean/journal_type.dart';
import 'package:sqflite/sqflite.dart';

import '../journal_type_classify_dao.dart';

final class JournalTypeClassifyGenerate {
  //生成数据
  static generate(Database db) {
    Batch batch = db.batch();
    _generateIncomeType(batch);
    _generateExpenseType(batch);
    batch.commit();
  }

  static _generateIncomeType(Batch db) {
    var journalType = JournalType.income;
    db.rawInsert(
      'INSERT INTO ${JournalTypeClassifyDao.table}(journalType, name) VALUES("${journalType.name}","生意")',
    );
    db.rawInsert(
      'INSERT INTO ${JournalTypeClassifyDao.table}(journalType, name) VALUES("${journalType.name}","工资")',
    );
    db.rawInsert(
      'INSERT INTO ${JournalTypeClassifyDao.table}(journalType, name) VALUES("${journalType.name}","奖金")',
    );
    db.rawInsert(
      'INSERT INTO ${JournalTypeClassifyDao.table}(journalType, name) VALUES("${journalType.name}","其他人情")',
    );
    db.rawInsert(
      'INSERT INTO ${JournalTypeClassifyDao.table}(journalType, name) VALUES("${journalType.name}","收红包")',
    );
    db.rawInsert(
      'INSERT INTO ${JournalTypeClassifyDao.table}(journalType, name) VALUES("${journalType.name}","收转账")',
    );
    db.rawInsert(
      'INSERT INTO ${JournalTypeClassifyDao.table}(journalType, name) VALUES("${journalType.name}","商家转账")',
    );
    db.rawInsert(
      'INSERT INTO ${JournalTypeClassifyDao.table}(journalType, name) VALUES("${journalType.name}","退款")',
    );
    db.rawInsert(
      'INSERT INTO ${JournalTypeClassifyDao.table}(journalType, name) VALUES("${journalType.name}","其他")',
    );
  }

  static _generateExpenseType(Batch db) {
    var journalType = JournalType.expense;
    db.rawInsert(
      'INSERT INTO ${JournalTypeClassifyDao.table}(journalType, name) VALUES("${journalType.name}","餐饮")',
    );
    db.rawInsert(
      'INSERT INTO ${JournalTypeClassifyDao.table}(journalType, name) VALUES("${journalType.name}","交通")',
    );
    db.rawInsert(
      'INSERT INTO ${JournalTypeClassifyDao.table}(journalType, name) VALUES("${journalType.name}","服饰")',
    );
    db.rawInsert(
      'INSERT INTO ${JournalTypeClassifyDao.table}(journalType, name) VALUES("${journalType.name}","购物")',
    );
    db.rawInsert(
      'INSERT INTO ${JournalTypeClassifyDao.table}(journalType, name) VALUES("${journalType.name}","服务")',
    );
    db.rawInsert(
      'INSERT INTO ${JournalTypeClassifyDao.table}(journalType, name) VALUES("${journalType.name}","教育")',
    );
    db.rawInsert(
      'INSERT INTO ${JournalTypeClassifyDao.table}(journalType, name) VALUES("${journalType.name}","娱乐")',
    );
    db.rawInsert(
      'INSERT INTO ${JournalTypeClassifyDao.table}(journalType, name) VALUES("${journalType.name}","运动")',
    );
    db.rawInsert(
      'INSERT INTO ${JournalTypeClassifyDao.table}(journalType, name) VALUES("${journalType.name}","生活缴费")',
    );
    db.rawInsert(
      'INSERT INTO ${JournalTypeClassifyDao.table}(journalType, name) VALUES("${journalType.name}","旅行")',
    );
    db.rawInsert(
      'INSERT INTO ${JournalTypeClassifyDao.table}(journalType, name) VALUES("${journalType.name}","宠物")',
    );
    db.rawInsert(
      'INSERT INTO ${JournalTypeClassifyDao.table}(journalType, name) VALUES("${journalType.name}","医疗")',
    );
    db.rawInsert(
      'INSERT INTO ${JournalTypeClassifyDao.table}(journalType, name) VALUES("${journalType.name}","保险")',
    );
    db.rawInsert(
      'INSERT INTO ${JournalTypeClassifyDao.table}(journalType, name) VALUES("${journalType.name}","公益")',
    );
    db.rawInsert(
      'INSERT INTO ${JournalTypeClassifyDao.table}(journalType, name) VALUES("${journalType.name}","发红包")',
    );
    db.rawInsert(
      'INSERT INTO ${JournalTypeClassifyDao.table}(journalType, name) VALUES("${journalType.name}","转账")',
    );
    db.rawInsert(
      'INSERT INTO ${JournalTypeClassifyDao.table}(journalType, name) VALUES("${journalType.name}","亲属卡")',
    );
    db.rawInsert(
      'INSERT INTO ${JournalTypeClassifyDao.table}(journalType, name) VALUES("${journalType.name}","其他人情")',
    );
    db.rawInsert(
      'INSERT INTO ${JournalTypeClassifyDao.table}(journalType, name) VALUES("${journalType.name}","退还")',
    );
    db.rawInsert(
      'INSERT INTO ${JournalTypeClassifyDao.table}(journalType, name) VALUES("${journalType.name}","其他")',
    );
  }
}
