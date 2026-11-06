import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

const Map<String, String> _corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type, X-User-Id',
};

Middleware corsMiddleware() =>
    (handler) => (context) async {
      if (context.request.method == HttpMethod.options) {
        return Response(
          statusCode: HttpStatus.noContent,
          headers: _corsHeaders,
        );
      }
      final response = await handler(context);
      return response.copyWith(
        headers: {...response.headers, ..._corsHeaders},
      );
    };
