import 'package:core/src/shared/errors/invalid_updated_at_error.dart';
import 'package:core/src/shared/value_objects/created_at_value_object.dart';
import 'package:core/src/shared/value_objects/updated_at_value_object.dart';
import 'package:core/src/user/value_objects/user_id_value_object.dart';
import 'package:core/src/watch/value_objects/watch_brand_value_object.dart';
import 'package:core/src/watch/value_objects/watch_category_value_object.dart';
import 'package:core/src/watch/value_objects/watch_description_value_object.dart';
import 'package:core/src/watch/value_objects/watch_id_value_object.dart';
import 'package:core/src/watch/value_objects/watch_image_url_value_object.dart';
import 'package:core/src/watch/value_objects/watch_name_value_object.dart';
import 'package:core/src/watch/value_objects/watch_tags_value_object.dart';
import 'package:core/src/watch/value_objects/watch_type_value_object.dart';

final class Watch {
  Watch._({
    required this.id,
    required this.owner,
    required this._name,
    required this._description,
    required this._brand,
    required this._type,
    required this._category,
    required this._tags,
    required List<String> complications,
    required this._imageUrl,
    required this.createdAt,
    required this._updatedAt,
  }) : _complications = List.unmodifiable(complications);

  factory Watch.create({
    required WatchId id,
    required UserId owner,
    required WatchName name,
    required WatchDescription description,
    required WatchBrand brand,
    required WatchType type,
    required WatchCategory category,
    required WatchTags tags,
    required List<String> complications,
    required WatchImageUrl imageUrl,
    required CreatedAt createdAt,
  }) => Watch._(
    id: id,
    owner: owner,
    name: name,
    description: description,
    brand: brand,
    type: type,
    category: category,
    tags: tags,
    complications: complications,
    imageUrl: imageUrl,
    createdAt: createdAt,
    updatedAt: UpdatedAt.fromCreatedAt(createdAt),
  );

  factory Watch.restore({
    required WatchId id,
    required UserId owner,
    required WatchName name,
    required WatchDescription description,
    required WatchBrand brand,
    required WatchType type,
    required WatchCategory category,
    required WatchTags tags,
    required List<String> complications,
    required WatchImageUrl imageUrl,
    required CreatedAt createdAt,
    required UpdatedAt updatedAt,
  }) {
    if (updatedAt.isBeforeCreation(createdAt)) {
      throw InvalidUpdatedAtError(updatedAt.value, createdAt.value);
    }
    return Watch._(
      id: id,
      owner: owner,
      name: name,
      description: description,
      brand: brand,
      type: type,
      category: category,
      tags: tags,
      complications: complications,
      imageUrl: imageUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory Watch.empty() => Watch._(
    id: WatchId.empty(),
    owner: UserId.empty(),
    name: WatchName.empty(),
    description: WatchDescription.empty(),
    brand: WatchBrand.empty(),
    type: WatchType.analog(),
    category: WatchCategory.quartz(),
    tags: WatchTags.empty(),
    complications: const [],
    imageUrl: WatchImageUrl.empty(),
    createdAt: CreatedAt.empty(),
    updatedAt: UpdatedAt.empty(),
  );

  final WatchId id;
  final UserId owner;
  final CreatedAt createdAt;
  WatchName _name;
  WatchDescription _description;
  WatchBrand _brand;
  WatchType _type;
  WatchCategory _category;
  WatchTags _tags;
  List<String> _complications;
  WatchImageUrl _imageUrl;
  UpdatedAt _updatedAt;

  WatchName get name => _name;
  WatchDescription get description => _description;
  WatchBrand get brand => _brand;
  WatchType get type => _type;
  WatchCategory get category => _category;
  WatchTags get tags => _tags;
  List<String> get complications => _complications;
  WatchImageUrl get imageUrl => _imageUrl;
  UpdatedAt get updatedAt => _updatedAt;

  bool get isEmpty => id.isEmpty;

  bool isOwnedBy(UserId user) => owner == user;

  void rename(WatchName name, {required UpdatedAt at}) {
    _touch(at);
    _name = name;
  }

  void describe(WatchDescription description, {required UpdatedAt at}) {
    _touch(at);
    _description = description;
  }

  void rebrand(WatchBrand brand, {required UpdatedAt at}) {
    _touch(at);
    _brand = brand;
  }

  void changeType(WatchType type, {required UpdatedAt at}) {
    _touch(at);
    _type = type;
  }

  void changeCategory(WatchCategory category, {required UpdatedAt at}) {
    _touch(at);
    _category = category;
  }

  void retag(WatchTags tags, {required UpdatedAt at}) {
    _touch(at);
    _tags = tags;
  }

  void changeComplications(
    List<String> complications, {
    required UpdatedAt at,
  }) {
    _touch(at);
    _complications = List.unmodifiable(complications);
  }

  void changeImage(WatchImageUrl imageUrl, {required UpdatedAt at}) {
    _touch(at);
    _imageUrl = imageUrl;
  }

  void _touch(UpdatedAt at) {
    if (at.isBefore(_updatedAt)) {
      throw InvalidUpdatedAtError(at.value, _updatedAt.value);
    }
    _updatedAt = at;
  }

  @override
  bool operator ==(Object other) => other is Watch && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
