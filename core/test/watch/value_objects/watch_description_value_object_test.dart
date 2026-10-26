import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:test/test.dart';

void main() {
  group('WatchDescription', () {
    test('is created from a valid description', () {
      final value = PrimitiveMother.sentence();

      expect(WatchDescription.create(value).value, value);
    });

    test('is trimmed', () {
      final value = PrimitiveMother.sentence();

      expect(WatchDescription.create('  $value  ').value, value);
    });

    test('a blank description is the empty description', () {
      expect(WatchDescription.create(''), WatchDescription.empty());
      expect(WatchDescription.create('   '), WatchDescription.empty());
      expect(WatchDescription.create('   ').isEmpty, isTrue);
    });

    test('accepts up to 2000 characters', () {
      expect(
        WatchDescription.create(PrimitiveMother.stringOfLength(2000)).value,
        hasLength(2000),
      );
    });

    test('rejects more than 2000 characters', () {
      expect(
        () => WatchDescription.create(PrimitiveMother.stringOfLength(2001)),
        throwsA(isA<InvalidWatchDescriptionError>()),
      );
    });

    test('invalid description is a domain error', () {
      expect(
        () => WatchDescription.create(PrimitiveMother.stringOfLength(2001)),
        throwsA(isA<DomainError>()),
      );
    });

    test('empty is empty', () {
      expect(WatchDescription.empty().isEmpty, isTrue);
      expect(WatchDescriptionMother.random().isEmpty, isFalse);
    });

    test('is equal to another description with the same value', () {
      final value = PrimitiveMother.sentence();

      expect(WatchDescription.create(value), WatchDescription.create(value));
      expect(
        WatchDescription.create(value).hashCode,
        WatchDescription.create(value).hashCode,
      );
    });
  });
}
