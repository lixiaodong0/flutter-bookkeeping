import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repository/journal_repository.dart';
import 'detail_journal_evnet.dart';
import 'detail_journal_state.dart';

class DetailJournalBloc extends Bloc<DetailJournalEvent, DetailJournalState> {
  final JournalRepository repository;
  final int id;

  DetailJournalBloc({required this.repository, required this.id})
    : super(DetailJournalState()) {
    on<DetailJournalInitLoad>(_initLoad);
  }

  void _initLoad(
    DetailJournalInitLoad event,
    Emitter<DetailJournalState> emit,
  ) async {
    var result = await repository.getJournal(id);
    emit(state.copyWith(currentJournal: result));
  }
}
