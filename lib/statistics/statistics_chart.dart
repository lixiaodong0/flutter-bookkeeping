import 'dart:ffi';

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

class ChartBehaviorProvider {
  static SelectionBehavior createSelectionBehavior(JournalType currentType) {
    Color color =
        currentType == JournalType.expense ? Colors.green : Colors.orange;
    return SelectionBehavior(
      enable: true,
      selectedColor: color,
      unselectedColor: color,
      unselectedOpacity: 0.2,
      toggleSelection: false,
    );
  }

  static TrackballBehavior createTrackballBehavior(JournalType currentType) {
    Color color =
        currentType == JournalType.expense ? Colors.green : Colors.orange;
    String title = currentType == JournalType.expense ? "支出" : "入账";
    return TrackballBehavior(
      activationMode: ActivationMode.longPress,
      enable: true,
      tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
      tooltipAlignment: ChartAlignment.near,
      shouldAlwaysShow: true,
      lineWidth: 2,
      lineDashArray: [2, 2],
      builder: (BuildContext context, TrackballDetails trackballDetails) {
        var index =
            trackballDetails
                .groupingModeInfo
                ?.currentPointIndices
                .firstOrNull ??
            0;
        var series =
            trackballDetails.groupingModeInfo?.visibleSeriesList.firstOrNull
                as ColumnSeriesRenderer<DayChartData, String>;
        var chartData = series.dataSource![index];
        series.selectionBehavior?.selectDataPoints(index);
        //TrackballBehavior如果激活改为按下就触发会导致无法响应悬浮窗的点击事件.
        //通过配合onChartTouchInteractionUp: (ChartTouchInteractionArgs args)，监听手指抬起，手动计算坐标点位，调用API形式触发。
        //点击悬浮窗的时候在重置为当前showByIndex位置。
        return GestureDetector(
          onTap: () {
            //按钮
            series.parent?.trackballBehavior?.showByIndex(index);
            if (chartData.amount > 0) {
              context.read<StatisticsBloc>().add(
                StatisticsOnShowEveryDayDataDialog(
                  type: currentType,
                  date: chartData.date,
                  amount: chartData.amount.toString(),
                ),
              );
            }
          },
          child: Container(
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
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 80),
                      child: Text(
                        "¥${FormatUtil.formatAmount(chartData.amount.toString())}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: color, fontSize: 12),
                      ),
                    ),
                  ],
                ),
                if (chartData.amount > 0)
                  Icon(
                    Icons.navigate_next_rounded,
                    size: 12,
                    color: Colors.grey,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  static TooltipBehavior createTooltipBehavior(Color color, String title) {
    return TooltipBehavior(
      activationMode: ActivationMode.doubleTap,
      enable: true,
      color: Colors.black87,
      shouldAlwaysShow: true,
      tooltipPosition: TooltipPosition.auto,
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
}

//每日图表
typedef SeriesRendererCreatedCallback =
    void Function(ChartSeriesController controller);

Widget buildStatisticsEveryDayChart(
  BuildContext context,
  StatisticsState state,
  ChartSeriesController? seriesController,
  SeriesRendererCreatedCallback callback,
) {
  final List<DayChartData> chartData = state.everyDayChartData;
  final selectDayChartDataIndex = state.selectDayChartDataIndex;
  var selectionBehavior = state.everyDaySelectionBehavior;
  var trackballBehavior = state.everyDayTrackballBehavior;

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
          trackballBehavior: trackballBehavior,
          //TrackballBehavior如果激活改为按下就触发会导致无法响应悬浮窗的点击事件.
          //这里监听手指抬起，手动计算坐标点位，调用API形式触发。
          onChartTouchInteractionUp: (ChartTouchInteractionArgs args) {
            final Offset value = Offset(args.position.dx, args.position.dy);
            if (seriesController != null) {
              CartesianChartPoint<dynamic> point = seriesController!
                  .pixelToPoint(value);
              trackballBehavior?.show(point.x, point.y?.toDouble() ?? 0);
            }
          },
          primaryXAxis: CategoryAxis(
            majorTickLines: MajorTickLines(width: 0, color: Colors.transparent),
            majorGridLines: MajorGridLines(width: 0, color: Colors.transparent),
            edgeLabelPlacement: EdgeLabelPlacement.shift,
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
              onRendererCreated: (ChartSeriesController controller) {
                seriesController = controller;
                callback(controller);
              },
              // enableTooltip: true,
              selectionBehavior: selectionBehavior,
              // onPointTap: (ChartPointDetails details) {
              //   print(
              //     "[onPointTap]${details.dataPoints?.length},pointIndex:${details.pointIndex},seriesIndex:${details.seriesIndex}",
              //   );
              //   var index = details.pointIndex ?? -1;
              //   if (index != -1) {
              //     context.read<StatisticsBloc>().add(
              //       StatisticsOnChangeDayChartData(selectIndex: index),
              //     );
              //   }
              // },
              initialSelectedDataIndexes: [selectDayChartDataIndex],
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
  var selectionBehavior = state.monthSelectionBehavior;
  var selectMonthChartDataIndex = state.selectMonthChartDataIndex;
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
              selectionBehavior: selectionBehavior,
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
        centerX: '50%',
        series: <CircularSeries<DoughnutChartData, String>>[
          DoughnutSeries<DoughnutChartData, String>(
            dataSource: state.dougnutChartData,
            xValueMapper: (DoughnutChartData data, _) => data.key,
            yValueMapper: (DoughnutChartData data, _) => data.value,
            animationDuration: 600,
            //外圆大小
            radius: '40%',
            innerRadius: '60%',
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
