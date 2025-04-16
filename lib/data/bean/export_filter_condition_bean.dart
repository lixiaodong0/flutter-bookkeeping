class ExportFilterAccountBook {
  int id;
  String name;

  ExportFilterAccountBook({required this.id, required this.name});
}

class ExportFilterJournalDate {
  String name;

  ExportFilterJournalDate({required this.name});
}

class JournalDateToday extends ExportFilterJournalDate {
  JournalDateToday({required super.name});
}

class JournalDateCurrentMonth extends ExportFilterJournalDate {
  JournalDateCurrentMonth({required super.name});
}

class JournalDateCurrentWeek extends ExportFilterJournalDate {
  JournalDateCurrentWeek({required super.name});
}

class JournalDateCurrentYear extends ExportFilterJournalDate {
  JournalDateCurrentYear({required super.name});
}

class JournalDateCustom extends ExportFilterJournalDate {
  JournalDateCustom({required super.name});
}

class ExportFilterJournalType {
  String name;

  ExportFilterJournalType({required this.name});
}

class JournalTypeAll extends ExportFilterJournalType {
  JournalTypeAll({required super.name});
}

class JournalTypeIncome extends ExportFilterJournalType {
  JournalTypeIncome({required super.name});
}

class JournalTypeExpense extends ExportFilterJournalType {
  JournalTypeExpense({required super.name});
}

class JournalTypeCustom extends ExportFilterJournalType {
  JournalTypeCustom({required super.name});
}
