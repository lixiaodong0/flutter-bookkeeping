import 'package:bookkeeping/data/bean/export_filter_condition_bean.dart';

class ExportEvent {
  const ExportEvent();
}

class ExportOnInit extends ExportEvent {
  const ExportOnInit();
}

class ExportOnAccountBookChange extends ExportEvent {
  final ExportFilterAccountBook accountBook;

  const ExportOnAccountBookChange(this.accountBook);
}

class ExportOnJournalDateChange extends ExportEvent {
  final ExportFilterJournalDate journalDate;
  final DateTime start;
  final DateTime end;

  const ExportOnJournalDateChange(
    this.journalDate, {
    required this.start,
    required this.end,
  });
}

class ExportOnJournalTypeChange extends ExportEvent {
  final ExportFilterJournalType journalType;

  const ExportOnJournalTypeChange(this.journalType);
}

class ExportOnShowJournalTypeDialog extends ExportEvent {
  const ExportOnShowJournalTypeDialog();
}

class ExportOnCloseJournalTypeDialog extends ExportEvent {
  const ExportOnCloseJournalTypeDialog();
}

class ExportOnExport extends ExportEvent {
  const ExportOnExport();
}

class ExportOnShowMonthPickerDialog extends ExportEvent {
  const ExportOnShowMonthPickerDialog();
}

class ExportOnCloseMonthPickerDialog extends ExportEvent {
  const ExportOnCloseMonthPickerDialog();
}

class ExportOnShowYearPickerDialog extends ExportEvent {
  const ExportOnShowYearPickerDialog();
}

class ExportOnCloseYearPickerDialog extends ExportEvent {
  const ExportOnCloseYearPickerDialog();
}
