import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/shared/infrastructure/api_config.dart';

void main() {
  group('ApiConfig', () {
    test('defaults to the local api and the seeded collector', () {
      final config = ApiConfig.fromEnvironment();

      expect(config.baseUrl, Uri.parse('http://localhost:8080'));
      expect(config.userId, '00000000-0000-4000-8000-000000000001');
    });

    test('resolves paths against the base url', () {
      final config = ApiConfig.create(
        baseUrl: 'http://api.test/',
        userId: 'user',
      );

      expect(config.uri('/watches'), Uri.parse('http://api.test/watches'));
    });
  });
}
