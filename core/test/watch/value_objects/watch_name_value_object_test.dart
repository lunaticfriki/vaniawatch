import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:test/test.dart';

void main() {
  group('WatchName', () {
    test('is created from a valid name', () {
      final value = PrimitiveMother.words();

      expect(WatchName.create(value).value, value);
    });

    test('is trimmed', () {
      final value = PrimitiveMother.words();

      expect(WatchName.create('  $value  ').value, value);
    });

    test('rejects a blank name', () {
      expect(() => WatchName.create(''), throwsA(isA<InvalidWatchNameError>()));
      expect(
        () => WatchName.create('   '),
        throwsA(isA<InvalidWatchNameError>()),
      );
    });

    test('accepts up to 100 characters', () {
      expect(
        WatchName.create(PrimitiveMother.stringOfLength(100)).value,
        hasLength(100),
      );
    });

    test('rejects more than 100 characters', () {
      expect(
        () => WatchName.create(PrimitiveMother.stringOfLength(101)),
        throwsA(isA<InvalidWatchNameError>()),
      );
    });

    test('invalid name is a domain error', () {
      expect(() => WatchName.create(''), throwsA(isA<DomainError>()));
    });

    test('empty is empty', () {
      expect(WatchName.empty().isEmpty, isTrue);
      expect(WatchNameMother.random().isEmpty, isFalse);
    });

    test('is equal to another name with the same value', () {
      final value = PrimitiveMother.words();

      expect(WatchName.create(value), WatchName.create(value));
      expect(
        WatchName.create(value).hashCode,
        WatchName.create(value).hashCode,
      );
    });
  });
}
