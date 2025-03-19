import 'package:bookkeeping/data/bean/journal_bean.dart';
import 'package:equatable/equatable.dart';

enum RecordDialogState { close, open }

final class TransactionState extends Equatable {
  final List<JournalBean> lists;
  final RecordDialogState recordDialogState;

  const TransactionState({
    this.lists = const [],
    this.recordDialogState = RecordDialogState.close,
  });

  @override
  List<Object?> get props => [lists, recordDialogState];

  TransactionState copyWith({
    List<JournalBean>? lists,
    RecordDialogState? recordDialogState,
  }) {
    return TransactionState(
      lists: lists ?? this.lists,
      recordDialogState: recordDialogState ?? this.recordDialogState,
    );
  }
}
