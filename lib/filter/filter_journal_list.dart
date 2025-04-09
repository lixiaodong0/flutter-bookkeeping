import 'package:bookkeeping/detail/detail_journal_screen.dart';
import 'package:flutter/material.dart';

import '../data/bean/income_images.dart';
import '../data/bean/journal_bean.dart';
import '../data/bean/journal_type.dart';
import '../util/date_util.dart';
import '../util/format_util.dart';

Widget journalListItem(BuildContext context, String symbol, JournalBean data) {

  var projectName = data.journalProjectName;
  Color journalColor =
  data.type == JournalType.income ? Colors.orange : Colors.green;

  String assetName =
  data.type == JournalType.income
      ? IncomeImages.fromName(projectName).img
      : ExpenseImages.fromName(projectName).img;


  return GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: () {
      DetailJournalScreenRoute.launch(context, data.id);
    },
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              journalTypeImageWidget(
                assetName,
                containerColor: journalColor,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      projectName,
                      style: const TextStyle(fontSize: 16, color: Colors.black),
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
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                    ),
                    Text(
                      DateUtil.formatMonth(data.date),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
