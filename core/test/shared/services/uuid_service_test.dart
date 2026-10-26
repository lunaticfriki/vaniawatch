import 'package:core/core.dart';
import 'package:core/testing.dart';
import 'package:test/test.dart';

void main() {
  group('UuidService', () {
    test('generates valid uuids', () {
      expect(UuidService.isValid(UuidService.generate()), isTrue);
    });

    test('generates version 4 uuids', () {
      expect(UuidService.generate()[14], '4');
    });

    test('generates distinct uuids', () {
      final generated = List.generate(1000, (_) => UuidService.generate());

      expect(generated.toSet(), hasLength(1000));
    });

    test('accepts a uuid in any case', () {
      final uuid = PrimitiveMother.uuid();

      expect(UuidService.isValid(uuid), isTrue);
      expect(UuidService.isValid(uuid.toUpperCase()), isTrue);
    });

    test('rejects values that are not uuids', () {
      for (final value in [
        '',
        PrimitiveMother.word(),
        '123e4567-e89b-12d3-a456-42661417400',
        '123e4567e89b12d3a456426614174000',
        'g23e4567-e89b-12d3-a456-426614174000',
      ]) {
        expect(UuidService.isValid(value), isFalse, reason: value);
      }
    });
  });
}
