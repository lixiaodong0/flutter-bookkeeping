import 'package:bookkeeping/data/bean/journal_type.dart';
import 'package:bookkeeping/data/repository/journal_month_repository.dart';
import 'package:bookkeeping/data/repository/journal_project_repository.dart';
import 'package:bookkeeping/data/repository/journal_repository.dart';
import 'package:bookkeeping/transaction/bloc/transaction_event.dart';
import 'package:bookkeeping/transaction/bloc/transaction_state.dart';
import 'package:bookkeeping/util/date_util.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/bean/journal_bean.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final JournalRepository repository;
  final JournalProjectRepository projectRepository;
  final JournalMonthRepository monthRepository;
  final int pageSize = 20;
  int page = 1;

  TransactionBloc({
    required this.repository,
    required this.projectRepository,
    required this.monthRepository,
  }) : super(TransactionState(currentDate: DateTime.now())) {
    on<TransactionInitLoad>(_onInitLoad);
    on<TransactionOnScrollChange>(_onScrollChange);
    on<TransactionReload>(_onReload);
    on<TransactionLoadMore>(_onLoadMore);
  }

  void _onScrollChange(
    TransactionOnScrollChange event,
    Emitter<TransactionState> emit,
  ) async {
    var firstIndex = event.firstIndex = event.firstIndex;
    var findItem = state.lists[firstIndex];
    var date = findItem.date;
    // print(
    //   "[_onScrollChange]firstIndex:${firstIndex},findItem:${findItem},date:${date}",
    // );
    if (!DateUtil.isSameMonth(date, state.currentDate)) {
      //重新计算
      var totalIncome = await repository.getMonthTotalAmount(
        date,
        JournalType.income,
      );
      var totalExpense = await repository.getMonthTotalAmount(
        date,
        JournalType.expense,
      );
      emit(
        state.copyWith(
          currentDate: date,
          dateMonthIncome: totalIncome,
          dateMonthExpense: totalExpense,
        ),
      );
    }
  }

  void _onInitLoad(
    TransactionInitLoad event,
    Emitter<TransactionState> emit,
  ) async {
    page = 1;
    var result = await _loadData();
    emit(state.copyWith(lists: result));
  }

  void _onReload(
    TransactionReload event,
    Emitter<TransactionState> emit,
  ) async {
    page = 1;
    var result = await _loadData();
    emit(state.copyWith(lists: result));
  }

  //加载数据
  Future<List<JournalBean>> _loadData() {
    return repository.getPageJournal(pageSize: pageSize, page: page);
  }

  void _onLoadMore(
    TransactionLoadMore event,
    Emitter<TransactionState> emit,
  ) async {
    page++;
    var result = await _loadData();
    List<JournalBean> newLists = [];
    newLists.addAll(state.lists);
    newLists.addAll(result);
    emit(state.copyWith(lists: newLists));
  }
}
