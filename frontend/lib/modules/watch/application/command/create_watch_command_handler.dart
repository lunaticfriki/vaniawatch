import 'package:frontend/modules/watch/application/command/create_watch_command.dart';
import 'package:frontend/modules/watch/application/watch_collection_repository.dart';
import 'package:frontend/modules/watch/application/watch_draft.dart';
import 'package:frontend/modules/watch/application/watch_image_storage.dart';

class CreateWatchCommandHandler {
  const CreateWatchCommandHandler(this._watches, this._images);

  final WatchCollectionRepository _watches;
  final WatchImageStorage _images;

  Future<String> handle(CreateWatchCommand command) async {
    final draft = WatchDraft.create(
      name: command.name,
      brand: command.brand,
      type: command.type,
      category: command.category,
      description: command.description,
      tags: command.tags,
      complications: command.complications,
    );
    final image = command.image;
    final complete = image == null
        ? draft
        : draft.withImage(await _images.upload(image));
    final id = await _watches.add(complete);
    return id.value;
  }
}
