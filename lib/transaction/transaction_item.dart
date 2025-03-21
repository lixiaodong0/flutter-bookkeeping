import 'dart:math';

import 'package:bookkeeping/data/bean/journal_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildTransactionHeader(
  BuildContext context,
  DateTime date,
  String dailyIncome,
  String dailyExpense,
) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 8,horizontal: 16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      shape: BoxShape.rectangle,
      color: Colors.white70,
    ),
    child: Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Text(
                "${date.month}月${date.day}日",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 20,
                color: Colors.grey,
                child: Text(
                  "出",
                  style: TextStyle(fontSize: 12, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(padding: EdgeInsets.only(left: 2)),
              Text(
                dailyIncome,
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
              Padding(padding: EdgeInsets.only(left: 8)),

              Container(
                width: 20,
                color: Colors.grey,
                child: Text(
                  "入",
                  style: TextStyle(fontSize: 12, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(padding: EdgeInsets.only(left: 2)),
              Text(
                dailyExpense,
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget buildTransactionItem(
  BuildContext context,
  JournalType journalType,
  String projectName,
  String amount,
  DateTime date, {
  bool isLastItem = false,
}) {
  Color journalColor = Colors.black;
  if (journalType == JournalType.income) {
    journalColor = Colors.orange;
  }
  BorderRadius borderRadius = BorderRadius.zero;
  if (isLastItem) {
    borderRadius = BorderRadius.vertical(bottom: Radius.circular(16));
  }
  return Container(
    padding: EdgeInsets.symmetric(vertical: 8,horizontal: 16),
    decoration: BoxDecoration(
      borderRadius: borderRadius,
      color: Colors.white,
      shape: BoxShape.rectangle,
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                projectName,
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              Padding(padding: EdgeInsets.only(top: 4)),
              Text(
                "${date.hour}:${date.minute.toString().padLeft(2, '0')}",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Stack(
            alignment: AlignmentDirectional.topEnd,
            children: [
              Text(
                "${journalType.symbol}${num.parse(amount).toStringAsFixed(2)}",
                style: TextStyle(fontSize: 16, color: journalColor),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
