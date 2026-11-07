import 'dart:typed_data';

import 'package:flutter/material.dart';

class AddWatchImageView extends StatelessWidget {
  const AddWatchImageView({
    required this.bytes,
    required this.fileName,
    required this.isEnabled,
    required this.isAvailable,
    required this.onPick,
    required this.onRemove,
    super.key,
  });

  static const String title = 'Photo';
  static const String chooseLabel = 'Choose image';
  static const String changeLabel = 'Change image';
  static const String removeLabel = 'Remove';
  static const String unavailableMessage =
      'Image upload is not set up yet. You can still save the watch.';
  static const double previewHeight = 220;

  final Uint8List? bytes;
  final String? fileName;
  final bool isEnabled;
  final bool isAvailable;
  final VoidCallback onPick;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final picked = bytes;
    final canPick = isEnabled && isAvailable;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8,
      children: [
        Text(title, style: theme.textTheme.titleSmall),
        if (picked != null)
          AddWatchImagePreview(bytes: picked, fileName: fileName ?? ''),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            OutlinedButton.icon(
              onPressed: canPick ? onPick : null,
              icon: const Icon(Icons.photo_outlined),
              label: Text(picked == null ? chooseLabel : changeLabel),
            ),
            if (picked != null)
              TextButton.icon(
                onPressed: isEnabled ? onRemove : null,
                icon: const Icon(Icons.close),
                label: const Text(removeLabel),
              ),
          ],
        ),
        if (!isAvailable)
          Text(
            unavailableMessage,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
      ],
    );
  }
}

class AddWatchImagePreview extends StatelessWidget {
  const AddWatchImagePreview({
    required this.bytes,
    required this.fileName,
    super.key,
  });

  final Uint8List bytes;
  final String fileName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: ColoredBox(
            color: theme.colorScheme.surfaceContainerHighest,
            child: SizedBox(
              height: AddWatchImageView.previewHeight,
              width: double.infinity,
              child: Image.memory(
                bytes,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    const Center(child: Icon(Icons.broken_image_outlined)),
              ),
            ),
          ),
        ),
        Text(fileName, style: theme.textTheme.bodySmall),
      ],
    );
  }
}
