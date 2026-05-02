import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';

enum ActionButtonVariant { primary, warning, danger }

class ActionButton extends StatelessWidget {
  const ActionButton({
    required this.label,
    required this.isLoading,
    required this.onTap,
    this.outlined = false,
    this.enabled = true,
    this.variant = ActionButtonVariant.primary,
    super.key,
  });

  final String label;
  final bool isLoading;
  final VoidCallback onTap;
  final bool outlined;
  final bool enabled;
  final ActionButtonVariant variant;

  Color _resolveColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    switch (variant) {
      case ActionButtonVariant.danger:
        return colorScheme.error;
      case ActionButtonVariant.warning:
        return isDark
            ? AppColors.buttonBlueTextDarkColor
            : AppColors.statusGreenTextDarkColor;
      case ActionButtonVariant.primary:
      return isDark
            ? AppColors.buttonBlueTextDarkColor
            : AppColors.buttonBlueColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _resolveColor(context);
    final colorScheme = Theme.of(context).colorScheme;
    final isDisabled = !enabled || isLoading;

    final Color fillColor;
    final Color labelColor;
    final Border? border;

    if (outlined) {
      fillColor = colorScheme.surface;
      labelColor = isDisabled ? color.withOpacity(0.4) : color;
      border = Border.all(
        color: isDisabled ? color.withOpacity(0.4) : color,
        width: 1,
      );
    } else {
      fillColor = isDisabled ? color.withOpacity(0.4) : color;
      labelColor = colorScheme.onPrimary;
      border = null;
    }

    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: isDisabled ? null : onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: BorderRadius.circular(10.r),
            border: border,
          ),
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: 18.r,
                    height: 18.r,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: outlined ? color : colorScheme.onPrimary,
                    ),
                  )
                : Text(
                    label,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeightHelper.semiBold,
                      color: labelColor,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}