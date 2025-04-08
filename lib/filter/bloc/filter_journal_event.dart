import '../../data/bean/filter_type.dart';

class FilterJournalEvent {
  const FilterJournalEvent();
}

class FilterJournalInitLoad extends FilterJournalEvent {
  const FilterJournalInitLoad();
}

class FilterJournalReload extends FilterJournalEvent {
  const FilterJournalReload();
}

class FilterJournalOnChangeFilterType extends FilterJournalEvent {
  final FilterType filterType;

  const FilterJournalOnChangeFilterType({required this.filterType});
}
