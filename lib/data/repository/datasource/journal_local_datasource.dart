import 'package:bookkeeping/data/bean/journal_bean.dart';
import 'package:bookkeeping/data/bean/journal_type.dart';
import 'package:bookkeeping/db/journal_dao.dart';

import '../../../db/model/journal_entry.dart';
import '../../bean/journal_project_bean.dart';
import 'journal_datasource.dart';

class JournalLocalDataSource implements JournalDataSource {
  final JournalDao dao;

  JournalLocalDataSource({required this.dao});

  @override
  Future<int> addJournal(JournalEntry entry) async {
    return await dao.insert(entry);
  }

  @override
  Future<List<JournalBean>> getAllJournal() async {
    var results = await dao.queryAll();
    return results;
  }

  @override
  Future<List<JournalBean>> getPageJournal({
    int pageSize = 20,
    int page = 1,

    DateTime? limitDate,
    JournalProjectBean? limitProject,
  }) async {
    var results = await dao.queryPager(
      pageSize: pageSize,
      page: page,
      limitDate: limitDate,
      limitProject: limitProject,
    );
    return results;
  }

  @override
  Future<String> getTodayTotalAmount(DateTime date, JournalType type) {
    return dao.queryTodayTotalAmount(date, type);
  }

  @override
  Future<String> getMonthTotalAmount(DateTime date, JournalType type) {
    return dao.queryMonthTotalAmount(date, type);
  }

  @override
  Future<List<JournalBean>> getMonthJournal(DateTime limitDate, JournalType journalType) {
    return dao.queryAllByMonth(limitDate, journalType);
  }
}
