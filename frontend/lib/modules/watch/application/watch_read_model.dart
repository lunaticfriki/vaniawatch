import 'package:collection/collection.dart';
import 'package:core/core.dart';
import 'package:meta/meta.dart';

@immutable
final class WatchReadModel {
  static const ListEquality<String> _strings = ListEquality();

  const WatchReadModel._({
    required this.id,
    required this.name,
    required this.description,
    required this.brand,
    required this.type,
    required this.category,
    required this.tags,
    required this.complications,
    required this.imageUrl,
    required this.createdAt,
  });

  factory WatchReadModel.fromDomain(Watch watch) => WatchReadModel._(
    id: watch.id.value,
    name: watch.name.value,
    description: watch.description.value,
    brand: watch.brand.value,
    type: watch.type.value,
    category: watch.category.value,
    tags: List.unmodifiable(watch.tags.values.map((tag) => tag.value)),
    complications: List.unmodifiable(watch.complications),
    imageUrl: watch.imageUrl.isEmpty ? null : watch.imageUrl.value,
    createdAt: watch.createdAt.value,
  );

  final String id;
  final String name;
  final String description;
  final String brand;
  final String type;
  final String category;
  final List<String> tags;
  final List<String> complications;
  final String? imageUrl;
  final DateTime createdAt;

  @override
  bool operator ==(Object other) =>
      other is WatchReadModel &&
      other.id == id &&
      other.name == name &&
      other.description == description &&
      other.brand == brand &&
      other.type == type &&
      other.category == category &&
      _strings.equals(other.tags, tags) &&
      _strings.equals(other.complications, complications) &&
      other.imageUrl == imageUrl &&
      other.createdAt == createdAt;

  @override
  int get hashCode => Object.hash(
    id,
    name,
    description,
    brand,
    type,
    category,
    Object.hashAll(tags),
    Object.hashAll(complications),
    imageUrl,
    createdAt,
  );
}
