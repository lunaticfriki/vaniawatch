import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:test/test.dart';

void main() {
  group('UserName', () {
    test('is created from a valid name', () {
      final value = PrimitiveMother.word();

      expect(UserName.create(value).value, value);
    });

    test('is trimmed', () {
      final value = PrimitiveMother.word();

      expect(UserName.create('  $value  ').value, value);
    });

    test('rejects a blank name', () {
      expect(() => UserName.create(''), throwsA(isA<InvalidUserNameError>()));
      expect(
        () => UserName.create('   '),
        throwsA(isA<InvalidUserNameError>()),
      );
    });

    test('accepts between 2 and 50 characters', () {
      expect(
        UserName.create(PrimitiveMother.stringOfLength(2)).value,
        hasLength(2),
      );
      expect(
        UserName.create(PrimitiveMother.stringOfLength(50)).value,
        hasLength(50),
      );
    });

    test('rejects fewer than 2 characters', () {
      expect(
        () => UserName.create(PrimitiveMother.stringOfLength(1)),
        throwsA(isA<InvalidUserNameError>()),
      );
    });

    test('rejects more than 50 characters', () {
      expect(
        () => UserName.create(PrimitiveMother.stringOfLength(51)),
        throwsA(isA<InvalidUserNameError>()),
      );
    });

    test('invalid name is a domain error', () {
      expect(() => UserName.create(''), throwsA(isA<DomainError>()));
    });

    test('empty is empty', () {
      expect(UserName.empty().isEmpty, isTrue);
      expect(UserNameMother.random().isEmpty, isFalse);
    });

    test('is equal to another name with the same value', () {
      final value = PrimitiveMother.word();

      expect(UserName.create(value), UserName.create(value));
      expect(UserName.create(value).hashCode, UserName.create(value).hashCode);
    });
  });
}
