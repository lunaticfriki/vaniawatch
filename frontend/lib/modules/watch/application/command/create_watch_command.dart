import 'package:frontend/modules/watch/application/watch_image.dart';

final class CreateWatchCommand {
  const CreateWatchCommand._({
    required this.name,
    required this.brand,
    required this.type,
    required this.category,
    required this.description,
    required this.tags,
    required this.complications,
    required this.image,
  });

  factory CreateWatchCommand.create({
    required String name,
    required String brand,
    required String type,
    required String category,
    required String description,
    required List<String> tags,
    required List<String> complications,
    WatchImage? image,
  }) => CreateWatchCommand._(
    name: name,
    brand: brand,
    type: type,
    category: category,
    description: description,
    tags: List.unmodifiable(tags),
    complications: List.unmodifiable(complications),
    image: image,
  );

  final String name;
  final String brand;
  final String type;
  final String category;
  final String description;
  final List<String> tags;
  final List<String> complications;
  final WatchImage? image;
}
