
import 'package:flutter/material.dart';

class HistoryErrorBanner extends StatelessWidget {
  final String message;
  final bool isDark;
  final VoidCallback onRetry;

  const HistoryErrorBanner({
    required this.message,
    required this.isDark,
    required this.onRetry,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF3A1A1A)
            : const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded,
              size: 16, color: Color(0xFFC62828)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                  fontSize: 12, color: Color(0xFFC62828)),
              maxLines: 2,
            ),
          ),
          TextButton(
            onPressed: onRetry,
            child: const Text('Retry',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFC62828))),
          ),
        ],
      ),
    );
  }
}