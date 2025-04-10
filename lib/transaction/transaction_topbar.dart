import 'package:bookkeeping/app_bloc.dart';
import 'package:bookkeeping/data/bean/account_book_bean.dart';
import 'package:bookkeeping/data/repository/account_book_repository.dart';
import 'package:bookkeeping/transaction/bloc/transaction_event.dart';
import 'package:bookkeeping/util/format_util.dart';
import 'package:bookkeeping/widget/clickable_widget.dart';
import 'package:bookkeeping/widget/create_account_book_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/bean/journal_project_bean.dart';
import '../data/bean/journal_type.dart';
import '../widget/month_picker_widget.dart';
import '../widget/switch_account_book_button.dart';
import 'bloc/transaction_bloc.dart';
import 'bloc/transaction_state.dart';

Widget buildTopBarContent(BuildContext context, TransactionState state) {
  return Stack(
    children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: _currentTypeContainer(context, state.currentProject),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 4, left: 24, top: 4),
            child: _currentDateAmountContainer(
              context,
              state.currentProject,
              state.currentDate,
              state.dateMonthIncome,
              state.dateMonthExpense,
            ),
          ),
        ],
      ),
      Positioned(
        top: 0,
        right: 0,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40, horizontal: 16),
          child: _currentAccountBookContainer(context),
        ),
      ),
    ],
  );
}

Widget _currentTypeContainer(BuildContext context, JournalProjectBean? data) {
  var title = data?.name ?? "";
  return sizedButtonWidget(
    width: 100,
    height: 26,
    onPressed: () {
      context.read<TransactionBloc>().add(TransactionShowProjectPicker());
    },
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title, style: TextStyle(color: Colors.white, fontSize: 12)),
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

Widget _currentDateAmountContainer(
  BuildContext context,
  JournalProjectBean? data,
  DateTime? current,
  String monthIncome,
  String monthExpense,
) {
  var isAllType = data == null || data.isAllItemBean();
  var projectName = data?.name ?? "";
  if (isAllType) {
    projectName = "";
  }
  var isShowMonthExpense = isAllType || data.journalType == JournalType.expense;
  var isShowMonthIncome = isAllType || data.journalType == JournalType.income;

  return Row(
    children: [
      sizedButtonWidget(
        width: 86,
        height: 26,
        onPressed: () {
          context.read<TransactionBloc>().add(TransactionShowMonthPicker());
        },
        child: Row(
          children: [
            Text(
              "${current?.year}年${current?.month}月",
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: Colors.white.withAlpha(200),
              size: 16,
            ),
          ],
        ),
      ),
      if (isShowMonthExpense)
        Text(
          "$projectName总支出¥${FormatUtil.formatAmount(monthExpense)}",
          style: TextStyle(color: Colors.white.withAlpha(200), fontSize: 12),
        ),
      if (isAllType) Padding(padding: EdgeInsets.only(left: 8)),
      if (isShowMonthIncome)
        Text(
          "$projectName总入账¥${FormatUtil.formatAmount(monthIncome)}",
          style: TextStyle(color: Colors.white.withAlpha(200), fontSize: 12),
        ),
    ],
  );
}

Widget _currentAccountBookContainer(BuildContext context) {
  return BlocBuilder<AppBloc, AppState>(
    builder: (context, appState) {
      return SwitchAccountBookButton(
        currentAccountBook: appState.currentAccountBook!,
        allAccountBooks: appState.allAccountBooks,
        onSwitchCallback: (data) {
          context.read<AppBloc>().add(AppUpdateCurrentAccountBook(data));
        },
        onCreateCallback: () {
          CreateAccountBookDialog.showDialog(
            context,
            context.read<AccountBookRepository>(),
            onCreateSuccessCallback: (data) {
              context.read<AppBloc>().add(AppCreateNewAccountBook(data));
            },
          );
        },
      );
    },
  );
}
