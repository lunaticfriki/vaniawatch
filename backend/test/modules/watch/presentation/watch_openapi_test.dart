import 'package:backend/modules/watch/presentation/watch_openapi.dart';
import 'package:core/core.dart';
import 'package:test/test.dart';

void main() {
  group('WatchOpenApi', () {
    final section = WatchOpenApi.section;
    Map<String, dynamic> operation(String path, String method) =>
        (section.paths[path]! as Map<String, dynamic>)[method]
            as Map<String, dynamic>;
    Map<String, dynamic> property(String schema, String name) =>
        ((section.schemas[schema]! as Map)['properties'] as Map)[name]
            as Map<String, dynamic>;

    test('documents the watch CRUD', () {
      expect(section.paths.keys, ['/watches', '/watches/{id}']);
      expect(
        (section.paths['/watches']! as Map).keys,
        containsAll(['get', 'post']),
      );
      expect(
        (section.paths['/watches/{id}']! as Map).keys,
        containsAll(['get', 'put', 'delete']),
      );
    });

    test('every operation requires the user identification', () {
      for (final (path, method) in [
        ('/watches', 'get'),
        ('/watches', 'post'),
        ('/watches/{id}', 'get'),
        ('/watches/{id}', 'put'),
        ('/watches/{id}', 'delete'),
      ]) {
        expect(
          operation(path, method)['security'],
          [
            {'userId': <String>[]},
          ],
          reason: '$method $path',
        );
      }
    });

    test('documents the status codes each operation can answer', () {
      Iterable<String> codes(String path, String method) =>
          (operation(path, method)['responses'] as Map).keys.cast<String>();

      expect(codes('/watches', 'post'), containsAll(['201', '400', '401']));
      expect(codes('/watches/{id}', 'get'), containsAll(['200', '404']));
      expect(codes('/watches/{id}', 'put'), containsAll(['204', '404', '409']));
      expect(codes('/watches/{id}', 'delete'), containsAll(['204', '404']));
    });

    test('input limits come from the domain', () {
      expect(property('WatchInput', 'name')['maxLength'], WatchName.maxLength);
      expect(
        property('WatchInput', 'brand')['maxLength'],
        WatchBrand.maxLength,
      );
      expect(
        property('WatchInput', 'description')['maxLength'],
        WatchDescription.maxLength,
      );
      expect(property('WatchInput', 'tags')['maxItems'], WatchTags.maxLength);
      expect(
        (property('WatchInput', 'tags')['items'] as Map)['maxLength'],
        WatchTag.maxLength,
      );
    });

    test('enums come from the domain', () {
      expect(property('WatchInput', 'type')['enum'], [
        WatchType.analog().value,
        WatchType.digital().value,
        WatchType.anaDigi().value,
      ]);
      expect(property('WatchInput', 'category')['enum'], [
        WatchCategory.mechanical().value,
        WatchCategory.quartz().value,
      ]);
    });

    test('the required input fields match the request mappers', () {
      expect(
        (section.schemas['WatchInput']! as Map)['required'],
        ['name', 'brand', 'type', 'category'],
      );
    });

    test('the watch schema matches the response fields', () {
      expect(
        ((section.schemas['Watch']! as Map)['properties'] as Map).keys,
        [
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
      );
    });
  });
}
