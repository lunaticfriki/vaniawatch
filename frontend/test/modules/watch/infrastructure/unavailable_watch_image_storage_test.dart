import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/modules/watch/application/watch_image_storage.dart';
import 'package:frontend/modules/watch/infrastructure/unavailable_watch_image_storage.dart';

import '../application/watch_image_mother.dart';

void main() {
  group('UnavailableWatchImageStorage', () {
    const storage = UnavailableWatchImageStorage();

    test('is not available', () {
      expect(storage.isAvailable, isFalse);
    });

    test('refuses every upload', () {
      expect(
        () => storage.upload(WatchImageMother.random()),
        throwsA(isA<WatchImageUploadFailedException>()),
      );
    });
  });
}
