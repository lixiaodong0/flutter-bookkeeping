import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../data/bean/doughnut_chart_data.dart';
import '../data/bean/journal_type.dart';
import 'bloc/statistics_state.dart';

class ChartData {
  ChartData(this.x, this.y);

  final int x;
  final double y;
}

//每日图表
Widget buildStatisticsEveryDayChart(
  BuildContext context,
  StatisticsState state,
) {
  final List<ChartData> chartData = [
    ChartData(1, 420),
    ChartData(2, 111),
    ChartData(3, 44),
    ChartData(4, 25),
    ChartData(5, 40),
    ChartData(6, 60),
    ChartData(7, 60),
    ChartData(8, 60),
    ChartData(9, 60),
    ChartData(10, 60),
    ChartData(11, 60),
    ChartData(12, 60),
    ChartData(13, 60),
    ChartData(14, 60),
    ChartData(15, 60),
    ChartData(16, 60),
    ChartData(17, 60),
    ChartData(18, 60),
    ChartData(19, 60),
    ChartData(20, 60),
    ChartData(21, 60),
    ChartData(22, 60),
    ChartData(23, 60),
    ChartData(24, 60),
    ChartData(25, 60),
    ChartData(26, 60),
    ChartData(27, 60),
    ChartData(28, 60),
    ChartData(29, 60),
    ChartData(30, 60),
  ];
  return Container(
    padding: EdgeInsets.all(16),
    child: SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: NumericAxis(
        majorTickLines: MajorTickLines(width: 0, color: Colors.transparent),
        majorGridLines: MajorGridLines(width: 0, color: Colors.transparent),
        interval: 6,
        edgeLabelPlacement: EdgeLabelPlacement.shift,
      ),
      primaryYAxis: NumericAxis(
        axisLine: AxisLine(width: 0, color: Colors.transparent),
        isVisible: true,
        majorTickLines: MajorTickLines(width: 0, color: Colors.transparent),
      ),
      series: <CartesianSeries<ChartData, int>>[
        // Renders column chart
        ColumnSeries<ChartData, int>(
          dataSource: chartData,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y,
          // Width of the columns`23`
          width: 1,
          // Spacing between the columns
          spacing: 0.5,
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
  SelectionBehavior selectionBehavior,
) {
  final List<ChartData> chartData = [
    ChartData(1, 35),
    ChartData(2, 23),
    ChartData(3, 34),
    ChartData(4, 25),
    ChartData(5, 40),
    ChartData(6, 60),
  ];
  return Container(
    padding: EdgeInsets.all(16),
    child: SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(
        majorTickLines: MajorTickLines(width: 0, color: Colors.transparent),
        majorGridLines: MajorGridLines(width: 0, color: Colors.transparent),
      ),
      primaryYAxis: NumericAxis(isVisible: false),
      series: <CartesianSeries<ChartData, int>>[
        // Renders column chart
        ColumnSeries<ChartData, int>(
          selectionBehavior: selectionBehavior,
          onPointTap: (ChartPointDetails details) {
            print("[onPointTap]${details.dataPoints?.length},pointIndex:${details.pointIndex},seriesIndex:${details.seriesIndex}");
          },
          initialSelectedDataIndexes: [1],
          dataSource: chartData,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y,
          dataLabelMapper: (ChartData data, _) => data.y.toString(),
          dataLabelSettings: const DataLabelSettings(isVisible: true),
          // Width of the columns`23`
          width: 1,
          // Spacing between the columns
          spacing: 0.5,
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
