import 'dart:io';

import 'package:backend/shared/http/request_user.dart';
import 'package:dart_frog/dart_frog.dart';

Middleware requestUserMiddleware() =>
    (handler) => (context) {
      final id = context.request.headers[RequestUser.header]?.trim() ?? '';
      if (id.isEmpty) {
        return Response.json(
          statusCode: HttpStatus.unauthorized,
          body: {'error': 'Missing X-User-Id header'},
        );
      }
      return handler(
        context.provide<RequestUser>(() => RequestUser.create(id)),
      );
    };
