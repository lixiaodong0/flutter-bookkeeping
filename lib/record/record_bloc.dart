import 'package:bloc/bloc.dart';
import 'package:bookkeeping/record/record_event.dart';
import 'package:bookkeeping/record/record_state.dart';
import 'package:bookkeeping/util/toast_util.dart';
import 'package:flutter/material.dart';

import '../data/bean/journal_type.dart';
import '../data/repository/journal_repository.dart';
import '../model/journal_entry.dart';
import '../widget/keyboard_widget.dart';

class RecordBloc extends Bloc<RecordEvent, RecordState> {
  final JournalRepository repository;

  RecordBloc({required this.repository}) : super(RecordState()) {
    on<RecordOnClickJournalType>(_onClickJournalType);
    on<RecordOnClickKeyCode>(_onClickKeyCode);
    on<RecordOnClickConfirm>(_onClickConfirm);
  }

  void _onClickJournalType(
    RecordOnClickJournalType event,
    Emitter<RecordState> emit,
  ) {
    var type = event.type;
    Color confirmColor;
    if (type == JournalType.expense) {
      confirmColor = Colors.green;
    } else {
      confirmColor = Colors.orange;
    }
    print("[_onClickJournalType]$type");
    emit(state.copyWith(journalType: type, confirmColor: confirmColor));
  }

  void _onClickKeyCode(RecordOnClickKeyCode event, Emitter<RecordState> emit) {
    var keyCode = event.keyCode;
    print("[_onClickJournalType]$keyCode");
    var newAmount = state.inputAmount;
    switch (keyCode) {
      case KeyCode.one:
        newAmount += "1";
        break;
      case KeyCode.two:
        newAmount += "2";
        break;
      case KeyCode.three:
        newAmount += "3";
        break;
      case KeyCode.four:
        newAmount += "4";
        break;
      case KeyCode.five:
        newAmount += "5";
        break;
      case KeyCode.six:
        newAmount += "6";
        break;
      case KeyCode.seven:
        newAmount += "7";
        break;
      case KeyCode.eight:
        newAmount += "8";
        break;
      case KeyCode.nine:
        newAmount += "9";
        break;
      case KeyCode.zero:
        newAmount += "0";
        break;
      case KeyCode.dot:
        newAmount += ".";
        break;
      case KeyCode.backspace:
        if (newAmount.isEmpty) {
          return;
        }
        newAmount = newAmount.substring(0, newAmount.length - 1);
        break;
      case KeyCode.confirm:
    }
    newAmount = _validAmount(newAmount);
    emit(
      state.copyWith(
        inputAmount: newAmount,
        confirmEnabled: newAmount.isNotEmpty,
      ),
    );
  }

  String _validAmount(String amount) {
    //01 02开头
    if (amount.length == 2 && !amount.contains(".") && amount.startsWith("0")) {
      return amount.substring(1, 2);
    }

    //处理单独输入.
    if (amount.length == 1 && amount.contains(".")) {
      return "0.";
    }

    //保留.小数点后两位
    if (amount.contains(".")) {
      var index = amount.indexOf(".");
      if (amount.length - index > 2) {
        return amount.substring(0, index + 3);
      }
    }
    return amount;
  }

  void _onClickConfirm(
    RecordOnClickConfirm event,
    Emitter<RecordState> emit,
  ) async {
    print("[_onClickConfirm]");
    var inputAmount = state.inputAmount.trim();
    if (inputAmount == "0." || inputAmount == "0") {
      showToast("所输入金额不得小于0.01");
      return;
    }
    var amount = num.parse(inputAmount);
    print("amount:${amount}");
    if (amount < 0.01) {
      showToast("所输入金额不得小于0.01");
      return;
    }
    var entry = JournalEntry(
      amount: amount.toString(),
      type: state.journalType.name,
      date: DateTime.now(),
    );
    repository.addJournal(entry);
    emit(state.copyWith(confirmStatus: RecordFinishStatus.success));
  }
}
