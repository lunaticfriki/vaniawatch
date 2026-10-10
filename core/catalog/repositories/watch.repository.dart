import '../../auth/value_objects/user_id.value_object.dart';
import '../entities/watch.entity.dart';
import '../value_objects/watch_id.value_object.dart';

abstract class WatchRepository {
  Future<void> save(Watch watch);

  Future<Watch?> findByIdForOwner({
    required WatchId id,
    required UserId ownerId,
  });

  Future<List<Watch>> findAllForOwner(UserId ownerId);
}
