import 'package:bookkeeping/data/repository/JournalRepository.dart';
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
  ) {
    print("lixd-_onTransactionInitLoad");
    repository.getAllJournal().then(
      (value) => {
        print("lixd-${value.length}"),
        emit(state.copyWith(lists:  List.from(value),count: value.length)),
      },
    );
  }

  void _onTransactionLoadMore(
    TransactionLoadMore event,
    Emitter<TransactionState> emit,
  ) {}
}
