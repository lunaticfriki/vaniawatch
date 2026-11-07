import 'dart:typed_data';

import 'package:meta/meta.dart';

@immutable
final class WatchImage {
  const WatchImage._({required this.bytes, required this.fileName});

  factory WatchImage.create({
    required Uint8List bytes,
    required String fileName,
  }) {
    if (bytes.isEmpty) {
      throw ArgumentError.value(bytes, 'bytes', 'must not be empty');
    }
    if (fileName.trim().isEmpty) {
      throw ArgumentError.value(fileName, 'fileName', 'must not be blank');
    }
    return WatchImage._(bytes: bytes, fileName: fileName.trim());
  }

  final Uint8List bytes;
  final String fileName;
}
