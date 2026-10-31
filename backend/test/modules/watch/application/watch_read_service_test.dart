import 'package:backend/modules/watch/application/query/get_watch_query.dart';
import 'package:backend/modules/watch/application/query/get_watch_query_handler.dart';
import 'package:backend/modules/watch/application/query/list_watches_query.dart';
import 'package:backend/modules/watch/application/query/list_watches_query_handler.dart';
import 'package:backend/modules/watch/application/watch_read_service.dart';
import 'package:core/testing.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'watch_read_model_mother.dart';

class _MockGetWatchQueryHandler extends Mock implements GetWatchQueryHandler {}

class _MockListWatchesQueryHandler extends Mock
    implements ListWatchesQueryHandler {}

void main() {
  group('WatchReadServiceImpl', () {
    late _MockGetWatchQueryHandler getWatch;
    late _MockListWatchesQueryHandler listWatches;
    late WatchReadService service;

    setUp(() {
      getWatch = _MockGetWatchQueryHandler();
      listWatches = _MockListWatchesQueryHandler();
      service = WatchReadServiceImpl(
        getWatch: getWatch,
        listWatches: listWatches,
      );
    });

    test('getById delegates to the get watch handler', () async {
      final query = GetWatchQuery.create(
        id: WatchIdMother.random().value,
        ownerId: UserIdMother.random().value,
      );
      final model = WatchReadModelMother.random();
      when(() => getWatch.handle(query)).thenAnswer((_) async => model);

      expect(await service.getById(query), model);
    });

    test('list delegates to the list watches handler', () async {
      final query = ListWatchesQuery.create(
        ownerId: UserIdMother.random().value,
      );
      final models = WatchReadModelMother.many();
      when(() => listWatches.handle(query)).thenAnswer((_) async => models);

      expect(await service.list(query), models);
    });
  });
}
