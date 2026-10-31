import 'package:backend/modules/watch/infrastructure/acl/watch_mapper.dart';
import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:test/test.dart';

import '../../../../support/watch_matchers.dart';

void main() {
  group('WatchMapper', () {
    test('maps a watch to a row with the column names', () {
      final watch = WatchMother.restored(tags: WatchTagsMother.of(['diver']));

      final row = WatchMapper.toRow(watch);

      expect(row, {
        'id': watch.id.value,
        'owner_id': watch.owner.value,
        'name': watch.name.value,
        'description': watch.description.value,
        'brand': watch.brand.value,
        'type': watch.type.value,
        'category': watch.category.value,
        'tags': ['diver'],
        'complications': watch.complications,
        'image_url': watch.imageUrl.value,
        'created_at': watch.createdAt.value,
        'updated_at': watch.updatedAt.value,
      });
    });

    test('stores a missing image as null', () {
      expect(
        WatchMapper.toRow(WatchMother.withoutImage())['image_url'],
        isNull,
      );
    });

    test('restores the same watch from its row', () {
      final watch = WatchMother.restored();

      expectSameWatch(WatchMapper.toDomain(WatchMapper.toRow(watch)), watch);
    });

    test('restores a null image as no image', () {
      final watch = WatchMother.withoutImage();

      final restored = WatchMapper.toDomain(WatchMapper.toRow(watch));

      expect(restored.imageUrl.isEmpty, isTrue);
    });

    test('rejects a row that breaks a domain rule', () {
      final row = WatchMapper.toRow(WatchMother.restored())..['type'] = 'smart';

      expect(
        () => WatchMapper.toDomain(row),
        throwsA(isA<InvalidWatchTypeError>()),
      );
    });
  });
}
