import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:test/test.dart';

void main() {
  group('WatchTags', () {
    test('keeps the given tags in order', () {
      final values = PrimitiveMother.uniqueWords(3);

      final tags = WatchTagsMother.of(values);

      expect(tags.values.map((tag) => tag.value), values);
      expect(tags.length, 3);
    });

    test('removes duplicated tags', () {
      final tags = WatchTagsMother.of(['diver', 'Diver', 'vintage']);

      expect(tags.values, [
        WatchTag.create('diver'),
        WatchTag.create('vintage'),
      ]);
    });

    test('accepts up to 20 tags', () {
      expect(WatchTagsMother.random(count: 20).length, 20);
    });

    test('rejects more than 20 tags', () {
      expect(
        () => WatchTagsMother.random(count: 21),
        throwsA(isA<InvalidWatchTagsError>()),
      );
    });

    test('invalid tags are a domain error', () {
      expect(
        () => WatchTagsMother.random(count: 21),
        throwsA(isA<DomainError>()),
      );
    });

    test('values cannot be modified from outside', () {
      final tags = WatchTagsMother.random();

      expect(
        () => tags.values.add(WatchTagMother.random()),
        throwsUnsupportedError,
      );
    });

    test('knows whether it contains a tag', () {
      final tags = WatchTagsMother.of(['diver']);

      expect(tags.contains(WatchTag.create('DIVER')), isTrue);
      expect(tags.contains(WatchTag.create('dress')), isFalse);
    });

    test('adding a tag returns new tags and leaves the original untouched', () {
      final original = WatchTagsMother.of(['diver']);

      final updated = original.add(WatchTag.create('vintage'));

      expect(updated, WatchTagsMother.of(['diver', 'vintage']));
      expect(original, WatchTagsMother.of(['diver']));
    });

    test('adding an existing tag changes nothing', () {
      final tags = WatchTagsMother.of(['diver']);

      expect(tags.add(WatchTag.create('Diver')), tags);
    });

    test('adding a tag beyond the limit is rejected', () {
      final tags = WatchTagsMother.random(count: 20);

      expect(
        () => tags.add(WatchTag.create('${PrimitiveMother.word()}-extra')),
        throwsA(isA<InvalidWatchTagsError>()),
      );
    });

    test(
      'removing a tag returns new tags and leaves the original untouched',
      () {
        final original = WatchTagsMother.of(['diver', 'vintage']);

        final updated = original.remove(WatchTag.create('diver'));

        expect(updated, WatchTagsMother.of(['vintage']));
        expect(original, WatchTagsMother.of(['diver', 'vintage']));
      },
    );

    test('empty has no tags', () {
      expect(WatchTags.empty().isEmpty, isTrue);
      expect(WatchTags.empty().length, 0);
      expect(WatchTagsMother.random().isEmpty, isFalse);
    });

    test('is equal to the same tags in any order', () {
      expect(
        WatchTagsMother.of(['diver', 'vintage']),
        WatchTagsMother.of(['vintage', 'diver']),
      );
      expect(
        WatchTagsMother.of(['diver', 'vintage']).hashCode,
        WatchTagsMother.of(['vintage', 'diver']).hashCode,
      );
    });

    test('is not equal to different tags', () {
      expect(
        WatchTagsMother.of(['diver']),
        isNot(WatchTagsMother.of(['dress'])),
      );
    });
  });
}
