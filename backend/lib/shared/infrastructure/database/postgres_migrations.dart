import 'package:backend/shared/infrastructure/database/postgres_migration.dart';

abstract final class PostgresMigrations {
  static const List<PostgresMigration> all = [
    PostgresMigration(
      version: 1,
      name: 'create_watches',
      sql: '''
CREATE TABLE watches (
  id uuid PRIMARY KEY,
  owner_id uuid NOT NULL,
  name text NOT NULL,
  description text NOT NULL DEFAULT '',
  brand text NOT NULL,
  type text NOT NULL,
  category text NOT NULL,
  tags text[] NOT NULL DEFAULT '{}',
  complications text[] NOT NULL DEFAULT '{}',
  image_url text,
  created_at timestamptz NOT NULL,
  updated_at timestamptz NOT NULL
);
CREATE INDEX watches_owner_id_created_at_idx ON watches (owner_id, created_at DESC);
''',
    ),
  ];
}
