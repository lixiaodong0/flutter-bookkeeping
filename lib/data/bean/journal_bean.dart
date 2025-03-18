final class JournalBean {
  final int id;
  final String type;
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
