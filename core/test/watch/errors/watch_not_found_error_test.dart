import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:test/test.dart';

void main() {
  group('WatchNotFoundError', () {
    test('is a not found domain error', () {
      final error = WatchNotFoundError(WatchIdMother.random());

      expect(error, isA<NotFoundError>());
      expect(error, isA<DomainError>());
    });

    test('names the missing watch', () {
      final id = WatchIdMother.random();

      expect(WatchNotFoundError(id).message, contains(id.value));
    });
  });
}
