
import 'package:bookkeeping/data/bean/journal_bean.dart';
import 'package:bookkeeping/db/journal_dao.dart';

import '../../../db/model/journal_entry.dart';
import 'journal_datasource.dart';

class JournalLocalDataSource implements JournalDataSource {
  final JournalDao dao;

  JournalLocalDataSource({required this.dao});

  @override
  Future<int> addJournal(JournalEntry entry) async {
    return await dao.insert(entry);
  }

  @override
  Future<List<JournalBean>> getAllJournal() async {
    var results = await dao.queryAll();
    return results;
  }
}
