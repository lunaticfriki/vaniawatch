import 'dart:convert';
import 'dart:io';

import 'package:backend/modules/watch/application/command/create_watch_command.dart';
import 'package:backend/modules/watch/application/query/list_watches_query.dart';
import 'package:backend/modules/watch/application/watch_read_service.dart';
import 'package:backend/modules/watch/application/watch_write_service.dart';
import 'package:backend/modules/watch/presentation/watch_response.dart';
import 'package:backend/shared/http/invalid_request_error.dart';
import 'package:backend/shared/http/request_user.dart';
import 'package:core/testing.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../routes/watches/index.dart' as route;
import '../../modules/watch/application/create_watch_command_mother.dart';
import '../../modules/watch/application/watch_read_model_mother.dart';
import '../../support/mocks.dart';

void main() {
  group('/watches', () {
    late MockRequestContext context;
    late MockWatchReadService readService;
    late MockWatchWriteService writeService;
    late String userId;

    setUpAll(() {
      registerFallbackValue(ListWatchesQuery.create(ownerId: 'fallback'));
      registerFallbackValue(CreateWatchCommandMother.random());
    });

    setUp(() {
      context = MockRequestContext();
      readService = MockWatchReadService();
      writeService = MockWatchWriteService();
      userId = UserIdMother.random().value;
      when(() => context.read<RequestUser>())
          .thenReturn(RequestUser.create(userId));
      when(() => context.read<WatchReadService>()).thenReturn(readService);
      when(() => context.read<WatchWriteService>()).thenReturn(writeService);
    });

    test('GET lists the watches of the request user', () async {
      final models = WatchReadModelMother.many();
      when(() => context.request)
          .thenReturn(Request.get(Uri.parse('http://localhost/watches')));
      when(() => readService.list(any())).thenAnswer((_) async => models);

      final response = await route.onRequest(context);

      expect(response.statusCode, HttpStatus.ok);
      expect(
        await response.json(),
        jsonDecode(jsonEncode(WatchResponse.fromReadModels(models))),
      );
      final query =
          verify(() => readService.list(captureAny())).captured.single
              as ListWatchesQuery;
      expect(query.ownerId, userId);
    });

    test('POST creates a watch for the request user', () async {
      final id = WatchIdMother.random().value;
      when(() => context.request).thenReturn(
        Request.post(
          Uri.parse('http://localhost/watches'),
          body: jsonEncode({
            'name': 'F91W',
            'brand': 'Casio',
            'type': 'digital',
            'category': 'quartz',
            'tags': ['beater'],
          }),
        ),
      );
      when(() => writeService.create(any())).thenAnswer((_) async => id);

      final response = await route.onRequest(context);

      expect(response.statusCode, HttpStatus.created);
      expect(response.headers['location'], '/watches/$id');
      expect(await response.json(), {'id': id});
      final command =
          verify(() => writeService.create(captureAny())).captured.single
              as CreateWatchCommand;
      expect(command.ownerId, userId);
      expect(command.name, 'F91W');
      expect(command.tags, ['beater']);
    });

    test('POST with an invalid body fails before creating anything', () async {
      when(() => context.request).thenReturn(
        Request.post(Uri.parse('http://localhost/watches'), body: '{}'),
      );

      await expectLater(
        route.onRequest(context),
        throwsA(isA<InvalidRequestError>()),
      );
      verifyNever(() => writeService.create(any()));
    });

    test('other methods are not allowed', () async {
      when(() => context.request)
          .thenReturn(Request.delete(Uri.parse('http://localhost/watches')));

      final response = await route.onRequest(context);

      expect(response.statusCode, HttpStatus.methodNotAllowed);
    });
  });
}
