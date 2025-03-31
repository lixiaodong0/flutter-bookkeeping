import 'package:bookkeeping/data/bean/filter_type.dart';
import 'package:bookkeeping/filter/bloc/filter_journal_bloc.dart';
import 'package:bookkeeping/filter/bloc/filter_journal_event.dart';
import 'package:bookkeeping/filter/bloc/filter_journal_state.dart';
import 'package:bookkeeping/util/format_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/bean/journal_type.dart';
import '../statistics/bloc/statistics_state.dart';

Widget buildFilterJournalHeader(
  BuildContext context,
  FilterJournalState state,
) {
  var typeTitle = state.currentType == JournalType.expense ? "支出" : "入账";
  var month = state.currentDate?.month;
  var monthAmount = state.monthAmount;
  var projectName = state.projectBean?.name ?? "";
  return SliverToBoxAdapter(
    child: Column(
      children: [
        SizedBox(
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "$month月$projectName共$typeTitle",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              SizedBox(height: 10),
              Text(
                "¥${FormatUtil.formatAmount(monthAmount)}",
                style: TextStyle(fontSize: 28, color: Colors.black),
              ),
            ],
          ),
        ),
        Container(height: 10, color: Color(0xFFF5F5F5)),
        _buildFilterContainer(context, state.currentFilterType),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Divider(height: 1),
        ),
      ],
    ),
  );
}

Widget _buildFilterContainer(BuildContext context, FilterType selectedType) {
  var journalType = JournalType.expense;
  var selectedTextColor =
      journalType == JournalType.expense ? Colors.green : Colors.orange;
  var selectedBackgroundColor = selectedTextColor.withAlpha(50);

  var unselectedBackgroundColor = Color(0xFFF5F5F5);
  var unselectedTextColor = Colors.grey;
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Row(
      children: [
        TextButton(
          onPressed: () {
            context.read<FilterJournalBloc>().add(
              FilterJournalOnChangeFilterType(filterType: FilterType.amount),
            );
          },
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            backgroundColor:
                selectedType == FilterType.amount
                    ? selectedBackgroundColor
                    : unselectedBackgroundColor,
            minimumSize: Size(50, 20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "按金额",
                style: TextStyle(
                  color:
                      selectedType == FilterType.amount
                          ? selectedTextColor
                          : unselectedTextColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 10),
        TextButton(
          onPressed: () {
            context.read<FilterJournalBloc>().add(
              FilterJournalOnChangeFilterType(filterType: FilterType.date),
            );
          },
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            backgroundColor:
                selectedType == FilterType.date
                    ? selectedBackgroundColor
                    : unselectedBackgroundColor,
            minimumSize: Size(50, 20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "按时间",
                style: TextStyle(
                  color:
                      selectedType == FilterType.date
                          ? selectedTextColor
                          : unselectedTextColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
