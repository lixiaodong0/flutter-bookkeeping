import 'package:bookkeeping/data/bean/journal_project_bean.dart';
import 'package:bookkeeping/data/bean/journal_type.dart';
import 'package:bookkeeping/db/journal_project_dao.dart';

import 'journal_project_datasource.dart';

class JournalProjectLocalDataSource implements JournalProjectDataSource {
  final JournalProjectDao dao;

  JournalProjectLocalDataSource({required this.dao});

  @override
  Future<List<JournalProjectBean>> getAllExpenseJournalProjects() {
    return dao.queryAll();
  }

  @override
  Future<List<JournalProjectBean>> getAllIncomeJournalProjects() {
    return dao.queryByJournalType(JournalType.income);
  }

  @override
  Future<List<JournalProjectBean>> getAllJournalProjects() {
    return dao.queryByJournalType(JournalType.expense);
  }
}
