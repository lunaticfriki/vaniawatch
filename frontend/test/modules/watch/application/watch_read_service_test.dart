import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/modules/watch/application/query/list_watches_query.dart';
import 'package:frontend/modules/watch/application/query/list_watches_query_handler.dart';
import 'package:frontend/modules/watch/application/watch_read_service.dart';
import 'package:mocktail/mocktail.dart';

import 'watch_read_model_mother.dart';

class _MockListWatchesQueryHandler extends Mock
    implements ListWatchesQueryHandler {}

void main() {
  group('WatchReadServiceImpl', () {
    test('list delegates to the list handler', () async {
      final listWatches = _MockListWatchesQueryHandler();
      final service = WatchReadServiceImpl(listWatches: listWatches);
      final query = ListWatchesQuery.all();
      final watches = WatchReadModelMother.many();
      when(() => listWatches.handle(query)).thenAnswer((_) async => watches);

      expect(await service.list(query), watches);
    });
  });
}
