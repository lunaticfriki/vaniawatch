import 'package:core/core.dart';
import 'package:frontend/modules/watch/application/watch_draft.dart';

abstract final class WatchMapper {
  static Watch toDomain(
    Map<String, dynamic> json, {
    required UserId owner,
  }) => Watch.restore(
    id: WatchId.create(json['id'] as String),
    owner: owner,
    name: WatchName.create(json['name'] as String),
    description: WatchDescription.create(json['description'] as String),
    brand: WatchBrand.create(json['brand'] as String),
    type: WatchType.create(json['type'] as String),
    category: WatchCategory.create(json['category'] as String),
    tags: WatchTags.create(
      (json['tags'] as List<dynamic>)
          .cast<String>()
          .map(WatchTag.create)
          .toList(),
    ),
    complications: (json['complications'] as List<dynamic>).cast<String>(),
    imageUrl: WatchImageUrl.optional(json['imageUrl'] as String? ?? ''),
    createdAt: CreatedAt.create(DateTime.parse(json['createdAt'] as String)),
    updatedAt: UpdatedAt.create(DateTime.parse(json['updatedAt'] as String)),
  );

  static Map<String, dynamic> toJson(WatchDraft draft) => {
    'name': draft.name.value,
    'brand': draft.brand.value,
    'type': draft.type.value,
    'category': draft.category.value,
    'description': draft.description.value,
    'tags': draft.tags.values.map((tag) => tag.value).toList(),
    'complications': draft.complications,
    'imageUrl': draft.imageUrl.isEmpty ? '' : draft.imageUrl.value,
  };
}
