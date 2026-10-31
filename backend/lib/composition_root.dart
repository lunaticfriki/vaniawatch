import 'package:backend/modules/watch/application/command/create_watch_command_handler.dart';
import 'package:backend/modules/watch/application/command/delete_watch_command_handler.dart';
import 'package:backend/modules/watch/application/command/update_watch_command_handler.dart';
import 'package:backend/modules/watch/application/query/get_watch_query_handler.dart';
import 'package:backend/modules/watch/application/query/list_watches_query_handler.dart';
import 'package:backend/modules/watch/application/watch_read_service.dart';
import 'package:backend/modules/watch/application/watch_write_service.dart';
import 'package:backend/modules/watch/infrastructure/postgres_watch_repository.dart';
import 'package:backend/shared/application/clock_service.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:postgres/postgres.dart';

Middleware compositionRoot({
  required Session database,
  required ClockService clock,
}) {
  final watches = PostgresWatchRepository(database);
  final WatchReadService readService = WatchReadServiceImpl(
    getWatch: GetWatchQueryHandler(watches),
    listWatches: ListWatchesQueryHandler(watches),
  );
  final WatchWriteService writeService = WatchWriteServiceImpl(
    createWatch: CreateWatchCommandHandler(watches, clock),
    updateWatch: UpdateWatchCommandHandler(watches, clock),
    deleteWatch: DeleteWatchCommandHandler(watches),
  );
  return (handler) => handler
      .use(provider<WatchReadService>((_) => readService))
      .use(provider<WatchWriteService>((_) => writeService));
}
