import 'package:backend/modules/watch/application/query/list_watches_query.dart';
import 'package:backend/modules/watch/application/watch_read_model.dart';
import 'package:core/core.dart';

class ListWatchesQueryHandler {
  const ListWatchesQueryHandler(this._watches);

  final WatchRepository _watches;

  Future<List<WatchReadModel>> handle(ListWatchesQuery query) async {
    final watches = await _watches.findByOwner(UserId.create(query.ownerId));
    return watches.map(WatchReadModel.fromDomain).toList();
  }
}
