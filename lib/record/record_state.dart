import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../data/bean/journal_type.dart';

final class RecordState extends Equatable {
  final String inputAmount;
  final JournalType journalType;
  final Color confirmColor;
  final bool confirmEnabled;

  const RecordState({
    this.inputAmount = "",
    this.journalType = JournalType.expense,
    this.confirmColor = Colors.green,
    this.confirmEnabled = false,
  });

  RecordState copyWith({
    String? inputAmount,
    JournalType? journalType,
    Color? confirmColor,
    bool? confirmEnabled,
  }) {
    return RecordState(
      inputAmount: inputAmount ?? this.inputAmount,
      journalType: journalType ?? this.journalType,
      confirmColor: confirmColor ?? this.confirmColor,
      confirmEnabled: confirmEnabled ?? this.confirmEnabled,
    );
  }

  @override
  List<Object?> get props => [
    inputAmount,
    journalType,
    confirmColor,
    confirmEnabled,
  ];
}
