final class OpenApiSection {
  const OpenApiSection({required this.paths, this.schemas = const {}});

  final Map<String, Object?> paths;
  final Map<String, Object?> schemas;
}

abstract final class OpenApiDocument {
  static const String userIdHeader = 'X-User-Id';

  static Map<String, Object?> create({
    required List<OpenApiSection> sections,
  }) => {
    'openapi': '3.1.0',
    'info': {
      'title': 'VaniaWatch API',
      'version': '0.1.0',
      'description':
          'Private watch collections. Until login exists, identify '
          'yourself with any UUID in the $userIdHeader header '
          '(Authorize button). Watches of other users are reported as '
          'not found.',
    },
    'servers': [
      {'url': '/'},
    ],
    'paths': {
      for (final section in sections) ...section.paths,
    },
    'components': {
      'securitySchemes': {
        'userId': {
          'type': 'apiKey',
          'in': 'header',
          'name': userIdHeader,
          'description':
              'Temporary identification: the UUID of the calling user.',
        },
      },
      'schemas': {
        'Error': {
          'type': 'object',
          'required': ['error'],
          'properties': {
            'error': {'type': 'string'},
          },
        },
        for (final section in sections) ...section.schemas,
      },
      'responses': {
        'BadRequest': _errorResponse(
          'Malformed JSON, a missing field, or a value that breaks a '
          'domain rule.',
        ),
        'Unauthorized': _errorResponse('The $userIdHeader header is missing.'),
        'NotFound': _errorResponse(
          'The resource does not exist or belongs to another user.',
        ),
        'Conflict': _errorResponse(
          'The change would move the update moment backwards.',
        ),
      },
    },
  };

  static Map<String, Object?> _errorResponse(String description) => {
    'description': description,
    'content': {
      'application/json': {
        'schema': {r'$ref': '#/components/schemas/Error'},
      },
    },
  };
}

abstract final class OpenApiRefs {
  static Map<String, Object?> schema(String name) => {
    r'$ref': '#/components/schemas/$name',
  };

  static Map<String, Object?> response(String name) => {
    r'$ref': '#/components/responses/$name',
  };

  static const List<Map<String, List<String>>> userIdSecurity = [
    {'userId': []},
  ];
}
