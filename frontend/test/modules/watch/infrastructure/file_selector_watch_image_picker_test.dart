import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/modules/watch/infrastructure/file_selector_watch_image_picker.dart';

void main() {
  group('FileSelectorWatchImagePicker', () {
    test('returns the chosen file as a watch image', () async {
      final bytes = Uint8List.fromList(const [1, 2, 3]);
      late List<XTypeGroup> offered;
      final picker = FileSelectorWatchImagePicker(
        openImage: (groups) async {
          offered = groups;
          return XFile.fromData(
            bytes,
            name: 'moonwatch.png',
            path: '/Users/me/Pictures/moonwatch.png',
          );
        },
      );

      final image = await picker.pick();

      expect(image?.bytes, bytes);
      expect(image?.fileName, 'moonwatch.png');
      expect(
        offered.single.extensions,
        containsAll(['jpg', 'jpeg', 'png', 'webp', 'gif', 'heic']),
      );
    });

    test('returns null when the user cancels', () async {
      final picker = FileSelectorWatchImagePicker(openImage: (_) async => null);

      expect(await picker.pick(), isNull);
    });

    test('returns null for an empty file', () async {
      final picker = FileSelectorWatchImagePicker(
        openImage: (_) async => XFile.fromData(Uint8List(0), name: 'empty.png'),
      );

      expect(await picker.pick(), isNull);
    });

    test('names a file without a name', () async {
      final picker = FileSelectorWatchImagePicker(
        openImage: (_) async => XFile.fromData(Uint8List.fromList(const [1])),
      );

      expect(
        (await picker.pick())?.fileName,
        FileSelectorWatchImagePicker.fallbackFileName,
      );
    });
  });
}
