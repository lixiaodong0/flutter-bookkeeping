import 'package:bookkeeping/data/bean/account_book_bean.dart';
import 'package:bookkeeping/db/journal_dao.dart';
import 'package:bookkeeping/export/export_dialog.dart';
import 'package:bookkeeping/settings/bloc/settings_bloc.dart';
import 'package:bookkeeping/settings/bloc/settings_state.dart';
import 'package:bookkeeping/widget/account_book_picker_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../app_bloc.dart';
import '../data/repository/account_book_repository.dart';
import '../util/excel_util.dart';
import '../widget/create_account_book_dialog.dart';
import 'bloc/settings_evnet.dart';

class SettingsRoute {
  static String route = "/settings";

  static GoRoute buildRoute() {
    return GoRoute(
      path: route,
      builder: (BuildContext context, GoRouterState state) {
        return BlocProvider(
          create:
              (context) => SettingsBloc(
                accountBookRepository: context.read<AccountBookRepository>(),
              ),
          child: _SettingsScreen(),
        );
      },
    );
  }

  static launch(BuildContext context) {
    context.go(route);
  }
}

class _SettingsScreen extends StatefulWidget {
  const _SettingsScreen();

  @override
  State createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<_SettingsScreen> {
  void _showCreateAccountBookDialog(AccountBookBean? current) {
    CreateAccountBookDialog.showDialog(
      context,
      context.read<AccountBookRepository>(),
      edit: current,
      onCreateSuccessCallback: (data) {
        context.read<AppBloc>().add(AppCreateNewAccountBook(data));
      },
      onUpdateSuccessCallback: (data) {
        context.read<AppBloc>().add(AppUpdateAccountBook(data));
      },
    );
  }

  AccountBookBean _getCurrentAccountBook() {
    return context.read<AppBloc>().state.currentAccountBook!;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsBloc, SettingsState>(
      listener: (context, state) {
        if (state.accountBookPickerDialogState
            is AccountBookPickerDialogOpenState) {
          var openState =
              state.accountBookPickerDialogState
                  as AccountBookPickerDialogOpenState;
          AccountBookPickerDialog.showDialog(
            context,
            list: openState.list,
            current: openState.current,
            onPickerSuccessCallback: (data) {
              _showCreateAccountBookDialog(data);
            },
            onClose: () {
              context.read<SettingsBloc>().add(
                SettingsOnCloseAccountBookPickerDialog(),
              );
            },
          );
        }
      },
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Color(0xFFEDEDED),
            appBar: AppBar(
              title: Text(
                "设置",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              backgroundColor: Colors.green,
              toolbarHeight: 100,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  _buildDataTableKit(),
                  _buildAccountBookMangerKit(),
                  /*SizedBox(height: 20),
            _buildListItem(Icons.contrast_rounded, "深色模式", desc: "跟随系统"),
            _buildListItem(
              Icons.translate,
              "多语言",
              desc: "跟随系统",
              isDivider: false,
            ),*/
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDataTableKit() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "数据报表",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              TextButton(
                onPressed: () {
                  ExportDialog.showDialog(context, () {});
                },
                child: Column(
                  children: [
                    Icon(Icons.downloading_rounded, color: Colors.black),
                    SizedBox(height: 4),
                    Text(
                      "导出数据",
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Column(
                  children: [
                    Icon(Icons.arrow_circle_up_rounded, color: Colors.black),
                    SizedBox(height: 4),
                    Text(
                      "导入数据",
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAccountBookMangerKit() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "账本管理",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              TextButton(
                onPressed: () {
                  _showCreateAccountBookDialog(null);
                },
                child: Column(
                  children: [
                    Icon(
                      Icons.add_circle_outline_outlined,
                      color: Colors.black,
                    ),
                    SizedBox(height: 4),
                    Text(
                      "新增账本",
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  context.read<SettingsBloc>().add(
                    SettingsOnShowAccountBookPickerDialog(
                      _getCurrentAccountBook(),
                    ),
                  );
                },
                child: Column(
                  children: [
                    Icon(Icons.update_rounded, color: Colors.black),
                    SizedBox(height: 4),
                    Text(
                      "编辑账本",
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Column(
                  children: [
                    Icon(Icons.delete_outline_rounded, color: Colors.black),
                    SizedBox(height: 4),
                    Text(
                      "删除账本",
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(
    IconData icon,
    String title, {
    String desc = "",
    bool isDivider = true,
  }) {
    return Container(
      padding: EdgeInsets.only(left: 8, right: 4),
      height: 48,
      color: Colors.white,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.black),
              SizedBox(width: 4),
              Text(title, style: TextStyle(fontSize: 14, color: Colors.black)),
              Spacer(),
              Text(desc, style: TextStyle(fontSize: 10, color: Colors.grey)),
              SizedBox(width: 4),
              Icon(Icons.navigate_next_rounded, color: Colors.grey),
            ],
          ),
          if (isDivider)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(left: 30),
                child: Divider(height: 1, color: Color(0xFFF5F5F5)),
              ),
            ),
        ],
      ),
    );
  }
}
