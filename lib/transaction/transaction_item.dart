import 'package:bookkeeping/data/bean/daily_date_amount.dart';
import 'package:bookkeeping/data/bean/income_images.dart';
import 'package:bookkeeping/data/bean/journal_type.dart';
import 'package:bookkeeping/util/date_util.dart';
import 'package:flutter/material.dart';

import '../util/format_util.dart';

String _formatWeekday2Str(int weekDay) {
  return switch (weekDay) {
    1 => "星期一",
    2 => "星期二",
    3 => "星期三",
    4 => "星期四",
    5 => "星期五",
    6 => "星期六",
    7 => "星期日",
    _ => "未知",
  };
}

String _formatDate2Str(DateTime date) {
  var now = DateTime.now();
  var str = "${date.month}月${date.day}日 ";
  if (DateUtil.isSameMonth(date, now)) {
    if (date.day == now.day) {
      str += "今天";
    } else if (date.day == now.day - 1) {
      str += "昨天";
    } else if (date.day == now.day - 2) {
      str += "前天";
    } else {
      str += _formatWeekday2Str(date.weekday);
    }
  } else {
    str += _formatWeekday2Str(date.weekday);
  }
  return str;
}

Widget buildTransactionHeader(
  BuildContext context,
  DailyDateAmount data,
  bool isFirst,
) {
  //2022-6-9
  var dateStr = _formatDate2Str(DateUtil.parse(data.date));
  List<Widget> amountUnitChildren = [];
  var isAllType = data.projectBean == null;
  if (isAllType || data.projectBean?.journalType == JournalType.expense) {
    amountUnitChildren.add(_amountUnitContainer("出", data.expense));
  }
  if (isAllType || data.projectBean?.journalType == JournalType.income) {
    amountUnitChildren.add(_amountUnitContainer("入", data.income));
  }
  return Container(
    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    margin: EdgeInsets.only(top: isFirst ? 0 : 10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      shape: BoxShape.rectangle,
      color: const Color.fromRGBO(251, 251, 251, 1),
    ),
    child: Row(
      children: [
        Row(
          children: [
            Text(dateStr, style: TextStyle(fontSize: 16, color: Colors.black)),
          ],
        ),
        Expanded(
          child: Wrap(
            alignment: WrapAlignment.end,
            spacing: 8,
            runSpacing: 2,
            direction: Axis.horizontal,
            children: amountUnitChildren,
          ),
        ),
      ],
    ),
  );
}

Widget _amountUnitContainer(String unit, String amount) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 20,
        color: const Color.fromRGBO(243, 243, 243, 1),
        child: Text(
          unit,
          style: TextStyle(fontSize: 12, color: Colors.black),
          textAlign: TextAlign.center,
        ),
      ),
      Padding(padding: EdgeInsets.only(left: 2)),
      Text(
        FormatUtil.formatAmount(amount),
        style: TextStyle(fontSize: 12, color: Colors.black),
      ),
    ],
  );
}

Widget buildTransactionItem(
  BuildContext context,
  JournalType journalType,
  String projectName,
  String amount,
  DateTime date, {
  bool isLastItem = false,
  String desc = "",
}) {
  Color journalTextColor = Colors.black;
  if (journalType == JournalType.income) {
    journalTextColor = Colors.orange;
  }

  Color journalColor =
      journalType == JournalType.income ? Colors.orange : Colors.green;

  String assetName =
      journalType == JournalType.income
          ? IncomeImages.fromName(projectName).img
          : ExpenseImages.fromName(projectName).img;

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
    child: Stack(
      children: [
        Row(
          children: [
            journalTypeImageWidget(assetName, containerColor: journalColor),
            SizedBox(width: 8),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    projectName,
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        "${FormatUtil.formatTime(date.hour)}:${FormatUtil.formatTime(date.minute)}",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      if (desc.isNotEmpty)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          height: 8,
                          child: VerticalDivider(
                            width: 2,
                            color: Colors.grey.withAlpha(100),
                          ),
                        ),
                      Expanded(
                        child: Text(
                          desc,
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Spacer(),
          ],
        ),
        Align(
          alignment: Alignment.topRight,
          child: Text(
            "${journalType.symbol}${FormatUtil.formatAmount(amount)}",
            style: TextStyle(fontSize: 16, color: journalTextColor),
          ),
        ),
      ],
    ),
  );
}
