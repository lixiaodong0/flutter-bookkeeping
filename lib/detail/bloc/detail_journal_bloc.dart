import 'package:bookkeeping/eventbus/journal_event.dart';
import 'package:bookkeeping/util/toast_util.dart';
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
    on<DetailJournalOnDelete>(_onDelete);
  }

  void _initLoad(
    DetailJournalInitLoad event,
    Emitter<DetailJournalState> emit,
  ) async {
    var result = await repository.getJournal(id);
    emit(state.copyWith(currentJournal: result));
  }

  void _onDelete(
    DetailJournalOnDelete event,
    Emitter<DetailJournalState> emit,
  ) async {
    var result = await repository.deleteJournal(id);
    emit(state.copyWith(isDeleted: true));
    JournalEvent.publishDeleteEvent(state.currentJournal!);
    showToast("已删除");
  }
}
