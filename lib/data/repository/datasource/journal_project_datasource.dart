import 'package:bookkeeping/data/bean/journal_project_bean.dart';

abstract class JournalProjectDataSource {
  Future<List<JournalProjectBean>> getAllJournalProjects();

  Future<List<JournalProjectBean>> getAllIncomeJournalProjects();

  Future<List<JournalProjectBean>> getAllExpenseJournalProjects();
}
