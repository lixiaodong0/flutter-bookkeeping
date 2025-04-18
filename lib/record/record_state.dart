import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../data/bean/journal_project_bean.dart';
import '../data/bean/journal_type.dart';

enum RecordFinishStatus { init, success }

final class RecordState extends Equatable {
  final String inputAmount;
  final JournalType journalType;
  final List<JournalProjectBean> projects;
  final JournalProjectBean? currentProject;
  final Color confirmColor;
  final bool confirmEnabled;
  final RecordFinishStatus confirmStatus;
  final DateTime? currentDate;
  final String? remark;

  const RecordState({
    this.inputAmount = "",
    this.journalType = JournalType.expense,
    this.projects = const [],
    this.currentProject,
    this.confirmColor = Colors.green,
    this.confirmEnabled = false,
    this.confirmStatus = RecordFinishStatus.init,
    this.currentDate,
    this.remark,
  });

  RecordState copyWith({
    String? inputAmount,
    JournalType? journalType,
    List<JournalProjectBean>? projects,
    JournalProjectBean? currentProject,
    Color? confirmColor,
    bool? confirmEnabled,
    RecordFinishStatus? confirmStatus,
    DateTime? currentDate,
    String? remark,
  }) {
    return RecordState(
      inputAmount: inputAmount ?? this.inputAmount,
      journalType: journalType ?? this.journalType,
      projects: projects ?? this.projects,
      currentProject: currentProject ?? this.currentProject,
      confirmColor: confirmColor ?? this.confirmColor,
      confirmEnabled: confirmEnabled ?? this.confirmEnabled,
      confirmStatus: confirmStatus ?? this.confirmStatus,
      currentDate: currentDate ?? this.currentDate,
      remark: remark ?? this.remark,
    );
  }

  @override
  List<Object?> get props => [
    inputAmount,
    journalType,
    projects,
    currentProject,
    confirmColor,
    confirmEnabled,
    confirmStatus,
    currentDate,
    remark,
  ];
}
