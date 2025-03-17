import 'package:bookkeeping/model/JournalEntry.dart';

import '../bean/JournalBean.dart';

abstract class JournalDataSource {
  Future<List<JournalBean>> getAllJournal();

  Future<JournalBean?> addJournal(JournalEntry entry);
}
