import 'package:backend/modules/watch/application/command/create_watch_command.dart';
import 'package:backend/modules/watch/application/command/delete_watch_command.dart';
import 'package:backend/modules/watch/application/query/list_watches_query.dart';
import 'package:backend/modules/watch/application/watch_seeder.dart';
import 'package:core/testing.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../support/mocks.dart';
import 'create_watch_command_mother.dart';
import 'watch_read_model_mother.dart';

void main() {
  group('WatchSeederImpl', () {
    late MockWatchReadService readService;
    late MockWatchWriteService writeService;
    late WatchSeeder seeder;

    setUpAll(() {
      registerFallbackValue(CreateWatchCommandMother.random());
      registerFallbackValue(ListWatchesQuery.create(ownerId: ''));
      registerFallbackValue(DeleteWatchCommand.create(id: '', ownerId: ''));
    });

    setUp(() {
      readService = MockWatchReadService();
      writeService = MockWatchWriteService();
      seeder = WatchSeederImpl(read: readService, write: writeService);
      when(() => readService.list(any())).thenAnswer((_) async => []);
      when(() => writeService.delete(any())).thenAnswer((_) async {});
      when(
        () => writeService.create(any()),
      ).thenAnswer((_) async => WatchIdMother.random().value);
    });

    test('creates every watch of the seed and returns the count', () async {
      final commands = List.generate(
        3,
        (_) => CreateWatchCommandMother.random(),
      );

      final count = await seeder.seed(commands);

      expect(count, commands.length);
      final created = verify(
        () => writeService.create(captureAny()),
      ).captured.cast<CreateWatchCommand>();
      expect(created, commands);
    });

    test('deletes the current watches of every seeded owner first', () async {
      final ownerId = UserIdMother.random().value;
      final existing = WatchReadModelMother.many(count: 2);
      when(
        () => readService.list(
          any(
            that: isA<ListWatchesQuery>().having(
              (query) => query.ownerId,
              'ownerId',
              ownerId,
            ),
          ),
        ),
      ).thenAnswer((_) async => existing);
      final calls = <String>[];
      when(
        () => writeService.delete(any()),
      ).thenAnswer((_) async => calls.add('delete'));
      when(() => writeService.create(any())).thenAnswer((_) async {
        calls.add('create');
        return WatchIdMother.random().value;
      });

      await seeder.seed([
        CreateWatchCommandMother.random(ownerId: ownerId),
        CreateWatchCommandMother.random(ownerId: ownerId),
      ]);

      final deleted = verify(
        () => writeService.delete(captureAny()),
      ).captured.cast<DeleteWatchCommand>();
      expect(deleted.map((command) => command.id), [
        for (final watch in existing) watch.id,
      ]);
      expect(deleted.map((command) => command.ownerId).toSet(), {ownerId});
      verify(() => readService.list(any())).called(1);
      expect(calls, ['delete', 'delete', 'create', 'create']);
    });

    test('lists the watches of each distinct owner once', () async {
      final first = UserIdMother.random().value;
      final second = UserIdMother.random().value;

      await seeder.seed([
        CreateWatchCommandMother.random(ownerId: first),
        CreateWatchCommandMother.random(ownerId: second),
        CreateWatchCommandMother.random(ownerId: first),
      ]);

      final owners = verify(
        () => readService.list(captureAny()),
      ).captured.cast<ListWatchesQuery>().map((query) => query.ownerId);
      expect(owners, [first, second]);
    });
  });
}
