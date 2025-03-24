import 'package:bookkeeping/data/bean/daily_date_amount.dart';
import 'package:bookkeeping/data/bean/journal_bean.dart';
import 'package:bookkeeping/data/bean/journal_type.dart';
import 'package:bookkeeping/data/repository/datasource/journal_datasource.dart';
import 'package:bookkeeping/util/date_util.dart';

import '../../db/model/journal_entry.dart';

class JournalRepository implements JournalDataSource {
  final JournalDataSource _localDataSource;

  JournalRepository({required JournalDataSource localDataSource})
    : _localDataSource = localDataSource;

  @override
  Future<int> addJournal(JournalEntry entry) {
    return _localDataSource.addJournal(entry);
  }

  @override
  Future<List<JournalBean>> getAllJournal() {
    return _localDataSource.getAllJournal();
  }

  @override
  Future<List<JournalBean>> getPageJournal({
    int pageSize = 20,
    int page = 0,
  }) async {
    //分页数据
    List<JournalBean> result = await _localDataSource.getPageJournal(
      pageSize: pageSize,
      page: page,
    );
    print("[getPageJournal]totalSize:${result.length}");

    if (result.isNotEmpty) {
      //根据分页数据 获取每天的日期
      Set<String> allDate = {};
      for (var element in result) {
        allDate.add(DateUtil.format(element.date));
      }

      print("[getPageJournal]allDate:$allDate");

      //获取每天的日期总金额
      Map<String, DailyDateAmount> allDailyDateAmounts = {};
      for (var element in allDate) {
        var date = DateUtil.parse(element);
        var totalIncome = await getTodayTotalAmount(date, JournalType.income);
        var totalExpense = await getTodayTotalAmount(date, JournalType.expense);

        var dailyDateAmount = DailyDateAmount(
          date: element,
          income: totalIncome,
          expense: totalExpense,
        );

        allDailyDateAmounts[element] = dailyDateAmount;
      }

      print("[getPageJournal]allDailyDateAmounts:$allDailyDateAmounts");

      //重新组合数据源
      for (var element in result) {
        var date = DateUtil.format(element.date);
        element.dailyAmount = allDailyDateAmounts[date];
      }
    }
    return result;
  }

  @override
  Future<String> getTodayTotalAmount(DateTime date, JournalType type) {
    return _localDataSource.getTodayTotalAmount(date, type);
  }

  @override
  Future<String> getMonthTotalAmount(DateTime date, JournalType type) {
    return _localDataSource.getMonthTotalAmount(date, type);
  }
}
