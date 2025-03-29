import 'package:bookkeeping/data/bean/day_chart_data.dart';
import 'package:bookkeeping/statistics/bloc/statistics_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../data/bean/doughnut_chart_data.dart';
import '../data/bean/journal_type.dart';
import '../data/bean/month_chart_data.dart';
import '../util/date_util.dart';
import '../util/format_util.dart';
import 'bloc/statistics_bloc.dart';
import 'bloc/statistics_state.dart';

class ChartData {
  ChartData(this.x, this.y);

  final int x;
  final double y;
}

SelectionBehavior _selectionBehavior(Color color) {
  return SelectionBehavior(
    enable: true,
    selectedColor: color,
    unselectedColor: color,
    unselectedOpacity: 0.2,
    toggleSelection: false,
  );
}

TooltipBehavior _tooltipBehavior(Color color, String title) {
  return TooltipBehavior(
    enable: true,
    color: Colors.black87,
    shouldAlwaysShow: true,
    builder: (
      dynamic data,
      dynamic point,
      dynamic series,
      int pointIndex,
      int seriesIndex,
    ) {
      var chartData = data as DayChartData;
      return Container(
        width: 100,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.black87,
        ),
        padding: EdgeInsets.only(left: 4, top: 4, bottom: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${DateUtil.formatMonthDay(chartData.date)}共$title",
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
                Text(
                  "¥${FormatUtil.formatAmount(chartData.amount.toString())}",
                  style: TextStyle(color: color, fontSize: 12),
                ),
              ],
            ),
            Icon(Icons.navigate_next_rounded, size: 12, color: Colors.grey),
          ],
        ),
      );
    },
  );
}

//每日图表
Widget buildStatisticsEveryDayChart(
  BuildContext context,
  StatisticsState state,
) {
  final List<DayChartData> chartData = state.everyDayChartData;
  final JournalType currentType = state.currentType;
  final selectDayChartDataIndex = state.selectDayChartDataIndex;

  Color color =
      currentType == JournalType.expense ? Colors.green : Colors.orange;

  String title = currentType == JournalType.expense ? "支出" : "入账";

  return Container(
    padding: EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 40),
          child: Text(
            "每日对比",
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
        SfCartesianChart(
          plotAreaBorderWidth: 0,
          tooltipBehavior: _tooltipBehavior(color, title),
          primaryXAxis: CategoryAxis(
            majorTickLines: MajorTickLines(width: 0, color: Colors.transparent),
            majorGridLines: MajorGridLines(width: 0, color: Colors.transparent),
            edgeLabelPlacement : EdgeLabelPlacement.shift,
            interval: 4,
          ),
          primaryYAxis: NumericAxis(
            axisLine: AxisLine(width: 0, color: Colors.transparent),
            isVisible: true,
            majorTickLines: MajorTickLines(width: 0, color: Colors.transparent),
            numberFormat: NumberFormat("¥"),
          ),
          series: <CartesianSeries<DayChartData, String>>[
            // Renders column chart
            ColumnSeries<DayChartData, String>(
              selectionBehavior: _selectionBehavior(color),
              onPointTap: (ChartPointDetails details) {
                print(
                  "[onPointTap]${details.dataPoints?.length},pointIndex:${details.pointIndex},seriesIndex:${details.seriesIndex}",
                );
                var index = details.pointIndex ?? -1;
                if (index != -1) {
                  context.read<StatisticsBloc>().add(
                    StatisticsOnChangeDayChartData(
                      selectIndex: index,
                    ),
                  );
                }
              },
              initialSelectedDataIndexes: [selectDayChartDataIndex],
              enableTooltip: true,
              dataSource: chartData,
              xValueMapper: (DayChartData data, _) => data.formatDateStr2,
              yValueMapper: (DayChartData data, _) => data.amount,
              // Width of the columns`23`
              width: 1,
              // Spacing between the columns
              spacing: 0.5,
            ),
          ],
        ),
      ],
    ),
  );
}

//每月图表
//选择文档：https://help.syncfusion.com/flutter/cartesian-charts/selection
Widget buildStatisticsEveryMonthChart(
  BuildContext context,
  StatisticsState state,
) {
  var list = state.monthChartData;
  var selectMonthChartDataIndex = state.selectMonthChartDataIndex;
  var currentType = state.currentType;
  Color color =
  currentType == JournalType.expense ? Colors.green : Colors.orange;

  return Container(
    padding: EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.zero,
          child: Text(
            "月度对比",
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
        SfCartesianChart(
          plotAreaBorderWidth: 0,
          primaryXAxis: CategoryAxis(
            majorTickLines: MajorTickLines(width: 0, color: Colors.transparent),
            majorGridLines: MajorGridLines(width: 0, color: Colors.transparent),
          ),
          primaryYAxis: NumericAxis(isVisible: false),
          series: <CartesianSeries<MonthChartData, String>>[
            // Renders column chart
            ColumnSeries<MonthChartData, String>(
              selectionBehavior: _selectionBehavior(color),
              onPointTap: (ChartPointDetails details) {
                print(
                  "[onPointTap]${details.dataPoints?.length},pointIndex:${details.pointIndex},seriesIndex:${details.seriesIndex}",
                );
                var index = details.pointIndex ?? -1;
                if (index != -1) {
                  context.read<StatisticsBloc>().add(
                    StatisticsOnChangeJournalRankingList(
                      changeDateTime: list[index].date,
                      selectIndex: index,
                    ),
                  );
                }
              },
              initialSelectedDataIndexes: [selectMonthChartDataIndex],
              dataSource: list,
              xValueMapper: (MonthChartData data, _) => data.dateStr,
              yValueMapper: (MonthChartData data, _) => data.amount,
              dataLabelMapper: (MonthChartData data, _) => data.amountLabel,
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                textStyle: TextStyle(fontSize: 12),
              ),
              // Width of the columns`23`
              width: 1,
              // Spacing between the columns
              spacing: 0.5,
            ),
          ],
        ),
      ],
    ),
  );
}

//圆形图表
Widget buildStatisticsCircularChart(
  BuildContext context,
  StatisticsState state,
) {
  return Stack(
    children: [
      Padding(
        padding: EdgeInsets.only(left: 16, top: 16),
        child: Text(
          state.currentType == JournalType.expense ? "支出构成" : "收入构成",
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
      ),
      //配置参考示例
      //https://help.syncfusion.com/flutter/circular-charts/datalabel
      SfCircularChart(
        centerY: '55%',
        centerX: '55%',
        series: <CircularSeries<DoughnutChartData, String>>[
          DoughnutSeries<DoughnutChartData, String>(
            dataSource: state.dougnutChartData,
            xValueMapper: (DoughnutChartData data, _) => data.key,
            yValueMapper: (DoughnutChartData data, _) => data.value,
            animationDuration: 600,
            //外圆大小
            radius: '50%',
            //按照百分百倒序排序
            sortingOrder: SortingOrder.descending,
            sortFieldValueMapper: (DoughnutChartData data, _) => data.value,
            //数据标签
            dataLabelMapper: (DoughnutChartData data, _) => data.key,
            pointColorMapper: (DoughnutChartData data, _) => data.color,
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              // Avoid labels intersection
              labelIntersectAction: LabelIntersectAction.shift,
              labelPosition: ChartDataLabelPosition.outside,
              textStyle: TextStyle(color: Color(0XFFA2A2A2)),
              connectorLineSettings: ConnectorLineSettings(
                type: ConnectorType.line,
                length: '20%',
                color: Color(0XFFA2A2A2),
              ),
            ),
          ),
        ],
      ),
    ],
  );
}
