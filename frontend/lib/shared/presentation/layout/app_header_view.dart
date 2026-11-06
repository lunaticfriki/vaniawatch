import 'package:flutter/material.dart';
import 'package:frontend/shared/presentation/app_routes.dart';

class AppHeaderView extends StatelessWidget {
  const AppHeaderView({
    required this.location,
    required this.onNavigate,
    super.key,
  });

  static const String title = 'VaniaWatch';
  static const String homeLabel = 'Home';
  static const String allWatchesLabel = 'All watches';

  final String location;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.primaryContainer,
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
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              AppHeaderLink(
                label: homeLabel,
                isActive: location == AppRoutes.home,
                onPressed: () => onNavigate(AppRoutes.home),
              ),
              AppHeaderLink(
                label: allWatchesLabel,
                isActive: location == AppRoutes.watches,
                onPressed: () => onNavigate(AppRoutes.watches),
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
