import 'package:bookkeeping/app_bloc.dart';
import 'package:bookkeeping/export/export_bloc.dart';
import 'package:bookkeeping/export/export_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/repository/journal_month_repository.dart';
import '../data/repository/journal_project_repository.dart';
import '../data/repository/journal_repository.dart';

class ExportDialog extends StatelessWidget {
  const ExportDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Spacer(),
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
              )..add(ExportOnInit()),
          child: ExportDialog(),
        );
      },
    ).then((value) {
      onClose();
    });
  }
}
