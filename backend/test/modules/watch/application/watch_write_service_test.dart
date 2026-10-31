import 'package:backend/modules/watch/application/command/create_watch_command_handler.dart';
import 'package:backend/modules/watch/application/command/delete_watch_command.dart';
import 'package:backend/modules/watch/application/command/delete_watch_command_handler.dart';
import 'package:backend/modules/watch/application/command/update_watch_command_handler.dart';
import 'package:backend/modules/watch/application/watch_write_service.dart';
import 'package:core/testing.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'create_watch_command_mother.dart';
import 'update_watch_command_mother.dart';

class _MockCreateWatchCommandHandler extends Mock
    implements CreateWatchCommandHandler {}

class _MockUpdateWatchCommandHandler extends Mock
    implements UpdateWatchCommandHandler {}

class _MockDeleteWatchCommandHandler extends Mock
    implements DeleteWatchCommandHandler {}

void main() {
  group('WatchWriteServiceImpl', () {
    late _MockCreateWatchCommandHandler createWatch;
    late _MockUpdateWatchCommandHandler updateWatch;
    late _MockDeleteWatchCommandHandler deleteWatch;
    late WatchWriteService service;

    setUp(() {
      createWatch = _MockCreateWatchCommandHandler();
      updateWatch = _MockUpdateWatchCommandHandler();
      deleteWatch = _MockDeleteWatchCommandHandler();
      service = WatchWriteServiceImpl(
        createWatch: createWatch,
        updateWatch: updateWatch,
        deleteWatch: deleteWatch,
      );
    });

    test('create delegates to the create handler and returns the id', () async {
      final command = CreateWatchCommandMother.random();
      final id = WatchIdMother.random().value;
      when(() => createWatch.handle(command)).thenAnswer((_) async => id);

      expect(await service.create(command), id);
    });

    test('update delegates to the update handler', () async {
      final command = UpdateWatchCommandMother.random();
      when(() => updateWatch.handle(command)).thenAnswer((_) async {});

      await service.update(command);

      verify(() => updateWatch.handle(command)).called(1);
    });

    test('delete delegates to the delete handler', () async {
      final command = DeleteWatchCommand.create(
        id: WatchIdMother.random().value,
        ownerId: UserIdMother.random().value,
      );
      when(() => deleteWatch.handle(command)).thenAnswer((_) async {});

      await service.delete(command);

      verify(() => deleteWatch.handle(command)).called(1);
    });
  });
}
