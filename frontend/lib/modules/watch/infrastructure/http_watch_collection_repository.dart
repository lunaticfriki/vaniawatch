import 'dart:convert';

import 'package:core/core.dart';
import 'package:frontend/modules/watch/application/watch_collection_repository.dart';
import 'package:frontend/modules/watch/application/watch_draft.dart';
import 'package:frontend/modules/watch/infrastructure/acl/watch_mapper.dart';
import 'package:frontend/shared/infrastructure/api_config.dart';
import 'package:http/http.dart' as http;

final class HttpWatchCollectionRepository implements WatchCollectionRepository {
  const HttpWatchCollectionRepository(this._client, this._config);

  static const String _userIdHeader = 'X-User-Id';
  static const String _contentTypeHeader = 'Content-Type';
  static const String _json = 'application/json';
  static const String _path = '/watches';
  static const int _ok = 200;
  static const int _created = 201;

  final http.Client _client;
  final ApiConfig _config;

  @override
  Future<List<Watch>> findAll() async {
    final response = await _send(
      'GET',
      expected: _ok,
      () => _client.get(_config.uri(_path), headers: _headers),
    );
    final owner = UserId.create(_config.userId);
    return (jsonDecode(response.body) as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map((json) => WatchMapper.toDomain(json, owner: owner))
        .toList();
  }

  @override
  Future<WatchId> add(WatchDraft draft) async {
    final response = await _send(
      'POST',
      expected: _created,
      () => _client.post(
        _config.uri(_path),
        headers: {..._headers, _contentTypeHeader: _json},
        body: jsonEncode(WatchMapper.toJson(draft)),
      ),
    );
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return WatchId.create(json['id'] as String);
  }

  Map<String, String> get _headers => {_userIdHeader: _config.userId};

  Future<http.Response> _send(
    String method,
    Future<http.Response> Function() request, {
    required int expected,
  }) async {
    final http.Response response;
    try {
      response = await request();
    } on http.ClientException catch (error) {
      throw WatchCollectionUnavailableException(error);
    }
    if (response.statusCode != expected) {
      throw WatchCollectionUnavailableException(
        '$method $_path answered ${response.statusCode}',
      );
    }
    return response;
  }
}
