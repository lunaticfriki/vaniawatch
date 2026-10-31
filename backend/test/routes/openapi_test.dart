import 'dart:convert';
import 'dart:io';

import 'package:backend/api_document.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../routes/openapi.dart' as route;
import '../support/mocks.dart';

void main() {
  group('/openapi', () {
    test('GET serves the API document as JSON', () async {
      final context = MockRequestContext();
      when(() => context.request)
          .thenReturn(Request.get(Uri.parse('http://localhost/openapi')));

      final response = route.onRequest(context);

      expect(response.statusCode, HttpStatus.ok);
      expect(
        await response.json(),
        jsonDecode(jsonEncode(ApiDocument.build())),
      );
    });

    test('other methods are not allowed', () {
      final context = MockRequestContext();
      when(() => context.request)
          .thenReturn(Request.post(Uri.parse('http://localhost/openapi')));

      expect(route.onRequest(context).statusCode, HttpStatus.methodNotAllowed);
    });
  });
}
