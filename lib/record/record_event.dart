import 'package:bookkeeping/widget/keyboard_widget.dart';

import '../data/bean/journal_type.dart';

sealed class RecordEvent {
  const RecordEvent();
}

final class RecordOnInitial extends RecordEvent {
  const RecordOnInitial();
}

final class RecordOnClickJournalType extends RecordEvent {
  final JournalType type;

  const RecordOnClickJournalType({required this.type});
}

final class RecordOnClickKeyCode extends RecordEvent {
  final KeyCode keyCode;

  const RecordOnClickKeyCode({required this.keyCode});
}

final class RecordOnClickConfirm extends RecordEvent {}
