import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/modules/watch/presentation/add_watch_form_values.dart';

void main() {
  group('AddWatchFormValues', () {
    test('splits tags and complications on commas, dropping blanks', () {
      final values = AddWatchFormValues.create(
        name: 'Speedmaster',
        brand: 'Omega',
        type: 'analog',
        category: 'mechanical',
        description: '',
        tags: ' chrono, ,steel ,',
        complications: 'chronograph,  moon phase ',
      );

      expect(values.tagList, ['chrono', 'steel']);
      expect(values.complicationList, ['chronograph', 'moon phase']);
    });

    test('gives empty lists for empty text', () {
      final values = AddWatchFormValues.create(
        name: '',
        brand: '',
        type: '',
        category: '',
        description: '',
        tags: '  ',
        complications: '',
      );

      expect(values.tagList, isEmpty);
      expect(values.complicationList, isEmpty);
    });
  });
}
