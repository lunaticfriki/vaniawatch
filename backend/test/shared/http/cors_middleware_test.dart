import 'dart:io';

import 'package:backend/shared/http/cors_middleware.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../support/mocks.dart';

void main() {
  group('corsMiddleware', () {
    late MockRequestContext context;
    late bool reached;
    late Handler handler;

    setUp(() {
      context = MockRequestContext();
      reached = false;
      handler = corsMiddleware()((_) {
        reached = true;
        return Response(statusCode: HttpStatus.created, body: 'inner');
      });
    });

    void stubRequest(HttpMethod method) => when(
      () => context.request,
    ).thenReturn(Request(method.value, Uri.parse('http://localhost/watches')));

    void expectCorsHeaders(Response response) {
      expect(response.headers['access-control-allow-origin'], '*');
      expect(
        response.headers['access-control-allow-methods'],
        'GET, POST, PUT, DELETE, OPTIONS',
      );
      expect(
        response.headers['access-control-allow-headers'],
        'Content-Type, X-User-Id',
      );
    }

    test('adds the cors headers to the inner response', () async {
      stubRequest(HttpMethod.get);

      final response = await handler(context);

      expect(reached, isTrue);
      expect(response.statusCode, HttpStatus.created);
      expect(await response.body(), 'inner');
      expectCorsHeaders(response);
    });

    test('answers a preflight without reaching the routes', () async {
      stubRequest(HttpMethod.options);

      final response = await handler(context);

      expect(reached, isFalse);
      expect(response.statusCode, HttpStatus.noContent);
      expectCorsHeaders(response);
    });
  });
}
