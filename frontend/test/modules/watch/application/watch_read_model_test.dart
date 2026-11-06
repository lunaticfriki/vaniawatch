import 'package:core/testing.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/modules/watch/application/watch_read_model.dart';

void main() {
  group('WatchReadModel', () {
    test('flattens a watch', () {
      final watch = WatchMother.restored();

      final model = WatchReadModel.fromDomain(watch);

      expect(model.id, watch.id.value);
      expect(model.name, watch.name.value);
      expect(model.description, watch.description.value);
      expect(model.brand, watch.brand.value);
      expect(model.type, watch.type.value);
      expect(model.category, watch.category.value);
      expect(model.tags, watch.tags.values.map((tag) => tag.value));
      expect(model.complications, watch.complications);
      expect(model.imageUrl, watch.imageUrl.value);
      expect(model.createdAt, watch.createdAt.value);
    });

    test('has no image url when the watch has no image', () {
      final model = WatchReadModel.fromDomain(WatchMother.withoutImage());

      expect(model.imageUrl, isNull);
    });
  });
}
