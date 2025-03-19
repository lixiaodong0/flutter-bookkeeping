import 'package:bookkeeping/data/bean/journal_bean.dart';
import 'package:bookkeeping/data/bean/journal_type.dart';
import 'package:bookkeeping/db/journal_dao.dart';

import '../../model/journal_entry.dart';
import 'journal_datasource.dart';

class JournalLocalDataSource implements JournalDataSource {
  final JournalDao dao;

  JournalLocalDataSource({required this.dao});

  @override
  Future<JournalBean?> addJournal(JournalEntry entry) async {
    var result = await dao.insert(entry);
    if (result > 0) {
      var bean = toJournalBean(entry);
      bean.id = result;
      return bean;
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
      type: JournalType.fromName(entry.type),
      amount: entry.amount,
      date: entry.date,
      description: entry.description ?? "",
    );
  }
}
