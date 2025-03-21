import 'package:bookkeeping/data/bean/journal_type.dart';
import 'package:bookkeeping/data/repository/journal_project_repository.dart';
import 'package:bookkeeping/record/record_bloc.dart';
import 'package:bookkeeping/record/record_event.dart';
import 'package:bookkeeping/record/record_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/repository/journal_repository.dart';
import '../widget/keyboard_widget.dart';

typedef OnRecordSuccessFunction = void Function();

void showRecordDialog(
  BuildContext context, {
  OnRecordSuccessFunction? onSuccess,
}) {
  var rootContext = Navigator.of(context, rootNavigator: true).context;
  showModalBottomSheet(
    context: rootContext,
    scrollControlDisabledMaxHeightRatio: 0.7,
    builder: (BuildContext context) {
      return BlocProvider(
        create:
            (context) => RecordBloc(
              repository: context.read<JournalRepository>(),
              projectRepository: context.read<JournalProjectRepository>(),
            )..add(RecordOnInitial()),

        child: _RecordDialog(onRecordSuccess: onSuccess),
      );
    },
  );
}

class _RecordDialog extends StatelessWidget {
  final OnRecordSuccessFunction? onRecordSuccess;

  const _RecordDialog({required this.onRecordSuccess}) : super();

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
        color: Colors.white,
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
            Padding(padding: EdgeInsets.only(top: 8)),
            BlocBuilder<RecordBloc, RecordState>(
              builder: (context, state) {
                return _inputContainer(state.inputAmount);
              },
            ),
            Padding(padding: EdgeInsets.only(top: 8)),
            _projectListContainer(),
            TextButton(
              onPressed: () {},
              child: Text(
                "添加备注",
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
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
            () {
              context.read<RecordBloc>().add(
                RecordOnClickJournalType(type: JournalType.expense),
              );
            },
          ),
          Padding(padding: EdgeInsets.only(left: 8)),
          _journalTypeButton("入账", state.journalType == JournalType.income, () {
            context.read<RecordBloc>().add(
              RecordOnClickJournalType(type: JournalType.income),
            );
          }),
        ],
      ),
    );
  }

  Widget _journalTypeButton(
    String title,
    bool selected,
    VoidCallback onPressed,
  ) {
    Color textColor = Colors.grey;
    Color? backgroundColor = Colors.grey[100];
    if (selected) {
      textColor = Colors.white;
      backgroundColor = Colors.blue;
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
      decoration: BoxDecoration(),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Text("¥", style: TextStyle(fontSize: 30, color: Colors.black)),
              Padding(padding: EdgeInsets.symmetric(horizontal: 8)),
              Text(
                inputAmount,
                style: TextStyle(fontSize: 30, color: Colors.black),
              ),
            ],
          ),
          Divider(height: 1, color: Colors.grey[400]),
        ],
      ),
    );
  }

  Widget _projectListContainer() {
    return BlocBuilder<RecordBloc, RecordState>(
      builder: (context, state) {
        return SizedBox(
          height: 100,
          child: GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6, //每行几列
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1 / 0.55, // 调整比例以适应所需高度
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
    Color backgroundColor = Colors.grey;
    if (selected) {
      if (type == JournalType.expense) {
        backgroundColor = Colors.green;
      } else {
        backgroundColor = Colors.orange;
      }
    }
    return TextButton(
      onPressed: onClickItem,
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: EdgeInsets.zero,
      ),
      child: Text(title, style: TextStyle(color: Colors.white, fontSize: 10)),
    );
  }
}
