import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/modules/watch/infrastructure/cloudinary_config.dart';

void main() {
  group('CloudinaryConfig', () {
    test('is configured with a cloud name and an upload preset', () {
      final config = CloudinaryConfig.create(
        cloudName: 'demo',
        uploadPreset: 'watches',
      );

      expect(config.isConfigured, isTrue);
      expect(
        config.uploadUri,
        Uri.parse('https://api.cloudinary.com/v1_1/demo/image/upload'),
      );
      expect(config.uploadPreset, 'watches');
    });

    test('is not configured when either value is blank', () {
      expect(
        CloudinaryConfig.create(
          cloudName: ' ',
          uploadPreset: 'watches',
        ).isConfigured,
        isFalse,
      );
      expect(
        CloudinaryConfig.create(
          cloudName: 'demo',
          uploadPreset: '',
        ).isConfigured,
        isFalse,
      );
    });

    test('is not configured without dart defines', () {
      expect(CloudinaryConfig.fromEnvironment().isConfigured, isFalse);
    });
  });
}
