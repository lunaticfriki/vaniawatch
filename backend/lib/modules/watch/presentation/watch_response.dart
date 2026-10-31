import 'package:backend/modules/watch/application/watch_read_model.dart';

abstract final class WatchResponse {
  static Map<String, Object?> fromReadModel(WatchReadModel model) => {
    'id': model.id,
    'name': model.name,
    'description': model.description,
    'brand': model.brand,
    'type': model.type,
    'category': model.category,
    'tags': model.tags,
    'complications': model.complications,
    'imageUrl': model.imageUrl,
    'createdAt': model.createdAt.toIso8601String(),
    'updatedAt': model.updatedAt.toIso8601String(),
  };

  static List<Map<String, Object?>> fromReadModels(
    List<WatchReadModel> models,
  ) => models.map(fromReadModel).toList();
}
