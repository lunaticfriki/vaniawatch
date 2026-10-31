import 'package:backend/modules/watch/application/query/get_watch_query.dart';
import 'package:backend/modules/watch/application/query/get_watch_query_handler.dart';
import 'package:backend/modules/watch/application/watch_read_model.dart';
import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../support/mocks.dart';

void main() {
  group('GetWatchQueryHandler', () {
    late MockWatchRepository repository;
    late GetWatchQueryHandler handler;
    late Watch watch;

    setUpAll(() => registerFallbackValue(WatchId.empty()));

    setUp(() {
      repository = MockWatchRepository();
      handler = GetWatchQueryHandler(repository);
      watch = WatchMother.restored();
      when(() => repository.findById(watch.id)).thenAnswer((_) async => watch);
    });

    test('returns the read model of a watch of its owner', () async {
      final result = await handler.handle(
        GetWatchQuery.create(id: watch.id.value, ownerId: watch.owner.value),
      );

      expect(result, WatchReadModel.fromDomain(watch));
    });

    test('fails when the watch does not exist', () async {
      when(() => repository.findById(any())).thenAnswer((_) async => null);

      await expectLater(
        handler.handle(
          GetWatchQuery.create(
            id: WatchIdMother.random().value,
            ownerId: watch.owner.value,
          ),
        ),
        throwsA(isA<WatchNotFoundError>()),
      );
    });

    test('treats a watch of another user as not found', () async {
      await expectLater(
        handler.handle(
          GetWatchQuery.create(
            id: watch.id.value,
            ownerId: UserIdMother.random().value,
          ),
        ),
        throwsA(isA<WatchNotFoundError>()),
      );
    });
  });
}
