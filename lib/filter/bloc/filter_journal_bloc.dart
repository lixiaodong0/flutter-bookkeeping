import 'package:bookkeeping/data/bean/journal_bean.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/bean/account_book_bean.dart';
import '../../data/bean/filter_type.dart';
import '../../data/repository/journal_month_repository.dart';
import '../../data/repository/journal_repository.dart';
import '../filter_journal_screen.dart';
import 'filter_journal_event.dart';
import 'filter_journal_state.dart';

class FilterJournalBloc extends Bloc<FilterJournalEvent, FilterJournalState> {
  final JournalRepository repository;
  final FilterJournalScreenParams params;
  AccountBookBean currentAccountBook;

  FilterJournalBloc({
    required this.repository,
    required this.params,
    required this.currentAccountBook,
  }) : super(
         FilterJournalState(
           currentDate: params.date,
           currentType: params.type,
           projectBean: params.projectBean,
         ),
       ) {
    on<FilterJournalInitLoad>(_onInitLoad);
    on<FilterJournalReload>(_onReload);
    on<FilterJournalOnChangeFilterType>(_onChangeFilterType);
  }

  void _onReload(
    FilterJournalReload event,
    Emitter<FilterJournalState> emit,
  ) async {
    await _reload(emit);
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

  int _getProjectId() {
    if (params.projectBean != null) {
      return params.projectBean!.id;
    }
    return -1;
  }

  Future<void> _reload(Emitter<FilterJournalState> emit) async {
    var date = state.currentDate ?? DateTime.now();
    var type = state.currentType;
    var projectId = _getProjectId();
    var monthAmount = await repository.getMonthTotalAmount(
      currentAccountBook.id,
      date,
      type,
      projectId: projectId,
    );
    var list = await repository.getMonthJournal(
      currentAccountBook.id,
      date,
      type,
      projectId: projectId,
    );
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
