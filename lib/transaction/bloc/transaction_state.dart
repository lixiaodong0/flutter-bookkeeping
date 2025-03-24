import 'package:bookkeeping/data/bean/journal_bean.dart';
import 'package:equatable/equatable.dart';

enum RecordDialogState { close, open }

final class TransactionState extends Equatable {
  final List<JournalBean> lists;
  final RecordDialogState recordDialogState;

  final DateTime? currentDate;
  final String dateMonthIncome;
  final String dateMonthExpense;

  const TransactionState({
    this.lists = const [],
    this.recordDialogState = RecordDialogState.close,
    this.currentDate,
    this.dateMonthIncome = "0",
    this.dateMonthExpense = "0",
  });

  @override
  List<Object?> get props => [
    lists,
    recordDialogState,
    currentDate,
    dateMonthIncome,
    dateMonthExpense,
  ];

  TransactionState copyWith({
    List<JournalBean>? lists,
    RecordDialogState? recordDialogState,
    DateTime? currentDate,
    String? dateMonthIncome,
    String? dateMonthExpense,
  }) {
    return TransactionState(
      lists: lists ?? this.lists,
      recordDialogState: recordDialogState ?? this.recordDialogState,
      currentDate: currentDate ?? this.currentDate,
      dateMonthIncome: dateMonthIncome ?? this.dateMonthIncome,
      dateMonthExpense: dateMonthExpense ?? this.dateMonthExpense,
    );
  }
}
