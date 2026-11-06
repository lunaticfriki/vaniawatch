import 'dart:convert';

import 'package:core/core.dart';
import 'package:frontend/modules/watch/application/watch_collection_repository.dart';
import 'package:frontend/modules/watch/infrastructure/acl/watch_mapper.dart';
import 'package:frontend/shared/infrastructure/api_config.dart';
import 'package:http/http.dart' as http;

final class HttpWatchCollectionRepository implements WatchCollectionRepository {
  const HttpWatchCollectionRepository(this._client, this._config);

  static const String _userIdHeader = 'X-User-Id';
  static const int _ok = 200;

  final http.Client _client;
  final ApiConfig _config;

  @override
  Future<List<Watch>> findAll() async {
    final response = await _get('/watches');
    final owner = UserId.create(_config.userId);
    return (jsonDecode(response.body) as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map((json) => WatchMapper.toDomain(json, owner: owner))
        .toList();
  }

  Future<http.Response> _get(String path) async {
    final http.Response response;
    try {
      response = await _client.get(
        _config.uri(path),
        headers: {_userIdHeader: _config.userId},
      );
    } on http.ClientException catch (error) {
      throw WatchCollectionUnavailableException(error);
    }
    if (response.statusCode != _ok) {
      throw WatchCollectionUnavailableException(
        'GET $path answered ${response.statusCode}',
      );
    }
    return response;
  }
}
