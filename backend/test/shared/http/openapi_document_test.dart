import 'package:backend/shared/http/openapi_document.dart';
import 'package:test/test.dart';

void main() {
  group('OpenApiDocument', () {
    const first = OpenApiSection(
      paths: {
        '/a': {'get': <String, Object?>{}},
      },
      schemas: {
        'A': {'type': 'object'},
      },
    );
    const second = OpenApiSection(
      paths: {
        '/b': {'post': <String, Object?>{}},
      },
      schemas: {
        'B': {'type': 'string'},
      },
    );

    test('is an OpenAPI 3.1 document for the VaniaWatch API', () {
      final document = OpenApiDocument.create(sections: []);

      expect(document['openapi'], '3.1.0');
      expect((document['info']! as Map)['title'], 'VaniaWatch API');
    });

    test('merges the paths and schemas of every section', () {
      final document = OpenApiDocument.create(sections: [first, second]);

      expect((document['paths']! as Map).keys, ['/a', '/b']);
      final schemas = (document['components']! as Map)['schemas'] as Map;
      expect(schemas.keys, containsAll(['A', 'B', 'Error']));
    });

    test('declares the X-User-Id header as the user identification', () {
      final components =
          OpenApiDocument.create(sections: [])['components']! as Map;

      expect((components['securitySchemes'] as Map)['userId'], {
        'type': 'apiKey',
        'in': 'header',
        'name': 'X-User-Id',
        'description': isA<String>(),
      });
    });

    test('offers the shared error responses', () {
      final components =
          OpenApiDocument.create(sections: [])['components']! as Map;

      expect(
        (components['responses'] as Map).keys,
        containsAll(['BadRequest', 'Unauthorized', 'NotFound', 'Conflict']),
      );
    });
  });
}
