import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/modules/watch/application/query/list_watches_query_handler.dart';
import 'package:frontend/modules/watch/application/watch_read_service.dart';
import 'package:frontend/modules/watch/infrastructure/http_watch_collection_repository.dart';
import 'package:frontend/shared/infrastructure/api_config.dart';
import 'package:http/http.dart' as http;

class CompositionRoot extends StatelessWidget {
  const CompositionRoot({
    required this.config,
    required this.client,
    required this.child,
    super.key,
  });

  final ApiConfig config;
  final http.Client client;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final watches = HttpWatchCollectionRepository(client, config);
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<WatchReadService>(
          create: (_) => WatchReadServiceImpl(
            listWatches: ListWatchesQueryHandler(watches),
          ),
        ),
      ],
      child: child,
    );
  }
}
