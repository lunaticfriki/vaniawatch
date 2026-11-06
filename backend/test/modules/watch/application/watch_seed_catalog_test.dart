import 'package:backend/modules/watch/application/command/create_watch_command_handler.dart';
import 'package:backend/modules/watch/application/watch_seed_catalog.dart';
import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../support/mocks.dart';

void main() {
  group('WatchSeedCatalog', () {
    setUpAll(() => registerFallbackValue(WatchMother.empty()));

    test('every entry is a valid watch', () async {
      final repository = MockWatchRepository();
      final clock = MockClockService();
      when(clock.now).thenReturn(PrimitiveMother.dateTime());
      when(() => repository.save(any())).thenAnswer((_) async {});
      final handler = CreateWatchCommandHandler(repository, clock);

      for (final command in WatchSeedCatalog.all) {
        await handler.handle(command);
      }

      verify(
        () => repository.save(any()),
      ).called(WatchSeedCatalog.all.length);
    });

    test('belongs only to the demo users, each with watches', () {
      final owners = WatchSeedCatalog.all.map((command) => command.ownerId);

      expect(owners.toSet(), {
        WatchSeedCatalog.collectorId,
        WatchSeedCatalog.newcomerId,
      });
    });

    test('uses valid user ids for the demo users', () {
      expect(
        () => [
          UserId.create(WatchSeedCatalog.collectorId),
          UserId.create(WatchSeedCatalog.newcomerId),
        ],
        returnsNormally,
      );
    });
  });
}
