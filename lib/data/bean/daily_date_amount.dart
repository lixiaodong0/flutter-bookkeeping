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
}
