import 'package:backend/modules/watch/presentation/create_watch_request.dart';
import 'package:backend/shared/http/invalid_request_error.dart';
import 'package:backend/shared/http/json_request.dart';
import 'package:test/test.dart';

void main() {
  group('CreateWatchRequest', () {
    const ownerId = '5f0c7c2e-1d3a-4b6e-9f2a-3c4d5e6f7a8b';

    test('maps a full body to a command', () {
      final command = CreateWatchRequest.toCommand(
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
        ownerId: ownerId,
      );

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

    test('optional fields default to empty', () {
      final command = CreateWatchRequest.toCommand(
        JsonRequest.fromObject({
          'name': 'F91W',
          'brand': 'Casio',
          'type': 'digital',
          'category': 'quartz',
        }),
        ownerId: ownerId,
      );

      expect(command.description, '');
      expect(command.tags, isEmpty);
      expect(command.complications, isEmpty);
      expect(command.imageUrl, '');
    });

    test('rejects a body without a required field', () {
      expect(
        () => CreateWatchRequest.toCommand(
          JsonRequest.fromObject({
            'brand': 'Casio',
            'type': 'digital',
            'category': 'quartz',
          }),
          ownerId: ownerId,
        ),
        throwsA(isA<InvalidRequestError>()),
      );
    });
  });
}
