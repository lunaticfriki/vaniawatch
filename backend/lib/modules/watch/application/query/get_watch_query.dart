final class GetWatchQuery {
  const GetWatchQuery._({required this.id, required this.ownerId});

  factory GetWatchQuery.create({
    required String id,
    required String ownerId,
  }) => GetWatchQuery._(id: id, ownerId: ownerId);

  final String id;
  final String ownerId;
}
