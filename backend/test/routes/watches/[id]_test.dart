import 'dart:convert';
import 'dart:io';

import 'package:backend/modules/watch/application/command/delete_watch_command.dart';
import 'package:backend/modules/watch/application/command/update_watch_command.dart';
import 'package:backend/modules/watch/application/query/get_watch_query.dart';
import 'package:backend/modules/watch/application/watch_read_service.dart';
import 'package:backend/modules/watch/application/watch_write_service.dart';
import 'package:backend/modules/watch/presentation/watch_response.dart';
import 'package:backend/shared/http/request_user.dart';
import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../routes/watches/[id].dart' as route;
import '../../modules/watch/application/update_watch_command_mother.dart';
import '../../modules/watch/application/watch_read_model_mother.dart';
import '../../support/mocks.dart';

void main() {
  group('/watches/[id]', () {
    late MockRequestContext context;
    late MockWatchReadService readService;
    late MockWatchWriteService writeService;
    late String userId;
    late String watchId;
    late Uri uri;

    setUpAll(() {
      registerFallbackValue(
        GetWatchQuery.create(id: 'fallback', ownerId: 'fallback'),
      );
      registerFallbackValue(UpdateWatchCommandMother.random());
      registerFallbackValue(
        DeleteWatchCommand.create(id: 'fallback', ownerId: 'fallback'),
      );
    });

    setUp(() {
      context = MockRequestContext();
      readService = MockWatchReadService();
      writeService = MockWatchWriteService();
      userId = UserIdMother.random().value;
      watchId = WatchIdMother.random().value;
      uri = Uri.parse('http://localhost/watches/$watchId');
      when(() => context.read<RequestUser>())
          .thenReturn(RequestUser.create(userId));
      when(() => context.read<WatchReadService>()).thenReturn(readService);
      when(() => context.read<WatchWriteService>()).thenReturn(writeService);
    });

    test('GET returns the watch of the request user', () async {
      final model = WatchReadModelMother.random();
      when(() => context.request).thenReturn(Request.get(uri));
      when(() => readService.getById(any())).thenAnswer((_) async => model);

      final response = await route.onRequest(context, watchId);

      expect(response.statusCode, HttpStatus.ok);
      expect(
        await response.json(),
        jsonDecode(jsonEncode(WatchResponse.fromReadModel(model))),
      );
      final query =
          verify(() => readService.getById(captureAny())).captured.single
              as GetWatchQuery;
      expect(query.id, watchId);
      expect(query.ownerId, userId);
    });

    test('GET lets a not found error reach the error middleware', () async {
      when(() => context.request).thenReturn(Request.get(uri));
      when(() => readService.getById(any()))
          .thenThrow(WatchNotFoundError(WatchId.create(watchId)));

      await expectLater(
        route.onRequest(context, watchId),
        throwsA(isA<WatchNotFoundError>()),
      );
    });

    test('PUT replaces the watch of the request user', () async {
      when(() => context.request).thenReturn(
        Request.put(
          uri,
          body: jsonEncode({
            'name': 'Speedmaster',
            'brand': 'Omega',
            'type': 'analog',
            'category': 'mechanical',
          }),
        ),
      );
      when(() => writeService.update(any())).thenAnswer((_) async {});

      final response = await route.onRequest(context, watchId);

      expect(response.statusCode, HttpStatus.noContent);
      final command =
          verify(() => writeService.update(captureAny())).captured.single
              as UpdateWatchCommand;
      expect(command.id, watchId);
      expect(command.ownerId, userId);
      expect(command.name, 'Speedmaster');
    });

    test('DELETE removes the watch of the request user', () async {
      when(() => context.request).thenReturn(Request.delete(uri));
      when(() => writeService.delete(any())).thenAnswer((_) async {});

      final response = await route.onRequest(context, watchId);

      expect(response.statusCode, HttpStatus.noContent);
      final command =
          verify(() => writeService.delete(captureAny())).captured.single
              as DeleteWatchCommand;
      expect(command.id, watchId);
      expect(command.ownerId, userId);
    });

    test('other methods are not allowed', () async {
      when(() => context.request).thenReturn(Request.post(uri));

      final response = await route.onRequest(context, watchId);

      expect(response.statusCode, HttpStatus.methodNotAllowed);
    });
  });
}
