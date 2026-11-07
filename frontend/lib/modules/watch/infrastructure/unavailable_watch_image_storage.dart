import 'package:core/core.dart';
import 'package:frontend/modules/watch/application/watch_image.dart';
import 'package:frontend/modules/watch/application/watch_image_storage.dart';

final class UnavailableWatchImageStorage implements WatchImageStorage {
  const UnavailableWatchImageStorage();

  @override
  bool get isAvailable => false;

  @override
  Future<WatchImageUrl> upload(WatchImage image) => Future.error(
    const WatchImageUploadFailedException('image uploads are not configured'),
  );
}
