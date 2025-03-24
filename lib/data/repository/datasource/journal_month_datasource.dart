import 'package:bookkeeping/data/bean/journal_month_bean.dart';
import 'package:bookkeeping/db/model/journal_month_entry.dart';

abstract class JournalMonthDataSource {
  Future<List<JournalMonthBean>> getAllJournalMonth();

  Future<int> addJournalMonth(JournalMonthEntry entry);
}
