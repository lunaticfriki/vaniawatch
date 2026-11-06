import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/shared/presentation/app_routes.dart';
import 'package:frontend/shared/presentation/layout/app_footer_view.dart';
import 'package:frontend/shared/presentation/layout/app_header_view.dart';
import 'package:frontend/shared/presentation/layout/app_shell_view.dart';

void main() {
  group('AppShellView', () {
    Future<List<String>> pumpShell(
      WidgetTester tester, {
      String location = AppRoutes.home,
    }) async {
      final navigations = <String>[];
      await tester.pumpWidget(
        MaterialApp(
          home: AppShellView(
            location: location,
            onNavigate: navigations.add,
            child: const Text('page'),
          ),
        ),
      );
      return navigations;
    }

    testWidgets('puts the page between the header and the footer', (
      tester,
    ) async {
      await pumpShell(tester);

      expect(find.byType(AppHeaderView), findsOneWidget);
      expect(find.text('page'), findsOneWidget);
      expect(find.byType(AppFooterView), findsOneWidget);
      expect(
        tester.getTopLeft(find.byType(AppHeaderView)).dy,
        lessThan(tester.getTopLeft(find.text('page')).dy),
      );
      expect(
        tester.getTopLeft(find.text('page')).dy,
        lessThan(tester.getTopLeft(find.byType(AppFooterView)).dy),
      );
    });

    testWidgets('navigates from the header links', (tester) async {
      final navigations = await pumpShell(tester);

      await tester.tap(find.text(AppHeaderView.allWatchesLabel));
      await tester.tap(find.text(AppHeaderView.homeLabel));
      await tester.tap(find.text(AppHeaderView.title));

      expect(navigations, [AppRoutes.watches, AppRoutes.home, AppRoutes.home]);
    });

    testWidgets('highlights the link of the current page', (tester) async {
      await pumpShell(tester, location: AppRoutes.watches);

      final active = tester.widget<AppHeaderLink>(
        find.widgetWithText(AppHeaderLink, AppHeaderView.allWatchesLabel),
      );
      final inactive = tester.widget<AppHeaderLink>(
        find.widgetWithText(AppHeaderLink, AppHeaderView.homeLabel),
      );
      expect(active.isActive, isTrue);
      expect(inactive.isActive, isFalse);
    });
  });
}
