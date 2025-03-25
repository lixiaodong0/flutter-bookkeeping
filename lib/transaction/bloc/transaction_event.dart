sealed class TransactionEvent {
  const TransactionEvent();
}

final class TransactionInitLoad extends TransactionEvent {}

final class TransactionOnScrollChange extends TransactionEvent {
  int firstIndex;
  int lastIndex;

  TransactionOnScrollChange({
    required this.firstIndex,
    required this.lastIndex,
  });
}

final class TransactionShowMonthPicker extends TransactionEvent {
  TransactionShowMonthPicker();
}
final class TransactionCloseMonthPicker extends TransactionEvent {
  TransactionCloseMonthPicker();
}

final class TransactionShowProjectPicker extends TransactionEvent {
  TransactionShowProjectPicker();
}
final class TransactionCloseProjectPicker extends TransactionEvent {
  TransactionCloseProjectPicker();
}

final class TransactionReload extends TransactionEvent {}

final class TransactionLoadMore extends TransactionEvent {}
