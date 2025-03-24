import 'package:bookkeeping/cache/picker_date_cache.dart';
import 'package:bookkeeping/data/repository/datasource/journal_month_local_datasource.dart';
import 'package:bookkeeping/data/repository/datasource/journal_project_local_datasource.dart';
import 'package:bookkeeping/data/repository/journal_month_repository.dart';
import 'package:bookkeeping/data/repository/journal_project_repository.dart';
import 'package:bookkeeping/db/database.dart';
import 'package:bookkeeping/db/journal_month_dao.dart';
import 'package:bookkeeping/db/journal_project_dao.dart';
import 'package:bookkeeping/statistics/statistics_screen.dart';
import 'package:bookkeeping/transaction/transaction_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'data/repository/datasource/journal_local_datasource.dart';
import 'data/repository/journal_repository.dart';
import 'db/journal_dao.dart';

void main() async {
  await DatabaseHelper().init();
  runApp(const MyApp());
  PickerDateCache().create();
}

final GlobalKey toastGlobalContext = GlobalKey();

final GoRouter _router = GoRouter(
  initialLocation: "/transaction",
  routes: <RouteBase>[
    ShellRoute(
      routes: <RouteBase>[
        GoRoute(
          path: "/statistics",
          builder: (BuildContext context, GoRouterState state) {
            return const StatisticsScreen();
          },
        ),
        GoRoute(
          path: "/transaction",
          builder: (BuildContext context, GoRouterState state) {
            return TransactionScreen();
          },
        ),
      ],
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return _ScaffoldWithNavBar(child: child);
      },
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create:
              (context) => JournalRepository(
                localDataSource: JournalLocalDataSource(dao: JournalDao()),
              ),
        ),
        RepositoryProvider(
          create:
              (context) => JournalProjectRepository(
                localDataSource: JournalProjectLocalDataSource(
                  dao: JournalProjectDao(),
                ),
              ),
        ),
        RepositoryProvider(
          create:
              (context) => JournalMonthRepository(
                localDataSource: JournalMonthLocalDataSource(
                  dao: JournalMonthDao(),
                ),
              ),
        ),
      ],
      child: MaterialApp.router(routerConfig: _router),
    );
  }
}

class _ScaffoldWithNavBar extends StatelessWidget {
  const _ScaffoldWithNavBar({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: toastGlobalContext,
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.green,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.event_note), label: "明细"),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart_rounded),
            label: "统计",
          ),
        ],
        currentIndex: _calculateSelectedIndex(context),
        onTap: (int index) {
          switch (index) {
            case 0:
              context.go("/transaction");
              break;
            case 1:
              context.go("/statistics");
              break;
          }
        },
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/transaction')) {
      return 0;
    }
    if (location.startsWith('/statistics')) {
      return 1;
    }
    return 0;
  }
}
