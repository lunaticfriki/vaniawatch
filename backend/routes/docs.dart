import 'dart:io';

import 'package:backend/shared/http/swagger_ui_page.dart';
import 'package:dart_frog/dart_frog.dart';

Response onRequest(RequestContext context) {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }
  return Response(
    body: SwaggerUiPage.html(documentUrl: '/openapi'),
    headers: {HttpHeaders.contentTypeHeader: 'text/html; charset=utf-8'},
  );
}
