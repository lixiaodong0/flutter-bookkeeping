import '../../eventbus/journal_event.dart';

class DetailJournalEvent {
  const DetailJournalEvent();
}

class DetailJournalInitLoad extends DetailJournalEvent {
  const DetailJournalInitLoad();
}

class DetailJournalOnDelete extends DetailJournalEvent {
  const DetailJournalOnDelete();
}

class DetailJournalOnJournalEvent extends DetailJournalEvent {
  const DetailJournalOnJournalEvent({required this.event});

  final JournalEvent event;
}
