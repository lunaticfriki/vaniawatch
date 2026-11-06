import 'package:flutter/material.dart';
import 'package:frontend/shared/presentation/layout/app_footer_view.dart';
import 'package:frontend/shared/presentation/layout/app_header_view.dart';

class AppShellView extends StatelessWidget {
  const AppShellView({
    required this.location,
    required this.onNavigate,
    required this.child,
    super.key,
  });

  static const double maxContentWidth = 840;

  final String location;
  final ValueChanged<String> onNavigate;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppHeaderView(location: location, onNavigate: onNavigate),
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
