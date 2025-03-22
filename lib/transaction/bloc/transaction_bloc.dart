import 'package:bookkeeping/data/repository/journal_repository.dart';
import 'package:bookkeeping/transaction/bloc/transaction_event.dart';
import 'package:bookkeeping/transaction/bloc/transaction_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/bean/journal_bean.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final JournalRepository repository;
  final int pageSize = 20;
  int page = 1;

  TransactionBloc({required this.repository}) : super(TransactionState()) {
    on<TransactionInitLoad>(_onTransactionInitLoad);
    on<TransactionLoadMore>(_onTransactionLoadMore);
  }

  void _onTransactionInitLoad(
    TransactionInitLoad event,
    Emitter<TransactionState> emit,
  ) async {
    print("[_onTransactionInitLoad]start");
    var result = await repository.getPageJournal(
      pageSize: pageSize,
      page: page,
    );
    print("[_onTransactionInitLoad]result:$result");
    emit(state.copyWith(lists: result));
  }

  void _onTransactionLoadMore(
    TransactionLoadMore event,
    Emitter<TransactionState> emit,
  ) async {
    page++;
    print("[_onTransactionLoadMore]start");
    var result = await repository.getPageJournal(
      pageSize: pageSize,
      page: page,
    );
    print("[_onTransactionLoadMore]result:$result");
    List<JournalBean> newLists = [];
    newLists.addAll(state.lists);
    newLists.addAll(result);
    emit(state.copyWith(lists: newLists));
  }
}
