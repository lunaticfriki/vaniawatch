import 'package:core/core.dart';
import 'package:test/test.dart';

void expectSameWatch(Watch actual, Watch expected) {
  expect(actual.id, expected.id);
  expect(actual.owner, expected.owner);
  expect(actual.name, expected.name);
  expect(actual.description, expected.description);
  expect(actual.brand, expected.brand);
  expect(actual.type, expected.type);
  expect(actual.category, expected.category);
  expect(actual.tags, expected.tags);
  expect(actual.complications, expected.complications);
  expect(actual.imageUrl, expected.imageUrl);
  expect(actual.createdAt, expected.createdAt);
  expect(actual.updatedAt, expected.updatedAt);
}
