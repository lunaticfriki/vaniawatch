import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:test/test.dart';

void main() {
  group('UpdatedAt', () {
    test('stores the moment in UTC', () {
      final local = DateTime(2024, 5, 10, 12, 30);

      final updatedAt = UpdatedAt.create(local);

      expect(updatedAt.value.isUtc, isTrue);
      expect(updatedAt.value, local.toUtc());
    });

    test('now is the current moment', () {
      final before = DateTime.now().toUtc();

      final updatedAt = UpdatedAt.now();

      final after = DateTime.now().toUtc();
      expect(updatedAt.value.isBefore(before), isFalse);
      expect(updatedAt.value.isAfter(after), isFalse);
    });

    test('starts at the creation moment', () {
      final createdAt = CreatedAtMother.random();

      final updatedAt = UpdatedAt.fromCreatedAt(createdAt);

      expect(updatedAt.value, createdAt.value);
    });

    test('empty is the unix epoch', () {
      final updatedAt = UpdatedAt.empty();

      expect(
        updatedAt.value,
        DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      );
      expect(updatedAt.isEmpty, isTrue);
    });

    test('knows when it is before another update', () {
      final updatedAt = UpdatedAtMother.random();

      expect(UpdatedAtMother.before(updatedAt).isBefore(updatedAt), isTrue);
      expect(UpdatedAtMother.after(updatedAt).isBefore(updatedAt), isFalse);
      expect(updatedAt.isBefore(updatedAt), isFalse);
    });

    test('knows when it is before the creation moment', () {
      final createdAt = CreatedAtMother.random();

      expect(
        UpdatedAtMother.beforeCreation(createdAt).isBeforeCreation(createdAt),
        isTrue,
      );
      expect(
        UpdatedAtMother.afterCreation(createdAt).isBeforeCreation(createdAt),
        isFalse,
      );
      expect(
        UpdatedAt.fromCreatedAt(createdAt).isBeforeCreation(createdAt),
        isFalse,
      );
    });

    test('is equal to another updated at for the same moment', () {
      final moment = PrimitiveMother.dateTime();

      expect(UpdatedAt.create(moment), UpdatedAt.create(moment));
      expect(
        UpdatedAt.create(moment).hashCode,
        UpdatedAt.create(moment).hashCode,
      );
    });
  });
}
