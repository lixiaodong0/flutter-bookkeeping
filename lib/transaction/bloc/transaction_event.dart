import 'package:bookkeeping/data/bean/journal_project_bean.dart';

import '../../eventbus/journal_event.dart';

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
  final int accountBookId;

  const TransactionShowMonthPicker(this.accountBookId);
}

final class TransactionCloseMonthPicker extends TransactionEvent {
  TransactionCloseMonthPicker();
}

final class TransactionSelectedMonth extends TransactionEvent {
  DateTime selectedDate;

  TransactionSelectedMonth({required this.selectedDate});
}

final class TransactionShowProjectPicker extends TransactionEvent {
  TransactionShowProjectPicker();
}

final class TransactionCloseProjectPicker extends TransactionEvent {
  TransactionCloseProjectPicker();
}

final class TransactionSelectedProject extends TransactionEvent {
  JournalProjectBean? selectedProject;

  TransactionSelectedProject({required this.selectedProject});
}

final class TransactionReload extends TransactionEvent {}

final class TransactionLoadMore extends TransactionEvent {}

final class TransactionOnJournalEvent extends TransactionEvent {
  const TransactionOnJournalEvent({required this.event});

  final JournalEvent event;
}
