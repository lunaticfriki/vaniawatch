import 'package:backend/shared/http/openapi_document.dart';
import 'package:core/core.dart';

abstract final class WatchOpenApi {
  static const String _tag = 'Watches';

  static final OpenApiSection section = OpenApiSection(
    paths: {
      '/watches': {
        'get': {
          'tags': [_tag],
          'summary': 'List my watches, newest first',
          'security': OpenApiRefs.userIdSecurity,
          'responses': {
            '200': {
              'description': 'The watches of the calling user.',
              'content': {
                'application/json': {
                  'schema': {
                    'type': 'array',
                    'items': OpenApiRefs.schema('Watch'),
                  },
                },
              },
            },
            '400': OpenApiRefs.response('BadRequest'),
            '401': OpenApiRefs.response('Unauthorized'),
          },
        },
        'post': {
          'tags': [_tag],
          'summary': 'Add a watch to my collection',
          'security': OpenApiRefs.userIdSecurity,
          'requestBody': _input,
          'responses': {
            '201': {
              'description': 'The watch was created.',
              'headers': {
                'Location': {
                  'description': 'The path of the new watch.',
                  'schema': {'type': 'string'},
                },
              },
              'content': {
                'application/json': {
                  'schema': OpenApiRefs.schema('CreatedWatch'),
                },
              },
            },
            '400': OpenApiRefs.response('BadRequest'),
            '401': OpenApiRefs.response('Unauthorized'),
          },
        },
      },
      '/watches/{id}': {
        'parameters': [
          {
            'name': 'id',
            'in': 'path',
            'required': true,
            'schema': {'type': 'string', 'format': 'uuid'},
          },
        ],
        'get': {
          'tags': [_tag],
          'summary': 'Get one of my watches',
          'security': OpenApiRefs.userIdSecurity,
          'responses': {
            '200': {
              'description': 'The watch.',
              'content': {
                'application/json': {'schema': OpenApiRefs.schema('Watch')},
              },
            },
            '400': OpenApiRefs.response('BadRequest'),
            '401': OpenApiRefs.response('Unauthorized'),
            '404': OpenApiRefs.response('NotFound'),
          },
        },
        'put': {
          'tags': [_tag],
          'summary': 'Replace one of my watches',
          'description':
              'Full replacement: optional fields that are omitted are cleared.',
          'security': OpenApiRefs.userIdSecurity,
          'requestBody': _input,
          'responses': {
            '204': {'description': 'The watch was replaced.'},
            '400': OpenApiRefs.response('BadRequest'),
            '401': OpenApiRefs.response('Unauthorized'),
            '404': OpenApiRefs.response('NotFound'),
            '409': OpenApiRefs.response('Conflict'),
          },
        },
        'delete': {
          'tags': [_tag],
          'summary': 'Delete one of my watches',
          'security': OpenApiRefs.userIdSecurity,
          'responses': {
            '204': {'description': 'The watch was deleted.'},
            '400': OpenApiRefs.response('BadRequest'),
            '401': OpenApiRefs.response('Unauthorized'),
            '404': OpenApiRefs.response('NotFound'),
          },
        },
      },
    },
    schemas: {
      'WatchInput': {
        'type': 'object',
        'description': 'Text values are trimmed before their limits apply.',
        'required': ['name', 'brand', 'type', 'category'],
        'properties': {
          'name': {
            'type': 'string',
            'minLength': WatchName.minLength,
            'maxLength': WatchName.maxLength,
            'examples': ['Speedmaster Professional'],
          },
          'description': {
            'type': 'string',
            'maxLength': WatchDescription.maxLength,
            'default': '',
          },
          'brand': {
            'type': 'string',
            'minLength': WatchBrand.minLength,
            'maxLength': WatchBrand.maxLength,
            'examples': ['Omega'],
          },
          'type': {'type': 'string', 'enum': _types},
          'category': {'type': 'string', 'enum': _categories},
          'tags': {
            'type': 'array',
            'description': 'Lowercased and deduplicated.',
            'maxItems': WatchTags.maxLength,
            'default': <String>[],
            'items': {
              'type': 'string',
              'minLength': 1,
              'maxLength': WatchTag.maxLength,
            },
            'examples': [
              ['diver', 'vintage'],
            ],
          },
          'complications': {
            'type': 'array',
            'description': 'Free text, stored as given.',
            'default': <String>[],
            'items': {'type': 'string'},
            'examples': [
              ['chronograph', 'date'],
            ],
          },
          'imageUrl': {
            'type': 'string',
            'description':
                'An http or https URL. Empty or omitted means no image.',
            'default': '',
            'examples': ['https://example.com/speedmaster.jpg'],
          },
        },
      },
      'Watch': {
        'type': 'object',
        'required': [
          'id',
          'name',
          'description',
          'brand',
          'type',
          'category',
          'tags',
          'complications',
          'imageUrl',
          'createdAt',
          'updatedAt',
        ],
        'properties': {
          'id': {'type': 'string', 'format': 'uuid'},
          'name': {'type': 'string'},
          'description': {'type': 'string'},
          'brand': {'type': 'string'},
          'type': {'type': 'string', 'enum': _types},
          'category': {'type': 'string', 'enum': _categories},
          'tags': {
            'type': 'array',
            'items': {'type': 'string'},
          },
          'complications': {
            'type': 'array',
            'items': {'type': 'string'},
          },
          'imageUrl': {
            'type': ['string', 'null'],
            'format': 'uri',
          },
          'createdAt': {'type': 'string', 'format': 'date-time'},
          'updatedAt': {'type': 'string', 'format': 'date-time'},
        },
      },
      'CreatedWatch': {
        'type': 'object',
        'required': ['id'],
        'properties': {
          'id': {'type': 'string', 'format': 'uuid'},
        },
      },
    },
  );

  static final Map<String, Object?> _input = {
    'required': true,
    'content': {
      'application/json': {'schema': OpenApiRefs.schema('WatchInput')},
    },
  };

  static final List<String> _types = [
    WatchType.analog().value,
    WatchType.digital().value,
    WatchType.anaDigi().value,
  ];

  static final List<String> _categories = [
    WatchCategory.mechanical().value,
    WatchCategory.quartz().value,
  ];
}
