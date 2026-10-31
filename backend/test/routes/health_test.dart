import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../routes/health.dart' as route;
import '../support/mocks.dart';

void main() {
  group('/health', () {
    test('GET responds ok', () async {
      final context = MockRequestContext();
      when(() => context.request)
          .thenReturn(Request.get(Uri.parse('http://localhost/health')));

      final response = route.onRequest(context);

      expect(response.statusCode, HttpStatus.ok);
      expect(await response.json(), {'status': 'ok'});
    });

    test('other methods are not allowed', () {
      final context = MockRequestContext();
      when(() => context.request)
          .thenReturn(Request.post(Uri.parse('http://localhost/health')));

      expect(route.onRequest(context).statusCode, HttpStatus.methodNotAllowed);
    });
  });
}
