import 'package:bookkeeping/data/bean/doughnut_chart_data.dart';
import 'package:bookkeeping/data/bean/journal_type.dart';
import 'package:bookkeeping/statistics/bloc/statistics_bloc.dart';
import 'package:bookkeeping/statistics/bloc/statistics_event.dart';
import 'package:bookkeeping/statistics/statistics_chart.dart';
import 'package:bookkeeping/statistics/statistics_ranking_list.dart';
import 'package:bookkeeping/statistics/statistics_topbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../data/repository/journal_month_repository.dart';
import '../data/repository/journal_repository.dart';
import '../widget/month_picker_widget.dart';
import 'bloc/statistics_state.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  late SelectionBehavior _selectionBehavior;
  late TooltipBehavior  _tooltipBehavior ;

  @override
  void initState() {
    _selectionBehavior = SelectionBehavior(
      enable: true,
      selectedColor: Colors.green,
      unselectedColor: Colors.green,
      unselectedOpacity: 0.2,
      toggleSelection: false,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
      StatisticsBloc(
        repository: context.read<JournalRepository>(),
        monthRepository: context.read<JournalMonthRepository>(),
      )
        ..add(StatisticsInitLoad()),
      child: BlocListener<StatisticsBloc, StatisticsState>(
        listener: (context, state) {
          if (state.datePickerDialogState is DatePickerDialogOpenState) {
            var open = state.datePickerDialogState as DatePickerDialogOpenState;
            MonthPickerWidget.showDatePicker(
              context,
              currentDate: open.currentDate,
              allDate: open.allDate,
              onChanged: (newDate) {
                context.read<StatisticsBloc>().add(
                  StatisticsOnSelectedDate(selectedDate: newDate),
                );
              },
              onClose: () {
                context.read<StatisticsBloc>().add(
                  StatisticsOnCloseDatePicker(),
                );
              },
            );
          }
        },
        child: BlocBuilder<StatisticsBloc, StatisticsState>(
          builder: (context, state) {
            return Container(
              color: Colors.white,
              child: Scrollbar(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      buildStatisticsHeader(context, state),
                      buildStatisticsCircularChart(context, state),
                      buildStatisticsProjectRankingList(context, state),
                      buildStatisticsJournalRankingList(context, state),
                      buildStatisticsEveryDayChart(context, state),
                      buildStatisticsEveryMonthChart(
                        context,
                        state,
                        _selectionBehavior,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
