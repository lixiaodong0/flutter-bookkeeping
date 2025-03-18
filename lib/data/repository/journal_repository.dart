import 'package:bookkeeping/data/bean/journal_bean.dart';
import 'package:bookkeeping/data/repository/journal_datasource.dart';
import 'package:bookkeeping/model/journal_entry.dart';

class JournalRepository implements JournalDataSource {
  final JournalDataSource _localDataSource;

  JournalRepository({required JournalDataSource localDataSource})
    : _localDataSource = localDataSource;

  @override
  Future<JournalBean?> addJournal(JournalEntry entry) {
    return _localDataSource.addJournal(entry);
  }

  @override
  Future<List<JournalBean>> getAllJournal() {
    return _localDataSource.getAllJournal();
  }
}
