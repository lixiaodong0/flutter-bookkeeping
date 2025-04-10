import 'package:bookkeeping/data/bean/daily_date_amount.dart';
import 'package:bookkeeping/data/bean/journal_bean.dart';
import 'package:bookkeeping/data/bean/journal_type.dart';
import 'package:bookkeeping/data/repository/datasource/journal_datasource.dart';
import 'package:bookkeeping/util/date_util.dart';

import '../../db/model/journal_entry.dart';
import '../bean/journal_project_bean.dart';

class JournalRepository implements JournalDataSource {
  final JournalDataSource _localDataSource;

  JournalRepository({required JournalDataSource localDataSource})
    : _localDataSource = localDataSource;

  @override
  Future<JournalBean?> getJournal(int id) {
    return _localDataSource.getJournal(id);
  }

  @override
  Future<int> addJournal(JournalEntry entry) {
    return _localDataSource.addJournal(entry);
  }

  @override
  Future<int> updateJournal(JournalEntry entry) {
    return _localDataSource.updateJournal(entry);
  }

  @override
  Future<List<JournalBean>> getPageJournal(
    int accountBookId, {
    int pageSize = 20,
    int page = 0,
    DateTime? limitDate,
    JournalProjectBean? limitProject,
  }) async {
    //分页数据
    List<JournalBean> result = await _localDataSource.getPageJournal(
      accountBookId,
      pageSize: pageSize,
      page: page,
      limitDate: limitDate,
      limitProject: limitProject,
    );

    var projectId = limitProject?.id ?? -1;

    if (result.isNotEmpty) {
      //根据分页数据 获取每天的日期
      Set<String> allDate = {};
      for (var element in result) {
        allDate.add(DateUtil.format(element.date));
      }

      //获取每天的日期总金额
      Map<String, DailyDateAmount> allDailyDateAmounts = {};
      for (var element in allDate) {
        var date = DateUtil.parse(element);
        var totalIncome = await getTodayTotalAmount(
          accountBookId,
          date,
          JournalType.income,
          projectId: projectId,
        );
        var totalExpense = await getTodayTotalAmount(
          accountBookId,
          date,
          JournalType.expense,
          projectId: projectId,
        );

        var dailyDateAmount = DailyDateAmount(
          date: element,
          income: totalIncome,
          expense: totalExpense,
          projectBean: limitProject,
        );
        allDailyDateAmounts[element] = dailyDateAmount;
      }

      //重新组合数据源
      for (var element in result) {
        var date = DateUtil.format(element.date);
        element.dailyAmount = allDailyDateAmounts[date];
      }
    }
    return result;
  }

  @override
  Future<String> getTodayTotalAmount(
    int accountBookId,
    DateTime date,
    JournalType type, {
    int projectId = -1,
  }) {
    return _localDataSource.getTodayTotalAmount(
      accountBookId,
      date,
      type,
      projectId: projectId,
    );
  }

  @override
  Future<String> getMonthTotalAmount(
    int accountBookId,
    DateTime date,
    JournalType type, {
    int projectId = -1,
  }) {
    return _localDataSource.getMonthTotalAmount(
      accountBookId,
      date,
      type,
      projectId: projectId,
    );
  }

  @override
  Future<List<JournalBean>> getMonthJournal(
    int accountBookId,
    DateTime limitDate,
    JournalType journalType, {
    int projectId = -1,
  }) {
    return _localDataSource.getMonthJournal(
      accountBookId,
      limitDate,
      journalType,
      projectId: projectId,
    );
  }

  @override
  Future<List<JournalBean>> getDayJournal(
    int accountBookId,
    DateTime limitDate,
    JournalType journalType,
  ) {
    return _localDataSource.getDayJournal(
      accountBookId,
      limitDate,
      journalType,
    );
  }

  @override
  Future<int> deleteJournal(int id) {
    return _localDataSource.deleteJournal(id);
  }
}
