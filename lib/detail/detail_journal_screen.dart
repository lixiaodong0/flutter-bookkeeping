import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DetailJournalScreenRoute {
  static String route = "/detail_journal/:id";

  static GoRoute buildRoute() {
    return GoRoute(
      path: route,
      builder: (BuildContext context, GoRouterState state) {
        var id = state.pathParameters["id"];
        return _DetailJournalScreen();
      },
    );
  }

  static launch(BuildContext context) {
    context.push(route);
  }
}

class _DetailJournalScreen extends StatelessWidget {
  const _DetailJournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: Column(children: [_buildContent()]),
    );
  }

  Widget _buildContent() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("名称", style: TextStyle(fontSize: 14, color: Colors.black)),
              Icon(Icons.navigate_next_rounded),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("价格", style: TextStyle(fontSize: 24, color: Colors.black)),
            ],
          ),
          SizedBox(height: 20),
          _keyValueContent("记录时间", "2025年4月1日 20:15:17"),
          SizedBox(height: 10),
          _keyValueContent("来源", "手动"),
          SizedBox(height: 10),
          _keyValueContent("备注", ""),
          SizedBox(height: 40),
          Divider(height: 1),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {},
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
