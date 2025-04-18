import 'package:bookkeeping/data/bean/export_params.dart';
import 'package:bookkeeping/data/bean/journal_type.dart';

import '../../../db/model/journal_entry.dart';
import '../../bean/journal_bean.dart';
import '../../bean/journal_project_bean.dart';

abstract class JournalDataSource {

  Future<List<JournalBean>> exportJournal(ExportParams params);

  Future<JournalBean?> getJournal(int id);

  Future<List<JournalBean>> getMonthJournal(
    int accountBookId,
    DateTime limitDate,
    JournalType journalType, {
    int projectId = -1,
  });

  Future<List<JournalBean>> getDayJournal(
    int accountBookId,
    DateTime limitDate,
    JournalType journalType,
  );

  Future<List<JournalBean>> getPageJournal(
    int accountBookId, {
    int pageSize = 20,
    int page = 0,
    DateTime? limitDate,
    JournalProjectBean? limitProject,
  });

  Future<String> getTodayTotalAmount(
    int accountBookId,
    DateTime date,
    JournalType type, {
    int projectId = -1,
  });

  Future<String> getMonthTotalAmount(
    int accountBookId,
    DateTime date,
    JournalType type, {
    int projectId = -1,
  });

  Future<int> addJournal(JournalEntry entry);

  Future<int> updateJournal(JournalEntry entry);

  Future<int> deleteJournal(int id);
}
