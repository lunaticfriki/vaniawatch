import 'package:backend/modules/watch/presentation/watch_response.dart';
import 'package:test/test.dart';

import '../application/watch_read_model_mother.dart';

void main() {
  group('WatchResponse', () {
    test('serializes a read model without the owner', () {
      final model = WatchReadModelMother.random();

      expect(WatchResponse.fromReadModel(model), {
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
      });
    });

    test('serializes a list of read models in order', () {
      final models = WatchReadModelMother.many();

      expect(
        WatchResponse.fromReadModels(models),
        models.map(WatchResponse.fromReadModel).toList(),
      );
    });
  });
}
