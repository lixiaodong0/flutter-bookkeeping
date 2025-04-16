import 'package:bookkeeping/data/bean/export_filter_condition_bean.dart';
import 'package:equatable/equatable.dart';

final class ExportState extends Equatable {
  final List<ExportFilterAccountBook> filterAccountBook;
  final ExportFilterAccountBook? selectedAccountBook;
  final List<ExportFilterJournalDate> filterJournalDate;
  final ExportFilterJournalDate? selectedJournalDate;
  final List<ExportFilterJournalType> filterJournalType;
  final ExportFilterJournalType? selectedJournalType;

  const ExportState({
    this.selectedAccountBook,
    this.selectedJournalDate,
    this.selectedJournalType,
    this.filterAccountBook = const [],
    this.filterJournalDate = const [],
    this.filterJournalType = const [],
  });

  ExportState copyWith({
    List<ExportFilterAccountBook>? filterAccountBook,
    ExportFilterAccountBook? selectedAccountBook,
    List<ExportFilterJournalDate>? filterJournalDate,
    List<ExportFilterJournalType>? filterJournalType,
    ExportFilterJournalDate? selectedJournalDate,
    ExportFilterJournalType? selectedJournalType,
  }) {
    return ExportState(
      filterAccountBook: filterAccountBook ?? this.filterAccountBook,
      selectedAccountBook: selectedAccountBook ?? this.selectedAccountBook,
      filterJournalDate: filterJournalDate ?? this.filterJournalDate,
      filterJournalType: filterJournalType ?? this.filterJournalType,
      selectedJournalDate: selectedJournalDate ?? this.selectedJournalDate,
      selectedJournalType: selectedJournalType ?? this.selectedJournalType,
    );
  }

  @override
  List<Object?> get props => [
    filterAccountBook,
    selectedAccountBook,
    filterJournalDate,
    filterJournalType,
    selectedJournalDate,
    selectedJournalType,
  ];
}
