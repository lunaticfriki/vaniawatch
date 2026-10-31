import 'package:backend/modules/watch/application/command/update_watch_command_handler.dart';
import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../support/mocks.dart';
import '../update_watch_command_mother.dart';

void main() {
  group('UpdateWatchCommandHandler', () {
    late MockWatchRepository repository;
    late MockClockService clock;
    late UpdateWatchCommandHandler handler;
    late Watch watch;
    late DateTime now;

    setUpAll(() {
      registerFallbackValue(WatchMother.empty());
      registerFallbackValue(WatchId.empty());
    });

    setUp(() {
      repository = MockWatchRepository();
      clock = MockClockService();
      handler = UpdateWatchCommandHandler(repository, clock);
      watch = WatchMother.restored();
      now = watch.updatedAt.value.add(const Duration(minutes: 5));
      when(() => clock.now()).thenReturn(now);
      when(() => repository.findById(watch.id)).thenAnswer((_) async => watch);
      when(() => repository.save(any())).thenAnswer((_) async {});
    });

    test('replaces every editable field and saves the watch', () async {
      final command = UpdateWatchCommandMother.random(
        id: watch.id.value,
        ownerId: watch.owner.value,
        tags: ['dress'],
        complications: ['moon phase'],
        imageUrl: '',
      );

      await handler.handle(command);

      expect(watch.name, WatchName.create(command.name));
      expect(watch.description, WatchDescription.create(command.description));
      expect(watch.brand, WatchBrand.create(command.brand));
      expect(watch.type, WatchType.create(command.type));
      expect(watch.category, WatchCategory.create(command.category));
      expect(watch.tags, WatchTagsMother.of(['dress']));
      expect(watch.complications, ['moon phase']);
      expect(watch.imageUrl.isEmpty, isTrue);
      expect(watch.updatedAt, UpdatedAt.create(now));
      verify(() => repository.save(watch)).called(1);
    });

    test('keeps the identity, owner and creation moment', () async {
      final id = watch.id;
      final owner = watch.owner;
      final createdAt = watch.createdAt;

      await handler.handle(
        UpdateWatchCommandMother.random(
          id: watch.id.value,
          ownerId: watch.owner.value,
        ),
      );

      expect(watch.id, id);
      expect(watch.owner, owner);
      expect(watch.createdAt, createdAt);
    });

    test('fails when the watch does not exist', () async {
      when(() => repository.findById(any())).thenAnswer((_) async => null);

      await expectLater(
        handler.handle(UpdateWatchCommandMother.random()),
        throwsA(isA<WatchNotFoundError>()),
      );
      verifyNever(() => repository.save(any()));
    });

    test('treats a watch of another user as not found', () async {
      await expectLater(
        handler.handle(
          UpdateWatchCommandMother.random(
            id: watch.id.value,
            ownerId: UserIdMother.random().value,
          ),
        ),
        throwsA(isA<WatchNotFoundError>()),
      );
      verifyNever(() => repository.save(any()));
    });

    test('rejects invalid data and leaves the watch untouched', () async {
      final name = watch.name;
      final updatedAt = watch.updatedAt;

      await expectLater(
        handler.handle(
          UpdateWatchCommandMother.random(
            id: watch.id.value,
            ownerId: watch.owner.value,
            category: 'solar',
          ),
        ),
        throwsA(isA<InvalidWatchCategoryError>()),
      );
      expect(watch.name, name);
      expect(watch.updatedAt, updatedAt);
      verifyNever(() => repository.save(any()));
    });
  });
}
