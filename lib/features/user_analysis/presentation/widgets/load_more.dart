import 'package:flutter/material.dart';
import 'package:mobile_app/core/themes/app_colors.dart';

class LoadMoreRow extends StatelessWidget {
  final bool isLoading;
  final bool isDark;
  final VoidCallback onTap;

  const LoadMoreRow({
    required this.isLoading,
    required this.isDark,
    required this.onTap,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark
        ? AppColors.buttonBlueTextDarkColor
        : AppColors.buttonBlueColor;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: isLoading
            ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  valueColor: AlwaysStoppedAnimation<Color>(textColor),
                ),
              )
            : TextButton(
                onPressed: onTap,
                style: TextButton.styleFrom(
                  foregroundColor: textColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: textColor.withOpacity(0.35)),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Load more',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(Icons.keyboard_arrow_down_rounded,
                        size: 18, color: textColor),
                  ],
                ),
              ),
      ),
    );
  }
}