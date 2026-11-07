import 'package:flutter/material.dart';
import 'package:frontend/shared/presentation/app_menu.dart';
import 'package:frontend/shared/presentation/app_routes.dart';

class AppHeaderView extends StatelessWidget {
  const AppHeaderView({
    required this.location,
    required this.onNavigate,
    required this.onOpenMenu,
    super.key,
  });

  static const String title = 'VaniaWatch';
  static const String menuLabel = 'Menu';
  static const double compactBreakpoint = 600;

  final String location;
  final ValueChanged<String> onNavigate;
  final VoidCallback onOpenMenu;

  static bool isCompact(BuildContext context) =>
      MediaQuery.sizeOf(context).width < compactBreakpoint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Material(
      color: colors.primaryContainer,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            spacing: 8,
            children: [
              TextButton(
                onPressed: () => onNavigate(AppRoutes.home),
                child: Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: colors.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              if (isCompact(context))
                IconButton(
                  tooltip: menuLabel,
                  color: colors.onPrimaryContainer,
                  onPressed: onOpenMenu,
                  icon: const Icon(Icons.menu),
                )
              else
                for (final item in AppMenu.items)
                  AppHeaderLink(
                    label: item.label,
                    isActive: location == item.route,
                    onPressed: () => onNavigate(item.route),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppHeaderLink extends StatelessWidget {
  const AppHeaderLink({
    required this.label,
    required this.isActive,
    required this.onPressed,
    super.key,
  });

  final String label;
  final bool isActive;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: colors.onPrimaryContainer,
        backgroundColor: isActive
            ? colors.onPrimaryContainer.withValues(alpha: 0.12)
            : null,
      ),
      child: Text(label),
    );
  }
}
