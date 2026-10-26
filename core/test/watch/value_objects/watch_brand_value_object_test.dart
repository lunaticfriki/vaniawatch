import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:test/test.dart';

void main() {
  group('WatchBrand', () {
    test('is created from a valid brand', () {
      expect(WatchBrand.create('Seiko').value, 'Seiko');
    });

    test('is trimmed', () {
      expect(WatchBrand.create('  Grand Seiko  ').value, 'Grand Seiko');
    });

    test('rejects a blank brand', () {
      expect(
        () => WatchBrand.create(''),
        throwsA(isA<InvalidWatchBrandError>()),
      );
      expect(
        () => WatchBrand.create('   '),
        throwsA(isA<InvalidWatchBrandError>()),
      );
    });

    test('accepts up to 50 characters', () {
      expect(
        WatchBrand.create(PrimitiveMother.stringOfLength(50)).value,
        hasLength(50),
      );
    });

    test('rejects more than 50 characters', () {
      expect(
        () => WatchBrand.create(PrimitiveMother.stringOfLength(51)),
        throwsA(isA<InvalidWatchBrandError>()),
      );
    });

    test('invalid brand is a domain error', () {
      expect(() => WatchBrand.create(''), throwsA(isA<DomainError>()));
    });

    test('empty is empty', () {
      expect(WatchBrand.empty().isEmpty, isTrue);
      expect(WatchBrandMother.random().isEmpty, isFalse);
    });

    test('is equal to another brand with the same value', () {
      expect(WatchBrand.create('Casio'), WatchBrand.create('Casio'));
      expect(
        WatchBrand.create('Casio').hashCode,
        WatchBrand.create('Casio').hashCode,
      );
    });
  });
}
