import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:test/test.dart';

void main() {
  group('UserId', () {
    test('is created from a valid uuid', () {
      final value = PrimitiveMother.uuid();

      expect(UserId.create(value).value, value);
    });

    test('is normalized to lowercase', () {
      final value = PrimitiveMother.uuid();

      expect(UserId.create(value.toUpperCase()).value, value);
    });

    test('rejects an empty value', () {
      expect(() => UserId.create(''), throwsA(isA<InvalidUserIdError>()));
    });

    test('rejects a value that is not a uuid', () {
      expect(
        () => UserId.create(PrimitiveMother.word()),
        throwsA(isA<InvalidUserIdError>()),
      );
      expect(
        () => UserId.create('123e4567-e89b-12d3-a456-42661417400'),
        throwsA(isA<InvalidUserIdError>()),
      );
    });

    test('invalid id is a domain error', () {
      expect(() => UserId.create(''), throwsA(isA<DomainError>()));
    });

    test('generates valid and distinct ids', () {
      final first = UserId.generate();
      final second = UserId.generate();

      expect(() => UserId.create(first.value), returnsNormally);
      expect(first, isNot(second));
    });

    test('empty is empty', () {
      expect(UserId.empty().isEmpty, isTrue);
      expect(UserIdMother.random().isEmpty, isFalse);
    });

    test('is equal to another id with the same value', () {
      final value = PrimitiveMother.uuid();

      expect(UserId.create(value), UserId.create(value));
      expect(UserId.create(value).hashCode, UserId.create(value).hashCode);
    });

    test('is not equal to an id with a different value', () {
      expect(UserIdMother.random(), isNot(UserIdMother.random()));
    });
  });
}
