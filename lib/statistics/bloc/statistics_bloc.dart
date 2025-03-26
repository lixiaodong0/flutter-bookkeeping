import 'package:bookkeeping/data/bean/doughnut_chart_data.dart';
import 'package:bookkeeping/data/bean/journal_bean.dart';
import 'package:bookkeeping/data/bean/journal_type.dart';
import 'package:bookkeeping/data/bean/project_ranking_bean.dart';
import 'package:bookkeeping/data/repository/journal_month_repository.dart';
import 'package:bookkeeping/data/repository/journal_repository.dart';
import 'package:bookkeeping/statistics/bloc/statistics_event.dart';
import 'package:bookkeeping/statistics/bloc/statistics_state.dart';
import 'package:bookkeeping/util/format_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/bean/journal_month_bean.dart';

class StatisticsBloc extends Bloc<StatisticsEvent, StatisticsState> {
  final JournalRepository repository;
  final JournalMonthRepository monthRepository;

  StatisticsBloc({required this.repository, required this.monthRepository})
    : super(StatisticsState(currentDate: DateTime.now())) {
    on<StatisticsInitLoad>(_onInitLoad);
    on<StatisticsOnSwitchType>(_onSwitchType);
    on<StatisticsOnShowDatePicker>(_onShowDatePicker);
    on<StatisticsOnCloseDatePicker>(_onShowCloseDatePicker);
    on<StatisticsOnSelectedDate>(_onSelectedDate);
    on<StatisticsOnExpandedChange>(_onExpandedChange);
  }

  void _onExpandedChange(
    StatisticsOnExpandedChange event,
    Emitter<StatisticsState> emit,
  ) async {
    emit(state.copyWith(expandedProjectRanking: event.newExpanded));
  }

  void _onSelectedDate(
    StatisticsOnSelectedDate event,
    Emitter<StatisticsState> emit,
  ) async {
    emit(state.copyWith(currentDate: event.selectedDate));
    await _reload(emit);
  }

  void _onShowDatePicker(
    StatisticsOnShowDatePicker event,
    Emitter<StatisticsState> emit,
  ) async {
    var result = await monthRepository.getAllJournalMonth();

    Map<int, List<JournalMonthBean>> map = {};
    for (var item in result) {
      var valueList = map[item.year];
      valueList ??= [];
      valueList.add(item);
      map[item.year] = valueList;
    }

    List<JournalMonthGroupBean> group = [];
    for (var item in map.entries) {
      var list = item.value;
      list.sort((a, b) => a.month.compareTo(b.month));
      group.add(JournalMonthGroupBean(year: item.key, list: list));
    }

    emit(
      state.copyWith(
        datePickerDialogState: DatePickerDialogOpenState(
          currentDate: state.currentDate ?? DateTime.now(),
          allDate: group,
        ),
      ),
    );
  }

  void _onShowCloseDatePicker(
    StatisticsOnCloseDatePicker event,
    Emitter<StatisticsState> emit,
  ) async {
    emit(state.copyWith(datePickerDialogState: DatePickerDialogCloseState()));
  }

  void _onSwitchType(
    StatisticsOnSwitchType event,
    Emitter<StatisticsState> emit,
  ) async {
    emit(state.copyWith(currentType: event.journalType));
    await _reload(emit);
  }

  void _onInitLoad(
    StatisticsInitLoad event,
    Emitter<StatisticsState> emit,
  ) async {
    await _reload(emit);
  }

  Future<void> _reload(Emitter<StatisticsState> emit) async {
    var currentDate = state.currentDate ?? DateTime.now();
    var currentType = state.currentType;

    var monthIncome = await repository.getMonthTotalAmount(
      currentDate,
      JournalType.income,
    );
    var monthExpense = await repository.getMonthTotalAmount(
      currentDate,
      JournalType.expense,
    );

    var monthJournal = await repository.getMonthJournal(
      currentDate,
      currentType,
    );

    Map<int, ProjectWrapper> map = {};
    for (var item in monthJournal) {
      var key = item.journalProjectId;
      var value =
          map[key] ?? ProjectWrapper(id: key, name: item.journalProjectName);
      value.amount += num.parse(item.amount);
      map[key] = value;
    }
    List<ProjectWrapper> projectList = [];
    for (var item in map.entries) {
      projectList.add(item.value);
    }

    //圆形图表数据
    var dougnutChartData = _createChartData(projectList, currentType);
    //产品分类数据
    var projectRankingData = _createProjectRankingData(
      projectList,
      currentType,
    );

    emit(
      state.copyWith(
        dougnutChartData: dougnutChartData,
        projectRankingList: projectRankingData,
        currentMonthIncome: monthIncome,
        currentMonthExpense: monthExpense,
      ),
    );
  }

  List<ProjectRankingBean> _createProjectRankingData(
    List<ProjectWrapper> list,
    JournalType type,
  ) {
    List<ProjectRankingBean> rankingList = [];
    if (list.isEmpty) {
      return rankingList;
    }

    var maxProject = list.first;
    for (var item in list) {
      if (item.amount > maxProject.amount) {
        maxProject = item;
      }
    }

    for (var item in list) {
      var data = ProjectRankingBean(
        id: item.id,
        name: item.name,
        amount: item.amount,
        progress: item.amount / maxProject.amount,
      );
      rankingList.add(data);
    }
    //从大到小 排序
    rankingList.sort((a, b) => b.amount.compareTo(a.amount));
    return rankingList;
  }

  List<DoughnutChartData> _createChartData(
    List<ProjectWrapper> list,
    JournalType type,
  ) {
    num total = 0;
    if (list.isNotEmpty) {
      for (var element in list) {
        total += element.amount;
      }
    }
    List<DoughnutChartData> chartDataList = [];
    Color color = type == JournalType.expense ? Colors.green : Colors.orange;
    for (var item in list) {
      var ratioStr = (item.amount / total).toStringAsFixed(2);
      var ratio = double.parse(ratioStr) * 100;
      var data = DoughnutChartData(
        "${item.name} ${FormatUtil.formatAmount(ratio.toString())}%",
        ratio,
        color,
      );
      chartDataList.add(data);
    }
    //从大到小 排序
    chartDataList.sort((a, b) => b.value.compareTo(a.value));

    //设置颜色
    var alpha = 255;
    for (var data in chartDataList) {
      data.color = data.color.withAlpha(alpha);
      alpha -= 25;
      if (alpha < 0) {
        alpha = 0;
      }
    }
    return chartDataList;
  }
}

class ProjectWrapper {
  final int id;
  final String name;
  num amount = 0;

  ProjectWrapper({required this.id, required this.name});
}
