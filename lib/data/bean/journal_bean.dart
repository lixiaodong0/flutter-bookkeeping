import 'package:bookkeeping/data/bean/journal_type.dart';

final class JournalBean {
  int id;
  final JournalType type;
  final double amount;
  final DateTime date;
  final String description;

  JournalBean({
    required this.id,
    required this.type,
    required this.amount,
    required this.date,
    required this.description,
  });
}
