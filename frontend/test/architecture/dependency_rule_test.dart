import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final files = Directory('lib')
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith('.dart'))
      .toList();

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

  String? moduleOf(String path) =>
      RegExp(r'modules/([^/]+)/').firstMatch(path)?.group(1);

  test('application depends only on the domain and itself', () {
    expectNoImports(
      (path) => isLayer(path, 'application'),
      (import) =>
          import.contains('/infrastructure/') ||
          import.contains('/presentation/') ||
          import.startsWith('package:flutter/') ||
          import.startsWith('package:flutter_bloc') ||
          import.startsWith('package:go_router') ||
          import.startsWith('package:http'),
    );
  });

  test('infrastructure never depends on presentation or the ui', () {
    expectNoImports(
      (path) => isLayer(path, 'infrastructure'),
      (import) =>
          import.contains('/presentation/') ||
          import.startsWith('package:flutter/') ||
          import.startsWith('package:flutter_bloc') ||
          import.startsWith('package:go_router') ||
          import.startsWith('dart:io'),
    );
  });

  test('presentation never depends on infrastructure', () {
    expectNoImports(
      (path) => isLayer(path, 'presentation') || path == 'lib/app.dart',
      (import) =>
          import.contains('/infrastructure/') ||
          import.startsWith('package:http'),
    );
  });

  test('modules never reach into the internals of another module', () {
    final violations = [
      for (final file in files)
        for (final import in importsOf(file))
          if (moduleOf(file.path) case final module?)
            if (moduleOf(import) case final other?)
              if (other != module &&
                  (import.contains('/infrastructure/') ||
                      import.contains('/presentation/')))
                '${file.path} -> $import',
    ];
    expect(violations, isEmpty);
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
