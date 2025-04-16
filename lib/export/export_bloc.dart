import 'package:bookkeeping/data/bean/journal_type.dart';
import 'package:bookkeeping/data/repository/account_book_repository.dart';
import 'package:bookkeeping/export/export_event.dart';
import 'package:bookkeeping/util/excel_util.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/bean/account_book_bean.dart';
import '../data/bean/export_filter_condition_bean.dart';
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
    on<ExportOnExport>(onExport);
    on<ExportOnAccountBookChange>(onAccountBookChange);
    on<ExportOnJournalDateChange>(onJournalDateChange);
    on<ExportOnJournalTypeChange>(onJournalTypeChange);
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
    emit(state.copyWith(selectedJournalDate: event.journalDate));
  }

  Future<void> onJournalTypeChange(
    ExportOnJournalTypeChange event,
    Emitter<ExportState> emit,
  ) async {
    emit(state.copyWith(selectedJournalType: event.journalType));
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
    ExportFilterJournalDate selectedJournalDate = JournalDateToday(name: '今天');
    filterJournalDate.add(selectedJournalDate);
    filterJournalDate.add(JournalDateCurrentWeek(name: '本周'));
    filterJournalDate.add(JournalDateCurrentMonth(name: '本月'));
    filterJournalDate.add(JournalDateCurrentYear(name: '本年'));
    filterJournalDate.add(JournalDateCustom(name: '自定义'));

    List<ExportFilterJournalType> filterJournalType = [];
    ExportFilterJournalType selectedJournalType = JournalTypeAll(name: '全部');
    filterJournalType.add(selectedJournalType);
    filterJournalType.add(JournalTypeIncome(name: '支出'));
    filterJournalType.add(JournalTypeExpense(name: '入账'));
    filterJournalType.add(JournalTypeCustom(name: '自定义'));

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

  Future<void> onExport(ExportOnExport event, Emitter<ExportState> emit) async {
    var result = await repository.getMonthJournal(
      currentAccountBook.id,
      DateTime.now(),
      JournalType.expense,
    );
    print("result:${result.length}");
    ExcelUtil.saveToExcel(result);
  }
}
