import 'package:core/core.dart';

abstract class WatchCollectionRepository {
  Future<List<Watch>> findAll();
}

final class WatchCollectionUnavailableException implements Exception {
  const WatchCollectionUnavailableException([this.cause]);

  final Object? cause;

  @override
  String toString() => 'The watch collection is unavailable: $cause';
}
