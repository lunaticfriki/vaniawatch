import 'package:core/core.dart';
import 'package:test/test.dart';

void main() {
  group('WatchType', () {
    test('has three types', () {
      expect(WatchType.analog().value, 'analog');
      expect(WatchType.digital().value, 'digital');
      expect(WatchType.anaDigi().value, 'anadigi');
    });

    test('is created from its value ignoring case and surrounding spaces', () {
      expect(WatchType.create('analog'), WatchType.analog());
      expect(WatchType.create(' DIGITAL '), WatchType.digital());
      expect(WatchType.create('AnaDigi'), WatchType.anaDigi());
    });

    test('rejects an unknown type', () {
      expect(() => WatchType.create(''), throwsA(isA<InvalidWatchTypeError>()));
      expect(
        () => WatchType.create('smart'),
        throwsA(isA<InvalidWatchTypeError>()),
      );
    });

    test('invalid type is a domain error', () {
      expect(() => WatchType.create('smart'), throwsA(isA<DomainError>()));
    });

    test('knows which type it is', () {
      expect(WatchType.analog().isAnalog, isTrue);
      expect(WatchType.analog().isDigital, isFalse);
      expect(WatchType.digital().isDigital, isTrue);
      expect(WatchType.digital().isAnaDigi, isFalse);
      expect(WatchType.anaDigi().isAnaDigi, isTrue);
      expect(WatchType.anaDigi().isAnalog, isFalse);
    });

    test('is equal to the same type', () {
      expect(WatchType.analog(), WatchType.analog());
      expect(WatchType.analog().hashCode, WatchType.analog().hashCode);
      expect(WatchType.analog(), isNot(WatchType.digital()));
    });
  });
}
