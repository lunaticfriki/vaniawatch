import 'package:core/core.dart';
import 'package:test/test.dart';

void main() {
  group('WatchCategory', () {
    test('has two categories', () {
      expect(WatchCategory.mechanical().value, 'mechanical');
      expect(WatchCategory.quartz().value, 'quartz');
    });

    test('is created from its value ignoring case and surrounding spaces', () {
      expect(WatchCategory.create('mechanical'), WatchCategory.mechanical());
      expect(WatchCategory.create(' QUARTZ '), WatchCategory.quartz());
    });

    test('rejects an unknown category', () {
      expect(
        () => WatchCategory.create(''),
        throwsA(isA<InvalidWatchCategoryError>()),
      );
      expect(
        () => WatchCategory.create('solar'),
        throwsA(isA<InvalidWatchCategoryError>()),
      );
    });

    test('invalid category is a domain error', () {
      expect(() => WatchCategory.create('solar'), throwsA(isA<DomainError>()));
    });

    test('knows which category it is', () {
      expect(WatchCategory.mechanical().isMechanical, isTrue);
      expect(WatchCategory.mechanical().isQuartz, isFalse);
      expect(WatchCategory.quartz().isQuartz, isTrue);
      expect(WatchCategory.quartz().isMechanical, isFalse);
    });

    test('is equal to the same category', () {
      expect(WatchCategory.quartz(), WatchCategory.quartz());
      expect(WatchCategory.quartz().hashCode, WatchCategory.quartz().hashCode);
      expect(WatchCategory.quartz(), isNot(WatchCategory.mechanical()));
    });
  });
}
