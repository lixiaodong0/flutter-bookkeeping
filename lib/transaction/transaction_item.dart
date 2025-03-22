import 'dart:math';

import 'package:bookkeeping/data/bean/daily_date_amount.dart';
import 'package:bookkeeping/data/bean/journal_type.dart';
import 'package:bookkeeping/util/date_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../util/format_util.dart';

Widget buildTransactionHeader(BuildContext context, DailyDateAmount data) {
  //2022-6-9
  var date = DateUtil.parse(data.date);
  var dateStr = "${date.month}月${date.day}日";
  if (date.year != DateTime.now().year) {
    dateStr = "${date.year}年${date.month}月${date.day}日";
  } else {
    if(date.day == DateTime.now().day){
      dateStr += " 今天";
    }
  }
  return Container(
    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    margin: EdgeInsets.only(top: 10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      shape: BoxShape.rectangle,
      color: const Color.fromRGBO(251, 251, 251, 1),
    ),
    child: Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Text(
                dateStr,
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
                color: const Color.fromRGBO(243, 243, 243, 1),
                child: Text(
                  "出",
                  style: TextStyle(fontSize: 12, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(padding: EdgeInsets.only(left: 2)),
              Text(
                FormatUtil.formatAmount(data.expense),
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
              Padding(padding: EdgeInsets.only(left: 8)),

              Container(
                width: 20,
                color: const Color.fromRGBO(243, 243, 243, 1),
                child: Text(
                  "入",
                  style: TextStyle(fontSize: 12, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(padding: EdgeInsets.only(left: 2)),
              Text(
                FormatUtil.formatAmount(data.income),
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
    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                "${FormatUtil.formatTime(date.hour)}:${FormatUtil.formatTime(date.minute)}",
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
                "${journalType.symbol}${FormatUtil.formatAmount(amount)}",
                style: TextStyle(fontSize: 16, color: journalColor),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
