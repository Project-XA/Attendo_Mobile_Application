import 'package:flutter/material.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';

class CacheBadge extends StatelessWidget {
  const CacheBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.buttonBlueBgDarkColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.info_outline,
            size: 14,
            color: AppColors.buttonBlueTextDarkColor,
          ),

          horizontalSpace(6),
          Text(
            'Showing cached data — pull to refresh',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.buttonBlueTextDarkColor,
            ),
          ),
        ],
      ),
    );
  }
}
