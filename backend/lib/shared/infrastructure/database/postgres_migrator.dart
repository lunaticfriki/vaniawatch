import 'package:backend/shared/infrastructure/database/postgres_migration.dart';
import 'package:backend/shared/infrastructure/database/postgres_migrations.dart';
import 'package:postgres/postgres.dart';

final class PostgresMigrator {
  const PostgresMigrator(
    this._database, {
    this._migrations = PostgresMigrations.all,
  });

  final Pool<void> _database;
  final List<PostgresMigration> _migrations;

  Future<void> migrate() async {
    await _database.execute('''
CREATE TABLE IF NOT EXISTS schema_migrations (
  version integer PRIMARY KEY,
  name text NOT NULL,
  applied_at timestamptz NOT NULL DEFAULT now()
)''');
    final applied = await _appliedVersions();
    for (final migration in _migrations) {
      if (!applied.contains(migration.version)) {
        await _apply(migration);
      }
    }
  }

  Future<Set<int>> _appliedVersions() async {
    final rows = await _database.execute(
      'SELECT version FROM schema_migrations',
    );
    return rows.map((row) => row.first! as int).toSet();
  }

  Future<void> _apply(PostgresMigration migration) => _database.runTx(
    (transaction) async {
      await transaction.execute(
        migration.sql,
        queryMode: QueryMode.simple,
      );
      await transaction.execute(
        Sql.named(
          'INSERT INTO schema_migrations (version, name) '
          'VALUES (@version:int4, @name:text)',
        ),
        parameters: {'version': migration.version, 'name': migration.name},
      );
    },
  );
}
