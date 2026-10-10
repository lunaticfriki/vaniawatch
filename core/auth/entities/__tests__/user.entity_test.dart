import 'package:test/test.dart';

import 'user.mother.dart';

void main() {
  group('User', () {
    test('provides an empty placeholder', () {
      final user = UserMother.empty();

      expect(user.id.value, isEmpty);
      expect(user.email.value, isEmpty);
    });

    test('retains its identity and email', () {
      final user = UserMother.valid();

      expect(user.id.value, 'user-1');
      expect(user.email.value, 'user@example.com');
    });
  });
}
