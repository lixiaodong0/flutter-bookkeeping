import 'package:bookkeeping/data/bean/day_chart_data.dart';
import 'package:bookkeeping/data/bean/doughnut_chart_data.dart';
import 'package:bookkeeping/data/bean/journal_bean.dart';
import 'package:bookkeeping/data/bean/journal_type.dart';
import 'package:bookkeeping/data/bean/month_chart_data.dart';
import 'package:bookkeeping/data/bean/project_ranking_bean.dart';
import 'package:equatable/equatable.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../data/bean/journal_month_bean.dart';

final class StatisticsState extends Equatable {
  final DateTime? currentDate;
  final JournalType currentType;
  final String currentMonthAmount;
  final bool expandedProjectRanking;
  final List<DayChartData> everyDayChartData;
  final SelectionBehavior? everyDaySelectionBehavior;
  final TrackballBehavior? everyDayTrackballBehavior;
  final List<DoughnutChartData> dougnutChartData;
  final List<ProjectRankingBean> projectRankingList;
  final List<MonthChartData> monthChartData;
  final SelectionBehavior? monthSelectionBehavior;
  final int selectMonthChartDataIndex;
  final int selectDayChartDataIndex;
  final List<JournalBean> monthRankingList;
  final DatePickerDialogState datePickerDialogState;

  const StatisticsState({
    this.currentDate,
    this.currentType = JournalType.expense,
    this.expandedProjectRanking = false,
    this.currentMonthAmount = "0",
    this.everyDayChartData = const [],
    this.everyDaySelectionBehavior,
    this.everyDayTrackballBehavior,
    this.dougnutChartData = const [],
    this.projectRankingList = const [],
    this.monthChartData = const [],
    this.monthSelectionBehavior,
    this.selectMonthChartDataIndex = 0,
    this.selectDayChartDataIndex = 0,
    this.monthRankingList = const [],
    this.datePickerDialogState = const DatePickerDialogCloseState(),
  });

  @override
  List<Object?> get props => [
    currentDate,
    currentType,
    expandedProjectRanking,
    currentMonthAmount,
    everyDayChartData,
    everyDaySelectionBehavior,
    everyDayTrackballBehavior,
    dougnutChartData,
    projectRankingList,
    datePickerDialogState,
    monthChartData,
    monthSelectionBehavior,
    selectMonthChartDataIndex,
    selectDayChartDataIndex,
    monthRankingList,
  ];

  StatisticsState copyWith({
    DateTime? currentDate,
    JournalType? currentType,
    bool? expandedProjectRanking,
    String? currentMonthAmount,
    List<DayChartData>? everyDayChartData,
    SelectionBehavior? everyDaySelectionBehavior,
    TrackballBehavior? everyDayTrackballBehavior,
    List<DoughnutChartData>? dougnutChartData,
    List<ProjectRankingBean>? projectRankingList,
    List<MonthChartData>? monthChartData,
    SelectionBehavior? monthSelectionBehavior,
    int? selectMonthChartDataIndex,
    int? selectDayChartDataIndex,
    DatePickerDialogState? datePickerDialogState,
    List<JournalBean>? monthRankingList,
  }) {
    return StatisticsState(
      currentDate: currentDate ?? this.currentDate,
      currentType: currentType ?? this.currentType,
      expandedProjectRanking:
          expandedProjectRanking ?? this.expandedProjectRanking,
      currentMonthAmount: currentMonthAmount ?? this.currentMonthAmount,
      everyDayChartData: everyDayChartData ?? this.everyDayChartData,
      everyDaySelectionBehavior: everyDaySelectionBehavior ?? this.everyDaySelectionBehavior,
      everyDayTrackballBehavior: everyDayTrackballBehavior ?? this.everyDayTrackballBehavior,
      dougnutChartData: dougnutChartData ?? this.dougnutChartData,
      projectRankingList: projectRankingList ?? this.projectRankingList,
      monthChartData: monthChartData ?? this.monthChartData,
      monthSelectionBehavior: monthSelectionBehavior ?? this.monthSelectionBehavior,
      selectMonthChartDataIndex:
          selectMonthChartDataIndex ?? this.selectMonthChartDataIndex,
      selectDayChartDataIndex:
          selectDayChartDataIndex ?? this.selectDayChartDataIndex,
      monthRankingList: monthRankingList ?? this.monthRankingList,
      datePickerDialogState:
          datePickerDialogState ?? this.datePickerDialogState,
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
