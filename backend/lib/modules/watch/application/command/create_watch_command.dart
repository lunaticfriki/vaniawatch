final class CreateWatchCommand {
  const CreateWatchCommand._({
    required this.ownerId,
    required this.name,
    required this.description,
    required this.brand,
    required this.type,
    required this.category,
    required this.tags,
    required this.complications,
    required this.imageUrl,
  });

  factory CreateWatchCommand.create({
    required String ownerId,
    required String name,
    required String description,
    required String brand,
    required String type,
    required String category,
    required List<String> tags,
    required List<String> complications,
    required String imageUrl,
  }) => CreateWatchCommand._(
    ownerId: ownerId,
    name: name,
    description: description,
    brand: brand,
    type: type,
    category: category,
    tags: List.unmodifiable(tags),
    complications: List.unmodifiable(complications),
    imageUrl: imageUrl,
  );

  final String ownerId;
  final String name;
  final String description;
  final String brand;
  final String type;
  final String category;
  final List<String> tags;
  final List<String> complications;
  final String imageUrl;
}
