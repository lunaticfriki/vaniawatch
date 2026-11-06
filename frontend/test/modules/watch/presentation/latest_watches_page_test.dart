import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/modules/watch/application/query/list_watches_query.dart';
import 'package:frontend/modules/watch/application/watch_read_service.dart';
import 'package:frontend/modules/watch/presentation/cubit/watch_list_cubit.dart';
import 'package:frontend/modules/watch/presentation/cubit/watch_list_state.dart';
import 'package:frontend/modules/watch/presentation/latest_watches_page.dart';
import 'package:frontend/modules/watch/presentation/latest_watches_view.dart';
import 'package:frontend/modules/watch/presentation/watch_list_skeleton.dart';
import 'package:frontend/modules/watch/presentation/watch_list_failure_view.dart';
import 'package:mocktail/mocktail.dart';

import '../application/watch_read_model_mother.dart';
import '../../../support/mocks.dart';
import '../../../support/pump.dart';

void main() {
  group('LatestWatchesPage', () {
    setUpAll(() => registerFallbackValue(ListWatchesQuery.all()));

    testWidgets('loads the five newest watches', (tester) async {
      final readService = MockWatchReadService();
      when(() => readService.list(any())).thenAnswer((_) async => []);

      await tester.pumpView(
        RepositoryProvider<WatchReadService>.value(
          value: readService,
          child: const LatestWatchesPage(),
        ),
      );

      final query =
          verify(() => readService.list(captureAny())).captured.single
              as ListWatchesQuery;
      expect(query.limit, LatestWatchesPage.count);
    });
  });

  group('LatestWatchesPageBody', () {
    late MockWatchListCubit cubit;

    setUp(() => cubit = MockWatchListCubit());

    Future<void> pumpBody(WidgetTester tester, WatchListState state) {
      when(() => cubit.state).thenReturn(state);
      return tester.pumpView(
        BlocProvider<WatchListCubit>.value(
          value: cubit,
          child: LatestWatchesPageBody(onSeeAll: () {}),
        ),
      );
    }

    testWidgets('shows the skeleton while loading', (tester) async {
      await pumpBody(tester, const WatchListLoading());

      expect(find.byType(WatchListSkeleton), findsOneWidget);
    });

    testWidgets('shows the failure view and retries', (tester) async {
      when(() => cubit.load(any())).thenAnswer((_) async {});
      await pumpBody(tester, const WatchListFailure());

      await tester.tap(find.text(WatchListFailureView.retryLabel));

      verify(() => cubit.load(any())).called(1);
    });

    testWidgets('shows the latest watches when loaded', (tester) async {
      await pumpBody(
        tester,
        WatchListLoaded(WatchReadModelMother.many(count: 2)),
      );

      expect(find.byType(LatestWatchesView), findsOneWidget);
    });
  });
}
