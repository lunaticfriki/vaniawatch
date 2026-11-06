import 'package:core/core.dart';
import 'package:core/testing.dart';

abstract final class WatchJsonMother {
  static Map<String, dynamic> fromWatch(Watch watch) => {
    'id': watch.id.value,
    'name': watch.name.value,
    'description': watch.description.value,
    'brand': watch.brand.value,
    'type': watch.type.value,
    'category': watch.category.value,
    'tags': watch.tags.values.map((tag) => tag.value).toList(),
    'complications': watch.complications,
    'imageUrl': watch.imageUrl.isEmpty ? null : watch.imageUrl.value,
    'createdAt': watch.createdAt.value.toUtc().toIso8601String(),
    'updatedAt': watch.updatedAt.value.toUtc().toIso8601String(),
  };

  static Map<String, dynamic> random() => fromWatch(WatchMother.restored());
}
