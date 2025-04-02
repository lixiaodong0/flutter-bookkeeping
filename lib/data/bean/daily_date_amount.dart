import 'journal_project_bean.dart';

class DailyDateAmount {
  final String date;
  final String income;
  final String expense;
  final JournalProjectBean? projectBean;

  DailyDateAmount({
    required this.date,
    required this.income,
    required this.expense,
    required this.projectBean,
  });

  DailyDateAmount copyWith({
    String? date,
    String? income,
    String? expense,
    JournalProjectBean? projectBean,
  }) {
    return DailyDateAmount(
      date: date ?? this.date,
      income: income ?? this.income,
      expense: expense ?? this.expense,
      projectBean: projectBean ?? this.projectBean,
    );
  }
  @override
  String toString() {
    return 'DailyDateAmount(date: $date, income: $income, expense: $expense, projectBean: $projectBean)';
  }
}
