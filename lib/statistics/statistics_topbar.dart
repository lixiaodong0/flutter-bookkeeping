import 'package:bookkeeping/util/format_util.dart';
import 'package:bookkeeping/widget/clickable_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/bean/journal_type.dart';
import 'bloc/statistics_bloc.dart';
import 'bloc/statistics_event.dart';
import 'bloc/statistics_state.dart';

Widget buildStatisticsHeader(BuildContext context, StatisticsState state) {
  var totalAmount = state.currentMonthAmount;
  var color =
      state.currentType == JournalType.expense ? Colors.green : Colors.orange;
  return Container(
    color: color,
    padding: EdgeInsets.only(top: 80, bottom: 30),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4, right: 16),
          child: Row(
            children: [
              _buildDateSwitchContainer(context, state.currentDate),
              Spacer(),
              _buildTypeSwitchContainer(context, state),
            ],
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "共支出",
            style: TextStyle(color: Colors.white.withAlpha(200), fontSize: 12),
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "¥ ${FormatUtil.formatAmount(totalAmount)}",
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
      ],
    ),
  );
}

Widget _buildDateSwitchContainer(BuildContext context, DateTime? current) {
  return TextButton(
    onPressed: () {
      context.read<StatisticsBloc>().add(StatisticsOnShowDatePicker());
    },
    style: TextButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "${current?.year}年${current?.month}月",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        Padding(padding: EdgeInsets.symmetric(horizontal: 4)),
        Icon(Icons.calendar_today_outlined, color: Colors.white, size: 14),
      ],
    ),
  );
}

Widget _buildTypeSwitchContainer(BuildContext context, StatisticsState state) {
  return Row(
    children: [
      TextButton(
        onPressed: () {
          context.read<StatisticsBloc>().add(
            StatisticsOnSwitchType(journalType: JournalType.expense),
          );
        },
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          backgroundColor:
              state.currentType == JournalType.expense
                  ? Colors.white12
                  : Colors.transparent,
          minimumSize: Size(50, 20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "支出",
              style: TextStyle(
                color:
                    state.currentType == JournalType.expense
                        ? Colors.white
                        : Colors.white.withAlpha(200),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      TextButton(
        onPressed: () {
          context.read<StatisticsBloc>().add(
            StatisticsOnSwitchType(journalType: JournalType.income),
          );
        },
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          backgroundColor:
              state.currentType == JournalType.income
                  ? Colors.white12
                  : Colors.transparent,
          minimumSize: Size(50, 20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "入账",
              style: TextStyle(
                color:
                    state.currentType == JournalType.income
                        ? Colors.white
                        : Colors.white.withAlpha(200),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
