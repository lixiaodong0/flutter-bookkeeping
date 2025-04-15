import 'package:bookkeeping/app_bloc.dart';
import 'package:bookkeeping/cache/picker_date_cache.dart';
import 'package:bookkeeping/data/repository/account_book_repository.dart';
import 'package:bookkeeping/data/repository/datasource/account_book_local_datasource.dart';
import 'package:bookkeeping/data/repository/datasource/journal_month_local_datasource.dart';
import 'package:bookkeeping/data/repository/datasource/journal_project_local_datasource.dart';
import 'package:bookkeeping/data/repository/journal_month_repository.dart';
import 'package:bookkeeping/data/repository/journal_project_repository.dart';
import 'package:bookkeeping/db/account_book_dao.dart';
import 'package:bookkeeping/db/database.dart';
import 'package:bookkeeping/db/journal_month_dao.dart';
import 'package:bookkeeping/db/journal_project_dao.dart';
import 'package:bookkeeping/detail/detail_journal_screen.dart';
import 'package:bookkeeping/filter/filter_journal_screen.dart';
import 'package:bookkeeping/settings/SettingsScreen.dart';
import 'package:bookkeeping/statistics/statistics_screen.dart';
import 'package:bookkeeping/transaction/transaction_screen.dart';
import 'package:bookkeeping/util/toast_util.dart';
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
        SettingsRoute.buildRoute(),
      ],
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return _ScaffoldWithNavBar(child: child);
      },
    ),
    GoRoute(
      path: "/filter_journal",
      builder: (BuildContext context, GoRouterState state) {
        var params = state.extra as FilterJournalScreenParams;
        return FilterJournalScreen(params: params);
      },
    ),
    DetailJournalScreenRoute.buildRoute(),
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
        RepositoryProvider(
          create:
              (context) => AccountBookRepository(
                localDataSource: AccountBookLocalDataSource(
                  dao: AccountBookDao(),
                ),
              ),
        ),
      ],
      child: BlocProvider(
        create:
            (context) => AppBloc(
              accountBookRepository: context.read<AccountBookRepository>(),
            )..add(AppInitLoad()),
        child: BlocBuilder<AppBloc, AppState>(
          builder: (context, state) {
            if (state.currentAccountBook != null) {
              return MaterialApp.router(routerConfig: _router);
            }
            return MaterialApp(home: Scaffold());
          },
        ),
      ),
    );
  }
}

class _ScaffoldWithNavBar extends StatelessWidget {
  const _ScaffoldWithNavBar({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: ToastManager().toastGlobalContext,
      body: child,
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(splashFactory: NoSplash.splashFactory),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.green,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.event_note), label: "明细"),
            BottomNavigationBarItem(
              icon: Icon(Icons.pie_chart_rounded),
              label: "统计",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_rounded),
              label: "设置",
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
              case 2:
                SettingsRoute.launch(context);
                break;
            }
          },
        ),
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
    if (location.startsWith(SettingsRoute.route)) {
      return 2;
    }
    return 0;
  }
}
