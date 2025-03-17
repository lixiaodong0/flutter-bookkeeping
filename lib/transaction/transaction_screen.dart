import 'package:bookkeeping/transaction/bloc/transaction_bloc.dart';
import 'package:bookkeeping/transaction/bloc/transaction_event.dart';
import 'package:bookkeeping/transaction/bloc/transaction_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/repository/JournalRepository.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              TransactionBloc(repository: context.read<JournalRepository>())
                ..add(TransactionInitLoad()),
      child: TransactionList(),
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
        return Column(children: [Text("${state.count}个")]);
        return ListView.builder(
          itemCount: state.lists.length,
          itemBuilder: (context, index) {
            var item = state.lists[index];
            print("lixd-index=${index},amount=${item.amount}");
            return ListTile(title: Text("${item.amount}"));
          },
        );
      },
    );
  }
}
