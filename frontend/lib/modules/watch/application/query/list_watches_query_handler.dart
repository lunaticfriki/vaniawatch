import 'package:frontend/modules/watch/application/query/list_watches_query.dart';
import 'package:frontend/modules/watch/application/watch_collection_repository.dart';
import 'package:frontend/modules/watch/application/watch_read_model.dart';

class ListWatchesQueryHandler {
  const ListWatchesQueryHandler(this._watches);

  final WatchCollectionRepository _watches;

  Future<List<WatchReadModel>> handle(ListWatchesQuery query) async {
    final watches = await _watches.findAll();
    final selected = switch (query.limit) {
      final limit? => watches.take(limit),
      null => watches,
    };
    return selected.map(WatchReadModel.fromDomain).toList();
  }
}
