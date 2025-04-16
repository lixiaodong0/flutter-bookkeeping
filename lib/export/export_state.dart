import 'package:bookkeeping/data/bean/export_filter_condition_bean.dart';
import 'package:equatable/equatable.dart';

import '../data/bean/journal_project_bean.dart';

final class ExportState extends Equatable {
  final List<ExportFilterAccountBook> filterAccountBook;
  final ExportFilterAccountBook? selectedAccountBook;
  final List<ExportFilterJournalDate> filterJournalDate;
  final ExportFilterJournalDate? selectedJournalDate;
  final List<ExportFilterJournalType> filterJournalType;
  final ExportFilterJournalType? selectedJournalType;

  final JournalTypeDialog journalTypeDialogState;

  const ExportState({
    this.selectedAccountBook,
    this.selectedJournalDate,
    this.selectedJournalType,
    this.filterAccountBook = const [],
    this.filterJournalDate = const [],
    this.filterJournalType = const [],
    this.journalTypeDialogState = const JournalTypeDialogCloseState(),
  });

  ExportState copyWith({
    List<ExportFilterAccountBook>? filterAccountBook,
    ExportFilterAccountBook? selectedAccountBook,
    List<ExportFilterJournalDate>? filterJournalDate,
    List<ExportFilterJournalType>? filterJournalType,
    ExportFilterJournalDate? selectedJournalDate,
    ExportFilterJournalType? selectedJournalType,
    JournalTypeDialog? journalTypeDialogState,
  }) {
    return ExportState(
      filterAccountBook: filterAccountBook ?? this.filterAccountBook,
      selectedAccountBook: selectedAccountBook ?? this.selectedAccountBook,
      filterJournalDate: filterJournalDate ?? this.filterJournalDate,
      filterJournalType: filterJournalType ?? this.filterJournalType,
      selectedJournalDate: selectedJournalDate ?? this.selectedJournalDate,
      selectedJournalType: selectedJournalType ?? this.selectedJournalType,
      journalTypeDialogState:
          journalTypeDialogState ?? this.journalTypeDialogState,
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
    journalTypeDialogState,
  ];
}

final class JournalTypeDialog {
  const JournalTypeDialog();
}

final class JournalTypeDialogOpenState extends JournalTypeDialog {
  final JournalProjectBean? currentProject;
  final List<JournalProjectBean> allIncomeProject;
  final List<JournalProjectBean> allExpenseProject;

  const JournalTypeDialogOpenState({
    required this.currentProject,
    required this.allIncomeProject,
    required this.allExpenseProject,
  });
}

final class JournalTypeDialogCloseState extends JournalTypeDialog {
  const JournalTypeDialogCloseState();
}
