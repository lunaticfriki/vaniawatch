import 'dart:io';

import 'package:backend/composition_root.dart';
import 'package:backend/shared/infrastructure/database/database_config.dart';
import 'package:backend/shared/infrastructure/database/postgres_database.dart';
import 'package:backend/shared/infrastructure/database/postgres_migrator.dart';
import 'package:backend/shared/infrastructure/system_clock_service.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:postgres/postgres.dart';

late final Pool<void> _database;

Future<void> init(InternetAddress ip, int port) async {
  _database = PostgresDatabase.connect(
    DatabaseConfig.fromEnvironment(Platform.environment),
  );
  await PostgresMigrator(_database).migrate();
}

Future<HttpServer> run(Handler handler, InternetAddress ip, int port) => serve(
  handler.use(
    compositionRoot(database: _database, clock: const SystemClockService()),
  ),
  ip,
  port,
);
