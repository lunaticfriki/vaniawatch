@Tags(['integration'])
library;

import 'dart:io';

import 'package:backend/modules/watch/infrastructure/postgres_watch_repository.dart';
import 'package:backend/shared/infrastructure/database/database_config.dart';
import 'package:backend/shared/infrastructure/database/postgres_database.dart';
import 'package:backend/shared/infrastructure/database/postgres_migrator.dart';
import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:postgres/postgres.dart';
import 'package:test/test.dart';

import '../../../support/watch_matchers.dart';

void main() {
  group('PostgresWatchRepository', () {
    late Pool<void> pool;
    late PostgresWatchRepository repository;

    setUpAll(() async {
      pool = PostgresDatabase.connect(
        DatabaseConfig.forTests(Platform.environment),
      );
      await PostgresMigrator(pool).migrate();
    });

    setUp(() async {
      await pool.execute('TRUNCATE watches');
      repository = PostgresWatchRepository(pool);
    });

    tearDownAll(() => pool.close());

    test('saves a watch and finds it by id', () async {
      final watch = WatchMother.restored();

      await repository.save(watch);

      expectSameWatch((await repository.findById(watch.id))!, watch);
    });

    test('saves a watch without image, tags or complications', () async {
      final watch = WatchMother.restored(
        tags: WatchTagsMother.empty(),
        complications: WatchComplicationsMother.empty(),
        imageUrl: WatchImageUrlMother.empty(),
        description: WatchDescriptionMother.empty(),
      );

      await repository.save(watch);

      expectSameWatch((await repository.findById(watch.id))!, watch);
    });

    test('finds nothing for an unknown id', () async {
      expect(await repository.findById(WatchIdMother.random()), isNull);
    });

    test('saving an existing watch updates it', () async {
      final watch = WatchMother.restored();
      await repository.save(watch);

      watch.rename(
        WatchName.create('${PrimitiveMother.word()} renamed'),
        at: UpdatedAtMother.after(watch.updatedAt),
      );
      await repository.save(watch);

      expectSameWatch((await repository.findById(watch.id))!, watch);
    });

    test('finds only the watches of an owner, newest first', () async {
      final owner = UserIdMother.random();
      final oldest = WatchMother.restored(
        owner: owner,
        createdAt: CreatedAt.create(DateTime.utc(2024)),
      );
      final newest = WatchMother.restored(
        owner: owner,
        createdAt: CreatedAt.create(DateTime.utc(2025)),
      );
      final foreign = WatchMother.restored();
      for (final watch in [oldest, foreign, newest]) {
        await repository.save(watch);
      }

      final found = await repository.findByOwner(owner);

      expect(found.map((watch) => watch.id), [newest.id, oldest.id]);
    });

    test('deletes a watch', () async {
      final watch = WatchMother.restored();
      await repository.save(watch);

      await repository.delete(watch.id);

      expect(await repository.findById(watch.id), isNull);
    });
  });
}
