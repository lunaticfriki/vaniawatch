import 'package:backend/modules/watch/presentation/update_watch_request.dart';
import 'package:backend/shared/http/invalid_request_error.dart';
import 'package:backend/shared/http/json_request.dart';
import 'package:test/test.dart';

void main() {
  group('UpdateWatchRequest', () {
    const id = '0b5e7a1c-2d3e-4f5a-8b6c-7d8e9f0a1b2c';
    const ownerId = '5f0c7c2e-1d3a-4b6e-9f2a-3c4d5e6f7a8b';

    test('maps a full body to a command for the given watch', () {
      final command = UpdateWatchRequest.toCommand(
        JsonRequest.fromObject({
          'name': 'Speedmaster',
          'description': 'Moonwatch',
          'brand': 'Omega',
          'type': 'analog',
          'category': 'mechanical',
          'tags': ['chrono'],
          'complications': ['chronograph'],
          'imageUrl': 'https://example.com/speedy.jpg',
        }),
        id: id,
        ownerId: ownerId,
      );

      expect(command.id, id);
      expect(command.ownerId, ownerId);
      expect(command.name, 'Speedmaster');
      expect(command.description, 'Moonwatch');
      expect(command.brand, 'Omega');
      expect(command.type, 'analog');
      expect(command.category, 'mechanical');
      expect(command.tags, ['chrono']);
      expect(command.complications, ['chronograph']);
      expect(command.imageUrl, 'https://example.com/speedy.jpg');
    });

    test('missing optional fields clear them', () {
      final command = UpdateWatchRequest.toCommand(
        JsonRequest.fromObject({
          'name': 'F91W',
          'brand': 'Casio',
          'type': 'digital',
          'category': 'quartz',
        }),
        id: id,
        ownerId: ownerId,
      );

      expect(command.description, '');
      expect(command.tags, isEmpty);
      expect(command.complications, isEmpty);
      expect(command.imageUrl, '');
    });

    test('rejects a body without a required field', () {
      expect(
        () => UpdateWatchRequest.toCommand(
          JsonRequest.fromObject({'name': 'F91W'}),
          id: id,
          ownerId: ownerId,
        ),
        throwsA(isA<InvalidRequestError>()),
      );
    });
  });
}
