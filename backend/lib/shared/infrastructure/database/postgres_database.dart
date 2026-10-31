import 'package:backend/shared/infrastructure/database/database_config.dart';
import 'package:postgres/postgres.dart';

abstract final class PostgresDatabase {
  static Pool<void> connect(DatabaseConfig config) => Pool.withEndpoints(
    [
      Endpoint(
        host: config.host,
        port: config.port,
        database: config.name,
        username: config.user,
        password: config.password,
      ),
    ],
    settings: const PoolSettings(sslMode: SslMode.disable),
  );
}
