import 'package:bookkeeping/data/repository/journal_repository.dart';
import 'package:bookkeeping/transaction/bloc/transaction_event.dart';
import 'package:bookkeeping/transaction/bloc/transaction_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/bean/journal_bean.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final JournalRepository repository;
  final int pageSize = 20;
  int page = 1;

  TransactionBloc({required this.repository})
    : super(TransactionState(currentDate: DateTime.now())) {
    on<TransactionInitLoad>(_onInitLoad);
    on<TransactionOnScrollChange>(_onScrollChange);
    on<TransactionReload>(_onReload);
    on<TransactionLoadMore>(_onLoadMore);
  }

  void _onScrollChange(
    TransactionOnScrollChange event,
    Emitter<TransactionState> emit,
  ) async {

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
