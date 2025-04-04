import 'package:bookkeeping/data/bean/journal_type.dart';

import '../../../db/model/journal_entry.dart';
import '../../bean/journal_bean.dart';
import '../../bean/journal_project_bean.dart';

abstract class JournalDataSource {
  Future<JournalBean?> getJournal(int id);

  Future<List<JournalBean>> getAllJournal();

  Future<List<JournalBean>> getMonthJournal(
    DateTime limitDate,
    JournalType journalType, {
    int projectId = -1,
  });

  Future<List<JournalBean>> getDayJournal(
    DateTime limitDate,
    JournalType journalType,
  );

  Future<List<JournalBean>> getPageJournal({
    int pageSize = 20,
    int page = 0,
    DateTime? limitDate,
    JournalProjectBean? limitProject,
  });

  Future<String> getTodayTotalAmount(
    DateTime date,
    JournalType type, {
    int projectId = -1,
  });

  Future<String> getMonthTotalAmount(
    DateTime date,
    JournalType type, {
    int projectId = -1,
  });

  Future<int> addJournal(JournalEntry entry);
  Future<int> updateJournal(JournalEntry entry);

  Future<int> deleteJournal(int id);
}
