import 'dart:io';

import 'package:backend/api_document.dart';
import 'package:test/test.dart';

const _documentationPaths = {'/openapi', '/docs'};

void main() {
  test('the API document lists exactly the implemented routes', () {
    final implemented = <String>{
      for (final file in Directory('routes').listSync(recursive: true))
        if (file is File &&
            file.path.endsWith('.dart') &&
            !file.path.endsWith('_middleware.dart'))
          for (final method in _methodsOf(file))
            if (!_documentationPaths.contains(_pathOf(file)))
              '${method.toUpperCase()} ${_pathOf(file)}',
    };
    final documented = <String>{
      for (final MapEntry(key: path, value: operations)
          in (ApiDocument.build()['paths']! as Map<String, Object?>).entries)
        for (final method in (operations! as Map<String, Object?>).keys)
          if (method != 'parameters') '${method.toUpperCase()} $path',
    };

    expect(documented, implemented);
  });
}

String _pathOf(File file) {
  final segments = file.path
      .substring('routes/'.length, file.path.length - '.dart'.length)
      .split('/')
      .where((segment) => segment != 'index')
      .map(
        (segment) => segment.startsWith('[')
            ? '{${segment.substring(1, segment.length - 1)}}'
            : segment,
      );
  return '/${segments.join('/')}';
}

Iterable<String> _methodsOf(File file) =>
    RegExp(r'HttpMethod\.(\w+)')
        .allMatches(file.readAsStringSync())
        .map((match) => match.group(1)!)
        .toSet();
