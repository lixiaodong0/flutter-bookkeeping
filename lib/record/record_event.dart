import 'package:bookkeeping/data/bean/journal_project_bean.dart';
import 'package:bookkeeping/widget/keyboard_widget.dart';

import '../data/bean/journal_type.dart';

sealed class RecordEvent {
  const RecordEvent();
}

final class RecordOnInitial extends RecordEvent {
  const RecordOnInitial();
}

final class RecordOnUpdateCurrentDate extends RecordEvent {
  final DateTime date;

  const RecordOnUpdateCurrentDate({required this.date});
}

final class RecordOnCheckedProject extends RecordEvent {
  final JournalProjectBean checked;

  const RecordOnCheckedProject({required this.checked});
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
