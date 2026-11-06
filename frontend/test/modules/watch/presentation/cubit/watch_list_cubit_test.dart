import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/modules/watch/application/query/list_watches_query.dart';
import 'package:frontend/modules/watch/application/watch_collection_repository.dart';
import 'package:frontend/modules/watch/presentation/cubit/watch_list_cubit.dart';
import 'package:frontend/modules/watch/presentation/cubit/watch_list_state.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../support/mocks.dart';
import '../../application/watch_read_model_mother.dart';

void main() {
  group('WatchListCubit', () {
    late MockWatchReadService readService;
    final query = ListWatchesQuery.latest(5);
    final watches = WatchReadModelMother.many();

    setUpAll(() => registerFallbackValue(ListWatchesQuery.all()));

    setUp(() => readService = MockWatchReadService());

    test('starts loading', () {
      expect(WatchListCubit(readService).state, isA<WatchListLoading>());
    });

    blocTest<WatchListCubit, WatchListState>(
      'emits loading then the watches of the query',
      setUp: () =>
          when(() => readService.list(query)).thenAnswer((_) async => watches),
      build: () => WatchListCubit(readService),
      act: (cubit) => cubit.load(query),
      expect: () => [
        isA<WatchListLoading>(),
        isA<WatchListLoaded>().having(
          (state) => state.watches,
          'watches',
          watches,
        ),
      ],
    );

    blocTest<WatchListCubit, WatchListState>(
      'emits failure when the collection is unavailable',
      setUp: () =>
          when(() => readService.list(any()))
              .thenThrow(const WatchCollectionUnavailableException()),
      build: () => WatchListCubit(readService),
      act: (cubit) => cubit.load(query),
      expect: () => [isA<WatchListLoading>(), isA<WatchListFailure>()],
    );

    blocTest<WatchListCubit, WatchListState>(
      'emits failure when the api returns data that breaks a domain rule',
      setUp: () =>
          when(() => readService.list(any()))
              .thenThrow(const InvalidWatchTypeError('sundial')),
      build: () => WatchListCubit(readService),
      act: (cubit) => cubit.load(query),
      expect: () => [isA<WatchListLoading>(), isA<WatchListFailure>()],
    );
  });
}
