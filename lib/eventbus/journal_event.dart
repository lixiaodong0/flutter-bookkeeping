import 'package:bookkeeping/data/bean/journal_bean.dart';

import 'eventbus.dart';

enum JournalEventAction { add, delete, update }

class JournalEvent {
  final JournalEventAction action;
  final JournalBean journalBean;

  const JournalEvent({required this.action, required this.journalBean});

  static publishAddEvent(JournalBean journalBean) {
    eventBus.fire(
      JournalEvent(action: JournalEventAction.add, journalBean: journalBean),
    );
  }

  static publishDeleteEvent(JournalBean journalBean) {
    eventBus.fire(
      JournalEvent(action: JournalEventAction.delete, journalBean: journalBean),
    );
  }

  static publishUpdateEvent(JournalBean journalBean) {
    eventBus.fire(
      JournalEvent(action: JournalEventAction.update, journalBean: journalBean),
    );
  }
}
