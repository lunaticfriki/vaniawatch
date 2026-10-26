import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:test/test.dart';

void main() {
  group('WatchTag', () {
    test('is created from a valid tag', () {
      final value = PrimitiveMother.word();

      expect(WatchTag.create(value).value, value);
    });

    test('is trimmed and lowercased', () {
      expect(WatchTag.create('  Diver  ').value, 'diver');
    });

    test('rejects a blank tag', () {
      expect(() => WatchTag.create(''), throwsA(isA<InvalidWatchTagError>()));
      expect(
        () => WatchTag.create('   '),
        throwsA(isA<InvalidWatchTagError>()),
      );
    });

    test('accepts up to 30 characters', () {
      expect(
        WatchTag.create(PrimitiveMother.stringOfLength(30)).value,
        hasLength(30),
      );
    });

    test('rejects more than 30 characters', () {
      expect(
        () => WatchTag.create(PrimitiveMother.stringOfLength(31)),
        throwsA(isA<InvalidWatchTagError>()),
      );
    });

    test('invalid tag is a domain error', () {
      expect(() => WatchTag.create(''), throwsA(isA<DomainError>()));
    });

    test('is equal to the same tag regardless of case', () {
      expect(WatchTag.create('Diver'), WatchTag.create('diver'));
      expect(
        WatchTag.create('Diver').hashCode,
        WatchTag.create('diver').hashCode,
      );
    });

    test('is not equal to a different tag', () {
      expect(
        WatchTagMother.random(),
        isNot(WatchTag.create('${PrimitiveMother.word()}-other')),
      );
    });
  });
}
