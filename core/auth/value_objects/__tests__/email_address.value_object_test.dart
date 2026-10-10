import 'package:test/test.dart';

import 'email_address.mother.dart';
import '../email_address.value_object.dart';
import '../../errors/invalid_email_address.error.dart';

void main() {
  group('EmailAddress', () {
    test('trims whitespace and normalizes case', () {
      expect(
        EmailAddress.create('  USER@example.com '),
        EmailAddressMother.valid(),
      );
    });

    test('rejects an invalid email address', () {
      expect(
        () => EmailAddress.create('not-an-email'),
        throwsA(isA<InvalidEmailAddressError>()),
      );
    });
  });
}
