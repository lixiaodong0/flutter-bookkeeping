
import '../../../db/model/journal_entry.dart';
import '../../bean/journal_bean.dart';

abstract class JournalDataSource {
  Future<List<JournalBean>> getAllJournal();

  Future<int> addJournal(JournalEntry entry);
}
