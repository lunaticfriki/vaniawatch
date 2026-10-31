import 'package:backend/modules/watch/infrastructure/acl/watch_mapper.dart';
import 'package:core/core.dart';
import 'package:postgres/postgres.dart';

final class PostgresWatchRepository implements WatchRepository {
  const PostgresWatchRepository(this._database);

  final Session _database;

  static const String _columns =
      'id::text, owner_id::text, name, description, brand, type, category, '
      'tags, complications, image_url, created_at, updated_at';

  @override
  Future<Watch?> findById(WatchId id) async {
    final rows = await _database.execute(
      Sql.named('SELECT $_columns FROM watches WHERE id = @id:uuid'),
      parameters: {'id': id.value},
    );
    return rows.isEmpty ? null : WatchMapper.toDomain(rows.first.toColumnMap());
  }

  @override
  Future<List<Watch>> findByOwner(UserId owner) async {
    final rows = await _database.execute(
      Sql.named(
        'SELECT $_columns FROM watches WHERE owner_id = @owner_id:uuid '
        'ORDER BY created_at DESC, id',
      ),
      parameters: {'owner_id': owner.value},
    );
    return rows.map((row) => WatchMapper.toDomain(row.toColumnMap())).toList();
  }

  @override
  Future<void> save(Watch watch) => _database.execute(
    Sql.named('''
INSERT INTO watches (
  id, owner_id, name, description, brand, type, category,
  tags, complications, image_url, created_at, updated_at
) VALUES (
  @id:uuid, @owner_id:uuid, @name:text, @description:text, @brand:text,
  @type:text, @category:text, @tags:_text, @complications:_text,
  @image_url:text, @created_at:timestamptz, @updated_at:timestamptz
)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  brand = EXCLUDED.brand,
  type = EXCLUDED.type,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  complications = EXCLUDED.complications,
  image_url = EXCLUDED.image_url,
  updated_at = EXCLUDED.updated_at
'''),
    parameters: WatchMapper.toRow(watch),
  );

  @override
  Future<void> delete(WatchId id) => _database.execute(
    Sql.named('DELETE FROM watches WHERE id = @id:uuid'),
    parameters: {'id': id.value},
  );
}
