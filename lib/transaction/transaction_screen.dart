import 'package:bookkeeping/transaction/bloc/transaction_bloc.dart';
import 'package:bookkeeping/transaction/bloc/transaction_event.dart';
import 'package:bookkeeping/transaction/bloc/transaction_state.dart';
import 'package:bookkeeping/transaction/transaction_item.dart';
import 'package:bookkeeping/widget/date_piacker_widget.dart';
import 'package:bookkeeping/widget/keyboard_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/bean/journal_bean.dart';
import '../data/repository/journal_repository.dart';
import '../record/record_dialog.dart';

class TransactionScreen extends StatelessWidget {
  TransactionScreen({super.key});

  final ScrollController _scrollController = ScrollController();

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
            body: Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: _buildTransactionList(context, state),
            ),
            backgroundColor: Color.fromRGBO(237, 237, 237, 1.0),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                RecordDialog.showRecordDialog(
                  context,
                  onSuccess: () {
                    context.read<TransactionBloc>().add(TransactionReload());
                  },
                );
              },
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              child: Text("记一笔"),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTransactionList(BuildContext context, TransactionState state) {
    return ListView.builder(
      controller: _scrollController,
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
