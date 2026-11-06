import 'package:core/testing.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/modules/watch/application/query/list_watches_query.dart';
import 'package:frontend/modules/watch/application/query/list_watches_query_handler.dart';
import 'package:frontend/modules/watch/application/watch_collection_repository.dart';
import 'package:frontend/modules/watch/application/watch_read_model.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../support/mocks.dart';

void main() {
  group('ListWatchesQueryHandler', () {
    late MockWatchCollectionRepository repository;
    late ListWatchesQueryHandler handler;

    setUp(() {
      repository = MockWatchCollectionRepository();
      handler = ListWatchesQueryHandler(repository);
    });

    test('returns every watch, in the repository order, for all()', () async {
      final watches = List.generate(7, (_) => WatchMother.restored());
      when(repository.findAll).thenAnswer((_) async => watches);

      final result = await handler.handle(ListWatchesQuery.all());

      expect(result, watches.map(WatchReadModel.fromDomain).toList());
    });

    test('returns only the newest watches for latest()', () async {
      final watches = List.generate(7, (_) => WatchMother.restored());
      when(repository.findAll).thenAnswer((_) async => watches);

      final result = await handler.handle(ListWatchesQuery.latest(5));

      expect(result, watches.take(5).map(WatchReadModel.fromDomain).toList());
    });

    test('returns fewer watches when the collection is smaller', () async {
      final watches = List.generate(2, (_) => WatchMother.restored());
      when(repository.findAll).thenAnswer((_) async => watches);

      final result = await handler.handle(ListWatchesQuery.latest(5));

      expect(result, hasLength(2));
    });

    test('propagates an unavailable collection', () {
      when(repository.findAll)
          .thenThrow(const WatchCollectionUnavailableException());

      expect(
        () => handler.handle(ListWatchesQuery.all()),
        throwsA(isA<WatchCollectionUnavailableException>()),
      );
    });
  });

  group('ListWatchesQuery', () {
    test('latest() rejects a count below one', () {
      expect(() => ListWatchesQuery.latest(0), throwsArgumentError);
    });
  });
}
