import 'package:flutter/material.dart';

class WatchListFailureView extends StatelessWidget {
  const WatchListFailureView({required this.onRetry, super.key});

  static const String message = "We couldn't load your watches.";
  static const String retryLabel = 'Try again';

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        children: [
          const Text(message),
          FilledButton(onPressed: onRetry, child: const Text(retryLabel)),
        ],
      ),
    );
  }
}
