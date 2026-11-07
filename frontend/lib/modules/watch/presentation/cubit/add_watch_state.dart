import 'package:frontend/modules/watch/application/watch_image.dart';

enum AddWatchField { name, brand, type, category, description, tags }

enum AddWatchFailure { upload, save }

sealed class AddWatchState {
  const AddWatchState({required this.image, required this.acceptsImages});

  final WatchImage? image;
  final bool acceptsImages;
}

final class AddWatchEditing extends AddWatchState {
  const AddWatchEditing({
    required super.image,
    required super.acceptsImages,
    this.fieldErrors = const {},
    this.failure,
  });

  final Map<AddWatchField, String> fieldErrors;
  final AddWatchFailure? failure;
}

final class AddWatchSubmitting extends AddWatchState {
  const AddWatchSubmitting({
    required super.image,
    required super.acceptsImages,
  });
}

final class AddWatchSubmitted extends AddWatchState {
  const AddWatchSubmitted({
    required this.id,
    required super.image,
    required super.acceptsImages,
  });

  final String id;
}
