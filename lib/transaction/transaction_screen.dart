import 'package:bookkeeping/transaction/bloc/transaction_bloc.dart';
import 'package:bookkeeping/transaction/bloc/transaction_event.dart';
import 'package:bookkeeping/transaction/bloc/transaction_state.dart';
import 'package:bookkeeping/transaction/transaction_item.dart';
import 'package:bookkeeping/transaction/transaction_topbar.dart';
import 'package:bookkeeping/widget/clickable_widget.dart';
import 'package:bookkeeping/widget/date_piacker_widget.dart';
import 'package:bookkeeping/widget/keyboard_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../data/bean/journal_bean.dart';
import '../data/repository/journal_repository.dart';
import '../record/record_dialog.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<StatefulWidget> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  final GlobalKey _blocContext = GlobalKey();

  @override
  void initState() {
    super.initState();
    itemPositionsListener.itemPositions.addListener(_onScroll);
  }

  void _onScroll() {
    var firstIndex = itemPositionsListener.itemPositions.value.first.index;
    var lastIndex = itemPositionsListener.itemPositions.value.last.index;
    if (_blocContext.currentContext != null) {
      _blocContext.currentContext!.read<TransactionBloc>().add(
        TransactionOnScrollChange(firstIndex: firstIndex, lastIndex: lastIndex),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              TransactionBloc(repository: context.read<JournalRepository>())
                ..add(TransactionInitLoad()),
      child: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          return Scaffold(
            key: _blocContext,
            body: Column(
              children: [
                _buildHeader(context, state),
                Expanded(child: _buildTransactionList(context, state)),
              ],
            ),
            backgroundColor: Color.fromRGBO(237, 237, 237, 1.0),
            floatingActionButton: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withAlpha(50), // 阴影颜色
                    offset: Offset(0, 4), // 阴影偏移量
                    blurRadius: 6, // 模糊半径
                    spreadRadius: 2, // 扩散半径
                  ),
                ],
              ),
              child: sizedButtonWidget(
                onPressed: () {
                  RecordDialog.showRecordDialog(
                    context,
                    onSuccess: () {
                      context.read<TransactionBloc>().add(TransactionReload());
                    },
                  );
                },
                width: 90,
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.post_add_outlined, color: Colors.green),
                    Text(
                      "记一笔",
                      style: TextStyle(color: Colors.green, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, TransactionState state) {
    return Container(
      height: 150,
      color: Colors.green,
      child: buildTopBarContent(context, state),
    );
  }

  Widget _buildTransactionList(BuildContext context, TransactionState state) {
    return ScrollablePositionedList.builder(
      padding: EdgeInsets.symmetric(horizontal: 16),
      itemPositionsListener: itemPositionsListener,
      itemCount: state.lists.length,
      itemBuilder: (context, index) {
        var item = state.lists[index];
        var currentDate = item.dailyAmount?.date ?? "";
        var previousDate = "";
        var previousIndex = index - 1;
        if (previousIndex >= 0) {
          previousDate = state.lists[previousIndex].dailyAmount?.date ?? "";
        }

        var nextDate = "";
        var nextIndex = index + 1;
        if (nextIndex < state.lists.length) {
          nextDate = state.lists[nextIndex].dailyAmount?.date ?? "";
        }

        List<Widget> children = [];
        //渲染头部
        if (currentDate != previousDate && item.dailyAmount != null) {
          children.add(buildTransactionHeader(context, item.dailyAmount!));
        }
        //渲染Item
        children.add(
          buildTransactionItem(
            context,
            item.type,
            item.journalProjectName,
            item.amount,
            item.date,
            isLastItem: nextDate != currentDate,
          ),
        );

        if (state.lists.length - 1 == index) {
          context.read<TransactionBloc>().add(TransactionLoadMore());
        }
        return Column(children: children);
      },
    );
  }
}
