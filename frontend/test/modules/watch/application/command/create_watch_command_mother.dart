import 'package:core/testing.dart';
import 'package:frontend/modules/watch/application/command/create_watch_command.dart';
import 'package:frontend/modules/watch/application/watch_image.dart';

abstract final class CreateWatchCommandMother {
  static CreateWatchCommand valid({WatchImage? image}) =>
      CreateWatchCommand.create(
        name: WatchNameMother.random().value,
        brand: WatchBrandMother.random().value,
        type: WatchTypeMother.random().value,
        category: WatchCategoryMother.random().value,
        description: WatchDescriptionMother.random().value,
        tags: WatchTagsMother.random(count: 2).values
            .map((tag) => tag.value)
            .toList(),
        complications: WatchComplicationsMother.random(count: 2),
        image: image,
      );

  static CreateWatchCommand invalid({WatchImage? image}) =>
      CreateWatchCommand.create(
        name: '',
        brand: '',
        type: 'sundial',
        category: 'solar',
        description: '',
        tags: const [],
        complications: const [],
        image: image,
      );
}
