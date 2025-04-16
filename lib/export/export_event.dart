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

  const ExportOnJournalDateChange(this.journalDate);
}

class ExportOnJournalTypeChange extends ExportEvent {
  final ExportFilterJournalType journalType;

  const ExportOnJournalTypeChange(this.journalType);
}

class ExportOnExport extends ExportEvent {
  const ExportOnExport();
}
