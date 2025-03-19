import 'package:bookkeeping/transaction/bloc/transaction_bloc.dart';
import 'package:bookkeeping/transaction/bloc/transaction_event.dart';
import 'package:bookkeeping/transaction/bloc/transaction_state.dart';
import 'package:bookkeeping/widget/keyboard_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/repository/journal_repository.dart';
import '../record/record_dialog.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

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
              body: TransactionList(),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  showRecordDialog(context, onSuccess: () {
                    context.read<TransactionBloc>().add(TransactionInitLoad());
                  });
                },
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                child: Text("记一笔"),
              ),
            );
          }),
    );
  }
}

class TransactionList extends StatefulWidget {
  const TransactionList({super.key});

  @override
  State<StatefulWidget> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        return ListView.builder(
          itemCount: state.lists.length,
          itemBuilder: (context, index) {
            var item = state.lists[index];
            return ListTile(title: Text("${item.amount}"));
          },
        );
      },
    );
  }
}
