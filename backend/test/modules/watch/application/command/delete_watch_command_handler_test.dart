import 'package:backend/modules/watch/application/command/delete_watch_command.dart';
import 'package:backend/modules/watch/application/command/delete_watch_command_handler.dart';
import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../support/mocks.dart';

void main() {
  group('DeleteWatchCommandHandler', () {
    late MockWatchRepository repository;
    late DeleteWatchCommandHandler handler;
    late Watch watch;

    setUpAll(() => registerFallbackValue(WatchId.empty()));

    setUp(() {
      repository = MockWatchRepository();
      handler = DeleteWatchCommandHandler(repository);
      watch = WatchMother.random();
      when(() => repository.findById(watch.id)).thenAnswer((_) async => watch);
      when(() => repository.delete(any())).thenAnswer((_) async {});
    });

    test('deletes a watch of its owner', () async {
      await handler.handle(
        DeleteWatchCommand.create(
          id: watch.id.value,
          ownerId: watch.owner.value,
        ),
      );

      verify(() => repository.delete(watch.id)).called(1);
    });

    test('fails when the watch does not exist', () async {
      when(() => repository.findById(any())).thenAnswer((_) async => null);

      await expectLater(
        handler.handle(
          DeleteWatchCommand.create(
            id: WatchIdMother.random().value,
            ownerId: UserIdMother.random().value,
          ),
        ),
        throwsA(isA<WatchNotFoundError>()),
      );
      verifyNever(() => repository.delete(any()));
    });

    test('treats a watch of another user as not found', () async {
      await expectLater(
        handler.handle(
          DeleteWatchCommand.create(
            id: watch.id.value,
            ownerId: UserIdMother.random().value,
          ),
        ),
        throwsA(isA<WatchNotFoundError>()),
      );
      verifyNever(() => repository.delete(any()));
    });

    test('rejects an invalid id', () async {
      await expectLater(
        handler.handle(
          DeleteWatchCommand.create(
            id: 'not-an-id',
            ownerId: watch.owner.value,
          ),
        ),
        throwsA(isA<InvalidWatchIdError>()),
      );
    });
  });
}
