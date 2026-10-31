import 'package:backend/shared/infrastructure/database/database_config.dart';
import 'package:test/test.dart';

void main() {
  group('DatabaseConfig', () {
    test('reads the connection from the environment', () {
      final config = DatabaseConfig.fromEnvironment({
        'DATABASE_HOST': 'db',
        'DATABASE_PORT': '6543',
        'DATABASE_NAME': 'watches',
        'DATABASE_USER': 'owner',
        'DATABASE_PASSWORD': 'secret',
      });

      expect(config.host, 'db');
      expect(config.port, 6543);
      expect(config.name, 'watches');
      expect(config.user, 'owner');
      expect(config.password, 'secret');
    });

    test('falls back to the local development defaults', () {
      final config = DatabaseConfig.fromEnvironment({});

      expect(config.host, 'localhost');
      expect(config.port, 5432);
      expect(config.name, 'vaniawatch');
      expect(config.user, 'vaniawatch');
      expect(config.password, 'vaniawatch');
    });

    test('rejects a port that is not a number', () {
      expect(
        () => DatabaseConfig.fromEnvironment({'DATABASE_PORT': 'abc'}),
        throwsFormatException,
      );
    });

    test('tests use the test database unless told otherwise', () {
      expect(DatabaseConfig.forTests({}).name, 'vaniawatch_test');
      expect(
        DatabaseConfig.forTests({'TEST_DATABASE_NAME': 'other'}).name,
        'other',
      );
    });
  });
}
