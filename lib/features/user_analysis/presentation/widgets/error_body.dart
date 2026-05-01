import 'package:flutter/material.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';

class ErrorBody extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorBody({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 52, color: Colors.grey),
            verticalSpace(16),
            Text(
              'Failed to load data',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            verticalSpace(8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            verticalSpace(24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
