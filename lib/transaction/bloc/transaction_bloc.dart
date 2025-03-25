import 'dart:ffi';

import 'package:bookkeeping/data/bean/journal_month_bean.dart';
import 'package:bookkeeping/data/bean/journal_type.dart';
import 'package:bookkeeping/data/repository/journal_month_repository.dart';
import 'package:bookkeeping/data/repository/journal_project_repository.dart';
import 'package:bookkeeping/data/repository/journal_repository.dart';
import 'package:bookkeeping/transaction/bloc/transaction_event.dart';
import 'package:bookkeeping/transaction/bloc/transaction_state.dart';
import 'package:bookkeeping/util/date_util.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/bean/journal_bean.dart';
import '../../data/bean/journal_project_bean.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final JournalRepository repository;
  final JournalProjectRepository projectRepository;
  final JournalMonthRepository monthRepository;
  final int pageSize = 20;
  int page = 1;

  TransactionBloc({
    required this.repository,
    required this.projectRepository,
    required this.monthRepository,
  }) : super(TransactionState(currentDate: DateTime.now())) {
    on<TransactionInitLoad>(_onInitLoad);
    on<TransactionOnScrollChange>(_onScrollChange);
    on<TransactionReload>(_onReload);
    on<TransactionLoadMore>(_onLoadMore);
    on<TransactionShowMonthPicker>(_onShowMonthPicker);
    on<TransactionCloseMonthPicker>(_onCloseMonthPicker);
    on<TransactionShowProjectPicker>(_onShowProjectPicker);
    on<TransactionCloseProjectPicker>(_onCloseProjectPicker);
    on<TransactionSelectedProject>(_onSelectedProject);
    on<TransactionSelectedMonth>(_onSelectedMonth);
  }

  void _onSelectedProject(
    TransactionSelectedProject event,
    Emitter<TransactionState> emit,
  ) async {
    var selectedProject = event.selectedProject;
    page = 1;
    var result = await _loadData(limitProject: selectedProject);
    emit(
      state.copyWith(
        currentProject: selectedProject,
        projectPickerDialogState: ProjectPickerDialogCloseState(),
        lists: result,
      ),
    );
  }

  void _onSelectedMonth(
    TransactionSelectedMonth event,
    Emitter<TransactionState> emit,
  ) async {
    emit(
      state.copyWith(
        currentDate: event.selectedDate,
        monthPickerDialogState: MonthPickerDialogCloseState(),
      ),
    );
  }

  void _onShowMonthPicker(
    TransactionShowMonthPicker event,
    Emitter<TransactionState> emit,
  ) async {
    var result = await monthRepository.getAllJournalMonth();

    Map<int, List<JournalMonthBean>> map = {};
    for (var item in result) {
      var valueList = map[item.year];
      valueList ??= [];
      valueList.add(item);
      map[item.year] = valueList;
    }

    List<JournalMonthGroupBean> group = [];
    for (var item in map.entries) {
      var list = item.value;
      list.sort((a, b) => a.month.compareTo(b.month));
      group.add(JournalMonthGroupBean(year: item.key, list: list));
    }

    emit(
      state.copyWith(
        monthPickerDialogState: MonthPickerDialogOpenState(
          currentDate: state.currentDate ?? DateTime.now(),
          allDate: group,
        ),
      ),
    );
  }

  void _onCloseMonthPicker(
    TransactionCloseMonthPicker event,
    Emitter<TransactionState> emit,
  ) async {
    emit(state.copyWith(monthPickerDialogState: MonthPickerDialogCloseState()));
  }

  void _onShowProjectPicker(
    TransactionShowProjectPicker event,
    Emitter<TransactionState> emit,
  ) async {
    var allIncomeProject =
        await projectRepository.getAllIncomeJournalProjects();
    var allExpenseProject =
        await projectRepository.getAllExpenseJournalProjects();
    emit(
      state.copyWith(
        projectPickerDialogState: ProjectPickerDialogOpenState(
          currentProject: state.currentProject,
          allIncomeProject: allIncomeProject,
          allExpenseProject: allExpenseProject,
        ),
      ),
    );
  }

  void _onCloseProjectPicker(
    TransactionCloseProjectPicker event,
    Emitter<TransactionState> emit,
  ) async {
    emit(
      state.copyWith(projectPickerDialogState: ProjectPickerDialogCloseState()),
    );
  }

  void _onScrollChange(
    TransactionOnScrollChange event,
    Emitter<TransactionState> emit,
  ) async {
    var firstIndex = event.firstIndex = event.firstIndex;
    var findItem = state.lists[firstIndex];
    var date = findItem.date;
    // print(
    //   "[_onScrollChange]firstIndex:${firstIndex},findItem:${findItem},date:${date}",
    // );
    if (!DateUtil.isSameMonth(date, state.currentDate)) {
      //重新计算
      var totalIncome = await repository.getMonthTotalAmount(
        date,
        JournalType.income,
      );
      var totalExpense = await repository.getMonthTotalAmount(
        date,
        JournalType.expense,
      );
      emit(
        state.copyWith(
          currentDate: date,
          dateMonthIncome: totalIncome,
          dateMonthExpense: totalExpense,
        ),
      );
    }
  }

  void _onInitLoad(
    TransactionInitLoad event,
    Emitter<TransactionState> emit,
  ) async {
    print("_onInitLoad");
    page = 1;
    var result = await _loadData();
    emit(state.copyWith(lists: result));
  }

  void _onReload(
    TransactionReload event,
    Emitter<TransactionState> emit,
  ) async {
    print("_onReload");
    page = 1;
    var result = await _loadData();
    emit(state.copyWith(lists: result));
  }

  //加载数据
  Future<List<JournalBean>> _loadData({JournalProjectBean? limitProject}) {
    return repository.getPageJournal(
      pageSize: pageSize,
      page: page,
      limitProject: limitProject,
    );
  }

  void _onLoadMore(
    TransactionLoadMore event,
    Emitter<TransactionState> emit,
  ) async {
    print("_onLoadMore");
    page++;
    var result = await _loadData();
    List<JournalBean> newLists = [];
    newLists.addAll(state.lists);
    newLists.addAll(result);
    emit(state.copyWith(lists: newLists));
  }
}
