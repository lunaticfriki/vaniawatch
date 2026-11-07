import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/shared/presentation/app_menu.dart';
import 'package:frontend/shared/presentation/app_routes.dart';
import 'package:frontend/shared/presentation/layout/app_footer_view.dart';
import 'package:frontend/shared/presentation/layout/app_header_view.dart';
import 'package:frontend/shared/presentation/layout/app_menu_drawer_view.dart';
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

    void useCompactScreen(WidgetTester tester) {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
    }

    Finder headerLink(AppMenuItem item) => find.descendant(
      of: find.byType(AppHeaderView),
      matching: find.widgetWithText(AppHeaderLink, item.label),
    );

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

      await tester.tap(headerLink(AppMenu.watches));
      await tester.tap(headerLink(AppMenu.add));
      await tester.tap(headerLink(AppMenu.home));
      await tester.tap(find.text(AppHeaderView.title));

      expect(navigations, [
        AppRoutes.watches,
        AppRoutes.add,
        AppRoutes.home,
        AppRoutes.home,
      ]);
    });

    testWidgets('highlights the link of the current page', (tester) async {
      await pumpShell(tester, location: AppRoutes.watches);

      final active = tester.widget<AppHeaderLink>(headerLink(AppMenu.watches));
      final inactive = tester.widget<AppHeaderLink>(headerLink(AppMenu.home));
      expect(active.isActive, isTrue);
      expect(inactive.isActive, isFalse);
    });

    testWidgets('goes to the add page from the floating button', (
      tester,
    ) async {
      final navigations = await pumpShell(tester);

      await tester.tap(find.byTooltip(AppShellView.addLabel));

      expect(navigations, [AppRoutes.add]);
    });

    testWidgets('hides the floating button on the add page', (tester) async {
      await pumpShell(tester, location: AppRoutes.add);

      expect(find.byType(FloatingActionButton), findsNothing);
    });

    testWidgets('shows the links and no burger on a wide screen', (
      tester,
    ) async {
      await pumpShell(tester);

      expect(headerLink(AppMenu.home), findsOneWidget);
      expect(find.byTooltip(AppHeaderView.menuLabel), findsNothing);
    });

    testWidgets('hides the links behind a burger on a compact screen', (
      tester,
    ) async {
      useCompactScreen(tester);
      await pumpShell(tester);

      expect(headerLink(AppMenu.home), findsNothing);
      expect(find.byTooltip(AppHeaderView.menuLabel), findsOneWidget);
    });

    testWidgets('navigates from the burger menu and closes it', (tester) async {
      useCompactScreen(tester);
      final navigations = await pumpShell(tester);

      await tester.tap(find.byTooltip(AppHeaderView.menuLabel));
      await tester.pumpAndSettle();
      expect(find.byType(AppMenuDrawerView), findsOneWidget);

      await tester.tap(
        find.descendant(
          of: find.byType(AppMenuDrawerView),
          matching: find.text(AppMenu.add.label),
        ),
      );
      await tester.pumpAndSettle();

      expect(navigations, [AppRoutes.add]);
      expect(find.byType(AppMenuDrawerView), findsNothing);
    });

    testWidgets('highlights the current page in the burger menu', (
      tester,
    ) async {
      useCompactScreen(tester);
      await pumpShell(tester, location: AppRoutes.watches);

      await tester.tap(find.byTooltip(AppHeaderView.menuLabel));
      await tester.pumpAndSettle();

      final active = tester.widget<ListTile>(
        find.widgetWithText(ListTile, AppMenu.watches.label),
      );
      final inactive = tester.widget<ListTile>(
        find.widgetWithText(ListTile, AppMenu.home.label),
      );
      expect(active.selected, isTrue);
      expect(inactive.selected, isFalse);
    });
  });
}
