final class ListWatchesQuery {
  const ListWatchesQuery._({required this.ownerId});

  factory ListWatchesQuery.create({required String ownerId}) =>
      ListWatchesQuery._(ownerId: ownerId);

  final String ownerId;
}
