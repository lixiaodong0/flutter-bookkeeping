import 'package:bookkeeping/data/bean/journal_bean.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/bean/filter_type.dart';
import '../../data/repository/journal_month_repository.dart';
import '../../data/repository/journal_repository.dart';
import '../filter_journal_screen.dart';
import 'filter_journal_event.dart';
import 'filter_journal_state.dart';

class FilterJournalBloc extends Bloc<FilterJournalEvent, FilterJournalState> {
  final JournalRepository repository;
  final FilterJournalScreenParams params;

  FilterJournalBloc({required this.repository, required this.params})
    : super(
        FilterJournalState(
          currentDate: params.date,
          currentType: params.type,
          projectBean: params.projectBean,
        ),
      ) {
    on<FilterJournalInitLoad>(_onInitLoad);
    on<FilterJournalOnChangeFilterType>(_onChangeFilterType);
  }

  void _onInitLoad(
    FilterJournalInitLoad event,
    Emitter<FilterJournalState> emit,
  ) async {
    await _reload(emit);
  }

  void _onChangeFilterType(
    FilterJournalOnChangeFilterType event,
    Emitter<FilterJournalState> emit,
  ) async {
    var filterType = event.filterType;
    List<JournalBean> list = [];
    list.addAll(state.list);
    _sort(list, filterType);
    emit(state.copyWith(currentFilterType: filterType, list: list));
  }

  Future<void> _reload(Emitter<FilterJournalState> emit) async {
    var date = state.currentDate ?? DateTime.now();
    var type = state.currentType;
    var monthAmount = await repository.getMonthTotalAmount(date, type);
    var list = await repository.getMonthJournal(date, type);
    _sort(list, state.currentFilterType);
    emit(state.copyWith(monthAmount: monthAmount, list: list));
  }

  void _sort(List<JournalBean> list, FilterType filterType) {
    if (filterType == FilterType.date) {
      //时间倒叙
      list.sort((a, b) => b.date.compareTo(a.date));
    } else {
      //金额倒叙
      list.sort((a, b) => num.parse(b.amount).compareTo(num.parse(a.amount)));
    }
  }
}
