import 'package:bookkeeping/data/bean/journal_bean.dart';
import 'package:equatable/equatable.dart';

final class DetailJournalState extends Equatable {
  final JournalBean? currentJournal;

  const DetailJournalState({this.currentJournal});

  @override
  List<Object?> get props => [currentJournal];

  DetailJournalState copyWith({JournalBean? currentJournal}) {
    return DetailJournalState(
      currentJournal: currentJournal ?? this.currentJournal,
    );
  }
}
