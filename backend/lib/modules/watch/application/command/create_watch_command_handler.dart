import 'package:backend/modules/watch/application/command/create_watch_command.dart';
import 'package:backend/shared/application/clock_service.dart';
import 'package:core/core.dart';

class CreateWatchCommandHandler {
  const CreateWatchCommandHandler(this._watches, this._clock);

  final WatchRepository _watches;
  final ClockService _clock;

  Future<String> handle(CreateWatchCommand command) async {
    final watch = Watch.create(
      id: WatchId.generate(),
      owner: UserId.create(command.ownerId),
      name: WatchName.create(command.name),
      description: WatchDescription.create(command.description),
      brand: WatchBrand.create(command.brand),
      type: WatchType.create(command.type),
      category: WatchCategory.create(command.category),
      tags: WatchTags.create(command.tags.map(WatchTag.create).toList()),
      complications: command.complications,
      imageUrl: WatchImageUrl.optional(command.imageUrl),
      createdAt: CreatedAt.create(_clock.now()),
    );
    await _watches.save(watch);
    return watch.id.value;
  }
}
