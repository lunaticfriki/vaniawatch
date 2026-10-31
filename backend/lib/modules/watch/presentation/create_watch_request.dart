import 'package:backend/modules/watch/application/command/create_watch_command.dart';
import 'package:backend/shared/http/json_request.dart';

abstract final class CreateWatchRequest {
  static CreateWatchCommand toCommand(
    JsonRequest body, {
    required String ownerId,
  }) => CreateWatchCommand.create(
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
