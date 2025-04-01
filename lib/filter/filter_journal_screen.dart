import 'package:bookkeeping/filter/bloc/filter_journal_bloc.dart';
import 'package:bookkeeping/filter/bloc/filter_journal_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../data/bean/journal_bean.dart';
import '../data/bean/journal_type.dart';
import '../data/bean/project_ranking_bean.dart';
import '../data/repository/journal_repository.dart';
import 'bloc/filter_journal_state.dart';
import 'filter_journal_list.dart';
import 'filter_journal_topbar.dart';

class FilterJournalScreenParams {
  final JournalType type;
  ProjectRankingBean? projectBean;
  final DateTime date;

  FilterJournalScreenParams({
    required this.type,
    required this.date,
    this.projectBean,
  });
}

class FilterJournalScreen extends StatefulWidget {
  final FilterJournalScreenParams params;

  const FilterJournalScreen({super.key, required this.params});

  @override
  State<FilterJournalScreen> createState() => _FilterJournalScreenState();
}

class _FilterJournalScreenState extends State<FilterJournalScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => FilterJournalBloc(
            repository: context.read<JournalRepository>(),
            params: widget.params,
          )..add(FilterJournalInitLoad()),
      child: BlocListener<FilterJournalBloc, FilterJournalState>(
        listener: (context, state) {},
        child: BlocBuilder<FilterJournalBloc, FilterJournalState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                surfaceTintColor: Colors.white,
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
