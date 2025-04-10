import 'package:bookkeeping/data/bean/journal_month_bean.dart';
import 'package:bookkeeping/db/model/journal_month_entry.dart';

import 'datasource/journal_month_datasource.dart';

class JournalMonthRepository implements JournalMonthDataSource {
  final JournalMonthDataSource _localDataSource;

  JournalMonthRepository({required JournalMonthDataSource localDataSource})
    : _localDataSource = localDataSource;


  @override
  Future<int> addJournalMonth(JournalMonthEntry entry) {
    return _localDataSource.addJournalMonth(entry);
  }

  @override
  Future<List<JournalMonthBean>> getAllJournalMonth(int accountBookId) {
    return _localDataSource.getAllJournalMonth(accountBookId);
  }
}
