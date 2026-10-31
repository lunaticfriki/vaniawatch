final class DeleteWatchCommand {
  const DeleteWatchCommand._({required this.id, required this.ownerId});

  factory DeleteWatchCommand.create({
    required String id,
    required String ownerId,
  }) => DeleteWatchCommand._(id: id, ownerId: ownerId);

  final String id;
  final String ownerId;
}
