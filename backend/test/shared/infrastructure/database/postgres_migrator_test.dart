@Tags(['integration'])
library;

import 'dart:io';

import 'package:backend/shared/infrastructure/database/database_config.dart';
import 'package:backend/shared/infrastructure/database/postgres_database.dart';
import 'package:backend/shared/infrastructure/database/postgres_migrations.dart';
import 'package:backend/shared/infrastructure/database/postgres_migrator.dart';
import 'package:postgres/postgres.dart';
import 'package:test/test.dart';

void main() {
  group('PostgresMigrator', () {
    late Pool<void> pool;

    setUpAll(() {
      pool = PostgresDatabase.connect(
        DatabaseConfig.forTests(Platform.environment),
      );
    });

    tearDownAll(() => pool.close());

    test('applies every migration once and records it', () async {
      await PostgresMigrator(pool).migrate();
      await PostgresMigrator(pool).migrate();

      final versions = await pool.execute(
        'SELECT version FROM schema_migrations ORDER BY version',
      );
      expect(
        versions.map((row) => row.first),
        PostgresMigrations.all.map((migration) => migration.version),
      );
    });

    test('creates the watches table', () async {
      await PostgresMigrator(pool).migrate();

      final tables = await pool.execute(
        "SELECT to_regclass('public.watches')::text",
      );
      expect(tables.single.first, 'watches');
    });
  });
}
