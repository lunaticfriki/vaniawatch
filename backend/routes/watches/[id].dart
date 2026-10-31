import 'dart:io';

import 'package:backend/modules/watch/application/command/delete_watch_command.dart';
import 'package:backend/modules/watch/application/query/get_watch_query.dart';
import 'package:backend/modules/watch/application/watch_read_service.dart';
import 'package:backend/modules/watch/application/watch_write_service.dart';
import 'package:backend/modules/watch/presentation/update_watch_request.dart';
import 'package:backend/modules/watch/presentation/watch_response.dart';
import 'package:backend/shared/http/json_request.dart';
import 'package:backend/shared/http/request_user.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context, String id) =>
    switch (context.request.method) {
      HttpMethod.get => _get(context, id),
      HttpMethod.put => _update(context, id),
      HttpMethod.delete => _delete(context, id),
      _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed)),
    };

Future<Response> _get(RequestContext context, String id) async {
  final user = context.read<RequestUser>();
  final watch = await context.read<WatchReadService>().getById(
    GetWatchQuery.create(id: id, ownerId: user.id),
  );
  return Response.json(body: WatchResponse.fromReadModel(watch));
}

Future<Response> _update(RequestContext context, String id) async {
  final user = context.read<RequestUser>();
  final command = UpdateWatchRequest.toCommand(
    await JsonRequest.read(context.request),
    id: id,
    ownerId: user.id,
  );
  await context.read<WatchWriteService>().update(command);
  return Response(statusCode: HttpStatus.noContent);
}

Future<Response> _delete(RequestContext context, String id) async {
  final user = context.read<RequestUser>();
  await context.read<WatchWriteService>().delete(
    DeleteWatchCommand.create(id: id, ownerId: user.id),
  );
  return Response(statusCode: HttpStatus.noContent);
}
