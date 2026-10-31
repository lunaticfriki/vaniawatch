import 'package:backend/modules/watch/application/command/create_watch_command_handler.dart';
import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../support/mocks.dart';
import '../create_watch_command_mother.dart';

void main() {
  group('CreateWatchCommandHandler', () {
    late MockWatchRepository repository;
    late MockClockService clock;
    late CreateWatchCommandHandler handler;
    late DateTime now;

    setUpAll(() => registerFallbackValue(WatchMother.empty()));

    setUp(() {
      repository = MockWatchRepository();
      clock = MockClockService();
      handler = CreateWatchCommandHandler(repository, clock);
      now = PrimitiveMother.dateTime();
      when(() => clock.now()).thenReturn(now);
      when(() => repository.save(any())).thenAnswer((_) async {});
    });

    test('creates the watch from the command and saves it', () async {
      final command = CreateWatchCommandMother.random(
        tags: ['diver', 'vintage'],
        complications: ['date', 'gmt'],
      );

      await handler.handle(command);

      final saved =
          verify(() => repository.save(captureAny())).captured.single as Watch;
      expect(saved.owner, UserId.create(command.ownerId));
      expect(saved.name, WatchName.create(command.name));
      expect(saved.description, WatchDescription.create(command.description));
      expect(saved.brand, WatchBrand.create(command.brand));
      expect(saved.type, WatchType.create(command.type));
      expect(saved.category, WatchCategory.create(command.category));
      expect(saved.tags, WatchTagsMother.of(['diver', 'vintage']));
      expect(saved.complications, ['date', 'gmt']);
      expect(saved.imageUrl, WatchImageUrl.create(command.imageUrl));
      expect(saved.createdAt, CreatedAt.create(now));
      expect(saved.updatedAt, UpdatedAt.create(now));
    });

    test('returns the id of the new watch', () async {
      final id = await handler.handle(CreateWatchCommandMother.random());

      final saved =
          verify(() => repository.save(captureAny())).captured.single as Watch;
      expect(id, saved.id.value);
      expect(saved.id.isEmpty, isFalse);
    });

    test('a blank image url means the watch has no image', () async {
      await handler.handle(CreateWatchCommandMother.random(imageUrl: ''));

      final saved =
          verify(() => repository.save(captureAny())).captured.single as Watch;
      expect(saved.imageUrl.isEmpty, isTrue);
    });

    test('rejects invalid data and saves nothing', () async {
      await expectLater(
        handler.handle(CreateWatchCommandMother.random(type: 'smart')),
        throwsA(isA<InvalidWatchTypeError>()),
      );
      verifyNever(() => repository.save(any()));
    });

    test('rejects an invalid owner and saves nothing', () async {
      await expectLater(
        handler.handle(CreateWatchCommandMother.random(ownerId: 'nobody')),
        throwsA(isA<InvalidUserIdError>()),
      );
      verifyNever(() => repository.save(any()));
    });
  });
}
