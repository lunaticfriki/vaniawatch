final class PostgresMigration {
  const PostgresMigration({
    required this.version,
    required this.name,
    required this.sql,
  });

  final int version;
  final String name;
  final String sql;
}
