import 'dart:async';
import 'dart:ffi';

import 'package:bookkeeping/cache/scroll_date_amount_cache.dart';
import 'package:bookkeeping/data/bean/journal_month_bean.dart';
import 'package:bookkeeping/data/bean/journal_type.dart';
import 'package:bookkeeping/data/bean/loading_state.dart';
import 'package:bookkeeping/data/repository/journal_month_repository.dart';
import 'package:bookkeeping/data/repository/journal_project_repository.dart';
import 'package:bookkeeping/data/repository/journal_repository.dart';
import 'package:bookkeeping/eventbus/eventbus.dart';
import 'package:bookkeeping/transaction/bloc/transaction_event.dart';
import 'package:bookkeeping/transaction/bloc/transaction_state.dart';
import 'package:bookkeeping/util/date_util.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/bean/journal_bean.dart';
import '../../data/bean/journal_project_bean.dart';
import '../../eventbus/journal_event.dart';

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
    on<TransactionOnJournalEvent>(_onJournalEvent);
  }

  int _findIndexById(List<JournalBean> list, int id) {
    for (var index = 0; index < list.length; index++) {
      if (id == list[index].id) {
        return index;
      }
    }
    return -1;
  }

  void _onJournalEvent(
    TransactionOnJournalEvent event,
    Emitter<TransactionState> emit,
  ) async {
    var journalEvent = event.event;
    var journalBean = journalEvent.journalBean;
    if (journalEvent.action == JournalEventAction.add) {
      //新增逻辑不做处理，已经设置dialog监听触发刷新操作。
      return;
    }
    List<JournalBean> origin = [];
    origin.addAll(state.lists);
    if (journalEvent.action == JournalEventAction.delete) {
      //删除，动态更新
      var findIndex = _findIndexById(origin, journalBean.id);
      if (findIndex != -1) {
        var removeBean = origin.removeAt(findIndex);
        await _startUpdate(origin, removeBean, emit);
      }
      return;
    }

    if (journalEvent.action == JournalEventAction.update) {
      //更新
      var findIndex = _findIndexById(origin, journalBean.id);
      if (findIndex != -1) {
        var oldBean = origin[findIndex];
        var newBean = journalBean;
        newBean.dailyAmount = oldBean.dailyAmount;
        origin[findIndex] = newBean;
        await _startUpdate(origin, origin[findIndex], emit);
      }
      return;
    }
  }

  Future<void> _startUpdate(
    List<JournalBean> origin,
    JournalBean updateBean,
    Emitter<TransactionState> emit,
  ) async {
    //更新缓存-每月的金额
    var latestAmount = await _updateDateAmountCache(updateBean.date);
    //更新缓存-每天的金额
    await _updateDailyDateAmount(origin, updateBean.date);

    //判断删除的月份是否正在展示，如果正在展示顺便更新价格。
    if (DateUtil.isSameMonth(state.currentDate!, updateBean.date)) {
      emit(
        state.copyWith(
          lists: origin,
          dateMonthIncome: latestAmount.incomeAmount,
          dateMonthExpense: latestAmount.expenseAmount,
        ),
      );
    } else {
      emit(state.copyWith(lists: origin));
    }
  }

  int _getCurrentProjectId() => currentLimitProject?.id ?? -1;

  Future<void> _updateDailyDateAmount(
    List<JournalBean> list,
    DateTime date,
  ) async {
    var projectId = _getCurrentProjectId();
    var todayIncomeAmount = await repository.getTodayTotalAmount(
      date,
      JournalType.income,
      projectId: projectId,
    );
    var todayExpenseAmount = await repository.getTodayTotalAmount(
      date,
      JournalType.expense,
      projectId: projectId,
    );
    for (var item in list) {
      var old = item.dailyAmount;
      if (old != null &&
          DateUtil.isSameDay(
            date.year,
            date.month,
            date.day,
            DateUtil.parse(old.date),
          )) {
        var latest = old.copyWith(
          income: todayIncomeAmount,
          expense: todayExpenseAmount,
        );
        item.dailyAmount = latest;
      }
    }
  }

  Future<AmountWrapper> _updateDateAmountCache(DateTime date) async {
    var projectId = _getCurrentProjectId();
    var totalIncome = await repository.getMonthTotalAmount(
      date,
      JournalType.income,
      projectId: projectId,
    );
    var totalExpense = await repository.getMonthTotalAmount(
      date,
      JournalType.expense,
      projectId: projectId,
    );
    DateAmountCache().putCache(date, totalIncome, totalExpense);
    return DateAmountCache().getCache(date)!;
  }

  void _onSelectedProject(
    TransactionSelectedProject event,
    Emitter<TransactionState> emit,
  ) async {
    currentLimitProject = event.selectedProject;
    await _refresh(
      emit,
      state.copyWith(
        currentProject: currentLimitProject,
        projectPickerDialogState: ProjectPickerDialogCloseState(),
      ),
    );
  }

  void _onSelectedMonth(
    TransactionSelectedMonth event,
    Emitter<TransactionState> emit,
  ) async {
    currentLimitDate = event.selectedDate;
    await _refresh(
      emit,
      state.copyWith(
        currentDate: currentLimitDate,
        monthPickerDialogState: MonthPickerDialogCloseState(),
      ),
    );
  }

  void _clearAmountCache() {
    DateAmountCache().clearAllCache();
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
    //   "[_onScrollChange]firstIndex:${firstIndex},lastIndex:${lastIndex},length:${state.lists.length-1},findItem:${findItem},date:${date}",
    // );

    if (!DateUtil.isSameMonth(date, state.currentDate)) {
      var cache = DateAmountCache().getCache(date);
      String totalIncome = cache?.incomeAmount ?? "";
      String totalExpense = cache?.expenseAmount ?? "";
      emit(
        state.copyWith(
          currentDate: date,
          dateMonthIncome: totalIncome,
          dateMonthExpense: totalExpense,
        ),
      );
    }

    /* var projectId = currentLimitProject?.id ?? -1;
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
          projectId: projectId,
        );
        totalExpense = await repository.getMonthTotalAmount(
          date,
          JournalType.expense,
          projectId: projectId,
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
    }*/
    _onScrollToBottom(emit, lastIndex);
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
    await _refresh(emit, state);
  }

  Future<void> _refresh(
    Emitter<TransactionState> emit,
    TransactionState? extState,
  ) async {
    var _state = extState ?? state;
    _resetPageParams();
    var result = await _loadData();
    var first = result.firstOrNull;
    var currentDate = _state.currentDate;
    var dateMonthIncome = _state.dateMonthIncome;
    var dateMonthExpense = _state.dateMonthExpense;
    if (first != null && DateUtil.isSameMonth(first.date, currentDate)) {
      var cache = DateAmountCache().getCache(first.date);
      dateMonthIncome = cache?.incomeAmount ?? "";
      dateMonthExpense = cache?.expenseAmount ?? "";
    }
    emit(
      _state.copyWith(
        lists: result,
        dateMonthExpense: dateMonthExpense,
        dateMonthIncome: dateMonthIncome,
      ),
    );
  }

  void _onReload(
    TransactionReload event,
    Emitter<TransactionState> emit,
  ) async {
    print("_onReload");
    await _refresh(emit, state);
  }

  //加载数据
  Future<List<JournalBean>> _loadData() async {
    //特殊处理 全部类型的情况
    var limitProject =
        currentLimitProject?.isAllItemBean() == true
            ? null
            : currentLimitProject;
    var limitDate = currentLimitDate;
    var result = await repository.getPageJournal(
      pageSize: pageSize,
      page: page,
      limitProject: limitProject,
      limitDate: limitDate,
    );
    //缓存每月价格
    Map<String, DateTime> allMonth = {};
    for (var item in result) {
      var key = "${item.date.year}-${item.date.month}";
      allMonth[key] = item.date;
    }
    var projectId = _getCurrentProjectId();
    for (var date in allMonth.values) {
      var hasCache = DateAmountCache().hasCache(date);
      if (!hasCache) {
        var totalIncome = await repository.getMonthTotalAmount(
          date,
          JournalType.income,
          projectId: projectId,
        );
        var totalExpense = await repository.getMonthTotalAmount(
          date,
          JournalType.expense,
          projectId: projectId,
        );
        DateAmountCache().putCache(date, totalIncome, totalExpense);
      }
    }
    return result;
  }

  //重置分页参数
  void _resetPageParams() {
    _clearAmountCache();
    page = 1;
    loadMoreLoadingState = LoadingState.finish;
  }

  var loadMoreLoadingState = LoadingState.finish;

  void _onLoadMore(
    TransactionLoadMore event,
    Emitter<TransactionState> emit,
  ) async {
    if (loadMoreLoadingState == LoadingState.nodata) {
      print("_onLoadMore no data");
      return;
    }
    if (loadMoreLoadingState == LoadingState.loading) {
      print("_onLoadMore loading");
      return;
    }
    print("_onLoadMore");
    loadMoreLoadingState = LoadingState.loading;
    page++;
    var result = await _loadData();
    List<JournalBean> newLists = [];
    newLists.addAll(state.lists);
    newLists.addAll(result);
    emit(state.copyWith(lists: newLists));
    if (result.length >= pageSize) {
      loadMoreLoadingState = LoadingState.finish;
    } else {
      loadMoreLoadingState = LoadingState.nodata;
    }
  }
}
