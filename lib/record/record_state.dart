import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../data/bean/journal_type.dart';

enum RecordFinishStatus { init, success }

final class RecordState extends Equatable {
  final String inputAmount;
  final JournalType journalType;
  final Color confirmColor;
  final bool confirmEnabled;
  final RecordFinishStatus confirmStatus;

  const RecordState({
    this.inputAmount = "",
    this.journalType = JournalType.expense,
    this.confirmColor = Colors.green,
    this.confirmEnabled = false,
    this.confirmStatus = RecordFinishStatus.init,
  });

  RecordState copyWith({
    String? inputAmount,
    JournalType? journalType,
    Color? confirmColor,
    bool? confirmEnabled,
    RecordFinishStatus? confirmStatus,
  }) {
    return RecordState(
      inputAmount: inputAmount ?? this.inputAmount,
      journalType: journalType ?? this.journalType,
      confirmColor: confirmColor ?? this.confirmColor,
      confirmEnabled: confirmEnabled ?? this.confirmEnabled,
      confirmStatus: confirmStatus ?? this.confirmStatus,
    );
  }

  @override
  List<Object?> get props => [
    inputAmount,
    journalType,
    confirmColor,
    confirmEnabled,
    confirmStatus,
  ];
}
