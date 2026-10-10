import 'package:test/test.dart';

import '../../../auth/value_objects/__tests__/user_id.mother.dart';
import '../../errors/invalid_watch_category.error.dart';
import '../../errors/invalid_watch_complication.error.dart';
import '../../errors/invalid_watch_brand.error.dart';
import '../../errors/invalid_watch_description.error.dart';
import '../../errors/invalid_watch_image_url.error.dart';
import '../../errors/invalid_watch_model.error.dart';
import '../../errors/invalid_watch_tag.error.dart';
import '../../value_objects/watch_brand.value_object.dart';
import '../../value_objects/watch_category.value_object.dart';
import '../../value_objects/watch_complication.value_object.dart';
import '../../value_objects/watch_description.value_object.dart';
import '../../value_objects/watch_image_url.value_object.dart';
import '../../value_objects/watch_model.value_object.dart';
import '../../value_objects/watch_tag.value_object.dart';
import 'watch.mother.dart';

void main() {
  group('Watch', () {
    test('provides an empty placeholder without collection metadata', () {
      final watch = WatchMother.empty();

      expect(watch.id.value, isEmpty);
      expect(watch.ownerId.value, isEmpty);
      expect(watch.brand.value, isEmpty);
      expect(watch.model.value, isEmpty);
      expect(watch.category.value, isEmpty);
      expect(watch.description, isNull);
      expect(watch.imageUrl, isNull);
      expect(watch.complications, isEmpty);
      expect(watch.tags, isEmpty);
    });

    test('retains its owner as part of the domain identity boundary', () {
      final watch = WatchMother.valid();

      expect(watch.ownerId, UserIdMother.valid());
      expect(watch.brand.value, 'Seiko');
      expect(watch.model.value, 'Prospex');
      expect(watch.category.value, 'Diver');
      expect(watch.description?.value, 'Stainless steel automatic watch.');
      expect(watch.imageUrl?.value, 'https://example.com/watch.jpg');
      expect(watch.complications.map((item) => item.value), ['Chronograph']);
      expect(watch.tags.map((item) => item.value), ['vintage']);
    });

    test('keeps complications and tags immutable', () {
      final watch = WatchMother.valid();

      expect(
        () => watch.complications.add(WatchComplication.create('Moon phase')),
        throwsUnsupportedError,
      );
      expect(
        () => watch.tags.add(WatchTag.create('limited edition')),
        throwsUnsupportedError,
      );
    });

    test('rejects an empty brand', () {
      expect(
        () => WatchBrand.create('  '),
        throwsA(isA<InvalidWatchBrandError>()),
      );
    });

    test('rejects an empty model', () {
      expect(
        () => WatchModel.create('  '),
        throwsA(isA<InvalidWatchModelError>()),
      );
    });

    test('rejects empty category, description, complication, and tag', () {
      expect(
        () => WatchCategory.create('  '),
        throwsA(isA<InvalidWatchCategoryError>()),
      );
      expect(
        () => WatchDescription.create('  '),
        throwsA(isA<InvalidWatchDescriptionError>()),
      );
      expect(
        () => WatchComplication.create('  '),
        throwsA(isA<InvalidWatchComplicationError>()),
      );
      expect(
        () => WatchTag.create('  '),
        throwsA(isA<InvalidWatchTagError>()),
      );
    });

    test('rejects an image URL without an absolute HTTP address', () {
      expect(
        () => WatchImageUrl.create('/images/watch.jpg'),
        throwsA(isA<InvalidWatchImageUrlError>()),
      );
    });
  });
}
