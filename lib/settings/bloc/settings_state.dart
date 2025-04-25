import 'package:bookkeeping/data/bean/account_book_bean.dart';
import 'package:equatable/equatable.dart';

final class SettingsState extends Equatable {
  final AccountBookPickerDialogState accountBookPickerDialogState;

  const SettingsState({
    this.accountBookPickerDialogState =
        const AccountBookPickerDialogCloseState(),
  });

  @override
  List<Object?> get props => [accountBookPickerDialogState];

  SettingsState copyWith({
    AccountBookPickerDialogState? accountBookPickerDialogState,
  }) {
    return SettingsState(
      accountBookPickerDialogState:
          accountBookPickerDialogState ?? this.accountBookPickerDialogState,
    );
  }
}

final class AccountBookPickerDialogState {
  const AccountBookPickerDialogState();
}

final class AccountBookPickerDialogOpenState
    extends AccountBookPickerDialogState {
  final AccountBookBean? current;
  final List<AccountBookBean> list;

  const AccountBookPickerDialogOpenState({
    required this.current,
    required this.list,
  });
}

final class AccountBookPickerDialogCloseState
    extends AccountBookPickerDialogState {
  const AccountBookPickerDialogCloseState();
}
