import 'package:flutter/material.dart';
import 'package:frontend/shared/presentation/app_routes.dart';
import 'package:frontend/shared/presentation/layout/app_footer_view.dart';
import 'package:frontend/shared/presentation/layout/app_header_view.dart';
import 'package:frontend/shared/presentation/layout/app_menu_drawer_view.dart';

class AppShellView extends StatelessWidget {
  const AppShellView({
    required this.location,
    required this.onNavigate,
    required this.child,
    super.key,
  });

  static const double maxContentWidth = 840;
  static const String addLabel = 'Add watch';

  final String location;
  final ValueChanged<String> onNavigate;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: AppHeaderView.isCompact(context)
          ? Builder(
              builder: (context) => AppMenuDrawerView(
                location: location,
                onNavigate: (route) {
                  Scaffold.of(context).closeEndDrawer();
                  onNavigate(route);
                },
              ),
            )
          : null,
      floatingActionButton: location == AppRoutes.add
          ? null
          : FloatingActionButton(
              tooltip: addLabel,
              onPressed: () => onNavigate(AppRoutes.add),
              child: const Icon(Icons.add),
            ),
      body: Column(
        children: [
          Builder(
            builder: (context) => AppHeaderView(
              location: location,
              onNavigate: onNavigate,
              onOpenMenu: Scaffold.of(context).openEndDrawer,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: maxContentWidth),
                  child: child,
                ),
              ),
            ),
          ),
          const AppFooterView(),
        ],
      ),
    );
  }
}
