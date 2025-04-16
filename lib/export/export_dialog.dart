import 'package:bookkeeping/app_bloc.dart';
import 'package:bookkeeping/export/export_bloc.dart';
import 'package:bookkeeping/export/export_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/repository/account_book_repository.dart';
import '../data/repository/journal_month_repository.dart';
import '../data/repository/journal_project_repository.dart';
import '../data/repository/journal_repository.dart';
import 'export_state.dart';

class ExportDialog extends StatelessWidget {
  const ExportDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
    return Wrap(
      spacing: 8,
      children: [
        for (var item in state.filterJournalDate)
          _buildItemType(
            item.name,
            selected: item == state.selectedJournalDate,
            onClick: () {
              context.read<ExportBloc>().add(ExportOnJournalDateChange(item));
            },
          ),
      ],
    );
  }

  Widget _buildTypeCondition(BuildContext context, ExportState state) {
    return Wrap(
      spacing: 8,
      children: [
        for (var item in state.filterJournalType)
          _buildItemType(
            item.name,
            selected: item == state.selectedJournalType,
            onClick: () {
              context.read<ExportBloc>().add(ExportOnJournalTypeChange(item));
            },
          ),
      ],
    );
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
