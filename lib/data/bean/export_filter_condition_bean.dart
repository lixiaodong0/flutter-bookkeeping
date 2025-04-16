import 'journal_project_bean.dart';

class ExportFilterAccountBook {
  int id;
  String name;

  ExportFilterAccountBook({required this.id, required this.name});
}

enum FilterJournalDate {
  today,
  currentWeek,
  currentMonth,
  currentYear,
  customMonth,
  customYear,
  customRange,
}

class ExportFilterJournalDate {
  FilterJournalDate type;
  String name;
  DateTime? start;
  DateTime? end;

  ExportFilterJournalDate({
    required this.type,
    required this.name,
    this.start,
    this.end,
  });

  bool isCustomDate() {
    return type == FilterJournalDate.customMonth ||
        type == FilterJournalDate.customYear ||
        type == FilterJournalDate.customRange;
  }
}

enum FilterJournalType { all, income, expense, custom }

class ExportFilterJournalType {
  FilterJournalType type;
  String name;

  ExportFilterJournalType({required this.type, required this.name});
}

class JournalTypeAll extends ExportFilterJournalType {
  JournalTypeAll({required super.name}) : super(type: FilterJournalType.all);
}

class JournalTypeIncome extends ExportFilterJournalType {
  JournalTypeIncome({required super.name})
    : super(type: FilterJournalType.income);
}

class JournalTypeExpense extends ExportFilterJournalType {
  JournalTypeExpense({required super.name})
    : super(type: FilterJournalType.expense);
}

class JournalTypeCustom extends ExportFilterJournalType {
  JournalProjectBean? data;

  JournalTypeCustom({this.data, required super.name})
    : super(type: FilterJournalType.custom);
}
