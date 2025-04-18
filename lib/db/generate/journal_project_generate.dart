import 'package:bookkeeping/data/bean/journal_type.dart';
import 'package:bookkeeping/db/model/account_book_entry.dart';
import 'package:bookkeeping/db/model/journal_project_entry.dart';
import 'package:sqflite/sqflite.dart';

final class JournalProjectGenerate {
  //生成数据
  static generate(Database db) {
    Batch batch = db.batch();
    var table = JournalProjectEntry.table;
    _generateIncomeProjects(batch, table);
    _generateExpenseProjects(batch, table);
    _generateSystemAccountBook(batch);
    batch.commit();
  }

  static _generateSystemAccountBook(Batch db) {
    String table = AccountBookEntry.table;
    db.rawInsert(
      'INSERT INTO $table(${AccountBookEntry.tableColumnName}, ${AccountBookEntry.tableColumnCreateDate}, ${AccountBookEntry.tableColumnDescription}, ${AccountBookEntry.tableColumnSysDefault}, ${AccountBookEntry.tableColumnShow}) VALUES("默认账本","${DateTime.now().toIso8601String()}","系统默认",1,1)',
    );
  }

  static _generateIncomeProjects(Batch db, String table) {
    var journalType = JournalType.income;
    db.rawInsert(
      'INSERT INTO $table(${JournalProjectEntry.tableColumnJournalType}, ${JournalProjectEntry.tableColumnName}) VALUES("${journalType.name}","生意")',
    );
    db.rawInsert(
      'INSERT INTO $table(${JournalProjectEntry.tableColumnJournalType}, ${JournalProjectEntry.tableColumnName}) VALUES("${journalType.name}","工资")',
    );
    db.rawInsert(
      'INSERT INTO $table(${JournalProjectEntry.tableColumnJournalType}, ${JournalProjectEntry.tableColumnName}) VALUES("${journalType.name}","奖金")',
    );
    db.rawInsert(
      'INSERT INTO $table(${JournalProjectEntry.tableColumnJournalType}, ${JournalProjectEntry.tableColumnName}) VALUES("${journalType.name}","其他人情")',
    );
    db.rawInsert(
      'INSERT INTO $table(${JournalProjectEntry.tableColumnJournalType}, ${JournalProjectEntry.tableColumnName}) VALUES("${journalType.name}","收红包")',
    );
    db.rawInsert(
      'INSERT INTO $table(${JournalProjectEntry.tableColumnJournalType}, ${JournalProjectEntry.tableColumnName}) VALUES("${journalType.name}","收转账")',
    );
    db.rawInsert(
      'INSERT INTO $table(${JournalProjectEntry.tableColumnJournalType}, ${JournalProjectEntry.tableColumnName}) VALUES("${journalType.name}","商家转账")',
    );
    db.rawInsert(
      'INSERT INTO $table(${JournalProjectEntry.tableColumnJournalType}, ${JournalProjectEntry.tableColumnName}) VALUES("${journalType.name}","退款")',
    );
    db.rawInsert(
      'INSERT INTO $table(${JournalProjectEntry.tableColumnJournalType}, ${JournalProjectEntry.tableColumnName}) VALUES("${journalType.name}","其他")',
    );
  }

  static _generateExpenseProjects(Batch db, String table) {
    var journalType = JournalType.expense;
    db.rawInsert(
      'INSERT INTO $table(${JournalProjectEntry.tableColumnJournalType}, ${JournalProjectEntry.tableColumnName}) VALUES("${journalType.name}","餐饮")',
    );
    db.rawInsert(
      'INSERT INTO $table(${JournalProjectEntry.tableColumnJournalType}, ${JournalProjectEntry.tableColumnName}) VALUES("${journalType.name}","交通")',
    );
    db.rawInsert(
      'INSERT INTO $table(${JournalProjectEntry.tableColumnJournalType}, ${JournalProjectEntry.tableColumnName}) VALUES("${journalType.name}","服饰")',
    );
    db.rawInsert(
      'INSERT INTO $table(${JournalProjectEntry.tableColumnJournalType}, ${JournalProjectEntry.tableColumnName}) VALUES("${journalType.name}","购物")',
    );
    db.rawInsert(
      'INSERT INTO $table(${JournalProjectEntry.tableColumnJournalType}, ${JournalProjectEntry.tableColumnName}) VALUES("${journalType.name}","服务")',
    );
    db.rawInsert(
      'INSERT INTO $table(${JournalProjectEntry.tableColumnJournalType}, ${JournalProjectEntry.tableColumnName}) VALUES("${journalType.name}","教育")',
    );
    db.rawInsert(
      'INSERT INTO $table(${JournalProjectEntry.tableColumnJournalType}, ${JournalProjectEntry.tableColumnName}) VALUES("${journalType.name}","娱乐")',
    );
    db.rawInsert(
      'INSERT INTO $table(${JournalProjectEntry.tableColumnJournalType}, ${JournalProjectEntry.tableColumnName}) VALUES("${journalType.name}","运动")',
    );
    db.rawInsert(
      'INSERT INTO $table(${JournalProjectEntry.tableColumnJournalType}, ${JournalProjectEntry.tableColumnName}) VALUES("${journalType.name}","生活缴费")',
    );
    db.rawInsert(
      'INSERT INTO $table(${JournalProjectEntry.tableColumnJournalType}, ${JournalProjectEntry.tableColumnName}) VALUES("${journalType.name}","旅行")',
    );
    db.rawInsert(
      'INSERT INTO $table(${JournalProjectEntry.tableColumnJournalType}, ${JournalProjectEntry.tableColumnName}) VALUES("${journalType.name}","宠物")',
    );
    db.rawInsert(
      'INSERT INTO $table(${JournalProjectEntry.tableColumnJournalType}, ${JournalProjectEntry.tableColumnName}) VALUES("${journalType.name}","医疗")',
    );
    db.rawInsert(
      'INSERT INTO $table(${JournalProjectEntry.tableColumnJournalType}, ${JournalProjectEntry.tableColumnName}) VALUES("${journalType.name}","保险")',
    );
    db.rawInsert(
      'INSERT INTO $table(${JournalProjectEntry.tableColumnJournalType}, ${JournalProjectEntry.tableColumnName}) VALUES("${journalType.name}","公益")',
    );
    db.rawInsert(
      'INSERT INTO $table(${JournalProjectEntry.tableColumnJournalType}, ${JournalProjectEntry.tableColumnName}) VALUES("${journalType.name}","发红包")',
    );
    db.rawInsert(
      'INSERT INTO $table(${JournalProjectEntry.tableColumnJournalType}, ${JournalProjectEntry.tableColumnName}) VALUES("${journalType.name}","转账")',
    );
    db.rawInsert(
      'INSERT INTO $table(${JournalProjectEntry.tableColumnJournalType}, ${JournalProjectEntry.tableColumnName}) VALUES("${journalType.name}","亲属卡")',
    );
    db.rawInsert(
      'INSERT INTO $table(${JournalProjectEntry.tableColumnJournalType}, ${JournalProjectEntry.tableColumnName}) VALUES("${journalType.name}","其他人情")',
    );
    db.rawInsert(
      'INSERT INTO $table(${JournalProjectEntry.tableColumnJournalType}, ${JournalProjectEntry.tableColumnName}) VALUES("${journalType.name}","退还")',
    );
    db.rawInsert(
      'INSERT INTO $table(${JournalProjectEntry.tableColumnJournalType}, ${JournalProjectEntry.tableColumnName}) VALUES("${journalType.name}","其他")',
    );
  }
}
