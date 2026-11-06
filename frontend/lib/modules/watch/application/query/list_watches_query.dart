final class ListWatchesQuery {
  const ListWatchesQuery._(this.limit);

  factory ListWatchesQuery.all() => const ListWatchesQuery._(null);

  factory ListWatchesQuery.latest(int count) {
    if (count < 1) {
      throw ArgumentError.value(count, 'count', 'must be at least 1');
    }
    return ListWatchesQuery._(count);
  }

  final int? limit;
}
