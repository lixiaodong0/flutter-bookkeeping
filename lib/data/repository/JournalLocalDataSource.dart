import 'package:bookkeeping/data/bean/JournalBean.dart';
import 'package:bookkeeping/db/JournalDao.dart';

import '../../model/JournalEntry.dart';
import 'JournalDataSource.dart';

class JournalLocalDataSource implements JournalDataSource {
  final JournalDao dao;

  JournalLocalDataSource({required this.dao});

  @override
  Future<JournalBean?> addJournal(JournalEntry entry) async {
    var result = await dao.insert(entry);
    if (result > 0) {
      return JournalBean(
        id: result,
        type: entry.type,
        amount: entry.amount,
        date: entry.date,
        description: entry.description,
      );
    }
    return null;
  }

  @override
  Future<List<JournalBean>> getAllJournal() async {
    var results = await dao.queryAll();
    return results.map((e) => toJournalBean(e)).toList();
  }

  static JournalBean toJournalBean(JournalEntry entry) {
    return JournalBean(
      id: entry.id ?? 0,
      type: entry.type,
      amount: entry.amount,
      date: entry.date,
      description: entry.description,
    );
  }
}
