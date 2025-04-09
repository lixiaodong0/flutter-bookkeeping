import 'package:bookkeeping/data/bean/journal_bean.dart';
import 'package:bookkeeping/data/bean/journal_type.dart';
import 'package:bookkeeping/data/bean/project_ranking_bean.dart';
import 'package:bookkeeping/detail/detail_journal_screen.dart';
import 'package:bookkeeping/statistics/bloc/statistics_event.dart';
import 'package:bookkeeping/util/format_util.dart';
import 'package:bookkeeping/widget/clickable_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../data/bean/income_images.dart';
import '../filter/filter_journal_screen.dart';
import '../util/date_util.dart';
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
    children.add(
      _projectRankingListItem(
        context,
        state.currentType,
        value,
        state.currentDate ?? DateTime.now(),
      ),
    );
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
  DateTime date,
) {
  var progressColor =
      type == JournalType.expense ? Colors.green : Colors.orange;

  var projectName = data.name;
  Color journalColor =
      type == JournalType.income ? Colors.orange : Colors.green;

  String assetName =
      type == JournalType.income
          ? IncomeImages.fromName(projectName).img
          : ExpenseImages.fromName(projectName).img;

  return GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: () {
      context.push(
        "/filter_journal",
        extra: FilterJournalScreenParams(
          type: type,
          date: date,
          projectBean: data,
        ),
      );
    },
    child: Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          journalTypeImageWidget(
            assetName,
            containerColor: journalColor,
            containerSize: 20,
            iconSize: 10,
          ),
          SizedBox(width: 8),
          SizedBox(
            width: 100,
            child: Text(
              projectName,
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
    ),
  );
}

//订单排行榜
Widget buildStatisticsJournalRankingList(
  BuildContext context,
  StatisticsState state,
) {
  var originalList = state.monthRankingList;
  var currentType = state.currentType;

  var currentDate = originalList.firstOrNull?.date;

  var currentMonth = currentDate?.month ?? state.currentDate?.month ?? 0;

  var title =
      currentType == JournalType.expense
          ? "$currentMonth月支出排行"
          : "$currentMonth月入账排行";
  List<Widget> children = [];
  children.add(
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Text(
            title,
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
      ],
    ),
  );

  var list = originalList.take(10).toList();
  for (var i = 0; i < list.length; i++) {
    var value = list[i];
    children.add(
      GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          DetailJournalScreenRoute.launch(context, value.id);
        },
        child: _journalRankingListItem(
          context,
          i + 1,
          currentType.symbol,
          value,
        ),
      ),
    );
  }
  if (originalList.length > 10) {
    children.add(_allItem(context, currentType, currentDate ?? DateTime.now()));
  }
  return Container(
    padding: EdgeInsets.only(left: 4, right: 16),
    child: Column(children: children),
  );
}

Widget _journalRankingListItem(
  BuildContext context,
  int index,
  String symbol,
  JournalBean data,
) {
  var projectName = data.journalProjectName;
  Color journalColor =
      data.type == JournalType.income ? Colors.orange : Colors.green;

  String assetName =
      data.type == JournalType.income
          ? IncomeImages.fromName(projectName).img
          : ExpenseImages.fromName(projectName).img;

  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        SizedBox(
          width: 40,
          child: Center(
            child: Text(
              "$index",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
        ),
        journalTypeImageWidget(assetName, containerColor: journalColor),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                projectName,
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              if (data.description != null && data.description!.isNotEmpty)
                Text(
                  data.description ?? "",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "$symbol${FormatUtil.formatAmount(data.amount)}",
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              Text(
                DateUtil.formatMonth(data.date),
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _allItem(
  BuildContext context,
  JournalType currentType,
  DateTime currentDate,
) {
  var title = "全部排行";
  var icon = Icons.navigate_next_rounded;
  return sizedButtonWidget(
    onPressed: () {
      context.push(
        "/filter_journal",
        extra: FilterJournalScreenParams(type: currentType, date: currentDate),
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
