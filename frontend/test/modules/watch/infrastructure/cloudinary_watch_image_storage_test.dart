import 'dart:convert';

import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/modules/watch/application/watch_image_storage.dart';
import 'package:frontend/modules/watch/infrastructure/cloudinary_config.dart';
import 'package:frontend/modules/watch/infrastructure/cloudinary_watch_image_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import '../application/watch_image_mother.dart';

void main() {
  group('CloudinaryWatchImageStorage', () {
    final config = CloudinaryConfig.create(
      cloudName: 'demo',
      uploadPreset: 'watches',
    );
    const secureUrl =
        'https://res.cloudinary.com/demo/image/upload/v1/watches/abc.jpg';

    CloudinaryWatchImageStorage storageAnswering(
      Future<http.Response> Function(http.Request request) answer,
    ) => CloudinaryWatchImageStorage(MockClient(answer), config);

    test('is available', () {
      expect(
        storageAnswering((_) async => http.Response('', 200)).isAvailable,
        isTrue,
      );
    });

    test(
      'uploads the file with the preset and returns its secure url',
      () async {
        final image = WatchImageMother.random(fileName: 'moonwatch.jpg');
        late http.Request sent;
        final storage = storageAnswering((request) async {
          sent = request;
          return http.Response(jsonEncode({'secure_url': secureUrl}), 200);
        });

        final url = await storage.upload(image);

        expect(url, WatchImageUrl.create(secureUrl));
        expect(sent.method, 'POST');
        expect(sent.url, config.uploadUri);
        expect(sent.headers['content-type'], startsWith('multipart/form-data'));
        final body = latin1.decode(sent.bodyBytes);
        expect(body, contains('name="upload_preset"'));
        expect(body, contains('watches'));
        expect(body, contains('name="file"; filename="moonwatch.jpg"'));
      },
    );

    test('fails when cloudinary rejects the upload', () {
      final storage = storageAnswering(
        (_) async => http.Response('{"error":{"message":"bad preset"}}', 400),
      );

      expect(
        () => storage.upload(WatchImageMother.random()),
        throwsA(isA<WatchImageUploadFailedException>()),
      );
    });

    test('fails when cloudinary cannot be reached', () {
      final storage = storageAnswering(
        (_) async => throw http.ClientException('offline'),
      );

      expect(
        () => storage.upload(WatchImageMother.random()),
        throwsA(isA<WatchImageUploadFailedException>()),
      );
    });

    test('fails when the answer has no usable url', () {
      final storage = storageAnswering(
        (_) async => http.Response('{"public_id":"abc"}', 200),
      );

      expect(
        () => storage.upload(WatchImageMother.random()),
        throwsA(isA<WatchImageUploadFailedException>()),
      );
    });
  });
}
