import 'dart:io';

import 'package:backend/shared/http/invalid_request_error.dart';
import 'package:core/core.dart';
import 'package:dart_frog/dart_frog.dart';

Middleware errorMiddleware({
  void Function(Object error, StackTrace stackTrace) log = _logToStderr,
}) =>
    (handler) => (context) async {
      try {
        return await handler(context);
      } on InvalidRequestError catch (error) {
        return _error(HttpStatus.badRequest, error.message);
      } on NotFoundError catch (error) {
        return _error(HttpStatus.notFound, error.message);
      } on InvalidUpdatedAtError catch (error) {
        return _error(HttpStatus.conflict, error.message);
      } on DomainError catch (error) {
        return _error(HttpStatus.badRequest, error.message);
      } on Object catch (error, stackTrace) {
        log(error, stackTrace);
        return _error(HttpStatus.internalServerError, 'Internal server error');
      }
    };

void _logToStderr(Object error, StackTrace stackTrace) =>
    stderr.writeln('$error\n$stackTrace');

Response _error(int statusCode, String message) =>
    Response.json(statusCode: statusCode, body: {'error': message});
