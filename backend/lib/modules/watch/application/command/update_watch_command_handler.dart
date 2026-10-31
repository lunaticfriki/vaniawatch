import 'package:backend/modules/watch/application/command/update_watch_command.dart';
import 'package:backend/shared/application/clock_service.dart';
import 'package:core/core.dart';

class UpdateWatchCommandHandler {
  const UpdateWatchCommandHandler(this._watches, this._clock);

  final WatchRepository _watches;
  final ClockService _clock;

  Future<void> handle(UpdateWatchCommand command) async {
    final id = WatchId.create(command.id);
    final owner = UserId.create(command.ownerId);
    final name = WatchName.create(command.name);
    final description = WatchDescription.create(command.description);
    final brand = WatchBrand.create(command.brand);
    final type = WatchType.create(command.type);
    final category = WatchCategory.create(command.category);
    final tags = WatchTags.create(command.tags.map(WatchTag.create).toList());
    final imageUrl = WatchImageUrl.optional(command.imageUrl);

    final watch = await _watches.findById(id);
    if (watch == null || !watch.isOwnedBy(owner)) {
      throw WatchNotFoundError(id);
    }

    final at = UpdatedAt.create(_clock.now());
    watch
      ..rename(name, at: at)
      ..describe(description, at: at)
      ..rebrand(brand, at: at)
      ..changeType(type, at: at)
      ..changeCategory(category, at: at)
      ..retag(tags, at: at)
      ..changeComplications(command.complications, at: at)
      ..changeImage(imageUrl, at: at);
    await _watches.save(watch);
  }
}
