import 'dart:ffi';

import 'package:bookkeeping/cache/scroll_date_amount_cache.dart';
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

  //筛选条件
  DateTime currentLimitDate = DateTime.now();
  JournalProjectBean? currentLimitProject = JournalProjectBean.allItemBean();

  TransactionBloc({
    required this.repository,
    required this.projectRepository,
    required this.monthRepository,
  }) : super(
         TransactionState(
           currentDate: DateTime.now(),
           currentProject: JournalProjectBean.allItemBean(),
         ),
       ) {
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
    currentLimitProject = event.selectedProject;
    page = 1;
    var result = await _loadData();
    emit(
      state.copyWith(
        currentProject: currentLimitProject,
        projectPickerDialogState: ProjectPickerDialogCloseState(),
        lists: result,
      ),
    );
  }

  void _onSelectedMonth(
    TransactionSelectedMonth event,
    Emitter<TransactionState> emit,
  ) async {
    currentLimitDate = event.selectedDate;
    page = 1;
    var result = await _loadData();
    emit(
      state.copyWith(
        currentDate: currentLimitDate,
        monthPickerDialogState: MonthPickerDialogCloseState(),
        lists: result,
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
          currentDate: currentLimitDate,
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
          currentProject: currentLimitProject,
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
    var firstIndex = event.firstIndex;
    var lastIndex = event.lastIndex;
    var findItem = state.lists[firstIndex];
    var date = findItem.date;
    // print(
    //   "[_onScrollChange]firstIndex:${firstIndex},findItem:${findItem},date:${date}",
    // );
    if (!DateUtil.isSameMonth(date, state.currentDate)) {
      var hasCache = DateAmountCache().hasCache(date);
      String totalIncome;
      String totalExpense;
      if (hasCache) {
        //读缓存
        var cache = DateAmountCache().getCache(date);
        totalIncome = cache!.incomeAmount;
        totalExpense = cache.expenseAmount;
      } else {
        //读数据库
        totalIncome = await repository.getMonthTotalAmount(
          date,
          JournalType.income,
        );
        totalExpense = await repository.getMonthTotalAmount(
          date,
          JournalType.expense,
        );
        DateAmountCache().putCache(date, totalIncome, totalExpense);
      }
      emit(
        state.copyWith(
          currentDate: date,
          dateMonthIncome: totalIncome,
          dateMonthExpense: totalExpense,
        ),
      );
      _onScrollToBottom(emit, lastIndex);
    }
  }

  void _onScrollToBottom(Emitter<TransactionState> emit, int lastIndex) {
    if (state.lists.length - 1 == lastIndex) {
      add(TransactionLoadMore());
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
  Future<List<JournalBean>> _loadData() {
    //特殊处理 全部类型的情况
    var limitProject =
        currentLimitProject?.isAllItemBean() == true
            ? null
            : currentLimitProject;
    var limitDate = currentLimitDate;
    return repository.getPageJournal(
      pageSize: pageSize,
      page: page,
      limitProject: limitProject,
      limitDate: limitDate,
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
