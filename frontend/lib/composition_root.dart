import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/modules/watch/application/command/create_watch_command_handler.dart';
import 'package:frontend/modules/watch/application/query/list_watches_query_handler.dart';
import 'package:frontend/modules/watch/application/watch_image_picker.dart';
import 'package:frontend/modules/watch/application/watch_image_storage.dart';
import 'package:frontend/modules/watch/application/watch_read_service.dart';
import 'package:frontend/modules/watch/application/watch_write_service.dart';
import 'package:frontend/modules/watch/infrastructure/cloudinary_config.dart';
import 'package:frontend/modules/watch/infrastructure/cloudinary_watch_image_storage.dart';
import 'package:frontend/modules/watch/infrastructure/file_selector_watch_image_picker.dart';
import 'package:frontend/modules/watch/infrastructure/http_watch_collection_repository.dart';
import 'package:frontend/modules/watch/infrastructure/unavailable_watch_image_storage.dart';
import 'package:frontend/shared/infrastructure/api_config.dart';
import 'package:http/http.dart' as http;

class CompositionRoot extends StatelessWidget {
  const CompositionRoot({
    required this.config,
    required this.cloudinary,
    required this.client,
    required this.child,
    super.key,
  });

  final ApiConfig config;
  final CloudinaryConfig cloudinary;
  final http.Client client;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final watches = HttpWatchCollectionRepository(client, config);
    final WatchImageStorage images = cloudinary.isConfigured
        ? CloudinaryWatchImageStorage(client, cloudinary)
        : const UnavailableWatchImageStorage();
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<WatchReadService>(
          create: (_) => WatchReadServiceImpl(
            listWatches: ListWatchesQueryHandler(watches),
          ),
        ),
        RepositoryProvider<WatchWriteService>(
          create: (_) => WatchWriteServiceImpl(
            createWatch: CreateWatchCommandHandler(watches, images),
            images: images,
          ),
        ),
        RepositoryProvider<WatchImagePicker>(
          create: (_) => const FileSelectorWatchImagePicker(),
        ),
      ],
      child: child,
    );
  }
}
