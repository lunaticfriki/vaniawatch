import 'package:flutter/material.dart';
import 'package:frontend/modules/watch/application/watch_read_model.dart';
import 'package:frontend/modules/watch/presentation/watch_card_view.dart';

class WatchListView extends StatelessWidget {
  const WatchListView({required this.watches, super.key});

  static const String title = 'All watches';
  static const String emptyMessage = 'Your collection is empty.';

  final List<WatchReadModel> watches;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 12,
      children: [
        Text(title, style: theme.textTheme.headlineSmall),
        Text(
          watches.length == 1 ? '1 watch' : '${watches.length} watches',
          style: theme.textTheme.bodyMedium,
        ),
        if (watches.isEmpty) const Text(emptyMessage),
        for (final watch in watches) WatchCardView(watch: watch),
      ],
    );
  }
}
