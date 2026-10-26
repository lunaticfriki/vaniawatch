import 'package:core/core.dart';
import 'package:core/src/testing/shared/created_at_mother.dart';
import 'package:core/src/testing/shared/updated_at_mother.dart';
import 'package:core/src/testing/user/user_id_mother.dart';
import 'package:core/src/testing/watch/watch_brand_mother.dart';
import 'package:core/src/testing/watch/watch_category_mother.dart';
import 'package:core/src/testing/watch/watch_complications_mother.dart';
import 'package:core/src/testing/watch/watch_description_mother.dart';
import 'package:core/src/testing/watch/watch_id_mother.dart';
import 'package:core/src/testing/watch/watch_image_url_mother.dart';
import 'package:core/src/testing/watch/watch_name_mother.dart';
import 'package:core/src/testing/watch/watch_tags_mother.dart';
import 'package:core/src/testing/watch/watch_type_mother.dart';

abstract final class WatchMother {
  static Watch random({
    WatchId? id,
    UserId? owner,
    WatchName? name,
    WatchDescription? description,
    WatchBrand? brand,
    WatchType? type,
    WatchCategory? category,
    WatchTags? tags,
    List<String>? complications,
    WatchImageUrl? imageUrl,
    CreatedAt? createdAt,
  }) => Watch.create(
    id: id ?? WatchIdMother.random(),
    owner: owner ?? UserIdMother.random(),
    name: name ?? WatchNameMother.random(),
    description: description ?? WatchDescriptionMother.random(),
    brand: brand ?? WatchBrandMother.random(),
    type: type ?? WatchTypeMother.random(),
    category: category ?? WatchCategoryMother.random(),
    tags: tags ?? WatchTagsMother.random(),
    complications: complications ?? WatchComplicationsMother.random(),
    imageUrl: imageUrl ?? WatchImageUrlMother.random(),
    createdAt: createdAt ?? CreatedAtMother.random(),
  );

  static Watch restored({
    WatchId? id,
    UserId? owner,
    WatchName? name,
    WatchDescription? description,
    WatchBrand? brand,
    WatchType? type,
    WatchCategory? category,
    WatchTags? tags,
    List<String>? complications,
    WatchImageUrl? imageUrl,
    CreatedAt? createdAt,
    UpdatedAt? updatedAt,
  }) {
    final created = createdAt ?? CreatedAtMother.random();
    return Watch.restore(
      id: id ?? WatchIdMother.random(),
      owner: owner ?? UserIdMother.random(),
      name: name ?? WatchNameMother.random(),
      description: description ?? WatchDescriptionMother.random(),
      brand: brand ?? WatchBrandMother.random(),
      type: type ?? WatchTypeMother.random(),
      category: category ?? WatchCategoryMother.random(),
      tags: tags ?? WatchTagsMother.random(),
      complications: complications ?? WatchComplicationsMother.random(),
      imageUrl: imageUrl ?? WatchImageUrlMother.random(),
      createdAt: created,
      updatedAt: updatedAt ?? UpdatedAtMother.afterCreation(created),
    );
  }

  static Watch ownedBy(UserId owner) => random(owner: owner);

  static Watch withoutImage() => random(imageUrl: WatchImageUrlMother.empty());

  static Watch empty() => Watch.empty();
}
