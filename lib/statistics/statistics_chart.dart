import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../data/bean/doughnut_chart_data.dart';
import '../data/bean/journal_type.dart';
import 'bloc/statistics_state.dart';

//圆形图表
Widget buildStatisticsCircularChart(BuildContext context, StatisticsState state) {
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
        series: <CircularSeries<DoughnutChartData, String>>[
          DoughnutSeries<DoughnutChartData, String>(
            dataSource: state.dougnutChartData,
            xValueMapper: (DoughnutChartData data, _) => data.key,
            yValueMapper: (DoughnutChartData data, _) => data.value,
            animationDuration: 600,
            //外圆大小
            radius: '55%',
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
