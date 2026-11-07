import 'package:frontend/modules/watch/application/watch_image.dart';

abstract class WatchImagePicker {
  Future<WatchImage?> pick();
}
