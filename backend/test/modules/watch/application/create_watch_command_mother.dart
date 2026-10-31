import 'package:backend/modules/watch/application/command/create_watch_command.dart';
import 'package:core/testing.dart';

abstract final class CreateWatchCommandMother {
  static CreateWatchCommand random({
    String? ownerId,
    String? name,
    String? description,
    String? brand,
    String? type,
    String? category,
    List<String>? tags,
    List<String>? complications,
    String? imageUrl,
  }) => CreateWatchCommand.create(
    ownerId: ownerId ?? UserIdMother.random().value,
    name: name ?? WatchNameMother.random().value,
    description: description ?? WatchDescriptionMother.random().value,
    brand: brand ?? WatchBrandMother.random().value,
    type: type ?? WatchTypeMother.random().value,
    category: category ?? WatchCategoryMother.random().value,
    tags:
        tags ??
        WatchTagsMother.random().values.map((tag) => tag.value).toList(),
    complications: complications ?? WatchComplicationsMother.random(),
    imageUrl: imageUrl ?? WatchImageUrlMother.random().value,
  );
}
