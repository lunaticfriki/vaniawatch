import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../routes/docs.dart' as route;
import '../support/mocks.dart';

void main() {
  group('/docs', () {
    test('GET serves Swagger UI pointing at the API document', () async {
      final context = MockRequestContext();
      when(() => context.request)
          .thenReturn(Request.get(Uri.parse('http://localhost/docs')));

      final response = route.onRequest(context);

      expect(response.statusCode, HttpStatus.ok);
      expect(response.headers['content-type'], startsWith('text/html'));
      final body = await response.body();
      expect(body, contains('swagger-ui-bundle.js'));
      expect(body, contains("url: '/openapi'"));
    });

    test('other methods are not allowed', () {
      final context = MockRequestContext();
      when(() => context.request)
          .thenReturn(Request.post(Uri.parse('http://localhost/docs')));

      expect(route.onRequest(context).statusCode, HttpStatus.methodNotAllowed);
    });
  });
}
