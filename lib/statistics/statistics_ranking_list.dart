import 'package:bookkeeping/data/bean/journal_type.dart';
import 'package:bookkeeping/data/bean/project_ranking_bean.dart';
import 'package:bookkeeping/statistics/bloc/statistics_event.dart';
import 'package:bookkeeping/util/format_util.dart';
import 'package:bookkeeping/widget/clickable_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/statistics_bloc.dart';
import 'bloc/statistics_state.dart';

//产品排行榜
Widget buildStatisticsProjectRankingList(
  BuildContext context,
  StatisticsState state,
) {
  var list = state.projectRankingList;
  List<Widget> children = [];

  var expandedProjectRanking = state.expandedProjectRanking;
  var expandedList = expandedProjectRanking ? list : list.take(4).toList();
  for (var value in expandedList) {
    children.add(_projectRankingListItem(context, state.currentType, value));
  }
  if (list.length > 4) {
    children.add(_expandedItem(context, state.expandedProjectRanking));
  }
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16),
    child: Column(children: children),
  );
}

Widget _expandedItem(BuildContext context, bool isExpanded) {
  var title = isExpanded ? "收起" : "展开更多";
  var icon =
      isExpanded
          ? Icons.keyboard_arrow_up_rounded
          : Icons.keyboard_arrow_down_rounded;
  return sizedButtonWidget(
    onPressed: () {
      context.read<StatisticsBloc>().add(
        StatisticsOnExpandedChange(newExpanded: !isExpanded),
      );
    },
    width: 100,
    height: 36,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title, style: TextStyle(fontSize: 14, color: Colors.grey)),
        Icon(icon, color: Colors.grey, size: 14),
      ],
    ),
  );
}

Widget _projectRankingListItem(
  BuildContext context,
  JournalType type,
  ProjectRankingBean data,
) {
  var progressColor =
      type == JournalType.expense ? Colors.green : Colors.orange;
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(
            data.name,
            style: TextStyle(fontSize: 14, color: Colors.black),
          ),
        ),
        Expanded(
          child: LinearProgressIndicator(
            value: data.progress,
            backgroundColor: Colors.white,
            minHeight: 10,
            borderRadius: BorderRadius.circular(10),
            valueColor: AlwaysStoppedAnimation(progressColor),
          ),
        ),
        SizedBox(
          width: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "¥${FormatUtil.formatAmount(data.amount.toString())}",
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              Icon(Icons.navigate_next_rounded, color: Colors.grey, size: 14),
            ],
          ),
        ),
      ],
    ),
  );
}

//订单排行榜
Widget buildStatisticsJournalRankingList(
  BuildContext context,
  StatisticsState state,
) {
  return Container();
}
