import 'package:bookkeeping/util/format_util.dart';
import 'package:bookkeeping/widget/clickable_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'bloc/transaction_state.dart';

Widget buildTopBarContent(BuildContext context, TransactionState state) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Spacer(),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: _currentTypeContainer(context),
      ),
      Padding(
        padding: EdgeInsets.only(bottom: 4, left: 24,top: 4),
        child: _currentDateContainer(
          context,
          state.currentDate!,
          state.dateMonthIncome,
          state.dateMonthExpense,
        ),
      ),
    ],
  );
}

Widget _currentTypeContainer(BuildContext context) {
  return sizedButtonWidget(
    width: 100,
    height: 26,
    onPressed: () {},
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("全部类型", style: TextStyle(color: Colors.white, fontSize: 12)),
          Padding(padding: EdgeInsets.only(left: 8)),
          SizedBox(
            height: 10,
            child: VerticalDivider(width: 1, color: Colors.white),
          ),
          Padding(padding: EdgeInsets.only(left: 8)),
          Icon(Icons.grid_view_outlined, color: Colors.white, size: 16),
        ],
      ),
    ),
  );
}

Widget _currentDateContainer(
  BuildContext context,
  DateTime current,
  String monthIncome,
  String monthExpense,
) {
  return Row(
    children: [
      sizedButtonWidget(
        width: 86,
        height: 26,
        onPressed: () {},
        child: Row(
          children: [
            Text(
              "${current.year}月${current.month}月",
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            Icon(Icons.arrow_drop_down, color: Colors.white.withAlpha(200),size: 16),
          ],
        ),
      ),
      Text(
        "总支出¥${FormatUtil.formatAmount(monthExpense)}",
        style: TextStyle(color: Colors.white.withAlpha(200), fontSize: 12),
      ),
      Padding(padding: EdgeInsets.only(left: 8)),
      Text(
        "总入账¥${FormatUtil.formatAmount(monthIncome)}",
        style: TextStyle(color: Colors.white.withAlpha(200), fontSize: 12),
      ),
    ],
  );
}
