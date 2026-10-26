import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:test/test.dart';

void main() {
  group('WatchId', () {
    test('is created from a valid uuid', () {
      final value = PrimitiveMother.uuid();

      expect(WatchId.create(value).value, value);
    });

    test('is normalized to lowercase', () {
      final value = PrimitiveMother.uuid();

      expect(WatchId.create(value.toUpperCase()).value, value);
    });

    test('rejects an empty value', () {
      expect(() => WatchId.create(''), throwsA(isA<InvalidWatchIdError>()));
    });

    test('rejects a value that is not a uuid', () {
      expect(
        () => WatchId.create(PrimitiveMother.word()),
        throwsA(isA<InvalidWatchIdError>()),
      );
    });

    test('invalid id is a domain error', () {
      expect(() => WatchId.create(''), throwsA(isA<DomainError>()));
    });

    test('generates valid and distinct ids', () {
      final first = WatchId.generate();
      final second = WatchId.generate();

      expect(() => WatchId.create(first.value), returnsNormally);
      expect(first, isNot(second));
    });

    test('empty is empty', () {
      expect(WatchId.empty().isEmpty, isTrue);
      expect(WatchIdMother.random().isEmpty, isFalse);
    });

    test('is equal to another id with the same value', () {
      final value = PrimitiveMother.uuid();

      expect(WatchId.create(value), WatchId.create(value));
      expect(WatchId.create(value).hashCode, WatchId.create(value).hashCode);
    });
  });
}
