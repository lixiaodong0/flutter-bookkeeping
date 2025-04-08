import 'dart:async';

import 'package:bookkeeping/data/bean/day_chart_data.dart';
import 'package:bookkeeping/data/bean/doughnut_chart_data.dart';
import 'package:bookkeeping/data/bean/journal_type.dart';
import 'package:bookkeeping/statistics/bloc/statistics_bloc.dart';
import 'package:bookkeeping/statistics/bloc/statistics_event.dart';
import 'package:bookkeeping/statistics/statistics_chart.dart';
import 'package:bookkeeping/statistics/statistics_ranking_list.dart';
import 'package:bookkeeping/statistics/statistics_topbar.dart';
import 'package:bookkeeping/util/date_util.dart';
import 'package:bookkeeping/util/format_util.dart';
import 'package:bookkeeping/widget/every_day_data_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../data/repository/journal_month_repository.dart';
import '../data/repository/journal_repository.dart';
import '../eventbus/eventbus.dart';
import '../eventbus/journal_event.dart';
import '../widget/month_picker_widget.dart';
import 'bloc/statistics_state.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  late final StreamSubscription _subscription;
  ChartSeriesController? seriesController;
  final GlobalKey _blocContext = GlobalKey();

  @override
  void initState() {
    //订阅事件
    _subscription = eventBus.on<JournalEvent>().listen((event) {
      _blocContext.currentContext?.read<StatisticsBloc>().add(
        StatisticsReload(),
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    //取消事件
    _subscription.cancel();
    super.dispose();
  }

  _onCallback(ChartSeriesController seriesController) {
    this.seriesController = seriesController;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => StatisticsBloc(
            repository: context.read<JournalRepository>(),
            monthRepository: context.read<JournalMonthRepository>(),
          )..add(StatisticsInitLoad()),
      child: BlocListener<StatisticsBloc, StatisticsState>(
        key: _blocContext,
        listener: (context, state) {
          if (state.datePickerDialogState is DatePickerDialogOpenState) {
            var open = state.datePickerDialogState as DatePickerDialogOpenState;
            MonthPickerWidget.showDatePicker(
              context,
              currentDate: open.currentDate,
              allDate: open.allDate,
              onChanged: (newDate) {
                context.read<StatisticsBloc>().add(
                  StatisticsOnSelectedDate(
                    selectedDate: DateTime(
                      newDate.year,
                      newDate.month,
                      newDate.maxDay,
                    ),
                  ),
                );
              },
              onClose: () {
                context.read<StatisticsBloc>().add(
                  StatisticsOnCloseDatePicker(),
                );
              },
            );
          }

          if (state.everyDayDataDialogState is EveryDayDataDialogOpenState) {
            var open =
                state.everyDayDataDialogState as EveryDayDataDialogOpenState;
            EveryDayDataDialog.showDialog(
              context,
              open.list,
              open.amount,
              open.date,
              open.type,
              () {
                context.read<StatisticsBloc>().add(
                  StatisticsOnCloseEveryDayDataDialog(),
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
                      Padding(
                        padding: EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 40,
                          bottom: 40,
                        ),
                        child: Divider(height: 1, color: Colors.grey[400]),
                      ),
                      buildStatisticsEveryDayChart(
                        context,
                        state,
                        seriesController,
                        _onCallback,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 40,
                          bottom: 40,
                        ),
                        child: Divider(height: 1, color: Colors.grey[400]),
                      ),
                      buildStatisticsEveryMonthChart(context, state),
                      buildStatisticsJournalRankingList(context, state),
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
