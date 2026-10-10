import '../../../auth/value_objects/__tests__/user_id.mother.dart';
import '../../value_objects/__tests__/watch_brand.mother.dart';
import '../../value_objects/__tests__/watch_category.mother.dart';
import '../../value_objects/__tests__/watch_complication.mother.dart';
import '../../value_objects/__tests__/watch_description.mother.dart';
import '../../value_objects/__tests__/watch_image_url.mother.dart';
import '../../value_objects/__tests__/watch_id.mother.dart';
import '../../value_objects/__tests__/watch_model.mother.dart';
import '../../value_objects/__tests__/watch_tag.mother.dart';
import '../watch.entity.dart';

class WatchMother {
  static Watch empty() => Watch.empty();

  static Watch valid() {
    return Watch.create(
      id: WatchIdMother.valid(),
      ownerId: UserIdMother.valid(),
      brand: WatchBrandMother.valid(),
      model: WatchModelMother.valid(),
      category: WatchCategoryMother.valid(),
      description: WatchDescriptionMother.valid(),
      imageUrl: WatchImageUrlMother.valid(),
      complications: [WatchComplicationMother.valid()],
      tags: [WatchTagMother.valid()],
    );
  }
}
