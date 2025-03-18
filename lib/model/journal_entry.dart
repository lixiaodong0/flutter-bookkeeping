/*
 * 每月收入支出表
 */
final class JournalEntry {
  final int? id; //主键可为空
  final String type; // 'income' 或 'expense'
  final double amount;
  final DateTime date;
  final String description;

  JournalEntry({
    this.id,
    required this.type,
    required this.amount,
    required this.date,
    required this.description,
  });

  factory JournalEntry.fromJson(Map<String, dynamic> json) => JournalEntry(
    id: json['id'],
    type: json['type'],
    amount: json['amount'],
    date: DateTime.parse(json['date']),
    description: json['description'],
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'date': date.toIso8601String(),
      'description': description,
    };
  }
}
