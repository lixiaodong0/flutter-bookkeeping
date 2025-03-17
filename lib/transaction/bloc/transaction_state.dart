import 'package:bookkeeping/data/bean/JournalBean.dart';
import 'package:bookkeeping/model/JournalEntry.dart';
import 'package:equatable/equatable.dart';

final class TransactionState extends Equatable {
  final List<JournalBean> lists;
  final int count;

  const TransactionState({this.lists = const [], this.count = 0});

  @override
  List<Object?> get props => [lists, count];

  TransactionState copyWith({List<JournalBean>? lists, int? count}) {
    return TransactionState(
      lists: lists ?? this.lists,
      count: count ?? this.count,
    );
  }
}
