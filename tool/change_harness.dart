import 'dart:io';

void main(List<String> arguments) {
  final options = _parseArguments(arguments);
  if (options == null) {
    _printUsage();
    exitCode = 2;
    return;
  }

  final action = options.action!.trim();
  final files = options.files;
  final decision = _decisionFor(action, files);
  final impact = _impactFor(files);
  final boundaryFindings = _checkCoreBoundary();
  final ownershipFindings = _checkOwnerScopedRepository();

  stdout.writeln('Decision: ${decision.label}');
  stdout.writeln('Action: $action');
  stdout.writeln(
    'Declared paths: ${files.isEmpty ? '(none)' : files.join(', ')}',
  );
  stdout.writeln('Affected components: ${impact.join(', ')}');
  stdout.writeln(
    'Core dependency findings: ${_formatFindings(boundaryFindings)}',
  );
  stdout.writeln('Ownership findings: ${_formatFindings(ownershipFindings)}');

  if (decision == _Decision.prohibit ||
      boundaryFindings.isNotEmpty ||
      ownershipFindings.isNotEmpty) {
    exitCode = 1;
  }
}

_Options? _parseArguments(List<String> arguments) {
  String? action;
  final files = <String>[];

  for (var index = 0; index < arguments.length; index++) {
    switch (arguments[index]) {
      case '--action':
        if (index + 1 >= arguments.length) return null;
        action = arguments[++index];
        break;
      case '--files':
        if (index + 1 >= arguments.length) return null;
        files.addAll(
          arguments[++index]
              .split(',')
              .map((path) => path.trim())
              .where((path) => path.isNotEmpty),
        );
        break;
      default:
        return null;
    }
  }

  if (action == null || action.trim().isEmpty) return null;
  return _Options(action: action, files: files);
}

_Decision _decisionFor(String action, List<String> files) {
  final normalizedAction = action.toLowerCase();
  if (normalizedAction.contains('firebase') ||
      RegExp(
        r'\b(make|set|expose|publish|share)\b.{0,50}\b(public|publicly|cross-user)\b|\ballow\b.{0,40}\b(other users|cross-user|everyone|any user)\b',
      ).hasMatch(normalizedAction) ||
      RegExp(
        r'\b(disable|remove|bypass|weaken|make public|allow cross-user)\b.{0,70}\b(owner|user|privacy|private|authorization|access control)\b|\b(owner|user|privacy|private|authorization|access control)\b.{0,70}\b(disable|remove|bypass|weaken|make public|allow cross-user)\b',
      ).hasMatch(normalizedAction)) {
    return _Decision.prohibit;
  }
  if (files.isEmpty || normalizedAction.trim().length < 12) {
    return _Decision.review;
  }
  return _Decision.allow;
}

List<String> _impactFor(List<String> files) {
  final impact = <String>{};
  for (final path in files) {
    if (path == 'core' || path.startsWith('core/')) {
      impact.addAll(['core domain', 'Dart Frog backend', 'Flutter frontend']);
    } else if (path == 'backend' || path.startsWith('backend/')) {
      impact.addAll(['Dart Frog backend', 'database adapters']);
    } else if (path == 'frontend' || path.startsWith('frontend/')) {
      impact.addAll(['Flutter frontend', 'Dart Frog backend']);
    } else if (path.startsWith('docs/')) {
      impact.add('project rules and documentation');
    } else if (path.startsWith('tool/')) {
      impact.addAll(['change gate', 'policy checks']);
    } else {
      impact.add('project root or unclassified path');
    }
  }
  return impact.toList()..sort();
}

List<String> _checkCoreBoundary() {
  final core = Directory('core');
  if (!core.existsSync()) return const ['core/ directory is missing'];

  final findings = <String>[];
  for (final entity in core.listSync(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('.dart')) continue;
    if (entity.path.contains('/__tests__/')) continue;
    final lines = entity.readAsLinesSync();
    for (var index = 0; index < lines.length; index++) {
      final line = lines[index];
      if (!line.trimLeft().startsWith('import ')) continue;
      final import = RegExp(r'package:([a-zA-Z0-9_]+)').firstMatch(line);
      if (import == null || import.group(1) == 'vaniawatch_core') continue;
      findings.add(
        '${entity.path}:${index + 1} imports package:${import.group(1)}',
      );
    }
  }
  return findings;
}

List<String> _checkOwnerScopedRepository() {
  final repository = File('core/catalog/repositories/watch.repository.dart');
  if (!repository.existsSync()) {
    return const ['watch repository port is missing'];
  }

  final source = repository.readAsStringSync();
  final findings = <String>[];
  if (!RegExp(
    r'findByIdForOwner\s*\(\s*\{[\s\S]*?WatchId id[\s\S]*?UserId ownerId',
  ).hasMatch(source)) {
    findings.add('watch lookup must require WatchId and UserId ownerId');
  }
  if (!RegExp(r'findAllForOwner\s*\(\s*UserId ownerId\s*\)').hasMatch(source)) {
    findings.add('watch collection query must require UserId ownerId');
  }
  return findings;
}

String _formatFindings(List<String> findings) =>
    findings.isEmpty ? 'passed' : findings.join('; ');

void _printUsage() {
  stderr.writeln(
    'Usage: dart tool/change_harness.dart --action "..." --files path[,path]',
  );
}

enum _Decision {
  allow('ALLOW'),
  review('REVIEW'),
  prohibit('PROHIBIT');

  const _Decision(this.label);

  final String label;
}

class _Options {
  const _Options({required this.action, required this.files});

  final String? action;
  final List<String> files;
}
