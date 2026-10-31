import 'package:backend/shared/http/invalid_request_error.dart';
import 'package:backend/shared/http/json_request.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:test/test.dart';

void main() {
  group('JsonRequest', () {
    test('reads a json object from a request', () async {
      final request = Request.post(
        Uri.parse('http://localhost/watches'),
        body: '{"name": "F91W"}',
      );

      final body = await JsonRequest.read(request);

      expect(body.requiredString('name'), 'F91W');
    });

    test('rejects a body that is not json', () async {
      final request = Request.post(
        Uri.parse('http://localhost/watches'),
        body: 'not json',
      );

      await expectLater(
        JsonRequest.read(request),
        throwsA(isA<InvalidRequestError>()),
      );
    });

    test('rejects a body that is not a json object', () {
      expect(
        () => JsonRequest.fromObject(['a']),
        throwsA(isA<InvalidRequestError>()),
      );
    });

    test('requires a string field', () {
      final body = JsonRequest.fromObject({'name': 1});

      expect(
        () => body.requiredString('name'),
        throwsA(isA<InvalidRequestError>()),
      );
      expect(
        () => body.requiredString('brand'),
        throwsA(isA<InvalidRequestError>()),
      );
    });

    test('an optional string defaults to empty', () {
      final body = JsonRequest.fromObject({
        'description': 'Nice',
        'imageUrl': null,
      });

      expect(body.optionalString('description'), 'Nice');
      expect(body.optionalString('imageUrl'), '');
      expect(body.optionalString('missing'), '');
      expect(
        () =>
            JsonRequest.fromObject({'description': 3})
                .optionalString('description'),
        throwsA(isA<InvalidRequestError>()),
      );
    });

    test('a string list defaults to empty', () {
      final body = JsonRequest.fromObject({
        'tags': ['a', 'b'],
      });

      expect(body.stringList('tags'), ['a', 'b']);
      expect(body.stringList('missing'), isEmpty);
      expect(
        () => JsonRequest.fromObject({
          'tags': ['a', 1],
        }).stringList('tags'),
        throwsA(isA<InvalidRequestError>()),
      );
      expect(
        () => JsonRequest.fromObject({'tags': 'a'}).stringList('tags'),
        throwsA(isA<InvalidRequestError>()),
      );
    });
  });
}
