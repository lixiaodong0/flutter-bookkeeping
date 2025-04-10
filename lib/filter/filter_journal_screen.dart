import 'dart:async';

import 'package:bookkeeping/app_bloc.dart';
import 'package:bookkeeping/filter/bloc/filter_journal_bloc.dart';
import 'package:bookkeeping/filter/bloc/filter_journal_event.dart';
import 'package:bookkeeping/util/date_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../data/bean/journal_bean.dart';
import '../data/bean/journal_type.dart';
import '../data/bean/project_ranking_bean.dart';
import '../data/repository/journal_repository.dart';
import '../eventbus/eventbus.dart';
import '../eventbus/journal_event.dart';
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
  late final StreamSubscription _subscription;
  GlobalKey blocContext = GlobalKey();

  @override
  void initState() {
    //订阅事件
    _subscription = eventBus.on<JournalEvent>().listen((event) {
      if (event.journalBean.type == widget.params.type &&
          DateUtil.isSameMonth(event.journalBean.date, widget.params.date)) {
        blocContext.currentContext?.read<FilterJournalBloc>().add(
          FilterJournalReload(),
        );
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    //取消事件
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => FilterJournalBloc(
            currentAccountBook:
                context.read<AppBloc>().state.currentAccountBook!,
            repository: context.read<JournalRepository>(),
            params: widget.params,
          )..add(FilterJournalInitLoad()),
      child: BlocListener<FilterJournalBloc, FilterJournalState>(
        key: blocContext,
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
