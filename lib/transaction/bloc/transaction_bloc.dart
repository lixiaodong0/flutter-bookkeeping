import 'package:bookkeeping/data/repository/journal_repository.dart';
import 'package:bookkeeping/transaction/bloc/transaction_event.dart';
import 'package:bookkeeping/transaction/bloc/transaction_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final JournalRepository repository;

  TransactionBloc({required this.repository}) : super(TransactionState()) {
    on<TransactionInitLoad>(_onTransactionInitLoad);
    on<TransactionLoadMore>(_onTransactionLoadMore);
  }

  void _onTransactionInitLoad(
    TransactionInitLoad event,
    Emitter<TransactionState> emit,
  ) async {
    print("[_onTransactionInitLoad]");
    var result = await repository.getAllJournal();
    print("[_onTransactionInitLoad]result:$result");
    emit(state.copyWith(lists: result));
  }

  void _onTransactionLoadMore(
    TransactionLoadMore event,
    Emitter<TransactionState> emit,
  ) {}
}
