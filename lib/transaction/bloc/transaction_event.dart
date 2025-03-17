sealed class TransactionEvent {
  const TransactionEvent();
}

final class TransactionInitLoad extends TransactionEvent {}

final class TransactionLoadMore extends TransactionEvent {}
