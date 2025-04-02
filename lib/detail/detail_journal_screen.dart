import 'package:bookkeeping/data/bean/journal_bean.dart';
import 'package:bookkeeping/data/repository/journal_repository.dart';
import 'package:bookkeeping/detail/bloc/detail_journal_evnet.dart';
import 'package:bookkeeping/detail/bloc/detail_journal_state.dart';
import 'package:bookkeeping/util/date_util.dart';
import 'package:bookkeeping/util/format_util.dart';
import 'package:bookkeeping/widget/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'bloc/detail_journal_bloc.dart';

class DetailJournalScreenRoute {
  static String route = "/detail_journal";

  static GoRoute buildRoute() {
    return GoRoute(
      path: route,
      builder: (BuildContext context, GoRouterState state) {
        var id = state.uri.queryParameters["id"] ?? "0";
        return BlocProvider(
          create:
              (context) => DetailJournalBloc(
                repository: context.read<JournalRepository>(),
                id: int.parse(id),
              )..add(DetailJournalInitLoad()),
          child: _DetailJournalScreen(),
        );
      },
    );
  }

  static launch(BuildContext context, int id) {
    Map<String, String> params = {"id": id.toString()};
    context.push(Uri(path: route, queryParameters: params).toString());
  }
}

class _DetailJournalScreen extends StatelessWidget {
  const _DetailJournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<DetailJournalBloc, DetailJournalState>(
      listener: (context, state) {
        if (state.isDeleted) {
          context.pop();
        }
      },
      child: BlocBuilder<DetailJournalBloc, DetailJournalState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Color(0xFFF5F5F5),
            appBar: AppBar(
              surfaceTintColor: Colors.transparent,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () {
                  context.pop();
                },
              ),
            ),
            body: Column(
              children: [_buildContent(context, state.currentJournal)],
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, JournalBean? data) {
    if (data == null) {
      return Container();
    }
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      data.journalProjectName,
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                    // Icon(Icons.navigate_next_rounded),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${data.type.symbol} ${FormatUtil.formatAmount(data.amount)}",
                style: TextStyle(fontSize: 30, color: Colors.black),
              ),
            ],
          ),
          SizedBox(height: 20),
          _keyValueContent("记录时间", DateUtil.simpleFormat(data.date)),
          SizedBox(height: 10),
          _keyValueContent("来源", "手动记账"),
          SizedBox(height: 10),
          _keyValueContent("备注", data.description ?? ""),
          SizedBox(height: 40),
          Divider(height: 1),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    AlertConfirmDialog.showAlertDialog(
                      context,
                      confirm: "删除",
                      desc: "删除后无法恢复，是否删除？",
                      onCancel: () {},
                      onConfirm: () {
                        context.read<DetailJournalBloc>().add(
                          DetailJournalOnDelete(),
                        );
                      },
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.delete_rounded, color: Colors.red),
                      SizedBox(width: 8),
                      Text(
                        "删除",
                        style: TextStyle(fontSize: 12, color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.edit_calendar_rounded, color: Colors.grey),
                      SizedBox(width: 8),
                      Text(
                        "编辑",
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _keyValueContent(String key, String value) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(key, style: TextStyle(fontSize: 12, color: Colors.grey)),
        ),
        Expanded(
          flex: 4,
          child: Text(
            value,
            style: TextStyle(fontSize: 12, color: Colors.black),
          ),
        ),
      ],
    );
  }
}
