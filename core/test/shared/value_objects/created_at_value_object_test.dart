import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:test/test.dart';

void main() {
  group('CreatedAt', () {
    test('stores the moment in UTC', () {
      final local = DateTime(2024, 5, 10, 12, 30);

      final createdAt = CreatedAt.create(local);

      expect(createdAt.value.isUtc, isTrue);
      expect(createdAt.value, local.toUtc());
    });

    test('now is the current moment', () {
      final before = DateTime.now().toUtc();

      final createdAt = CreatedAt.now();

      final after = DateTime.now().toUtc();
      expect(createdAt.value.isBefore(before), isFalse);
      expect(createdAt.value.isAfter(after), isFalse);
    });

    test('empty is the unix epoch', () {
      final createdAt = CreatedAt.empty();

      expect(
        createdAt.value,
        DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      );
      expect(createdAt.isEmpty, isTrue);
    });

    test('is not empty when created from a moment', () {
      expect(CreatedAtMother.random().isEmpty, isFalse);
    });

    test('is equal to another created at for the same moment', () {
      final moment = PrimitiveMother.dateTime();

      expect(CreatedAt.create(moment), CreatedAt.create(moment));
      expect(
        CreatedAt.create(moment).hashCode,
        CreatedAt.create(moment).hashCode,
      );
    });

    test('is not equal to a created at for a different moment', () {
      final moment = PrimitiveMother.dateTime();

      expect(
        CreatedAt.create(moment),
        isNot(CreatedAt.create(moment.add(const Duration(seconds: 1)))),
      );
    });
  });
}
