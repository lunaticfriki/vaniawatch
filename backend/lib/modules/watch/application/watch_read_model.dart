import 'package:core/core.dart';
import 'package:meta/meta.dart';

@immutable
final class WatchReadModel {
  const WatchReadModel._({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.description,
    required this.brand,
    required this.type,
    required this.category,
    required this.tags,
    required this.complications,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WatchReadModel.fromDomain(Watch watch) => WatchReadModel._(
    id: watch.id.value,
    ownerId: watch.owner.value,
    name: watch.name.value,
    description: watch.description.value,
    brand: watch.brand.value,
    type: watch.type.value,
    category: watch.category.value,
    tags: List.unmodifiable(watch.tags.values.map((tag) => tag.value)),
    complications: List.unmodifiable(watch.complications),
    imageUrl: watch.imageUrl.isEmpty ? null : watch.imageUrl.value,
    createdAt: watch.createdAt.value,
    updatedAt: watch.updatedAt.value,
  );

  final String id;
  final String ownerId;
  final String name;
  final String description;
  final String brand;
  final String type;
  final String category;
  final List<String> tags;
  final List<String> complications;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  @override
  bool operator ==(Object other) =>
      other is WatchReadModel &&
      other.id == id &&
      other.ownerId == ownerId &&
      other.name == name &&
      other.description == description &&
      other.brand == brand &&
      other.type == type &&
      other.category == category &&
      _sameItems(other.tags, tags) &&
      _sameItems(other.complications, complications) &&
      other.imageUrl == imageUrl &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt;

  @override
  int get hashCode => Object.hash(
    id,
    ownerId,
    name,
    description,
    brand,
    type,
    category,
    Object.hashAll(tags),
    Object.hashAll(complications),
    imageUrl,
    createdAt,
    updatedAt,
  );

  static bool _sameItems(List<String> first, List<String> second) =>
      first.length == second.length &&
      Iterable<int>.generate(first.length)
          .every((index) => first[index] == second[index]);
}
