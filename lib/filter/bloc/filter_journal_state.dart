import 'package:bookkeeping/data/bean/filter_type.dart';
import 'package:bookkeeping/data/bean/journal_bean.dart';
import 'package:bookkeeping/data/bean/project_ranking_bean.dart';
import 'package:equatable/equatable.dart';

import '../../data/bean/journal_type.dart';

final class FilterJournalState extends Equatable {
  final DateTime? currentDate;
  final JournalType currentType;
  final FilterType currentFilterType;
  final ProjectRankingBean? projectBean;
  final List<JournalBean> list;
  final String monthAmount;

  const FilterJournalState({
    this.currentDate,
    this.currentType = JournalType.expense,
    this.currentFilterType = FilterType.amount,
    this.projectBean,
    this.list = const [],
    this.monthAmount = "0",
  });

  @override
  List<Object?> get props => [
    currentDate,
    currentDate,
    currentFilterType,
    list,
    monthAmount,
    projectBean,
  ];

  FilterJournalState copyWith({
    DateTime? currentDate,
    JournalType? currentType,
    FilterType? currentFilterType,
    List<JournalBean>? list,
    String? monthAmount,
    ProjectRankingBean? projectBean,
  }) {
    return FilterJournalState(
      currentDate: currentDate ?? this.currentDate,
      currentType: currentType ?? this.currentType,
      currentFilterType: currentFilterType ?? this.currentFilterType,
      list: list ?? this.list,
      monthAmount: monthAmount ?? this.monthAmount,
      projectBean: projectBean ?? this.projectBean,
    );
  }
}
