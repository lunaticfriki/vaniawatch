final class DatabaseConfig {
  const DatabaseConfig._({
    required this.host,
    required this.port,
    required this.name,
    required this.user,
    required this.password,
  });

  factory DatabaseConfig.fromEnvironment(Map<String, String> environment) =>
      DatabaseConfig._(
        host: environment['DATABASE_HOST'] ?? 'localhost',
        port: int.parse(environment['DATABASE_PORT'] ?? '5432'),
        name: environment['DATABASE_NAME'] ?? 'vaniawatch',
        user: environment['DATABASE_USER'] ?? 'vaniawatch',
        password: environment['DATABASE_PASSWORD'] ?? 'vaniawatch',
      );

  factory DatabaseConfig.forTests(Map<String, String> environment) =>
      DatabaseConfig.fromEnvironment({
        ...environment,
        'DATABASE_NAME': environment['TEST_DATABASE_NAME'] ?? 'vaniawatch_test',
      });

  final String host;
  final int port;
  final String name;
  final String user;
  final String password;
}
