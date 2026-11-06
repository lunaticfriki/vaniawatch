import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/app.dart';
import 'package:frontend/modules/watch/application/query/list_watches_query.dart';
import 'package:frontend/modules/watch/application/watch_read_service.dart';
import 'package:frontend/modules/watch/presentation/latest_watches_view.dart';
import 'package:frontend/modules/watch/presentation/watch_list_view.dart';
import 'package:frontend/shared/presentation/layout/app_footer_view.dart';
import 'package:frontend/shared/presentation/layout/app_header_view.dart';
import 'package:mocktail/mocktail.dart';

import 'modules/watch/application/watch_read_model_mother.dart';
import 'support/mocks.dart';

void main() {
  group('VaniaWatchApp', () {
    late MockWatchReadService readService;

    setUpAll(() => registerFallbackValue(ListWatchesQuery.all()));

    setUp(() {
      readService = MockWatchReadService();
      when(() => readService.list(any()))
          .thenAnswer((_) async => WatchReadModelMother.many(count: 2));
    });

    Future<void> pumpApp(WidgetTester tester) async {
      await tester.pumpWidget(
        RepositoryProvider<WatchReadService>.value(
          value: readService,
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

    testWidgets('goes to all watches from the header', (tester) async {
      await pumpApp(tester);

      await tester.tap(find.text(AppHeaderView.allWatchesLabel));
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
