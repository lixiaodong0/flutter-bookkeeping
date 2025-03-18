import 'package:bookkeeping/data/bean/journal_bean.dart';
import 'package:equatable/equatable.dart';

final class TransactionState extends Equatable {
  final List<JournalBean> lists;

  const TransactionState({this.lists = const []});

  @override
  List<Object?> get props => [lists];

  TransactionState copyWith({List<JournalBean>? lists}) {
    return TransactionState(
      lists: lists ?? this.lists,
    );
  }
}
