import 'package:bookkeeping/app_bloc.dart';
import 'package:bookkeeping/data/bean/account_book_bean.dart';
import 'package:bookkeeping/data/bean/journal_type.dart';
import 'package:bookkeeping/data/repository/journal_project_repository.dart';
import 'package:bookkeeping/record/record_bloc.dart';
import 'package:bookkeeping/record/record_event.dart';
import 'package:bookkeeping/record/record_state.dart';
import 'package:bookkeeping/widget/remark_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../data/bean/income_images.dart';
import '../data/bean/journal_bean.dart';
import '../data/repository/journal_month_repository.dart';
import '../data/repository/journal_repository.dart';
import '../widget/calendar_picker_widget.dart';
import '../widget/keyboard_widget.dart';

typedef OnRecordSuccessFunction = void Function();

class RecordDialog extends StatelessWidget {
  final OnRecordSuccessFunction? onRecordSuccess;

  const RecordDialog({super.key, required this.onRecordSuccess});

  static showRecordDialog(
    BuildContext context, {
    JournalBean? edit,
    OnRecordSuccessFunction? onSuccess,
  }) {
    var currentAccountBook = context.read<AppBloc>().state.currentAccountBook;
    var rootContext = Navigator.of(context, rootNavigator: true).context;
    showModalBottomSheet(
      context: rootContext,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      scrollControlDisabledMaxHeightRatio: 0.72,
      builder: (BuildContext context) {
        return BlocProvider(
          create:
              (context) => RecordBloc(
                currentAccountBook: currentAccountBook!,
                repository: context.read<JournalRepository>(),
                projectRepository: context.read<JournalProjectRepository>(),
                monthRepository: context.read<JournalMonthRepository>(),
                edit: edit,
              )..add(RecordOnInitial()),

          child: RecordDialog(onRecordSuccess: onSuccess),
        );
      },
    );
  }

  //关闭弹窗
  void _closeDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  //完成
  void _onFinish(BuildContext context) {
    _closeDialog(context);
    onRecordSuccess?.call();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RecordBloc, RecordState>(
      listener: (context, state) {
        if (state.confirmStatus == RecordFinishStatus.success) {
          _onFinish(context);
        }
      },
      child: Container(
        padding: EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {
                _closeDialog(context);
              },
              icon: const Icon(Icons.close),
            ),
            BlocBuilder<RecordBloc, RecordState>(
              builder: (context, state) {
                return _journalTypeContainer(context, state);
              },
            ),
            BlocBuilder<RecordBloc, RecordState>(
              builder: (context, state) {
                return _inputContainer(state.inputAmount);
              },
            ),
            Padding(padding: EdgeInsets.only(top: 8)),
            Expanded(child: _projectListContainer()),
            BlocBuilder<RecordBloc, RecordState>(
              builder: (context, state) {
                var remark = state.remark ?? "";
                var maxWidth = MediaQuery.of(context).size.width - 100;
                return Row(
                  children: [
                    if (remark.isNotEmpty)
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: maxWidth),
                        child: Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Text(
                            remark,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ),
                      ),
                    TextButton(
                      onPressed: () {
                        RemarkDialog.showDialog(context, remark, (remark) {
                          context.read<RecordBloc>().add(
                            RecordOnChangeRemark(remark: remark),
                          );
                        });
                      },
                      child: Text(
                        remark.isNotEmpty ? "修改" : "添加备注",
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF63728c),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            BlocBuilder<RecordBloc, RecordState>(
              builder: (context, state) {
                return KeyboardWidget(
                  onClickKeyCode:
                      (keyCode) => {
                        if (keyCode == KeyCode.confirm)
                          {
                            context.read<RecordBloc>().add(
                              RecordOnClickConfirm(),
                            ),
                          }
                        else
                          {
                            context.read<RecordBloc>().add(
                              RecordOnClickKeyCode(keyCode: keyCode),
                            ),
                          },
                      },
                  confirmColor: state.confirmColor,
                  confirmEnabled: state.confirmEnabled,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _journalTypeContainer(BuildContext context, RecordState state) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _journalTypeButton(
            "支出",
            state.journalType == JournalType.expense,
            state.journalType == JournalType.expense
                ? Colors.green
                : Colors.grey,
            () {
              context.read<RecordBloc>().add(
                RecordOnClickJournalType(type: JournalType.expense),
              );
            },
          ),
          Padding(padding: EdgeInsets.only(left: 10)),
          _journalTypeButton(
            "入账",
            state.journalType == JournalType.income,
            state.journalType == JournalType.income
                ? Colors.orange
                : Colors.grey,
            () {
              context.read<RecordBloc>().add(
                RecordOnClickJournalType(type: JournalType.income),
              );
            },
          ),
          Expanded(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: _currentDateButton(
                    context,
                    state.currentDate ?? DateTime.now(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _currentDateButton(BuildContext context, DateTime current) {
    return TextButton(
      onPressed: () {
        CalendarPickerWidget.showDatePicker(
          context,
          defaultDate: current,
          onChanged: (date) {
            context.read<RecordBloc>().add(
              RecordOnUpdateCurrentDate(date: date),
            );
          },
        );
      },
      style: TextButton.styleFrom(
        backgroundColor: Colors.grey[100],
        padding: EdgeInsets.only(left: 5),
        minimumSize: const Size(80, 26),
        fixedSize: const Size(80, 26),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "${current.month}月${current.day}日",
            style: TextStyle(color: Colors.black, fontSize: 12),
          ),
          Icon(Icons.arrow_drop_down, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _journalTypeButton(
    String title,
    bool selected,
    Color selectColor,
    VoidCallback onPressed,
  ) {
    Color textColor = Colors.grey;
    Color? backgroundColor = Colors.grey.withAlpha(50);
    if (selected) {
      textColor = selectColor;
      backgroundColor = selectColor.withAlpha(50);
    }
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: EdgeInsets.all(0),
        minimumSize: const Size(48, 26),
        fixedSize: const Size(48, 26),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      child: Text(title, style: TextStyle(color: textColor, fontSize: 12)),
    );
  }

  Widget _inputContainer(String inputAmount) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "¥",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(horizontal: 6)),
              Text(
                inputAmount,
                style: TextStyle(
                  fontSize: 34,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Padding(padding: EdgeInsets.only(top: 8)),
          Divider(height: 1, color: Colors.grey[400]),
        ],
      ),
    );
  }

  Widget _projectListContainer() {
    return BlocBuilder<RecordBloc, RecordState>(
      builder: (context, state) {
        return SizedBox(
          child: GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6, //每行几列
              childAspectRatio: 0.70, // 调整比例以适应所需高度
            ),
            itemCount: state.projects.length,
            itemBuilder: (context, index) {
              var item = state.projects[index];
              return _projectItem(
                item.name,
                item.id == state.currentProject?.id,
                state.journalType,
                () {
                  context.read<RecordBloc>().add(
                    RecordOnCheckedProject(checked: item),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _projectItem(
    String title,
    bool selected,
    JournalType type,
    VoidCallback onClickItem,
  ) {
    Color backgroundColor = Color(0xFFF5F5F5);
    Color iconColor = Colors.grey;
    if (selected) {
      if (type == JournalType.expense) {
        backgroundColor = Colors.green;
      } else {
        backgroundColor = Colors.orange;
      }
      iconColor = Colors.white;
    }
    String assetName =
        type == JournalType.expense
            ? ExpenseImages.fromName(title).img
            : IncomeImages.fromName(title).img;

    return TextButton(
      onPressed: onClickItem,
      style: TextButton.styleFrom(padding: EdgeInsets.zero),
      child: Column(
        children: [
          journalTypeImageWidget(
            assetName,
            containerColor: backgroundColor,
            iconColor: iconColor,
          ),
          SizedBox(height: 4),
          Text(title, style: TextStyle(color: Colors.black, fontSize: 10)),
        ],
      ),
    );
  }
}
