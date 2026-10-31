import 'package:backend/modules/watch/application/query/get_watch_query.dart';
import 'package:backend/modules/watch/application/query/get_watch_query_handler.dart';
import 'package:backend/modules/watch/application/query/list_watches_query.dart';
import 'package:backend/modules/watch/application/query/list_watches_query_handler.dart';
import 'package:backend/modules/watch/application/watch_read_model.dart';

abstract class WatchReadService {
  Future<WatchReadModel> getById(GetWatchQuery query);

  Future<List<WatchReadModel>> list(ListWatchesQuery query);
}

final class WatchReadServiceImpl implements WatchReadService {
  const WatchReadServiceImpl({
    required this._getWatch,
    required this._listWatches,
  });

  final GetWatchQueryHandler _getWatch;
  final ListWatchesQueryHandler _listWatches;

  @override
  Future<WatchReadModel> getById(GetWatchQuery query) =>
      _getWatch.handle(query);

  @override
  Future<List<WatchReadModel>> list(ListWatchesQuery query) =>
      _listWatches.handle(query);
}
