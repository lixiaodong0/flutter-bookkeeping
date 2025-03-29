import 'package:bookkeeping/filter/bloc/filter_journal_bloc.dart';
import 'package:bookkeeping/filter/bloc/filter_journal_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../data/bean/journal_bean.dart';
import '../data/repository/journal_repository.dart';
import 'bloc/filter_journal_state.dart';
import 'filter_journal_list.dart';
import 'filter_journal_topbar.dart';

class FilterJournalScreen extends StatefulWidget {
  const FilterJournalScreen({super.key});

  @override
  State<FilterJournalScreen> createState() => _FilterJournalScreenState();
}

class _FilterJournalScreenState extends State<FilterJournalScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              FilterJournalBloc(repository: context.read<JournalRepository>())
                ..add(FilterJournalInitLoad()),
      child: BlocListener<FilterJournalBloc, FilterJournalState>(
        listener: (context, state) {},
        child: BlocBuilder<FilterJournalBloc, FilterJournalState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios_new_rounded),
                  onPressed: () {
                    context.pop();
                  },
                ),
              ),
              body: CustomScrollView(
                slivers: [
                  buildFilterJournalHeader(context, state),
                  SliverList(
                    delegate: SliverChildBuilderDelegate((
                      BuildContext context,
                      int index,
                    ) {
                      return journalListItem(
                        context,
                        state.currentType.symbol,
                        state.list[index],
                      );
                    }, childCount: state.list.length),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
