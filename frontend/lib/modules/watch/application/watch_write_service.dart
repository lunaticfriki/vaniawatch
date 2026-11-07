import 'package:frontend/modules/watch/application/command/create_watch_command.dart';
import 'package:frontend/modules/watch/application/command/create_watch_command_handler.dart';
import 'package:frontend/modules/watch/application/watch_image_storage.dart';

abstract class WatchWriteService {
  bool get acceptsImages;

  Future<String> create(CreateWatchCommand command);
}

final class WatchWriteServiceImpl implements WatchWriteService {
  const WatchWriteServiceImpl({
    required this._createWatch,
    required this._images,
  });

  final CreateWatchCommandHandler _createWatch;
  final WatchImageStorage _images;

  @override
  bool get acceptsImages => _images.isAvailable;

  @override
  Future<String> create(CreateWatchCommand command) =>
      _createWatch.handle(command);
}
