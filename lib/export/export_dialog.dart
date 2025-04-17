import 'package:bookkeeping/app_bloc.dart';
import 'package:bookkeeping/data/bean/export_filter_condition_bean.dart';
import 'package:bookkeeping/export/export_bloc.dart';
import 'package:bookkeeping/export/export_event.dart';
import 'package:bookkeeping/util/date_util.dart';
import 'package:bookkeeping/widget/project_picker_widget.dart';
import 'package:bookkeeping/widget/year_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/repository/account_book_repository.dart';
import '../data/repository/journal_month_repository.dart';
import '../data/repository/journal_project_repository.dart';
import '../data/repository/journal_repository.dart';
import '../widget/month_picker_widget.dart';
import 'export_state.dart';

class ExportDialog extends StatelessWidget {
  const ExportDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExportBloc, ExportState>(
      listener: (context, state) {
        if (state.journalTypeDialogState is JournalTypeDialogOpenState) {
          var openState =
              state.journalTypeDialogState as JournalTypeDialogOpenState;

          ProjectPickerWidget.showDatePicker(
            context,
            currentProject: openState.currentProject,
            allIncomeProject: openState.allIncomeProject,
            allExpenseProject: openState.allExpenseProject,
            onChanged: (newProject) {
              context.read<ExportBloc>().add(
                ExportOnJournalTypeChange(
                  JournalTypeCustom(data: newProject, name: newProject!.name),
                ),
              );
            },
            onClose: () {
              context.read<ExportBloc>().add(ExportOnCloseJournalTypeDialog());
            },
          );
        }

        if (state.monthPickerDialogState is MonthPickerDialogOpenState) {
          var open = state.monthPickerDialogState as MonthPickerDialogOpenState;
          MonthPickerWidget.showDatePicker(
            context,
            currentDate: open.currentDate,
            allDate: open.allDate,
            onChanged: (newDate) {
              DateTime start = DateTime(newDate.year, newDate.month, 1);
              DateTime end = start.copyWith(
                //如果day=0 会自动为上个月的最后一天
                day: DateTime(start.year, start.month + 1, 0).day,
                hour: 23,
                minute: 59,
                second: 59,
              );
              var journalDate = ExportFilterJournalDate(
                type: FilterJournalDate.customMonth,
                name: '选择月份',
              );
              context.read<ExportBloc>().add(
                ExportOnJournalDateChange(journalDate, start: start, end: end),
              );
            },
            onClose: () {
              context.read<ExportBloc>().add(ExportOnCloseMonthPickerDialog());
            },
          );
        }

        if (state.yearPickerDialogState is YearPickerDialogOpenState) {
          var open = state.yearPickerDialogState as YearPickerDialogOpenState;
          YearPickerWidget.showDatePicker(
            context,
            currentDate: open.currentDate,
            allDate: open.allDate,
            onChanged: (newDate) {
              DateTime start = DateTime(newDate.year);
              DateTime end = start.copyWith(
                month: 12,
                day: 31,
                hour: 23,
                minute: 59,
                second: 59,
              );
              var journalDate = ExportFilterJournalDate(
                type: FilterJournalDate.customYear,
                name: '选择年份',
              );
              context.read<ExportBloc>().add(
                ExportOnJournalDateChange(journalDate, start: start, end: end),
              );
            },
            onClose: () {
              context.read<ExportBloc>().add(ExportOnCloseYearPickerDialog());
            },
          );
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back_ios_rounded),
              padding: EdgeInsets.symmetric(horizontal: 4),
              onPressed: () {},
            ),
            Expanded(
              child: SingleChildScrollView(child: _buildFilterCondition()),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    context.read<ExportBloc>().add(ExportOnExport());
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green,
                    disabledBackgroundColor: Color(0xFFF5F5F5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    fixedSize: Size.fromWidth(200),
                  ),
                  child: Text(
                    "确认",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterCondition() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "选择账本",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          BlocBuilder<ExportBloc, ExportState>(
            builder: (context, state) {
              return _buildAccountBookCondition(context, state);
            },
          ),
          SizedBox(height: 20),
          Text(
            "选择日期",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          BlocBuilder<ExportBloc, ExportState>(
            builder: (context, state) {
              return _buildDateCondition(context, state);
            },
          ),
          SizedBox(height: 20),
          Text(
            "选择类型",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          BlocBuilder<ExportBloc, ExportState>(
            builder: (context, state) {
              return _buildTypeCondition(context, state);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAccountBookCondition(BuildContext context, ExportState state) {
    return Wrap(
      spacing: 8,
      children: [
        for (var item in state.filterAccountBook)
          _buildItemType(
            item.name,
            selected: item.id == state.selectedAccountBook?.id,
            onClick: () {
              context.read<ExportBloc>().add(ExportOnAccountBookChange(item));
            },
          ),
      ],
    );
  }

  Widget _buildDateCondition(BuildContext context, ExportState state) {
    List<Widget> children = [];
    for (var item in state.filterJournalDate) {
      var selected = item.type == state.selectedJournalDate?.type;
      var name = item.name;
      if (selected && item.isCustomDate()) {
        var selectedJournalDate = state.selectedJournalDate!;
        var startDate = selectedJournalDate.start;
        var endDate = selectedJournalDate.end;
        if (selectedJournalDate.type == FilterJournalDate.customMonth) {
          name = "${startDate!.year}年${startDate.month}月";
        } else if (selectedJournalDate.type == FilterJournalDate.customYear) {
          name = "${startDate!.year}年";
        } else if (selectedJournalDate.type == FilterJournalDate.customRange) {
          name =
              "自定义-${startDate!.year}年${startDate.month}月-${endDate!.year}年${endDate.month}月";
        }
      }
      var child = _buildItemType(
        name,
        selected: selected,
        onClick: () {
          if (item.isCustomDate()) {
            //自定义月份
            if (item.type == FilterJournalDate.customMonth) {
              context.read<ExportBloc>().add(ExportOnShowMonthPickerDialog());
            }

            //自定义年份
            if (item.type == FilterJournalDate.customYear) {
              context.read<ExportBloc>().add(ExportOnShowYearPickerDialog());
            }

            //自定义范围
            if (item.type == FilterJournalDate.customRange) {
              context.read<ExportBloc>().add(ExportOnShowMonthPickerDialog());
            }
          } else {
            DateTime now = DateTime.now();
            DateTime start = now;
            DateTime end = now;

            //当天
            if (item.type == FilterJournalDate.today) {
              start = now.copyWith(hour: 0, minute: 0, second: 0);
              end = start.copyWith(hour: 23, minute: 59, second: 59);
            }

            //本周
            if (item.type == FilterJournalDate.currentWeek) {
              var monday =
                  now.weekday != DateTime.monday
                      ? now.subtract(Duration(days: now.weekday - 1))
                      : now;
              start = monday.copyWith(hour: 0, minute: 0, second: 0);

              var sunday = monday.add(Duration(days: DateTime.sunday - 1));
              end = sunday.copyWith(hour: 23, minute: 59, second: 59);
            }

            //本月
            if (item.type == FilterJournalDate.currentMonth) {
              start = now.copyWith(
                year: now.year,
                month: now.month,
                day: 1,
                hour: 0,
                minute: 0,
                second: 0,
              );
              end = now.copyWith(
                year: now.year,
                month: now.month,
                //如果day=0 会自动为上个月的最后一天
                day: DateTime(now.year, now.month + 1, 0).day,
                hour: 23,
                minute: 59,
                second: 59,
              );
            }

            //本年
            if (item.type == FilterJournalDate.currentYear) {
              start = now.copyWith(
                year: now.year,
                month: 1,
                day: 1,
                hour: 0,
                minute: 0,
                second: 0,
              );
              end = now.copyWith(
                year: now.year,
                month: 12,
                day: 31,
                hour: 23,
                minute: 59,
                second: 59,
              );
            }

            context.read<ExportBloc>().add(
              ExportOnJournalDateChange(item, start: start, end: end),
            );
          }
        },
      );
      children.add(child);
    }
    return Wrap(spacing: 8, children: children);
  }

  Widget _buildTypeCondition(BuildContext context, ExportState state) {
    List<Widget> children = [];
    for (var item in state.filterJournalType) {
      var selected = item.type == state.selectedJournalType?.type;
      var name = item.name;
      if (selected && state.selectedJournalType is JournalTypeCustom) {
        var custom = state.selectedJournalType as JournalTypeCustom;
        if (custom.data != null) {
          name = "${item.name}-${custom.data!.name}";
        }
      }
      var child = _buildItemType(
        name,
        selected: selected,
        onClick: () {
          if (item is JournalTypeCustom) {
            context.read<ExportBloc>().add(ExportOnShowJournalTypeDialog());
          } else {
            context.read<ExportBloc>().add(ExportOnJournalTypeChange(item));
          }
        },
      );
      children.add(child);
    }
    return Wrap(spacing: 8, children: children);
  }

  Widget _buildItemType(
    String title, {
    bool selected = false,
    VoidCallback? onClick,
  }) {
    var backgroundColor = selected ? Colors.green : Color(0xFFF5F5F5);
    var textColor = selected ? Colors.white : Colors.grey;
    return TextButton(
      onPressed: onClick,
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      child: Text(title, style: TextStyle(color: textColor, fontSize: 14)),
    );
  }

  static showDialog(BuildContext context, VoidCallback onClose) {
    var rootContext = Navigator.of(context, rootNavigator: true).context;
    showModalBottomSheet(
      context: rootContext,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      scrollControlDisabledMaxHeightRatio: 0.8,
      builder: (BuildContext context) {
        return BlocProvider(
          create:
              (context) => ExportBloc(
                currentAccountBook:
                    context.read<AppBloc>().state.currentAccountBook!,
                repository: context.read<JournalRepository>(),
                projectRepository: context.read<JournalProjectRepository>(),
                monthRepository: context.read<JournalMonthRepository>(),
                accountBookRepository: context.read<AccountBookRepository>(),
              )..add(ExportOnInit()),
          child: ExportDialog(),
        );
      },
    ).then((value) {
      onClose();
    });
  }
}
