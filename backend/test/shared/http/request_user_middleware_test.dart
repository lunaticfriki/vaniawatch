import 'dart:io';

import 'package:backend/shared/http/request_user.dart';
import 'package:backend/shared/http/request_user_middleware.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../support/mocks.dart';

void main() {
  group('requestUserMiddleware', () {
    late MockRequestContext context;
    late MockRequestContext provided;

    setUpAll(() => registerFallbackValue(() => RequestUser.create('fallback')));

    setUp(() {
      context = MockRequestContext();
      provided = MockRequestContext();
      when(() => context.provide<RequestUser>(any())).thenReturn(provided);
    });

    Request requestWith(Map<String, String> headers) =>
        Request.get(Uri.parse('http://localhost/watches'), headers: headers);

    test('provides the user from the X-User-Id header', () async {
      when(() => context.request)
          .thenReturn(requestWith({'x-user-id': ' user-1 '}));
      RequestContext? received;
      final handler = requestUserMiddleware()((inner) {
        received = inner;
        return Response();
      });

      await handler(context);

      final create =
          verify(() => context.provide<RequestUser>(captureAny()))
                  .captured
                  .single
              as RequestUser Function();
      expect(create().id, 'user-1');
      expect(received, provided);
    });

    test('responds 401 without the header', () async {
      when(() => context.request).thenReturn(requestWith({}));
      final handler = requestUserMiddleware()((_) => Response());

      final response = await handler(context);

      expect(response.statusCode, HttpStatus.unauthorized);
      verifyNever(() => context.provide<RequestUser>(any()));
    });

    test('responds 401 with a blank header', () async {
      when(() => context.request).thenReturn(requestWith({'x-user-id': '  '}));
      final handler = requestUserMiddleware()((_) => Response());

      final response = await handler(context);

      expect(response.statusCode, HttpStatus.unauthorized);
    });
  });
}
