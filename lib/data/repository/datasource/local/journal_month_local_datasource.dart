import 'package:bookkeeping/data/bean/journal_month_bean.dart';
import 'package:bookkeeping/data/repository/datasource/journal_month_datasource.dart';

import '../../../../db/journal_month_dao.dart';
import '../../../../db/model/journal_month_entry.dart';

class JournalMonthLocalDataSource implements JournalMonthDataSource {
  final JournalMonthDao dao;

  JournalMonthLocalDataSource({required this.dao});

  @override
  Future<int> addJournalMonth(JournalMonthEntry entry) {
    return dao.insert(entry);
  }

  @override
  Future<List<JournalMonthBean>> getAllJournalMonth(int accountBookId) {
    return dao.queryAll(accountBookId);
  }
}
