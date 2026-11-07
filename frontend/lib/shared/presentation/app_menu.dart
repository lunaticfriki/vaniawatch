import 'package:frontend/shared/presentation/app_routes.dart';

final class AppMenuItem {
  const AppMenuItem._({required this.label, required this.route});

  final String label;
  final String route;
}

abstract final class AppMenu {
  static const AppMenuItem home = AppMenuItem._(
    label: 'Home',
    route: AppRoutes.home,
  );
  static const AppMenuItem watches = AppMenuItem._(
    label: 'All watches',
    route: AppRoutes.watches,
  );
  static const AppMenuItem add = AppMenuItem._(
    label: 'Add watch',
    route: AppRoutes.add,
  );

  static const List<AppMenuItem> items = [home, watches, add];
}
