import '../../auth/value_objects/user_id.value_object.dart';
import '../value_objects/watch_brand.value_object.dart';
import '../value_objects/watch_category.value_object.dart';
import '../value_objects/watch_complication.value_object.dart';
import '../value_objects/watch_description.value_object.dart';
import '../value_objects/watch_image_url.value_object.dart';
import '../value_objects/watch_id.value_object.dart';
import '../value_objects/watch_model.value_object.dart';
import '../value_objects/watch_tag.value_object.dart';

class Watch {
  Watch._({
    required this.id,
    required this.ownerId,
    required this.brand,
    required this.model,
    required this.category,
    required this.description,
    required this.imageUrl,
    required List<WatchComplication> complications,
    required List<WatchTag> tags,
  })  : complications = List.unmodifiable(complications),
        tags = List.unmodifiable(tags);

  factory Watch.create({
    required WatchId id,
    required UserId ownerId,
    required WatchBrand brand,
    required WatchModel model,
    required WatchCategory category,
    WatchDescription? description,
    WatchImageUrl? imageUrl,
    List<WatchComplication> complications = const [],
    List<WatchTag> tags = const [],
  }) {
    return Watch._(
      id: id,
      ownerId: ownerId,
      brand: brand,
      model: model,
      category: category,
      description: description,
      imageUrl: imageUrl,
      complications: complications,
      tags: tags,
    );
  }

  factory Watch.empty() {
    return Watch._(
      id: WatchId.empty(),
      ownerId: UserId.empty(),
      brand: WatchBrand.empty(),
      model: WatchModel.empty(),
      category: WatchCategory.empty(),
      description: null,
      imageUrl: null,
      complications: const [],
      tags: const [],
    );
  }

  final WatchId id;
  final UserId ownerId;
  final WatchBrand brand;
  final WatchModel model;
  final WatchCategory category;
  final WatchDescription? description;
  final WatchImageUrl? imageUrl;
  final List<WatchComplication> complications;
  final List<WatchTag> tags;

  @override
  bool operator ==(Object other) => other is Watch && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
