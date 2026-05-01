import 'package:flutter/material.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';

class EmptyHistoryPlaceholder extends StatelessWidget {
  final bool isDark;

  const EmptyHistoryPlaceholder({required this.isDark, super.key});

  @override
  Widget build(BuildContext context) {
    final color = isDark
        ? AppColors.subTextDarkColor
        : AppColors.subTextGreyColor;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.history_toggle_off_rounded, size: 44, color: color),
            verticalSpace(10),
            Text(
              'No attendance records yet',
              style: TextStyle(
                fontSize: 14,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
