import 'package:bookkeeping/eventbus/journal_event.dart';
import 'package:bookkeeping/util/toast_util.dart';
import 'package:bookkeeping/widget/toast_action_widget.dart';
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
    on<DetailJournalOnJournalEvent>(_onJournalEvent);
  }

  void _onJournalEvent(
    DetailJournalOnJournalEvent event,
    Emitter<DetailJournalState> emit,
  ) async {
    if (event.event.action == JournalEventAction.update) {
      if (event.event.journalBean.id == id) {
        emit(state.copyWith(currentJournal: event.event.journalBean));
      }
    }
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
    showSuccessActionToast("已删除");
  }
}
