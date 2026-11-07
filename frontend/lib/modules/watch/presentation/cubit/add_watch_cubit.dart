import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/modules/watch/application/command/create_watch_command.dart';
import 'package:frontend/modules/watch/application/watch_collection_repository.dart';
import 'package:frontend/modules/watch/application/watch_draft.dart';
import 'package:frontend/modules/watch/application/watch_image.dart';
import 'package:frontend/modules/watch/application/watch_image_storage.dart';
import 'package:frontend/modules/watch/application/watch_write_service.dart';
import 'package:frontend/modules/watch/presentation/add_watch_form_values.dart';
import 'package:frontend/modules/watch/presentation/cubit/add_watch_state.dart';

class AddWatchCubit extends Cubit<AddWatchState> {
  AddWatchCubit(WatchWriteService writeService)
    : _writeService = writeService,
      super(
        AddWatchEditing(image: null, acceptsImages: writeService.acceptsImages),
      );

  final WatchWriteService _writeService;

  void selectImage(WatchImage image) {
    if (state is! AddWatchEditing || !state.acceptsImages) return;
    _edit(image: image);
  }

  void removeImage() {
    if (state is! AddWatchEditing) return;
    _edit(image: null);
  }

  Future<void> submit(AddWatchFormValues values) async {
    if (state is! AddWatchEditing) return;
    final image = state.image;
    emit(AddWatchSubmitting(image: image, acceptsImages: state.acceptsImages));
    try {
      final id = await _writeService.create(
        CreateWatchCommand.create(
          name: values.name,
          brand: values.brand,
          type: values.type,
          category: values.category,
          description: values.description,
          tags: values.tagList,
          complications: values.complicationList,
          image: image,
        ),
      );
      emit(
        AddWatchSubmitted(
          id: id,
          image: image,
          acceptsImages: state.acceptsImages,
        ),
      );
    } on WatchDraftRejectedException catch (error) {
      _rejected(error.errors);
    } on WatchImageUploadFailedException {
      _edit(image: image, failure: AddWatchFailure.upload);
    } on WatchCollectionUnavailableException {
      _edit(image: image, failure: AddWatchFailure.save);
    }
  }

  void _rejected(List<DomainError> errors) {
    final fieldErrors = <AddWatchField, String>{};
    for (final error in errors) {
      final field = _fieldOf(error);
      if (field != null) fieldErrors.putIfAbsent(field, () => error.message);
    }
    _edit(
      image: state.image,
      fieldErrors: fieldErrors,
      failure: fieldErrors.length < errors.length ? AddWatchFailure.save : null,
    );
  }

  static AddWatchField? _fieldOf(DomainError error) => switch (error) {
    InvalidWatchNameError() => AddWatchField.name,
    InvalidWatchBrandError() => AddWatchField.brand,
    InvalidWatchTypeError() => AddWatchField.type,
    InvalidWatchCategoryError() => AddWatchField.category,
    InvalidWatchDescriptionError() => AddWatchField.description,
    InvalidWatchTagError() || InvalidWatchTagsError() => AddWatchField.tags,
    _ => null,
  };

  void _edit({
    required WatchImage? image,
    Map<AddWatchField, String> fieldErrors = const {},
    AddWatchFailure? failure,
  }) => emit(
    AddWatchEditing(
      image: image,
      acceptsImages: state.acceptsImages,
      fieldErrors: fieldErrors,
      failure: failure,
    ),
  );
}
