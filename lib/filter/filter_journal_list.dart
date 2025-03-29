import 'package:flutter/material.dart';

import '../data/bean/journal_bean.dart';
import '../util/date_util.dart';
import '../util/format_util.dart';

Widget journalListItem(BuildContext context, String symbol, JournalBean data) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    child: Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.journalProjectName,
                    style: TextStyle(fontSize: 16, color: Colors.black),
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
      ],
    ),
  );
}
