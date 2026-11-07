import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/app.dart';
import 'package:frontend/modules/watch/application/query/list_watches_query.dart';
import 'package:frontend/modules/watch/application/watch_image_picker.dart';
import 'package:frontend/modules/watch/application/watch_read_service.dart';
import 'package:frontend/modules/watch/application/watch_write_service.dart';
import 'package:frontend/modules/watch/presentation/add_watch_page.dart';
import 'package:frontend/modules/watch/presentation/latest_watches_view.dart';
import 'package:frontend/modules/watch/presentation/watch_list_view.dart';
import 'package:frontend/shared/presentation/app_menu.dart';
import 'package:frontend/shared/presentation/layout/app_footer_view.dart';
import 'package:frontend/shared/presentation/layout/app_header_view.dart';
import 'package:frontend/shared/presentation/layout/app_shell_view.dart';
import 'package:mocktail/mocktail.dart';

import 'modules/watch/application/watch_read_model_mother.dart';
import 'support/mocks.dart';

void main() {
  group('VaniaWatchApp', () {
    late MockWatchReadService readService;
    late MockWatchWriteService writeService;

    setUpAll(() => registerFallbackValue(ListWatchesQuery.all()));

    setUp(() {
      readService = MockWatchReadService();
      writeService = MockWatchWriteService();
      when(() => writeService.acceptsImages).thenReturn(false);
      when(() => readService.list(any()))
          .thenAnswer((_) async => WatchReadModelMother.many(count: 2));
    });

    Future<void> pumpApp(WidgetTester tester) async {
      await tester.pumpWidget(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider<WatchReadService>.value(value: readService),
            RepositoryProvider<WatchWriteService>.value(value: writeService),
            RepositoryProvider<WatchImagePicker>.value(
              value: MockWatchImagePicker(),
            ),
          ],
          child: const VaniaWatchApp(),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('opens on the latest watches, inside the shell', (
      tester,
    ) async {
      await pumpApp(tester);

      expect(find.byType(AppHeaderView), findsOneWidget);
      expect(find.byType(LatestWatchesView), findsOneWidget);
      expect(find.byType(AppFooterView), findsOneWidget);
    });

    testWidgets('goes to the add page from the floating button', (
      tester,
    ) async {
      await pumpApp(tester);

      await tester.tap(find.byTooltip(AppShellView.addLabel));
      await tester.pumpAndSettle();

      expect(find.byType(AddWatchPage), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsNothing);
    });

    testWidgets('goes to the add page from the header', (tester) async {
      await pumpApp(tester);

      await tester.tap(find.text(AppMenu.add.label));
      await tester.pumpAndSettle();

      expect(find.byType(AddWatchPage), findsOneWidget);
    });

    testWidgets('goes to all watches from the header', (tester) async {
      await pumpApp(tester);

      await tester.tap(find.text(AppMenu.watches.label));
      await tester.pumpAndSettle();

      expect(find.byType(WatchListView), findsOneWidget);
      expect(find.byType(AppHeaderView), findsOneWidget);
    });

    testWidgets('goes to all watches from the home page', (tester) async {
      await pumpApp(tester);

      await tester.tap(find.text(LatestWatchesView.seeAllLabel));
      await tester.pumpAndSettle();

      expect(find.byType(WatchListView), findsOneWidget);
    });
  });
}
