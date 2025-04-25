import 'package:bookkeeping/data/bean/account_book_bean.dart';

sealed class SettingsEvent {
  const SettingsEvent();
}

class SettingsOnShowAccountBookPickerDialog extends SettingsEvent {
  final AccountBookBean? current;
  final bool isDelete;

  const SettingsOnShowAccountBookPickerDialog(
    this.current, {
    required this.isDelete,
  });
}

class SettingsOnCloseAccountBookPickerDialog extends SettingsEvent {
  const SettingsOnCloseAccountBookPickerDialog();
}

class SettingsOnDeleteAccountBook extends SettingsEvent {
  final AccountBookBean accountBook;
  const SettingsOnDeleteAccountBook(this.accountBook);
}
