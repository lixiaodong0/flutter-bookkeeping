import 'package:bookkeeping/data/bean/journal_type.dart';
import 'package:bookkeeping/export/export_event.dart';
import 'package:bookkeeping/util/excel_util.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/bean/account_book_bean.dart';
import '../data/repository/journal_month_repository.dart';
import '../data/repository/journal_project_repository.dart';
import '../data/repository/journal_repository.dart';
import 'export_state.dart';

class ExportBloc extends Bloc<ExportEvent, ExportState> {
  final JournalRepository repository;
  final JournalProjectRepository projectRepository;
  final JournalMonthRepository monthRepository;
  AccountBookBean currentAccountBook;

  ExportBloc({
    required this.currentAccountBook,
    required this.repository,
    required this.projectRepository,
    required this.monthRepository,
  }) : super(const ExportState()) {
    on<ExportOnInit>(onInit);
    on<ExportOnExport>(onExport);
  }

  Future<void> onInit(ExportOnInit event, Emitter<ExportState> emit) async {}

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
