import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:test/test.dart';

void main() {
  group('UserEmail', () {
    test('is created from a valid email', () {
      final value = PrimitiveMother.email();

      expect(UserEmail.create(value).value, value);
    });

    test('is trimmed and lowercased', () {
      final value = PrimitiveMother.email();

      expect(UserEmail.create('  ${value.toUpperCase()}  ').value, value);
    });

    test('rejects a blank email', () {
      expect(() => UserEmail.create(''), throwsA(isA<InvalidUserEmailError>()));
      expect(
        () => UserEmail.create('   '),
        throwsA(isA<InvalidUserEmailError>()),
      );
    });

    test('rejects malformed emails', () {
      for (final value in [
        'plainaddress',
        'missing-domain@',
        '@missing-local.com',
        'no-tld@domain',
        'two@@at.com',
        'with space@domain.com',
      ]) {
        expect(
          () => UserEmail.create(value),
          throwsA(isA<InvalidUserEmailError>()),
          reason: value,
        );
      }
    });

    test('invalid email is a domain error', () {
      expect(() => UserEmail.create(''), throwsA(isA<DomainError>()));
    });

    test('empty is empty', () {
      expect(UserEmail.empty().isEmpty, isTrue);
      expect(UserEmailMother.random().isEmpty, isFalse);
    });

    test('is equal to the same email regardless of case', () {
      final value = PrimitiveMother.email();

      expect(UserEmail.create(value), UserEmail.create(value.toUpperCase()));
      expect(
        UserEmail.create(value).hashCode,
        UserEmail.create(value.toUpperCase()).hashCode,
      );
    });
  });
}
