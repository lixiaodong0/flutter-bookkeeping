import 'dart:async';

import 'package:bookkeeping/detail/detail_journal_screen.dart';
import 'package:bookkeeping/eventbus/eventbus.dart';
import 'package:bookkeeping/transaction/bloc/transaction_bloc.dart';
import 'package:bookkeeping/transaction/bloc/transaction_event.dart';
import 'package:bookkeeping/transaction/bloc/transaction_state.dart';
import 'package:bookkeeping/transaction/transaction_item.dart';
import 'package:bookkeeping/transaction/transaction_topbar.dart';
import 'package:bookkeeping/widget/clickable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../data/repository/journal_month_repository.dart';
import '../data/repository/journal_project_repository.dart';
import '../data/repository/journal_repository.dart';
import '../eventbus/journal_event.dart';
import '../record/record_dialog.dart';
import '../widget/month_picker_widget.dart';
import '../widget/project_picker_widget.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<StatefulWidget> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  final ItemScrollController itemScrollController = ItemScrollController();
  final GlobalKey _blocContext = GlobalKey();

  late final StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    itemPositionsListener.itemPositions.addListener(_onScroll);

    //订阅事件
    _subscription = eventBus.on<JournalEvent>().listen((event) {
      print("[eventBus-on]action=${event.action},id:${event.journalBean.id}");
      _blocContext.currentContext?.read<TransactionBloc>().add(
        TransactionOnJournalEvent(event: event),
      );
    });
  }

  void _onScroll() {
    if (itemPositionsListener.itemPositions.value.isEmpty) {
      return;
    }
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
    //取消事件
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => TransactionBloc(
            repository: context.read<JournalRepository>(),
            projectRepository: context.read<JournalProjectRepository>(),
            monthRepository: context.read<JournalMonthRepository>(),
          )..add(TransactionInitLoad()),

      child: BlocListener<TransactionBloc, TransactionState>(
        listener: (context, state) {
          if (state.monthPickerDialogState is MonthPickerDialogOpenState) {
            var open =
                state.monthPickerDialogState as MonthPickerDialogOpenState;
            MonthPickerWidget.showDatePicker(
              context,
              currentDate: open.currentDate,
              allDate: open.allDate,
              onChanged: (newDate) {
                context.read<TransactionBloc>().add(
                  TransactionSelectedMonth(
                    selectedDate: DateTime(newDate.year, newDate.month),
                  ),
                );
              },
              onClose: () {
                context.read<TransactionBloc>().add(
                  TransactionCloseMonthPicker(),
                );
              },
            );
          }

          if (state.projectPickerDialogState is ProjectPickerDialogOpenState) {
            var open =
                state.projectPickerDialogState as ProjectPickerDialogOpenState;
            ProjectPickerWidget.showDatePicker(
              context,
              currentProject: open.currentProject,
              allIncomeProject: open.allIncomeProject,
              allExpenseProject: open.allExpenseProject,
              onChanged: (newProject) {
                context.read<TransactionBloc>().add(
                  TransactionSelectedProject(selectedProject: newProject),
                );
              },
              onClose: () {
                context.read<TransactionBloc>().add(
                  TransactionCloseProjectPicker(),
                );
              },
            );
          }
        },
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

              floatingActionButton: sizedButtonWidget(
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
                child: DecoratedBox(
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
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
          children.add(
            buildTransactionHeader(context, item.dailyAmount!, index == 0),
          );
        }
        //渲染Item
        children.add(
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              DetailJournalScreenRoute.launch(context, item.id);
            },
            child: buildTransactionItem(
              context,
              item.type,
              item.journalProjectName,
              item.amount,
              item.date,
              isLastItem: nextDate != currentDate,
              desc: item.description ?? "",
            ),
          ),
        );
        return Column(children: children);
      },
    );
  }
}
