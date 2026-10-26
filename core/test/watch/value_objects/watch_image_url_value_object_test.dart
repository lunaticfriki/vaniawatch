import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:test/test.dart';

void main() {
  group('WatchImageUrl', () {
    test('is created from an https url', () {
      final value = PrimitiveMother.url();

      expect(WatchImageUrl.create(value).value, value);
    });

    test('accepts an http url', () {
      expect(
        WatchImageUrl.create('http://images.example.com/watch.png').value,
        'http://images.example.com/watch.png',
      );
    });

    test('is trimmed', () {
      final value = PrimitiveMother.url();

      expect(WatchImageUrl.create('  $value  ').value, value);
    });

    test('rejects invalid urls', () {
      for (final value in [
        '',
        '   ',
        'not a url',
        '/images/watch.jpg',
        'ftp://example.com/watch.jpg',
        'https://',
      ]) {
        expect(
          () => WatchImageUrl.create(value),
          throwsA(isA<InvalidWatchImageUrlError>()),
          reason: value,
        );
      }
    });

    test('invalid url is a domain error', () {
      expect(
        () => WatchImageUrl.create('not a url'),
        throwsA(isA<DomainError>()),
      );
    });

    test('empty means there is no image', () {
      expect(WatchImageUrl.empty().isEmpty, isTrue);
      expect(WatchImageUrlMother.random().isEmpty, isFalse);
    });

    test('is equal to another url with the same value', () {
      final value = PrimitiveMother.url();

      expect(WatchImageUrl.create(value), WatchImageUrl.create(value));
      expect(
        WatchImageUrl.create(value).hashCode,
        WatchImageUrl.create(value).hashCode,
      );
    });
  });
}
