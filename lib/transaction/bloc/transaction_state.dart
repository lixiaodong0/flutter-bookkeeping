import 'package:bookkeeping/data/bean/journal_bean.dart';
import 'package:bookkeeping/data/bean/journal_month_bean.dart';
import 'package:bookkeeping/data/bean/journal_project_bean.dart';
import 'package:equatable/equatable.dart';

import '../../data/bean/journal_type.dart';

final class TransactionState extends Equatable {
  final List<JournalBean> lists;
  final RecordDialogState recordDialogState;
  final MonthPickerDialogState monthPickerDialogState;
  final ProjectPickerDialogState projectPickerDialogState;

  final JournalProjectBean? currentProject;
  final DateTime? currentDate;
  final String dateMonthIncome;
  final String dateMonthExpense;

  const TransactionState({
    this.lists = const [],
    this.recordDialogState = RecordDialogState.close,
    this.monthPickerDialogState = const MonthPickerDialogCloseState(),
    this.projectPickerDialogState = const ProjectPickerDialogCloseState(),
    this.currentProject,
    this.currentDate,
    this.dateMonthIncome = "0",
    this.dateMonthExpense = "0",
  });

  @override
  List<Object?> get props => [
    lists,
    recordDialogState,
    monthPickerDialogState,
    projectPickerDialogState,
    currentProject,
    currentDate,
    dateMonthIncome,
    dateMonthExpense,
  ];

  TransactionState copyWith({
    List<JournalBean>? lists,
    RecordDialogState? recordDialogState,
    MonthPickerDialogState? monthPickerDialogState,
    ProjectPickerDialogState? projectPickerDialogState,
    JournalProjectBean? currentProject,
    DateTime? currentDate,
    String? dateMonthIncome,
    String? dateMonthExpense,
  }) {
    return TransactionState(
      lists: lists ?? this.lists,
      recordDialogState: recordDialogState ?? this.recordDialogState,
      monthPickerDialogState:
          monthPickerDialogState ?? this.monthPickerDialogState,
      projectPickerDialogState:
          projectPickerDialogState ?? this.projectPickerDialogState,
      currentProject: currentProject ?? this.currentProject,
      currentDate: currentDate ?? this.currentDate,
      dateMonthIncome: dateMonthIncome ?? this.dateMonthIncome,
      dateMonthExpense: dateMonthExpense ?? this.dateMonthExpense,
    );
  }
}

enum RecordDialogState { close, open }

final class MonthPickerDialogState {
  const MonthPickerDialogState();
}

final class MonthPickerDialogOpenState extends MonthPickerDialogState {
  final DateTime currentDate;
  final List<JournalMonthGroupBean> allDate;

  const MonthPickerDialogOpenState({
    required this.currentDate,
    required this.allDate,
  });
}

final class MonthPickerDialogCloseState extends MonthPickerDialogState {
  const MonthPickerDialogCloseState();
}

final class ProjectPickerDialogState {
  const ProjectPickerDialogState();
}

final class ProjectPickerDialogOpenState extends ProjectPickerDialogState {
  final JournalProjectBean? currentProject;
  final List<JournalProjectBean> allIncomeProject;
  final List<JournalProjectBean> allExpenseProject;

  const ProjectPickerDialogOpenState({
    required this.currentProject,
    required this.allIncomeProject,
    required this.allExpenseProject,
  });
}

final class ProjectPickerDialogCloseState extends ProjectPickerDialogState {
  const ProjectPickerDialogCloseState();
}
