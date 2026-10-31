import 'package:backend/modules/watch/application/query/list_watches_query.dart';
import 'package:backend/modules/watch/application/query/list_watches_query_handler.dart';
import 'package:backend/modules/watch/application/watch_read_model.dart';
import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../support/mocks.dart';

void main() {
  group('ListWatchesQueryHandler', () {
    late MockWatchRepository repository;
    late ListWatchesQueryHandler handler;

    setUp(() {
      repository = MockWatchRepository();
      handler = ListWatchesQueryHandler(repository);
    });

    test('returns the read models of the owner watches in order', () async {
      final owner = UserIdMother.random();
      final watches = List.generate(3, (_) => WatchMother.ownedBy(owner));
      when(() => repository.findByOwner(owner))
          .thenAnswer((_) async => watches);

      final result = await handler.handle(
        ListWatchesQuery.create(ownerId: owner.value),
      );

      expect(result, watches.map(WatchReadModel.fromDomain).toList());
    });

    test('returns an empty list when the owner has no watches', () async {
      final owner = UserIdMother.random();
      when(() => repository.findByOwner(owner)).thenAnswer((_) async => []);

      final result = await handler.handle(
        ListWatchesQuery.create(ownerId: owner.value),
      );

      expect(result, isEmpty);
    });

    test('rejects an invalid owner', () async {
      await expectLater(
        handler.handle(ListWatchesQuery.create(ownerId: 'nobody')),
        throwsA(isA<InvalidUserIdError>()),
      );
    });
  });
}
