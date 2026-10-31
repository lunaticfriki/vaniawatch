import 'package:backend/modules/watch/application/command/update_watch_command.dart';
import 'package:backend/shared/http/json_request.dart';

abstract final class UpdateWatchRequest {
  static UpdateWatchCommand toCommand(
    JsonRequest body, {
    required String id,
    required String ownerId,
  }) => UpdateWatchCommand.create(
    id: id,
    ownerId: ownerId,
    name: body.requiredString('name'),
    description: body.optionalString('description'),
    brand: body.requiredString('brand'),
    type: body.requiredString('type'),
    category: body.requiredString('category'),
    tags: body.stringList('tags'),
    complications: body.stringList('complications'),
    imageUrl: body.optionalString('imageUrl'),
  );
}
