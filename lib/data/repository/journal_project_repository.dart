import 'package:bookkeeping/data/bean/journal_project_bean.dart';

import 'datasource/journal_project_datasource.dart';

class JournalProjectRepository implements JournalProjectDataSource {
  final JournalProjectDataSource _localDataSource;

  JournalProjectRepository({required JournalProjectDataSource localDataSource})
    : _localDataSource = localDataSource;

  @override
  Future<List<JournalProjectBean>> getAllExpenseJournalProjects() {
    return _localDataSource.getAllJournalProjects();
  }

  @override
  Future<List<JournalProjectBean>> getAllIncomeJournalProjects() {
    return _localDataSource.getAllIncomeJournalProjects();
  }

  @override
  Future<List<JournalProjectBean>> getAllJournalProjects() {
    return _localDataSource.getAllJournalProjects();
  }
}
