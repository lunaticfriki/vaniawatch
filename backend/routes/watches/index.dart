import 'dart:io';

import 'package:backend/modules/watch/application/query/list_watches_query.dart';
import 'package:backend/modules/watch/application/watch_read_service.dart';
import 'package:backend/modules/watch/application/watch_write_service.dart';
import 'package:backend/modules/watch/presentation/create_watch_request.dart';
import 'package:backend/modules/watch/presentation/watch_response.dart';
import 'package:backend/shared/http/json_request.dart';
import 'package:backend/shared/http/request_user.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) =>
    switch (context.request.method) {
      HttpMethod.get => _list(context),
      HttpMethod.post => _create(context),
      _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed)),
    };

Future<Response> _list(RequestContext context) async {
  final user = context.read<RequestUser>();
  final watches = await context.read<WatchReadService>().list(
    ListWatchesQuery.create(ownerId: user.id),
  );
  return Response.json(body: WatchResponse.fromReadModels(watches));
}

Future<Response> _create(RequestContext context) async {
  final user = context.read<RequestUser>();
  final command = CreateWatchRequest.toCommand(
    await JsonRequest.read(context.request),
    ownerId: user.id,
  );
  final id = await context.read<WatchWriteService>().create(command);
  return Response.json(
    statusCode: HttpStatus.created,
    headers: {'location': '/watches/$id'},
    body: {'id': id},
  );
}
