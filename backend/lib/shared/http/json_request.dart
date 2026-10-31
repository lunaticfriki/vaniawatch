import 'dart:convert';

import 'package:backend/shared/http/invalid_request_error.dart';
import 'package:dart_frog/dart_frog.dart';

final class JsonRequest {
  const JsonRequest._(this._body);

  factory JsonRequest.fromObject(Object? body) {
    if (body is! Map<String, dynamic>) {
      throw const InvalidRequestError('The request body must be a JSON object');
    }
    return JsonRequest._(body);
  }

  static Future<JsonRequest> read(Request request) async {
    try {
      return JsonRequest.fromObject(jsonDecode(await request.body()));
    } on FormatException {
      throw const InvalidRequestError('The request body is not valid JSON');
    }
  }

  final Map<String, dynamic> _body;

  String requiredString(String key) {
    final value = _body[key];
    if (value is! String) {
      throw InvalidRequestError('"$key" is required and must be a string');
    }
    return value;
  }

  String optionalString(String key) {
    final value = _body[key];
    if (value == null) {
      return '';
    }
    if (value is! String) {
      throw InvalidRequestError('"$key" must be a string');
    }
    return value;
  }

  List<String> stringList(String key) {
    final value = _body[key];
    if (value == null) {
      return const [];
    }
    if (value is! List<dynamic> || value.any((item) => item is! String)) {
      throw InvalidRequestError('"$key" must be a list of strings');
    }
    return value.cast<String>();
  }
}
