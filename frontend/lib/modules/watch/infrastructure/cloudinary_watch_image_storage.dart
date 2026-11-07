import 'dart:convert';

import 'package:core/core.dart';
import 'package:frontend/modules/watch/application/watch_image.dart';
import 'package:frontend/modules/watch/application/watch_image_storage.dart';
import 'package:frontend/modules/watch/infrastructure/cloudinary_config.dart';
import 'package:http/http.dart' as http;

final class CloudinaryWatchImageStorage implements WatchImageStorage {
  const CloudinaryWatchImageStorage(this._client, this._config);

  static const int _ok = 200;

  final http.Client _client;
  final CloudinaryConfig _config;

  @override
  bool get isAvailable => true;

  @override
  Future<WatchImageUrl> upload(WatchImage image) async {
    final request = http.MultipartRequest('POST', _config.uploadUri)
      ..fields['upload_preset'] = _config.uploadPreset
      ..files.add(
        http.MultipartFile.fromBytes(
          'file',
          image.bytes,
          filename: image.fileName,
        ),
      );
    final http.Response response;
    try {
      response = await http.Response.fromStream(await _client.send(request));
    } on http.ClientException catch (error) {
      throw WatchImageUploadFailedException(error);
    }
    if (response.statusCode != _ok) {
      throw WatchImageUploadFailedException(
        'Cloudinary answered ${response.statusCode}',
      );
    }
    return _secureUrlOf(response.body);
  }

  WatchImageUrl _secureUrlOf(String body) {
    try {
      final json = jsonDecode(body) as Map<String, dynamic>;
      return WatchImageUrl.create(json['secure_url'] as String);
    } on Object catch (error) {
      throw WatchImageUploadFailedException(error);
    }
  }
}
