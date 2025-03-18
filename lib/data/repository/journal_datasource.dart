import 'package:bookkeeping/model/journal_entry.dart';

import '../bean/journal_bean.dart';

abstract class JournalDataSource {
  Future<List<JournalBean>> getAllJournal();

  Future<JournalBean?> addJournal(JournalEntry entry);
}
