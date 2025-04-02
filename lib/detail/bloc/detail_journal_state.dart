import 'package:bookkeeping/data/bean/journal_bean.dart';
import 'package:equatable/equatable.dart';

final class DetailJournalState extends Equatable {
  final JournalBean? currentJournal;
  final bool isDeleted;

  const DetailJournalState({this.currentJournal, this.isDeleted = false});

  @override
  List<Object?> get props => [currentJournal, isDeleted];

  DetailJournalState copyWith({JournalBean? currentJournal, bool? isDeleted}) {
    return DetailJournalState(
      currentJournal: currentJournal ?? this.currentJournal,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
