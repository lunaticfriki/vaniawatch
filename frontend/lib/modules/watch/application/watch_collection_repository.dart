import 'package:core/core.dart';
import 'package:frontend/modules/watch/application/watch_draft.dart';

abstract class WatchCollectionRepository {
  Future<List<Watch>> findAll();

  Future<WatchId> add(WatchDraft draft);
}

final class WatchCollectionUnavailableException implements Exception {
  const WatchCollectionUnavailableException([this.cause]);

  final Object? cause;

  @override
  String toString() => 'The watch collection is unavailable: $cause';
}
