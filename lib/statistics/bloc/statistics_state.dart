import 'package:bookkeeping/data/bean/doughnut_chart_data.dart';
import 'package:bookkeeping/data/bean/journal_type.dart';
import 'package:bookkeeping/data/bean/project_ranking_bean.dart';
import 'package:equatable/equatable.dart';

import '../../data/bean/journal_month_bean.dart';

final class StatisticsState extends Equatable {
  final DateTime? currentDate;
  final JournalType currentType;
  final String currentMonthIncome;
  final String currentMonthExpense;
  final bool expandedProjectRanking;
  final List<DoughnutChartData> dougnutChartData;
  final List<ProjectRankingBean> projectRankingList;
  final DatePickerDialogState datePickerDialogState;

  const StatisticsState({
    this.currentDate,
    this.currentType = JournalType.expense,
    this.expandedProjectRanking = false,
    this.currentMonthIncome = "0",
    this.currentMonthExpense = "0",
    this.dougnutChartData = const [],
    this.projectRankingList = const [],
    this.datePickerDialogState = const DatePickerDialogCloseState(),
  });

  @override
  List<Object?> get props => [
    currentDate,
    currentType,
    expandedProjectRanking,
    currentMonthIncome,
    currentMonthExpense,
    dougnutChartData,
    projectRankingList,
    datePickerDialogState,
  ];

  StatisticsState copyWith({
    DateTime? currentDate,
    JournalType? currentType,
    bool? expandedProjectRanking,
    String? currentMonthIncome,
    String? currentMonthExpense,
    List<DoughnutChartData>? dougnutChartData,
    List<ProjectRankingBean>? projectRankingList,
    DatePickerDialogState? datePickerDialogState,
  }) {
    return StatisticsState(
      currentDate: currentDate ?? this.currentDate,
      currentType: currentType ?? this.currentType,
      expandedProjectRanking: expandedProjectRanking ?? this.expandedProjectRanking,
      currentMonthIncome: currentMonthIncome ?? this.currentMonthIncome,
      currentMonthExpense: currentMonthExpense ?? this.currentMonthExpense,
      dougnutChartData: dougnutChartData ?? this.dougnutChartData,
      projectRankingList: projectRankingList ?? this.projectRankingList,
      datePickerDialogState: datePickerDialogState ?? this.datePickerDialogState,
    );
  }
}

final class DatePickerDialogState {
  const DatePickerDialogState();
}

final class DatePickerDialogOpenState extends DatePickerDialogState {
  final DateTime currentDate;
  final List<JournalMonthGroupBean> allDate;

  const DatePickerDialogOpenState({
    required this.currentDate,
    required this.allDate,
  });
}

final class DatePickerDialogCloseState extends DatePickerDialogState {
  const DatePickerDialogCloseState();
}
