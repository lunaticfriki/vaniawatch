import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/modules/watch/application/watch_draft.dart';
import 'package:frontend/modules/watch/application/watch_image_picker.dart';
import 'package:frontend/modules/watch/application/watch_write_service.dart';
import 'package:frontend/modules/watch/presentation/add_watch_form_view.dart';
import 'package:frontend/modules/watch/presentation/cubit/add_watch_cubit.dart';
import 'package:frontend/modules/watch/presentation/cubit/add_watch_state.dart';
import 'package:frontend/shared/presentation/app_routes.dart';
import 'package:go_router/go_router.dart';

class AddWatchPage extends StatelessWidget {
  const AddWatchPage({this.onSaved, super.key});

  static const String title = 'Add a watch';
  static const String savedMessage = 'Watch added to your collection';

  final VoidCallback? onSaved;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddWatchCubit(context.read<WatchWriteService>()),
      child: AddWatchPageBody(
        onSaved:
            onSaved ?? () => GoRouter.maybeOf(context)?.go(AppRoutes.watches),
      ),
    );
  }
}

class AddWatchPageBody extends StatelessWidget {
  const AddWatchPageBody({required this.onSaved, super.key});

  final VoidCallback onSaved;

  Future<void> _pickImage(BuildContext context) async {
    final cubit = context.read<AddWatchCubit>();
    final image = await context.read<WatchImagePicker>().pick();
    if (image != null) cubit.selectImage(image);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddWatchCubit, AddWatchState>(
      listenWhen: (previous, current) => current is AddWatchSubmitted,
      listener: (context, state) {
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
          const SnackBar(content: Text(AddWatchPage.savedMessage)),
        );
        onSaved();
      },
      builder: (context, state) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 24,
        children: [
          Text(
            AddWatchPage.title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          AddWatchFormView(
            state: state,
            types: WatchDraft.types,
            categories: WatchDraft.categories,
            onPickImage: () => _pickImage(context),
            onRemoveImage: context.read<AddWatchCubit>().removeImage,
            onSubmit: context.read<AddWatchCubit>().submit,
          ),
        ],
      ),
    );
  }
}
