import 'package:bookkeeping/data/bean/export_params.dart';
import 'package:bookkeeping/data/bean/journal_type.dart';
import 'package:bookkeeping/data/repository/account_book_repository.dart';
import 'package:bookkeeping/export/export_event.dart';
import 'package:bookkeeping/util/date_util.dart';
import 'package:bookkeeping/util/excel_util.dart';
import 'package:bookkeeping/widget/datewheel/date_wheel_scroll_view.dart';
import 'package:bookkeeping/widget/toast_action_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/bean/account_book_bean.dart';
import '../data/bean/export_filter_condition_bean.dart';
import '../data/bean/journal_month_bean.dart';
import '../data/bean/journal_project_bean.dart';
import '../data/repository/journal_month_repository.dart';
import '../data/repository/journal_project_repository.dart';
import '../data/repository/journal_repository.dart';
import 'export_state.dart';

class ExportBloc extends Bloc<ExportEvent, ExportState> {
  final JournalRepository repository;
  final JournalProjectRepository projectRepository;
  final JournalMonthRepository monthRepository;
  final AccountBookRepository accountBookRepository;
  AccountBookBean currentAccountBook;

  ExportBloc({
    required this.accountBookRepository,
    required this.currentAccountBook,
    required this.repository,
    required this.projectRepository,
    required this.monthRepository,
  }) : super(const ExportState()) {
    on<ExportOnInit>(onInit);
    on<ExportOnExportJournal>(onExportJournal);

    on<ExportOnAccountBookChange>(onAccountBookChange);
    on<ExportOnJournalDateChange>(onJournalDateChange);
    on<ExportOnJournalTypeChange>(onJournalTypeChange);
    on<ExportOnShowJournalTypeDialog>(onShowJournalTypeDialog);
    on<ExportOnCloseJournalTypeDialog>(onCloseJournalTypeDialog);

    on<ExportOnShowMonthPickerDialog>(_onShowMonthPicker);
    on<ExportOnCloseMonthPickerDialog>(_onCloseMonthPicker);

    on<ExportOnShowYearPickerDialog>(_onShowYearPicker);
    on<ExportOnCloseYearPickerDialog>(_onCloseYearPicker);

    on<ExportOnShowDateRangeDialog>(_onShowDateRangePicker);
    on<ExportOnCloseDateRangeDialog>(_onCloseDateRangePicker);
  }

  Future<void> onAccountBookChange(
    ExportOnAccountBookChange event,
    Emitter<ExportState> emit,
  ) async {
    emit(state.copyWith(selectedAccountBook: event.accountBook));
  }

  Future<void> onJournalDateChange(
    ExportOnJournalDateChange event,
    Emitter<ExportState> emit,
  ) async {
    var selectedJournalDate = event.journalDate;
    selectedJournalDate.start = event.start;
    selectedJournalDate.end = event.end;
    print(
      "[onJournalDateChange]start:${DateUtil.simpleFormat(selectedJournalDate.start!)},end:${DateUtil.simpleFormat(selectedJournalDate.end!)}",
    );
    emit(
      state.copyWith(
        selectedJournalDate: selectedJournalDate,
        monthPickerDialogState: MonthPickerDialogCloseState(),
        yearPickerDialogState: YearPickerDialogCloseState(),
        dateRangePickerDialogState: DateRangePickerDialogCloseState(),
      ),
    );
  }

  void _onShowDateRangePicker(
    ExportOnShowDateRangeDialog event,
    Emitter<ExportState> emit,
  ) async {
    List<JournalMonthGroupBean> group = await _createPickerData();

    List<YearWheel> years = [];
    for (var item in group) {
      List<MonthWheel> months = [];
      months =
          item.list.map((month) {
            List<DayWheel> days = [];
            int daysCount = DateTime(month.year, month.month + 1, 0).day;
            for (int i = 1; i <= daysCount; i++) {
              days.add(DayWheel(year: month.year, month: month.year, day: i));
            }
            return MonthWheel(year: month.year, month: month.month, days: days);
          }).toList();
      var yearWheel = YearWheel(year: item.year, months: months);
      years.add(yearWheel);
    }

    DateTime? startDate;
    DateTime? endDate;
    if (state.selectedJournalDate?.type == FilterJournalDate.customRange) {
      startDate = state.selectedJournalDate!.start;
      endDate = state.selectedJournalDate!.end;
    }
    emit(
      state.copyWith(
        dateRangePickerDialogState: DateRangePickerDialogOpenState(
          startDate: startDate,
          endDate: endDate,
          years: years,
        ),
      ),
    );
  }

  void _onCloseDateRangePicker(
    ExportOnCloseDateRangeDialog event,
    Emitter<ExportState> emit,
  ) async {
    emit(
      state.copyWith(
        dateRangePickerDialogState: DateRangePickerDialogCloseState(),
      ),
    );
  }

  void _onShowMonthPicker(
    ExportOnShowMonthPickerDialog event,
    Emitter<ExportState> emit,
  ) async {
    List<JournalMonthGroupBean> group = await _createPickerData();
    DateTime? currentDate;
    if (state.selectedJournalDate?.type == FilterJournalDate.customMonth) {
      currentDate = state.selectedJournalDate!.start;
    }
    emit(
      state.copyWith(
        monthPickerDialogState: MonthPickerDialogOpenState(
          currentDate: currentDate,
          allDate: group,
        ),
      ),
    );
  }

  void _onCloseMonthPicker(
    ExportOnCloseMonthPickerDialog event,
    Emitter<ExportState> emit,
  ) async {
    emit(state.copyWith(monthPickerDialogState: MonthPickerDialogCloseState()));
  }

  void _onCloseYearPicker(
    ExportOnCloseYearPickerDialog event,
    Emitter<ExportState> emit,
  ) async {
    emit(state.copyWith(yearPickerDialogState: YearPickerDialogCloseState()));
  }

  void _onShowYearPicker(
    ExportOnShowYearPickerDialog event,
    Emitter<ExportState> emit,
  ) async {
    List<JournalMonthGroupBean> group = await _createPickerData();
    DateTime? currentDate;
    if (state.selectedJournalDate?.type == FilterJournalDate.customYear) {
      currentDate = state.selectedJournalDate!.start;
    }
    emit(
      state.copyWith(
        yearPickerDialogState: YearPickerDialogOpenState(
          currentDate: currentDate,
          allDate: group,
        ),
      ),
    );
  }

  Future<List<JournalMonthGroupBean>> _createPickerData() async {
    var accountBookId = state.selectedAccountBook!.id;
    var result = await monthRepository.getAllJournalMonth(accountBookId);

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
    return group;
  }

  Future<void> onCloseJournalTypeDialog(
    ExportOnCloseJournalTypeDialog event,
    Emitter<ExportState> emit,
  ) async {
    emit(state.copyWith(journalTypeDialogState: JournalTypeDialogCloseState()));
  }

  Future<void> onShowJournalTypeDialog(
    ExportOnShowJournalTypeDialog event,
    Emitter<ExportState> emit,
  ) async {
    var allIncomeProject =
        await projectRepository.getAllIncomeJournalProjects();
    var allExpenseProject =
        await projectRepository.getAllExpenseJournalProjects();

    JournalProjectBean? currentProject;
    if (state.selectedJournalType?.type == FilterJournalType.custom) {
      var custom = state.selectedJournalType as JournalTypeCustom;
      currentProject = custom.data;
    }
    emit(
      state.copyWith(
        journalTypeDialogState: JournalTypeDialogOpenState(
          currentProject: currentProject,
          allIncomeProject: allIncomeProject,
          allExpenseProject: allExpenseProject,
        ),
      ),
    );
  }

  Future<void> onJournalTypeChange(
    ExportOnJournalTypeChange event,
    Emitter<ExportState> emit,
  ) async {
    emit(
      state.copyWith(
        selectedJournalType: event.journalType,
        journalTypeDialogState: JournalTypeDialogCloseState(),
      ),
    );
  }

  Future<void> onInit(ExportOnInit event, Emitter<ExportState> emit) async {
    var list = await accountBookRepository.findAll();

    List<ExportFilterAccountBook> filterAccountBook = [];
    ExportFilterAccountBook? selectedAccountBook;
    for (var element in list) {
      var item = ExportFilterAccountBook(id: element.id, name: element.name);
      if (currentAccountBook.id == element.id) {
        selectedAccountBook = item;
      }
      filterAccountBook.add(item);
    }

    List<ExportFilterJournalDate> filterJournalDate = [];

    DateTime now = DateTime.now();
    ExportFilterJournalDate selectedJournalDate = ExportFilterJournalDate(
      type: FilterJournalDate.today,
      name: '今天',
      start: now.copyWith(hour: 0, minute: 0, second: 0),
      end: now.copyWith(hour: 23, minute: 59, second: 59),
    );
    filterJournalDate.add(selectedJournalDate);
    filterJournalDate.add(
      ExportFilterJournalDate(type: FilterJournalDate.currentWeek, name: '本周'),
    );
    filterJournalDate.add(
      ExportFilterJournalDate(type: FilterJournalDate.currentMonth, name: '本月'),
    );
    filterJournalDate.add(
      ExportFilterJournalDate(type: FilterJournalDate.currentYear, name: '本年'),
    );
    filterJournalDate.add(
      ExportFilterJournalDate(
        type: FilterJournalDate.customMonth,
        name: '选择月份',
      ),
    );
    filterJournalDate.add(
      ExportFilterJournalDate(type: FilterJournalDate.customYear, name: '选择年份'),
    );
    filterJournalDate.add(
      ExportFilterJournalDate(type: FilterJournalDate.customRange, name: '自定义'),
    );

    List<ExportFilterJournalType> filterJournalType = [];
    ExportFilterJournalType selectedJournalType = JournalTypeAll(name: "全部");
    filterJournalType.add(selectedJournalType);
    filterJournalType.add(JournalTypeExpense(name: "支出"));
    filterJournalType.add(JournalTypeIncome(name: "入账"));
    filterJournalType.add(JournalTypeCustom(name: "自定义"));

    emit(
      state.copyWith(
        filterAccountBook: filterAccountBook,
        selectedAccountBook: selectedAccountBook,
        filterJournalDate: filterJournalDate,
        selectedJournalDate: selectedJournalDate,
        filterJournalType: filterJournalType,
        selectedJournalType: selectedJournalType,
      ),
    );
  }

  ExportParams _buildExportParams() {
    var accountBookId = state.selectedAccountBook!.id;
    var accountBookName = state.selectedAccountBook!.name;
    var startDate = state.selectedJournalDate!.start!;
    var endDate = state.selectedJournalDate!.end!;

    JournalType? journalType;
    int? projectId;

    if (state.selectedJournalType is JournalTypeIncome) {
      journalType = JournalType.income;
    }
    if (state.selectedJournalType is JournalTypeExpense) {
      journalType = JournalType.expense;
    }

    if (state.selectedJournalType is JournalTypeCustom) {
      var data = (state.selectedJournalType as JournalTypeCustom).data;
      projectId = data?.id;
    }

    return ExportParams(
      accountBookId: accountBookId,
      exportCreateExcelName: _createExcelName(),
      startDate: startDate,
      endDate: endDate,

      journalType: journalType,
      projectId: projectId,
    );
  }

  String _createExcelName() {
    var accountBookName = state.selectedAccountBook!.name;
    var startDate = state.selectedJournalDate!.start!;
    var endDate = state.selectedJournalDate!.end!;

    List<String> list = [];
    list.add(accountBookName);

    if (DateUtil.isSameDateDay(startDate, endDate)) {
      list.add(DateUtil.formatYearMonthDay(startDate));
    } else {
      list.add(
        "${DateUtil.formatYearMonthDay(startDate)}-${DateUtil.formatYearMonthDay(endDate)}",
      );
    }

    if (state.selectedJournalType is JournalTypeAll) {
      list.add("全部收支");
    }
    if (state.selectedJournalType is JournalTypeIncome) {
      list.add("入账");
    }
    if (state.selectedJournalType is JournalTypeExpense) {
      list.add("支出");
    }
    if (state.selectedJournalType is JournalTypeCustom) {
      var data = (state.selectedJournalType as JournalTypeCustom).data;
      list.add(data?.journalType == JournalType.income ? "入账" : "支出");
      list.add(data?.name ?? "");
    }
    return list.join("_");
  }

  Future<void> onExportJournal(
    ExportOnExportJournal event,
    Emitter<ExportState> emit,
  ) async {
    var exportParams = _buildExportParams();
    var result = await repository.exportJournal(exportParams);

    print("result:${result.length}");
    print("exportParams:$exportParams");
    if (result.isEmpty) {
      showErrorActionToast("暂无数据");
      return;
    }
    //统计价格
    num totalIncome = 0;
    num totalExpense = 0;
    num total = 0;
    for (var item in result) {
      var amount =
      item.type == JournalType.expense
          ? num.parse("-${item.amount}")
          : num.parse(item.amount);
      if (item.type == JournalType.income) {
        totalIncome += amount;
      } else {
        totalExpense += amount;
      }
      total += amount;
    }
    ExcelUtil.exportJournalDataToExcel(
      exportParams,
      result,
      totalExpense,
      totalIncome,
      total,
    );
  }
}
