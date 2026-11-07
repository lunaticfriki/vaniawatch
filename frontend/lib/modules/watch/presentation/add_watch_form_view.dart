import 'package:flutter/material.dart';
import 'package:frontend/modules/watch/presentation/add_watch_form_values.dart';
import 'package:frontend/modules/watch/presentation/add_watch_image_view.dart';
import 'package:frontend/modules/watch/presentation/cubit/add_watch_state.dart';

class AddWatchFormView extends StatefulWidget {
  const AddWatchFormView({
    required this.state,
    required this.types,
    required this.categories,
    required this.onPickImage,
    required this.onRemoveImage,
    required this.onSubmit,
    super.key,
  });

  static const Key nameKey = Key('add-watch-name');
  static const Key brandKey = Key('add-watch-brand');
  static const Key descriptionKey = Key('add-watch-description');
  static const Key tagsKey = Key('add-watch-tags');
  static const Key complicationsKey = Key('add-watch-complications');

  static const String nameLabel = 'Name';
  static const String brandLabel = 'Brand';
  static const String typeLabel = 'Type';
  static const String categoryLabel = 'Movement';
  static const String descriptionLabel = 'Description';
  static const String tagsLabel = 'Tags';
  static const String complicationsLabel = 'Complications';
  static const String listHint = 'Separate them with commas';
  static const String submitLabel = 'Save watch';
  static const String savingLabel = 'Saving…';
  static const String uploadFailedMessage =
      'The image could not be uploaded. Try again, or remove the image.';
  static const String saveFailedMessage =
      'The watch could not be saved. Try again.';

  final AddWatchState state;
  final List<String> types;
  final List<String> categories;
  final VoidCallback onPickImage;
  final VoidCallback onRemoveImage;
  final ValueChanged<AddWatchFormValues> onSubmit;

  @override
  State<AddWatchFormView> createState() => _AddWatchFormViewState();
}

class _AddWatchFormViewState extends State<AddWatchFormView> {
  final _name = TextEditingController();
  final _brand = TextEditingController();
  final _description = TextEditingController();
  final _tags = TextEditingController();
  final _complications = TextEditingController();
  late String _type = widget.types.first;
  late String _category = widget.categories.first;

  @override
  void dispose() {
    _name.dispose();
    _brand.dispose();
    _description.dispose();
    _tags.dispose();
    _complications.dispose();
    super.dispose();
  }

  void _submit() => widget.onSubmit(
    AddWatchFormValues.create(
      name: _name.text,
      brand: _brand.text,
      type: _type,
      category: _category,
      description: _description.text,
      tags: _tags.text,
      complications: _complications.text,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final isSubmitting = state is AddWatchSubmitting;
    final errors = switch (state) {
      AddWatchEditing(:final fieldErrors) => fieldErrors,
      _ => const <AddWatchField, String>{},
    };
    final failure = switch (state) {
      AddWatchEditing(:final failure) => failure,
      _ => null,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16,
      children: [
        if (failure != null) AddWatchFailureBanner(failure: failure),
        TextField(
          key: AddWatchFormView.nameKey,
          controller: _name,
          enabled: !isSubmitting,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: AddWatchFormView.nameLabel,
            errorText: errors[AddWatchField.name],
          ),
        ),
        TextField(
          key: AddWatchFormView.brandKey,
          controller: _brand,
          enabled: !isSubmitting,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: AddWatchFormView.brandLabel,
            errorText: errors[AddWatchField.brand],
          ),
        ),
        AddWatchChoiceView(
          label: AddWatchFormView.typeLabel,
          options: widget.types,
          selected: _type,
          error: errors[AddWatchField.type],
          isEnabled: !isSubmitting,
          onChanged: (value) => setState(() => _type = value),
        ),
        AddWatchChoiceView(
          label: AddWatchFormView.categoryLabel,
          options: widget.categories,
          selected: _category,
          error: errors[AddWatchField.category],
          isEnabled: !isSubmitting,
          onChanged: (value) => setState(() => _category = value),
        ),
        TextField(
          key: AddWatchFormView.descriptionKey,
          controller: _description,
          enabled: !isSubmitting,
          minLines: 3,
          maxLines: 6,
          decoration: InputDecoration(
            labelText: AddWatchFormView.descriptionLabel,
            alignLabelWithHint: true,
            errorText: errors[AddWatchField.description],
          ),
        ),
        TextField(
          key: AddWatchFormView.tagsKey,
          controller: _tags,
          enabled: !isSubmitting,
          decoration: InputDecoration(
            labelText: AddWatchFormView.tagsLabel,
            helperText: AddWatchFormView.listHint,
            errorText: errors[AddWatchField.tags],
          ),
        ),
        TextField(
          key: AddWatchFormView.complicationsKey,
          controller: _complications,
          enabled: !isSubmitting,
          decoration: const InputDecoration(
            labelText: AddWatchFormView.complicationsLabel,
            helperText: AddWatchFormView.listHint,
          ),
        ),
        AddWatchImageView(
          bytes: state.image?.bytes,
          fileName: state.image?.fileName,
          isEnabled: !isSubmitting,
          isAvailable: state.acceptsImages,
          onPick: widget.onPickImage,
          onRemove: widget.onRemoveImage,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton.icon(
            onPressed: isSubmitting ? null : _submit,
            icon: isSubmitting
                ? const SizedBox.square(
                    dimension: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.check),
            label: Text(
              isSubmitting
                  ? AddWatchFormView.savingLabel
                  : AddWatchFormView.submitLabel,
            ),
          ),
        ),
      ],
    );
  }
}

class AddWatchChoiceView extends StatelessWidget {
  const AddWatchChoiceView({
    required this.label,
    required this.options,
    required this.selected,
    required this.error,
    required this.isEnabled,
    required this.onChanged,
    super.key,
  });

  final String label;
  final List<String> options;
  final String selected;
  final String? error;
  final bool isEnabled;
  final ValueChanged<String> onChanged;

  static String labelOf(String option) =>
      option.isEmpty ? option : option[0].toUpperCase() + option.substring(1);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final message = error;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Text(label, style: theme.textTheme.titleSmall),
        SegmentedButton<String>(
          segments: [
            for (final option in options)
              ButtonSegment(value: option, label: Text(labelOf(option))),
          ],
          selected: {selected},
          onSelectionChanged: isEnabled
              ? (selection) => onChanged(selection.single)
              : null,
        ),
        if (message != null)
          Text(
            message,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
      ],
    );
  }
}

class AddWatchFailureBanner extends StatelessWidget {
  const AddWatchFailureBanner({required this.failure, super.key});

  final AddWatchFailure failure;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Material(
      color: colors.errorContainer,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          spacing: 12,
          children: [
            Icon(Icons.error_outline, color: colors.onErrorContainer),
            Expanded(
              child: Text(switch (failure) {
                AddWatchFailure.upload => AddWatchFormView.uploadFailedMessage,
                AddWatchFailure.save => AddWatchFormView.saveFailedMessage,
              }, style: TextStyle(color: colors.onErrorContainer)),
            ),
          ],
        ),
      ),
    );
  }
}
