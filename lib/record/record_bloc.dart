import 'dart:ffi';

import 'package:bloc/bloc.dart';
import 'package:bookkeeping/data/repository/journal_month_repository.dart';
import 'package:bookkeeping/data/repository/journal_project_repository.dart';
import 'package:bookkeeping/db/model/journal_month_entry.dart';
import 'package:bookkeeping/eventbus/eventbus.dart';
import 'package:bookkeeping/eventbus/journal_event.dart';
import 'package:bookkeeping/record/record_event.dart';
import 'package:bookkeeping/record/record_state.dart';
import 'package:bookkeeping/util/toast_util.dart';
import 'package:flutter/material.dart';

import '../data/bean/journal_bean.dart';
import '../data/bean/journal_project_bean.dart';
import '../data/bean/journal_type.dart';
import '../data/repository/journal_repository.dart';
import '../db/model/journal_entry.dart';
import '../widget/keyboard_widget.dart';

class RecordBloc extends Bloc<RecordEvent, RecordState> {
  final JournalRepository repository;
  final JournalProjectRepository projectRepository;
  final JournalMonthRepository monthRepository;
  final JournalBean? edit;

  RecordBloc({
    required this.repository,
    required this.projectRepository,
    required this.monthRepository,
    this.edit,
  }) : super(RecordState(currentDate: DateTime.now())) {
    on<RecordOnInitial>(_onInitial);
    on<RecordOnCheckedProject>(_onCheckedProject);
    on<RecordOnClickJournalType>(_onClickJournalType);
    on<RecordOnClickKeyCode>(_onClickKeyCode);
    on<RecordOnClickConfirm>(_onClickConfirm);
    on<RecordOnUpdateCurrentDate>(_onOnUpdateCurrentDate);
    on<RecordOnChangeRemark>(_onChangeRemark);
  }

  void _onChangeRemark(
    RecordOnChangeRemark event,
    Emitter<RecordState> emit,
  ) async {
    emit(state.copyWith(remark: event.remark));
  }

  void _onInitial(RecordOnInitial event, Emitter<RecordState> emit) async {
    print("[_onInitial]");
    int? defaultProjectId;
    if (edit != null) {
      defaultProjectId = edit!.journalProjectId;
      Color confirmColor;
      if (edit!.type == JournalType.expense) {
        confirmColor = Colors.green;
      } else {
        confirmColor = Colors.orange;
      }
      emit(
        state.copyWith(
          inputAmount: edit!.amount,
          journalType: edit!.type,
          currentDate: edit!.date,
          remark: edit!.description,
          confirmEnabled: edit!.amount.isNotEmpty,
          confirmColor: confirmColor,
        ),
      );
    }
    await _onSwitchJournalType(
      state.journalType,
      emit,
      defaultProjectId: defaultProjectId,
    );
  }

  Future<void> _onSwitchJournalType(
    JournalType journalType,
    Emitter<RecordState> emit, {
    int? defaultProjectId,
  }) async {
    List<JournalProjectBean> list = [];
    if (journalType == JournalType.expense) {
      list = await projectRepository.getAllExpenseJournalProjects();
    } else {
      list = await projectRepository.getAllIncomeJournalProjects();
    }
    var currentProject = list.firstOrNull;
    if (defaultProjectId != null) {
      for (var value in list) {
        if (value.id == defaultProjectId) {
          currentProject = value;
          break;
        }
      }
    }
    print("[_onSwitchJournalType]list:$list");
    emit(state.copyWith(projects: list, currentProject: currentProject));
  }

  void _onOnUpdateCurrentDate(
    RecordOnUpdateCurrentDate event,
    Emitter<RecordState> emit,
  ) async {
    emit(state.copyWith(currentDate: event.date));
  }

  void _onCheckedProject(
    RecordOnCheckedProject event,
    Emitter<RecordState> emit,
  ) async {
    emit(state.copyWith(currentProject: event.checked));
  }

  void _onClickJournalType(
    RecordOnClickJournalType event,
    Emitter<RecordState> emit,
  ) async {
    var type = event.type;
    Color confirmColor;
    if (type == JournalType.expense) {
      confirmColor = Colors.green;
    } else {
      confirmColor = Colors.orange;
    }
    print("[_onClickJournalType]$type");
    emit(state.copyWith(journalType: type, confirmColor: confirmColor));
    await _onSwitchJournalType(type, emit);
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
    if (inputAmount.isEmpty) {
      return;
    }
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
    var currentProject = state.currentProject;
    if (currentProject == null) {
      showToast("请选择服务分类");
      return;
    }
    var now = state.currentDate ?? DateTime.now();
    var entry = JournalEntry(
      amount: amount.toString(),
      type: state.journalType.name,
      date: now,
      journalProjectId: currentProject.id,
      description: state.remark,
    );

    if (edit != null) {
      //编辑
      if (_isChanged(entry)) {
        print("账单数据更新 oldDate:${edit!.date},newDate:${entry.date}");
        entry.id = edit!.id;
        await repository.updateJournal(entry);
        var journalBean = await repository.getJournal(edit!.id);
        JournalEvent.publishUpdateEvent(journalBean!);
      }
    } else {
      var id = await repository.addJournal(entry);
      if (id > 0) {
        print("账单数据新增");
        //添加成功
        var journalBean = await repository.getJournal(id);
        JournalEvent.publishAddEvent(journalBean!);
      }
    }
    await monthRepository.addJournalMonth(
      JournalMonthEntry(year: now.year, month: now.month, maxDay: now.day),
    );
    emit(state.copyWith(confirmStatus: RecordFinishStatus.success));
  }

  bool _isChanged(JournalEntry entry) {
    var old = edit!;
    if (entry.description != old.description ||
        entry.amount != old.amount ||
        entry.journalProjectId != old.journalProjectId ||
        entry.type != old.type.name ||
        entry.date != old.date) {
      return true;
    }
    return false;
  }
}
