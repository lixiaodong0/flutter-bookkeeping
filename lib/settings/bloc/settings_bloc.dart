import 'package:bookkeeping/settings/bloc/settings_evnet.dart';
import 'package:bookkeeping/settings/bloc/settings_state.dart';
import 'package:bookkeeping/widget/toast_action_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repository/account_book_repository.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final AccountBookRepository accountBookRepository;

  SettingsBloc({required this.accountBookRepository}) : super(SettingsState()) {
    on<SettingsOnShowAccountBookPickerDialog>(_showAccountBookPickerDialog);
    on<SettingsOnCloseAccountBookPickerDialog>(_closeAccountBookPickerDialog);
    on<SettingsOnDeleteAccountBook>(_deleteAccountBook);
  }

  void _deleteAccountBook(
    SettingsOnDeleteAccountBook event,
    Emitter<SettingsState> emit,
  ) async {
    var result = await accountBookRepository.delete(event.accountBook.id);
    showSuccessActionToast("删除成功");
  }

  void _showAccountBookPickerDialog(
    SettingsOnShowAccountBookPickerDialog event,
    Emitter<SettingsState> emit,
  ) async {
    var list = await accountBookRepository.findAll();
    emit(
      state.copyWith(
        accountBookPickerDialogState: AccountBookPickerDialogOpenState(
          isDelete: event.isDelete,
          current: event.current,
          list: list,
        ),
      ),
    );
  }

  void _closeAccountBookPickerDialog(
    SettingsOnCloseAccountBookPickerDialog event,
    Emitter<SettingsState> emit,
  ) async {
    emit(
      state.copyWith(
        accountBookPickerDialogState: AccountBookPickerDialogCloseState(),
      ),
    );
  }
}
