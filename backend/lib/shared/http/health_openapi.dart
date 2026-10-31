import 'package:backend/shared/http/openapi_document.dart';

abstract final class HealthOpenApi {
  static const OpenApiSection section = OpenApiSection(
    paths: {
      '/health': {
        'get': {
          'tags': ['System'],
          'summary': 'Check that the API is up',
          'security': <Object>[],
          'responses': {
            '200': {
              'description': 'The API is up.',
              'content': {
                'application/json': {
                  'schema': {
                    'type': 'object',
                    'properties': {
                      'status': {'type': 'string', 'const': 'ok'},
                    },
                  },
                },
              },
            },
          },
        },
      },
    },
  );
}
