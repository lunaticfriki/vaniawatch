import 'package:flutter/material.dart';
import 'package:frontend/shared/presentation/app_menu.dart';

class AppMenuDrawerView extends StatelessWidget {
  const AppMenuDrawerView({
    required this.location,
    required this.onNavigate,
    super.key,
  });

  final String location;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            for (final item in AppMenu.items)
              ListTile(
                title: Text(item.label),
                selected: location == item.route,
                onTap: () => onNavigate(item.route),
              ),
          ],
        ),
      ),
    );
  }
}
