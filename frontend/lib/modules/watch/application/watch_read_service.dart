import 'package:frontend/modules/watch/application/query/list_watches_query.dart';
import 'package:frontend/modules/watch/application/query/list_watches_query_handler.dart';
import 'package:frontend/modules/watch/application/watch_read_model.dart';

abstract class WatchReadService {
  Future<List<WatchReadModel>> list(ListWatchesQuery query);
}

final class WatchReadServiceImpl implements WatchReadService {
  const WatchReadServiceImpl({required this._listWatches});

  final ListWatchesQueryHandler _listWatches;

  @override
  Future<List<WatchReadModel>> list(ListWatchesQuery query) =>
      _listWatches.handle(query);
}
