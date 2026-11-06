import 'package:flutter/material.dart';
import 'package:frontend/modules/watch/application/watch_read_model.dart';

class WatchCardView extends StatelessWidget {
  const WatchCardView({required this.watch, super.key});

  final WatchReadModel watch;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Text(watch.name, style: theme.textTheme.titleMedium),
            Text(
              '${watch.brand} · ${watch.type} · ${watch.category}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (watch.tags.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final tag in watch.tags)
                    Chip(
                      label: Text(tag),
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
