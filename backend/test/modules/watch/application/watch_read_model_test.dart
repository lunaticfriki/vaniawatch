import 'package:backend/modules/watch/application/watch_read_model.dart';
import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:test/test.dart';

void main() {
  group('WatchReadModel', () {
    test('flattens a watch into primitives', () {
      final watch = WatchMother.restored(tags: WatchTagsMother.of(['diver']));

      final model = WatchReadModel.fromDomain(watch);

      expect(model.id, watch.id.value);
      expect(model.ownerId, watch.owner.value);
      expect(model.name, watch.name.value);
      expect(model.description, watch.description.value);
      expect(model.brand, watch.brand.value);
      expect(model.type, watch.type.value);
      expect(model.category, watch.category.value);
      expect(model.tags, ['diver']);
      expect(model.complications, watch.complications);
      expect(model.imageUrl, watch.imageUrl.value);
      expect(model.createdAt, watch.createdAt.value);
      expect(model.updatedAt, watch.updatedAt.value);
    });

    test('has no image url when the watch has no image', () {
      final model = WatchReadModel.fromDomain(WatchMother.withoutImage());

      expect(model.imageUrl, isNull);
    });

    test('lists cannot be modified', () {
      final model = WatchReadModel.fromDomain(WatchMother.random());

      expect(() => model.tags.add('x'), throwsUnsupportedError);
      expect(() => model.complications.add('x'), throwsUnsupportedError);
    });

    test('is equal to another read model of the same watch state', () {
      final watch = WatchMother.restored();

      expect(
        WatchReadModel.fromDomain(watch),
        WatchReadModel.fromDomain(watch),
      );
      expect(
        WatchReadModel.fromDomain(watch).hashCode,
        WatchReadModel.fromDomain(watch).hashCode,
      );
    });

    test('is not equal once the watch changes', () {
      final watch = WatchMother.restored();
      final before = WatchReadModel.fromDomain(watch);

      watch.rename(
        WatchName.create('${PrimitiveMother.word()} renamed'),
        at: UpdatedAtMother.after(watch.updatedAt),
      );

      expect(WatchReadModel.fromDomain(watch), isNot(before));
    });
  });
}
