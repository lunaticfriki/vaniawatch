import 'dart:convert';

import 'package:frontend/modules/watch/application/watch_image.dart';

abstract final class WatchImageMother {
  static const String _onePixelPng =
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII=';

  static WatchImage random({String fileName = 'speedmaster.png'}) =>
      WatchImage.create(bytes: base64Decode(_onePixelPng), fileName: fileName);
}
