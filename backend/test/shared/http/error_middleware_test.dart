import 'dart:io';

import 'package:backend/shared/http/error_middleware.dart';
import 'package:backend/shared/http/invalid_request_error.dart';
import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:test/test.dart';

import '../../support/mocks.dart';

void main() {
  group('errorMiddleware', () {
    late List<Object> logged;

    setUp(() => logged = []);

    Future<Response> respond(Object error) async {
      final handler =
          errorMiddleware(log: (Object error, _) => logged.add(error))(
            (_) => Error.throwWithStackTrace(error, StackTrace.current),
          );
      return handler(MockRequestContext());
    }

    test('lets successful responses through', () async {
      final handler = errorMiddleware()((_) => Response(body: 'ok'));

      final response = await handler(MockRequestContext());

      expect(response.statusCode, HttpStatus.ok);
    });

    test('an invalid request is a 400', () async {
      final response = await respond(const InvalidRequestError('bad body'));

      expect(response.statusCode, HttpStatus.badRequest);
      expect(await response.json(), {'error': 'bad body'});
    });

    test('expected errors are not logged', () async {
      await respond(const InvalidRequestError('bad body'));
      await respond(WatchNotFoundError(WatchIdMother.random()));

      expect(logged, isEmpty);
    });

    test('a not found error is a 404', () async {
      final error = WatchNotFoundError(WatchIdMother.random());

      final response = await respond(error);

      expect(response.statusCode, HttpStatus.notFound);
      expect(await response.json(), {'error': error.message});
    });

    test('an update moment conflict is a 409', () async {
      final response = await respond(
        InvalidUpdatedAtError(DateTime.utc(2024), DateTime.utc(2025)),
      );

      expect(response.statusCode, HttpStatus.conflict);
    });

    test('any other domain error is a 400', () async {
      final response = await respond(const InvalidWatchTypeError('smart'));

      expect(response.statusCode, HttpStatus.badRequest);
      expect(
        await response.json(),
        {'error': const InvalidWatchTypeError('smart').message},
      );
    });

    test('an unexpected error is a 500 that hides the details', () async {
      final response = await respond(StateError('database password leaked'));

      expect(response.statusCode, HttpStatus.internalServerError);
      expect(await response.json(), {'error': 'Internal server error'});
      expect(logged.single, isA<StateError>());
    });
  });
}
