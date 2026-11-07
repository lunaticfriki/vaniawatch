import 'package:core/core.dart';
import 'package:frontend/modules/watch/application/watch_image.dart';

abstract class WatchImageStorage {
  bool get isAvailable;

  Future<WatchImageUrl> upload(WatchImage image);
}

final class WatchImageUploadFailedException implements Exception {
  const WatchImageUploadFailedException([this.cause]);

  final Object? cause;

  @override
  String toString() => 'The image could not be uploaded: $cause';
}
