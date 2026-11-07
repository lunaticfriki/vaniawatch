final class AddWatchFormValues {
  const AddWatchFormValues._({
    required this.name,
    required this.brand,
    required this.type,
    required this.category,
    required this.description,
    required this.tagList,
    required this.complicationList,
  });

  factory AddWatchFormValues.create({
    required String name,
    required String brand,
    required String type,
    required String category,
    required String description,
    required String tags,
    required String complications,
  }) => AddWatchFormValues._(
    name: name,
    brand: brand,
    type: type,
    category: category,
    description: description,
    tagList: _split(tags),
    complicationList: _split(complications),
  );

  static List<String> _split(String text) => List.unmodifiable(
    text.split(',').map((item) => item.trim()).where((item) => item.isNotEmpty),
  );

  final String name;
  final String brand;
  final String type;
  final String category;
  final String description;
  final List<String> tagList;
  final List<String> complicationList;
}
