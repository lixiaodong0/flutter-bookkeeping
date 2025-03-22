import 'package:bookkeeping/data/bean/journal_type.dart';

import '../../../db/model/journal_entry.dart';
import '../../bean/journal_bean.dart';

abstract class JournalDataSource {
  Future<List<JournalBean>> getAllJournal();

  Future<List<JournalBean>> getPageJournal({int pageSize = 20, int page = 0});

  Future<String> getTodayTotalAmount(DateTime date,JournalType type);

  Future<int> addJournal(JournalEntry entry);
}
