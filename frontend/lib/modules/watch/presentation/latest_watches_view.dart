import 'package:flutter/material.dart';
import 'package:frontend/modules/watch/application/watch_read_model.dart';
import 'package:frontend/modules/watch/presentation/watch_card_view.dart';

class LatestWatchesView extends StatelessWidget {
  const LatestWatchesView({
    required this.watches,
    required this.onSeeAll,
    super.key,
  });

  static const String title = 'Latest watches';
  static const String emptyMessage = 'Your collection is empty.';
  static const String seeAllLabel = 'See all watches';

  final List<WatchReadModel> watches;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 12,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
        if (watches.isEmpty) const Text(emptyMessage),
        for (final watch in watches) WatchCardView(watch: watch),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: onSeeAll,
            child: const Text(seeAllLabel),
          ),
        ),
      ],
    );
  }
}
