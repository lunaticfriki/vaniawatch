import 'package:core/testing.dart';
import 'package:frontend/modules/watch/application/watch_draft.dart';

abstract final class WatchDraftMother {
  static WatchDraft random() => WatchDraft.create(
    name: WatchNameMother.random().value,
    brand: WatchBrandMother.random().value,
    type: WatchTypeMother.random().value,
    category: WatchCategoryMother.random().value,
    description: WatchDescriptionMother.random().value,
    tags: WatchTagsMother.random(count: 2).values
        .map((tag) => tag.value)
        .toList(),
    complications: WatchComplicationsMother.random(count: 2),
  );

  static WatchDraft withImage() =>
      random().withImage(WatchImageUrlMother.random());
}
