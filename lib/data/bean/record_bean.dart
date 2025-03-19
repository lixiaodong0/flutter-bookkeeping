import 'journal_type.dart';

class RecordBean {
  final String amount;
  final JournalType journalType;
  String? remark;
  RecordBean({required this.amount, required this.journalType, this.remark});
}
