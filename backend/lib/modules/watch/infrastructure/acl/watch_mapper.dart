import 'package:core/core.dart';

abstract final class WatchMapper {
  static Watch toDomain(Map<String, dynamic> row) => Watch.restore(
    id: WatchId.create(row['id'] as String),
    owner: UserId.create(row['owner_id'] as String),
    name: WatchName.create(row['name'] as String),
    description: WatchDescription.create(row['description'] as String),
    brand: WatchBrand.create(row['brand'] as String),
    type: WatchType.create(row['type'] as String),
    category: WatchCategory.create(row['category'] as String),
    tags: WatchTags.create(
      (row['tags'] as List<dynamic>)
          .cast<String>()
          .map(WatchTag.create)
          .toList(),
    ),
    complications: (row['complications'] as List<dynamic>).cast<String>(),
    imageUrl: WatchImageUrl.optional(row['image_url'] as String? ?? ''),
    createdAt: CreatedAt.create(row['created_at'] as DateTime),
    updatedAt: UpdatedAt.create(row['updated_at'] as DateTime),
  );

  static Map<String, Object?> toRow(Watch watch) => {
    'id': watch.id.value,
    'owner_id': watch.owner.value,
    'name': watch.name.value,
    'description': watch.description.value,
    'brand': watch.brand.value,
    'type': watch.type.value,
    'category': watch.category.value,
    'tags': watch.tags.values.map((tag) => tag.value).toList(),
    'complications': watch.complications.toList(),
    'image_url': watch.imageUrl.isEmpty ? null : watch.imageUrl.value,
    'created_at': watch.createdAt.value,
    'updated_at': watch.updatedAt.value,
  };
}
