import 'package:bookkeeping/data/bean/day_chart_data.dart';
import 'package:bookkeeping/data/bean/doughnut_chart_data.dart';
import 'package:bookkeeping/data/bean/journal_bean.dart';
import 'package:bookkeeping/data/bean/journal_type.dart';
import 'package:bookkeeping/data/bean/month_chart_data.dart';
import 'package:bookkeeping/data/bean/project_ranking_bean.dart';
import 'package:bookkeeping/data/repository/journal_month_repository.dart';
import 'package:bookkeeping/data/repository/journal_repository.dart';
import 'package:bookkeeping/statistics/bloc/statistics_event.dart';
import 'package:bookkeeping/statistics/bloc/statistics_state.dart';
import 'package:bookkeeping/util/format_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/bean/journal_month_bean.dart';
import '../../util/date_util.dart';
import '../statistics_chart.dart';

class StatisticsBloc extends Bloc<StatisticsEvent, StatisticsState> {
  final JournalRepository repository;
  final JournalMonthRepository monthRepository;

  StatisticsBloc({required this.repository, required this.monthRepository})
    : super(StatisticsState(currentDate: DateTime.now())) {
    on<StatisticsInitLoad>(_onInitLoad);
    on<StatisticsReload>(_onReload);
    on<StatisticsOnSwitchType>(_onSwitchType);
    on<StatisticsOnShowDatePicker>(_onShowDatePicker);
    on<StatisticsOnCloseDatePicker>(_onShowCloseDatePicker);
    on<StatisticsOnSelectedDate>(_onSelectedDate);
    on<StatisticsOnExpandedChange>(_onExpandedChange);
    on<StatisticsOnChangeJournalRankingList>(_onChangeJournalRankingList);
    on<StatisticsOnChangeDayChartData>(_onChangeDayChartData);
  }

  void _onChangeDayChartData(
    StatisticsOnChangeDayChartData event,
    Emitter<StatisticsState> emit,
  ) async {
    var selectIndex = event.selectIndex;
    emit(state.copyWith(selectDayChartDataIndex: selectIndex));
  }

  void _onChangeJournalRankingList(
    StatisticsOnChangeJournalRankingList event,
    Emitter<StatisticsState> emit,
  ) async {
    var changeDateTime = event.changeDateTime;
    var selectIndex = event.selectIndex;
    var result = await _queryJournalMonth(changeDateTime, state.currentType);
    emit(
      state.copyWith(
        monthRankingList: result,
        selectMonthChartDataIndex: selectIndex,
      ),
    );
  }

  Future<List<JournalBean>> _queryJournalMonth(
    DateTime currentDate,
    JournalType journalType,
  ) async {
    List<JournalBean> list = await repository.getMonthJournal(
      currentDate,
      journalType,
    );
    //价格从大到小排序
    list.sort((a, b) => num.parse(b.amount).compareTo(num.parse(a.amount)));
    //最多返回11条数据
    return list.take(11).toList();
  }

  Future<List<JournalBean>> _queryJournalDay(
    DateTime currentDate,
    JournalType journalType,
  ) async {
    return repository.getDayJournal(currentDate, journalType);
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
    emit(
      state.copyWith(
        currentDate: event.selectedDate,
        datePickerDialogState: DatePickerDialogCloseState(),
      ),
    );
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

  void _onReload(StatisticsReload event, Emitter<StatisticsState> emit) async {
    await _reload(emit);
  }

  void _onInitLoad(
    StatisticsInitLoad event,
    Emitter<StatisticsState> emit,
  ) async {
    await _reload(emit);
  }

  Future<List<DayChartData>> _createEveryDayChartData(
    DateTime endTime,
    JournalType type,
  ) async {
    var startTime = endTime;
    List<DayChartData> list = [];
    for (var index = 0; index < 30; index++) {
      var todayAmount = await repository.getTodayTotalAmount(startTime, type);
      list.insert(0, DayChartData(startTime, num.parse(todayAmount)));
      startTime = startTime.subtract(Duration(days: 1));
    }
    print("_createEveryDayChartData");
    print(list);
    return list;
  }

  Future<void> _reload(Emitter<StatisticsState> emit) async {
    var currentDate = state.currentDate ?? DateTime.now();
    var currentType = state.currentType;

    var currentMonthAmount = await repository.getMonthTotalAmount(
      currentDate,
      currentType,
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

    //每天图表数据
    var everyDayCharData = await _createEveryDayChartData(
      currentDate,
      currentType,
    );

    var everyDayTrackballBehavior =
        ChartBehaviorProvider.createTrackballBehavior(currentType);
    var everyDaySelectionBehavior =
        ChartBehaviorProvider.createSelectionBehavior(currentType);
    var selectDayChartDataIndex = everyDayCharData.length - 1;
    // everyDaySelectionBehavior.selectDataPoints(selectDayChartDataIndex);

    //每月图表数据
    //半年
    List<MonthChartData> monthChartDataList = [];
    monthChartDataList.add(
      MonthChartData(
        date: currentDate,
        dateStr: "${currentDate.month}月",
        amount: double.parse(currentMonthAmount),
        amountLabel: '¥${FormatUtil.formatAmount(currentMonthAmount)}',
      ),
    );
    var startDate = currentDate;
    DateTime? findFormatDate;
    for (var index = 0; index < 5; index++) {
      if (startDate.month - 1 >= 1) {
        startDate = DateTime(startDate.year, startDate.month - 1);
      } else {
        startDate = DateTime(startDate.year - 1, 12);

        findFormatDate = startDate;
      }
      var monthAmount = await repository.getMonthTotalAmount(
        startDate,
        currentType,
      );
      monthChartDataList.insert(
        0,
        MonthChartData(
          date: startDate,
          dateStr: "${startDate.month}月",
          amount: double.parse(monthAmount),
          amountLabel: '¥${FormatUtil.formatAmount(monthAmount)}',
        ),
      );
    }

    var monthSelectionBehavior = ChartBehaviorProvider.createSelectionBehavior(
      currentType,
    );

    //这里主要用是区分不同年份
    if (findFormatDate != null) {
      var findIndex = monthChartDataList.indexWhere(
        (data) => data.date == findFormatDate,
      );
      if (findIndex != -1) {
        var currentItem = monthChartDataList[findIndex];
        currentItem.dateStr =
            '${currentItem.date.month}月\n${currentItem.date.year}';
        var nextItem = monthChartDataList[findIndex + 1];
        nextItem.dateStr = '${nextItem.date.month}月\n${nextItem.date.year}';
      }
    }
    var selectMonthChartDataIndex = monthChartDataList.length - 1;
    var monthRankingList = await _queryJournalMonth(currentDate, currentType);

    emit(
      state.copyWith(
        monthChartData: monthChartDataList,
        monthSelectionBehavior: monthSelectionBehavior,
        dougnutChartData: dougnutChartData,
        everyDayChartData: everyDayCharData,
        everyDayTrackballBehavior: everyDayTrackballBehavior,
        everyDaySelectionBehavior: everyDaySelectionBehavior,
        projectRankingList: projectRankingData,
        currentMonthAmount: currentMonthAmount,
        selectMonthChartDataIndex: selectMonthChartDataIndex,
        selectDayChartDataIndex: selectDayChartDataIndex,
        monthRankingList: monthRankingList,
      ),
    );

    //延迟2秒执行 默认选中图表逻辑
    await Future.delayed(Duration(seconds: 2));
    everyDayTrackballBehavior.showByIndex(selectDayChartDataIndex);
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
