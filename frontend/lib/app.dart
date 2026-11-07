import 'package:flutter/material.dart';
import 'package:frontend/modules/watch/presentation/add_watch_page.dart';
import 'package:frontend/modules/watch/presentation/latest_watches_page.dart';
import 'package:frontend/modules/watch/presentation/watch_list_page.dart';
import 'package:frontend/shared/presentation/app_routes.dart';
import 'package:frontend/shared/presentation/layout/app_shell_view.dart';
import 'package:go_router/go_router.dart';

class VaniaWatchApp extends StatefulWidget {
  const VaniaWatchApp({super.key});

  @override
  State<VaniaWatchApp> createState() => _VaniaWatchAppState();
}

class _VaniaWatchAppState extends State<VaniaWatchApp> {
  final GoRouter _router = GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      ShellRoute(
        builder: (context, state, child) => AppShellView(
          location: state.uri.path,
          onNavigate: context.go,
          child: child,
        ),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: LatestWatchesPage()),
          ),
          GoRoute(
            path: AppRoutes.watches,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: WatchListPage()),
          ),
          GoRoute(
            path: AppRoutes.add,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: AddWatchPage()),
          ),
        ],
      ),
    ],
  );

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'VaniaWatch',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      routerConfig: _router,
    );
  }
}
