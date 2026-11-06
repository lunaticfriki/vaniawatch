import 'package:flutter/material.dart';

class WatchListSkeleton extends StatelessWidget {
  const WatchListSkeleton({this.count = 5, super.key});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 12,
      children: [
        for (var index = 0; index < count; index++)
          const WatchCardPlaceholder(),
      ],
    );
  }
}

class WatchCardPlaceholder extends StatelessWidget {
  const WatchCardPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 104,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
