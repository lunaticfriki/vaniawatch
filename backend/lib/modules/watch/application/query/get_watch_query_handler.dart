import 'package:backend/modules/watch/application/query/get_watch_query.dart';
import 'package:backend/modules/watch/application/watch_read_model.dart';
import 'package:core/core.dart';

class GetWatchQueryHandler {
  const GetWatchQueryHandler(this._watches);

  final WatchRepository _watches;

  Future<WatchReadModel> handle(GetWatchQuery query) async {
    final id = WatchId.create(query.id);
    final watch = await _watches.findById(id);
    if (watch == null || !watch.isOwnedBy(UserId.create(query.ownerId))) {
      throw WatchNotFoundError(id);
    }
    return WatchReadModel.fromDomain(watch);
  }
}
