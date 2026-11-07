import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/modules/watch/application/watch_image.dart';

void main() {
  group('WatchImage', () {
    test('keeps the bytes and the file name', () {
      final bytes = Uint8List.fromList(const [1, 2, 3]);

      final image = WatchImage.create(bytes: bytes, fileName: 'watch.png');

      expect(image.bytes, bytes);
      expect(image.fileName, 'watch.png');
    });

    test('rejects empty bytes', () {
      expect(
        () => WatchImage.create(bytes: Uint8List(0), fileName: 'watch.png'),
        throwsArgumentError,
      );
    });

    test('rejects a blank file name', () {
      expect(
        () => WatchImage.create(
          bytes: Uint8List.fromList(const [1]),
          fileName: '  ',
        ),
        throwsArgumentError,
      );
    });
  });
}
