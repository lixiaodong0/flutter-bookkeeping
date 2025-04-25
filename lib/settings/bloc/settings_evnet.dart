import 'package:bookkeeping/data/bean/account_book_bean.dart';

sealed class SettingsEvent {
  const SettingsEvent();
}

class SettingsOnShowAccountBookPickerDialog extends SettingsEvent {
  final AccountBookBean? current;

  const SettingsOnShowAccountBookPickerDialog(this.current);
}

class SettingsOnCloseAccountBookPickerDialog extends SettingsEvent {
  const SettingsOnCloseAccountBookPickerDialog();
}
