import 'package:backend/modules/watch/application/command/create_watch_command.dart';
import 'package:backend/modules/watch/application/command/create_watch_command_handler.dart';
import 'package:backend/modules/watch/application/command/delete_watch_command.dart';
import 'package:backend/modules/watch/application/command/delete_watch_command_handler.dart';
import 'package:backend/modules/watch/application/command/update_watch_command.dart';
import 'package:backend/modules/watch/application/command/update_watch_command_handler.dart';

abstract class WatchWriteService {
  Future<String> create(CreateWatchCommand command);

  Future<void> update(UpdateWatchCommand command);

  Future<void> delete(DeleteWatchCommand command);
}

final class WatchWriteServiceImpl implements WatchWriteService {
  const WatchWriteServiceImpl({
    required this._createWatch,
    required this._updateWatch,
    required this._deleteWatch,
  });

  final CreateWatchCommandHandler _createWatch;
  final UpdateWatchCommandHandler _updateWatch;
  final DeleteWatchCommandHandler _deleteWatch;

  @override
  Future<String> create(CreateWatchCommand command) =>
      _createWatch.handle(command);

  @override
  Future<void> update(UpdateWatchCommand command) =>
      _updateWatch.handle(command);

  @override
  Future<void> delete(DeleteWatchCommand command) =>
      _deleteWatch.handle(command);
}
