import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:test/test.dart';

void main() {
  group('Watch', () {
    group('create', () {
      test('keeps the given values', () {
        final id = WatchIdMother.random();
        final owner = UserIdMother.random();
        final name = WatchNameMother.random();
        final description = WatchDescriptionMother.random();
        final brand = WatchBrandMother.random();
        final type = WatchTypeMother.random();
        final category = WatchCategoryMother.random();
        final tags = WatchTagsMother.random();
        final complications = WatchComplicationsMother.random();
        final imageUrl = WatchImageUrlMother.random();
        final createdAt = CreatedAtMother.random();

        final watch = Watch.create(
          id: id,
          owner: owner,
          name: name,
          description: description,
          brand: brand,
          type: type,
          category: category,
          tags: tags,
          complications: complications,
          imageUrl: imageUrl,
          createdAt: createdAt,
        );

        expect(watch.id, id);
        expect(watch.owner, owner);
        expect(watch.name, name);
        expect(watch.description, description);
        expect(watch.brand, brand);
        expect(watch.type, type);
        expect(watch.category, category);
        expect(watch.tags, tags);
        expect(watch.complications, complications);
        expect(watch.imageUrl, imageUrl);
        expect(watch.createdAt, createdAt);
      });

      test('starts with the update moment equal to the creation moment', () {
        final createdAt = CreatedAtMother.random();

        final watch = WatchMother.random(createdAt: createdAt);

        expect(watch.updatedAt, UpdatedAt.fromCreatedAt(createdAt));
      });

      test('can have no description, tags, complications or image', () {
        final watch = WatchMother.random(
          description: WatchDescriptionMother.empty(),
          tags: WatchTagsMother.empty(),
          complications: WatchComplicationsMother.empty(),
          imageUrl: WatchImageUrlMother.empty(),
        );

        expect(watch.description.isEmpty, isTrue);
        expect(watch.tags.isEmpty, isTrue);
        expect(watch.complications.isEmpty, isTrue);
        expect(watch.imageUrl.isEmpty, isTrue);
      });
    });

    group('restore', () {
      test('keeps the given update moment', () {
        final createdAt = CreatedAtMother.random();
        final updatedAt = UpdatedAtMother.afterCreation(createdAt);

        final watch = WatchMother.restored(
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

        expect(watch.createdAt, createdAt);
        expect(watch.updatedAt, updatedAt);
      });

      test('rejects an update moment before the creation moment', () {
        final createdAt = CreatedAtMother.random();

        expect(
          () => WatchMother.restored(
            createdAt: createdAt,
            updatedAt: UpdatedAtMother.beforeCreation(createdAt),
          ),
          throwsA(isA<InvalidUpdatedAtError>()),
        );
      });
    });

    group('ownership', () {
      test('is owned by its owner', () {
        final owner = UserIdMother.random();

        expect(WatchMother.ownedBy(owner).isOwnedBy(owner), isTrue);
      });

      test('is not owned by another user', () {
        expect(WatchMother.random().isOwnedBy(UserIdMother.random()), isFalse);
      });
    });

    group('changes', () {
      test('rename changes the name and the update moment', () {
        final watch = WatchMother.random();
        final name = WatchNameMother.random();
        final at = UpdatedAtMother.after(watch.updatedAt);

        watch.rename(name, at: at);

        expect(watch.name, name);
        expect(watch.updatedAt, at);
      });

      test('describe changes the description and the update moment', () {
        final watch = WatchMother.random();
        final description = WatchDescriptionMother.random();
        final at = UpdatedAtMother.after(watch.updatedAt);

        watch.describe(description, at: at);

        expect(watch.description, description);
        expect(watch.updatedAt, at);
      });

      test('rebrand changes the brand and the update moment', () {
        final watch = WatchMother.random();
        final brand = WatchBrand.create('${PrimitiveMother.word()} Watches');
        final at = UpdatedAtMother.after(watch.updatedAt);

        watch.rebrand(brand, at: at);

        expect(watch.brand, brand);
        expect(watch.updatedAt, at);
      });

      test('changeType changes the type and the update moment', () {
        final watch = WatchMother.random(type: WatchType.analog());
        final at = UpdatedAtMother.after(watch.updatedAt);

        watch.changeType(WatchType.digital(), at: at);

        expect(watch.type, WatchType.digital());
        expect(watch.updatedAt, at);
      });

      test('changeCategory changes the category and the update moment', () {
        final watch = WatchMother.random(category: WatchCategory.mechanical());
        final at = UpdatedAtMother.after(watch.updatedAt);

        watch.changeCategory(WatchCategory.quartz(), at: at);

        expect(watch.category, WatchCategory.quartz());
        expect(watch.updatedAt, at);
      });

      test('retag replaces the tags and changes the update moment', () {
        final watch = WatchMother.random();
        final tags = WatchTagsMother.of(['${PrimitiveMother.word()}-new']);
        final at = UpdatedAtMother.after(watch.updatedAt);

        watch.retag(tags, at: at);

        expect(watch.tags, tags);
        expect(watch.updatedAt, at);
      });

      test('changeComplications replaces the complications and changes the update moment', () {
        final watch = WatchMother.random(complications: ['date']);
        final complications = ['chronograph', 'gmt'];
        final at = UpdatedAtMother.after(watch.updatedAt);

        watch.changeComplications(complications, at: at);

        expect(watch.complications, complications);
        expect(watch.updatedAt, at);
      });

      test('complications cannot be modified from outside', () {
        final watch = WatchMother.random();

        expect(() => watch.complications.add('alarm'), throwsUnsupportedError);
      });

      test('keeps its own copy of the complications it receives', () {
        final complications = ['date'];
        final watch = WatchMother.random(complications: complications);

        complications.add('gmt');
        watch.changeComplications(
          complications,
          at: UpdatedAtMother.after(watch.updatedAt),
        );
        complications.add('alarm');

        expect(watch.complications, ['date', 'gmt']);
      });

      test('changeImage replaces the image and changes the update moment', () {
        final watch = WatchMother.withoutImage();
        final imageUrl = WatchImageUrlMother.random();
        final at = UpdatedAtMother.after(watch.updatedAt);

        watch.changeImage(imageUrl, at: at);

        expect(watch.imageUrl, imageUrl);
        expect(watch.updatedAt, at);
      });

      final changes = <String, void Function(Watch watch, UpdatedAt at)>{
        'rename': (watch, at) => watch.rename(WatchNameMother.random(), at: at),
        'describe': (watch, at) =>
            watch.describe(WatchDescriptionMother.random(), at: at),
        'rebrand': (watch, at) =>
            watch.rebrand(WatchBrandMother.random(), at: at),
        'changeType': (watch, at) =>
            watch.changeType(WatchTypeMother.random(), at: at),
        'changeCategory': (watch, at) =>
            watch.changeCategory(WatchCategoryMother.random(), at: at),
        'retag': (watch, at) => watch.retag(WatchTagsMother.random(), at: at),
        'changeComplications': (watch, at) => watch.changeComplications(
          WatchComplicationsMother.random(),
          at: at,
        ),
        'changeImage': (watch, at) =>
            watch.changeImage(WatchImageUrlMother.random(), at: at),
      };

      for (final MapEntry(key: name, value: change) in changes.entries) {
        test(
          '$name rejects a moment before the last update and changes nothing',
          () {
            final watch = WatchMother.restored();
            final before = WatchMother.restored(
              id: watch.id,
              owner: watch.owner,
              name: watch.name,
              description: watch.description,
              brand: watch.brand,
              type: watch.type,
              category: watch.category,
              tags: watch.tags,
              complications: watch.complications,
              imageUrl: watch.imageUrl,
              createdAt: watch.createdAt,
              updatedAt: watch.updatedAt,
            );

            expect(
              () => change(watch, UpdatedAtMother.before(watch.updatedAt)),
              throwsA(isA<InvalidUpdatedAtError>()),
            );
            expect(watch.name, before.name);
            expect(watch.description, before.description);
            expect(watch.brand, before.brand);
            expect(watch.type, before.type);
            expect(watch.category, before.category);
            expect(watch.tags, before.tags);
            expect(watch.complications, before.complications);
            expect(watch.imageUrl, before.imageUrl);
            expect(watch.updatedAt, before.updatedAt);
          },
        );
      }
    });

    group('equality', () {
      test('is equal to a watch with the same id', () {
        final id = WatchIdMother.random();

        expect(WatchMother.random(id: id), WatchMother.random(id: id));
        expect(
          WatchMother.random(id: id).hashCode,
          WatchMother.random(id: id).hashCode,
        );
      });

      test('is not equal to a watch with a different id', () {
        expect(WatchMother.random(), isNot(WatchMother.random()));
      });
    });

    group('empty', () {
      test('is empty', () {
        expect(WatchMother.empty().isEmpty, isTrue);
      });

      test('a created watch is not empty', () {
        expect(WatchMother.random().isEmpty, isFalse);
      });
    });
  });
}
