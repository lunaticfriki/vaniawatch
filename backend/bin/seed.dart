import 'dart:io';

import 'package:backend/composition_root.dart';
import 'package:backend/modules/watch/application/watch_seed_catalog.dart';
import 'package:backend/modules/watch/application/watch_seeder.dart';
import 'package:backend/shared/infrastructure/database/database_config.dart';
import 'package:backend/shared/infrastructure/database/postgres_database.dart';
import 'package:backend/shared/infrastructure/database/postgres_migrator.dart';
import 'package:backend/shared/infrastructure/system_clock_service.dart';

Future<void> main() async {
  final config = DatabaseConfig.fromEnvironment(Platform.environment);
  final database = PostgresDatabase.connect(config);
  try {
    await PostgresMigrator(database).migrate();
    final watch = watchServices(
      database: database,
      clock: const SystemClockService(),
    );
    final count = await WatchSeederImpl(
      read: watch.read,
      write: watch.write,
    ).seed(WatchSeedCatalog.all);
    stdout
      ..writeln('✓ seeded $count watches into ${config.name}')
      ..writeln('  collector X-User-Id: ${WatchSeedCatalog.collectorId}')
      ..writeln('  newcomer  X-User-Id: ${WatchSeedCatalog.newcomerId}');
  } finally {
    await database.close();
  }
}
