import 'dart:io';

import 'package:test/test.dart';

void main() {
  final files = [
    ..._dartFiles('lib'),
    ..._dartFiles('routes'),
  ];

  List<String> importsOf(File file) =>
      RegExp(r'''^import\s+'([^']+)';''', multiLine: true)
          .allMatches(file.readAsStringSync())
          .map((match) => match.group(1)!)
          .toList();

  void expectNoImports(
    bool Function(String path) appliesTo,
    bool Function(String import) forbidden,
  ) {
    final violations = [
      for (final file in files.where((file) => appliesTo(file.path)))
        for (final import in importsOf(file).where(forbidden))
          '${file.path} -> $import',
    ];
    expect(violations, isEmpty);
  }

  bool isLayer(String path, String layer) => path.contains('/$layer/');

  test('application depends only on the domain and itself', () {
    expectNoImports(
      (path) => isLayer(path, 'application'),
      (import) =>
          import.contains('/infrastructure/') ||
          import.contains('/presentation/') ||
          import.contains('/http/') ||
          import.startsWith('package:dart_frog') ||
          import.startsWith('package:postgres'),
    );
  });

  test('infrastructure never depends on presentation', () {
    expectNoImports(
      (path) => isLayer(path, 'infrastructure'),
      (import) =>
          import.contains('/presentation/') ||
          import.contains('/http/') ||
          import.startsWith('package:dart_frog'),
    );
  });

  test('presentation and routes never depend on infrastructure', () {
    expectNoImports(
      (path) =>
          isLayer(path, 'presentation') ||
          isLayer(path, 'http') ||
          path.startsWith('routes/'),
      (import) =>
          import.contains('/infrastructure/') ||
          import.startsWith('package:postgres'),
    );
  });

  test('nothing reaches into core internals or its test fixtures', () {
    expectNoImports(
      (_) => true,
      (import) =>
          import.startsWith('package:core/src/') ||
          import == 'package:core/testing.dart',
    );
  });
}

List<File> _dartFiles(String directory) =>
    Directory(directory)
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'))
        .toList();
