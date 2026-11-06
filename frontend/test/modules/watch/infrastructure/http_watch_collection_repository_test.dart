import 'dart:convert';

import 'package:core/testing.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/modules/watch/application/watch_collection_repository.dart';
import 'package:frontend/modules/watch/infrastructure/http_watch_collection_repository.dart';
import 'package:frontend/shared/infrastructure/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'acl/watch_json_mother.dart';

void main() {
  group('HttpWatchCollectionRepository', () {
    final userId = UserIdMother.random();
    final config = ApiConfig.create(
      baseUrl: 'http://api.test',
      userId: userId.value,
    );

    HttpWatchCollectionRepository repositoryAnswering(
      Future<http.Response> Function(http.Request request) answer,
    ) => HttpWatchCollectionRepository(MockClient(answer), config);

    test('gets the watches of the configured user, in api order', () async {
      final sources = List.generate(3, (_) => WatchMother.restored());
      late http.Request sent;
      final repository = repositoryAnswering((request) async {
        sent = request;
        return http.Response(
          jsonEncode(sources.map(WatchJsonMother.fromWatch).toList()),
          200,
        );
      });

      final watches = await repository.findAll();

      expect(sent.method, 'GET');
      expect(sent.url, Uri.parse('http://api.test/watches'));
      expect(sent.headers['X-User-Id'], userId.value);
      expect(watches.map((watch) => watch.id), sources.map((s) => s.id));
      expect(watches.every((watch) => watch.isOwnedBy(userId)), isTrue);
    });

    test('throws unavailable on a non-200 response', () {
      final repository = repositoryAnswering(
        (_) async => http.Response('{"error":"boom"}', 500),
      );

      expect(
        repository.findAll,
        throwsA(isA<WatchCollectionUnavailableException>()),
      );
    });

    test('throws unavailable when the api cannot be reached', () {
      final repository = repositoryAnswering(
        (_) async => throw http.ClientException('connection refused'),
      );

      expect(
        repository.findAll,
        throwsA(isA<WatchCollectionUnavailableException>()),
      );
    });
  });
}
