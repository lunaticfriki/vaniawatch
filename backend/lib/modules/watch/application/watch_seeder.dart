import 'package:backend/modules/watch/application/command/create_watch_command.dart';
import 'package:backend/modules/watch/application/command/delete_watch_command.dart';
import 'package:backend/modules/watch/application/query/list_watches_query.dart';
import 'package:backend/modules/watch/application/watch_read_service.dart';
import 'package:backend/modules/watch/application/watch_write_service.dart';

abstract class WatchSeeder {
  Future<int> seed(List<CreateWatchCommand> commands);
}

final class WatchSeederImpl implements WatchSeeder {
  const WatchSeederImpl({required this._read, required this._write});

  final WatchReadService _read;
  final WatchWriteService _write;

  @override
  Future<int> seed(List<CreateWatchCommand> commands) async {
    final owners = commands.map((command) => command.ownerId).toSet();
    for (final owner in owners) {
      await _clear(owner);
    }
    for (final command in commands) {
      await _write.create(command);
    }
    return commands.length;
  }

  Future<void> _clear(String ownerId) async {
    final existing = await _read.list(
      ListWatchesQuery.create(ownerId: ownerId),
    );
    for (final watch in existing) {
      await _write.delete(
        DeleteWatchCommand.create(id: watch.id, ownerId: ownerId),
      );
    }
  }
}
