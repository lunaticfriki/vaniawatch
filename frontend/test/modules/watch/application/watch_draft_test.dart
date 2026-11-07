import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/modules/watch/application/watch_draft.dart';

void main() {
  group('WatchDraft', () {
    test('builds every field through the domain value objects', () {
      final draft = WatchDraft.create(
        name: '  Speedmaster  ',
        brand: 'Omega',
        type: 'Analog',
        category: 'mechanical',
        description: 'Moonwatch',
        tags: const ['chrono', 'Chrono', 'space'],
        complications: const ['chronograph'],
      );

      expect(draft.name, WatchName.create('Speedmaster'));
      expect(draft.brand, WatchBrand.create('Omega'));
      expect(draft.type, WatchType.analog());
      expect(draft.category, WatchCategory.mechanical());
      expect(draft.description, WatchDescription.create('Moonwatch'));
      expect(
        draft.tags,
        WatchTags.create([WatchTag.create('chrono'), WatchTag.create('space')]),
      );
      expect(draft.complications, ['chronograph']);
      expect(draft.imageUrl.isEmpty, isTrue);
    });

    test('collects every invalid field in one rejection', () {
      expect(
        () => WatchDraft.create(
          name: '',
          brand: '',
          type: 'sundial',
          category: 'solar',
          description: '',
          tags: const ['ok', ''],
          complications: const [],
        ),
        throwsA(
          isA<WatchDraftRejectedException>().having(
            (error) => error.errors.map((e) => e.runtimeType).toList(),
            'errors',
            [
              InvalidWatchNameError,
              InvalidWatchBrandError,
              InvalidWatchTypeError,
              InvalidWatchCategoryError,
              InvalidWatchTagError,
            ],
          ),
        ),
      );
    });

    test('rejects too many tags', () {
      expect(
        () => WatchDraft.create(
          name: WatchNameMother.random().value,
          brand: WatchBrandMother.random().value,
          type: WatchTypeMother.random().value,
          category: WatchCategoryMother.random().value,
          description: '',
          tags: [for (var i = 0; i <= WatchTags.maxLength; i++) 'tag$i'],
          complications: const [],
        ),
        throwsA(
          isA<WatchDraftRejectedException>().having(
            (error) => error.errors.single,
            'error',
            isA<InvalidWatchTagsError>(),
          ),
        ),
      );
    });

    test('sets the image on a copy', () {
      final draft = WatchDraft.create(
        name: 'Speedmaster',
        brand: 'Omega',
        type: 'analog',
        category: 'mechanical',
        description: '',
        tags: const [],
        complications: const [],
      );
      final imageUrl = WatchImageUrlMother.random();

      final withImage = draft.withImage(imageUrl);

      expect(withImage.imageUrl, imageUrl);
      expect(withImage.name, draft.name);
      expect(draft.imageUrl.isEmpty, isTrue);
    });

    test('offers the types and categories the domain accepts', () {
      expect(WatchDraft.types, ['analog', 'digital', 'anadigi']);
      expect(WatchDraft.categories, ['mechanical', 'quartz']);
      for (final type in WatchDraft.types) {
        expect(WatchType.create(type).value, type);
      }
      for (final category in WatchDraft.categories) {
        expect(WatchCategory.create(category).value, category);
      }
    });
  });
}
