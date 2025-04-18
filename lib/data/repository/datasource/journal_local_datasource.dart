import 'package:bookkeeping/data/bean/export_params.dart';
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
  Future<JournalBean?> getJournal(int id) async {
    return await dao.queryById(id);
  }

  @override
  Future<int> addJournal(JournalEntry entry) async {
    return await dao.insert(entry);
  }

  @override
  Future<int> updateJournal(JournalEntry entry) async {
    return await dao.update(entry);
  }

  @override
  Future<List<JournalBean>> getPageJournal(
    int accountBookId, {
    int pageSize = 20,
    int page = 1,

    DateTime? limitDate,
    JournalProjectBean? limitProject,
  }) async {
    var results = await dao.queryPager(
      accountBookId,
      pageSize: pageSize,
      page: page,
      limitDate: limitDate,
      limitProject: limitProject,
    );
    return results;
  }

  @override
  Future<String> getTodayTotalAmount(
    int accountBookId,
    DateTime date,
    JournalType type, {
    int projectId = -1,
  }) {
    return dao.queryTodayTotalAmount(
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
    return dao.queryMonthTotalAmount(
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
    return dao.queryAllByMonth(
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
    return dao.queryAllByDay(accountBookId, limitDate, journalType);
  }

  @override
  Future<int> deleteJournal(int id) {
    return dao.delete(id);
  }

  @override
  Future<List<JournalBean>> exportJournal(ExportParams params) {
    return dao.export(params);
  }
}
