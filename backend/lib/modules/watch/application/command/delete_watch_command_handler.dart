import 'package:backend/modules/watch/application/command/delete_watch_command.dart';
import 'package:core/core.dart';

class DeleteWatchCommandHandler {
  const DeleteWatchCommandHandler(this._watches);

  final WatchRepository _watches;

  Future<void> handle(DeleteWatchCommand command) async {
    final id = WatchId.create(command.id);
    final watch = await _watches.findById(id);
    if (watch == null || !watch.isOwnedBy(UserId.create(command.ownerId))) {
      throw WatchNotFoundError(id);
    }
    await _watches.delete(id);
  }
}
