import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';

class PasswordField extends StatelessWidget {
  const PasswordField({
    required this.label,
    required this.controller,
    required this.obscure,
    required this.onToggle,
    super.key,
  });

  final String label;
  final TextEditingController controller;
  final bool obscure;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    // Use Theme.of directly — never store colorScheme before the widget is
    // fully mounted inside a Theme ancestor.
    final outline = Theme.of(context).colorScheme.outline;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final primary = Theme.of(context).colorScheme.primary;
    final surface = Theme.of(context).colorScheme.surface;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final borderColor = isDark
        ? AppColors.borderDarkColor
        : AppColors.subTextGreyColor;

    final hintColor = isDark
        ? AppColors.subTextDarkColor
        : AppColors.subTextGreyColor;

    final borderSide = BorderSide(color: borderColor, width: 0.5);
    final borderRadius = BorderRadius.circular(8.r);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12.sp, color: outline),
        ),
        verticalSpace(5),
        TextField(
          controller: controller,
          obscureText: obscure,
          style: TextStyle(fontSize: 13.sp, color: onSurface),
          decoration: InputDecoration(
            filled: true,
            fillColor: surface,
            hintText: 'privacy.password_placeholder'.tr(),
            hintStyle: TextStyle(
              fontSize: 13.sp,
              color: hintColor, // ← no withOpacity — uses a real token
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 10.h,
            ),
            suffixIcon: GestureDetector(
              onTap: onToggle,
              child: Icon(
                obscure
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 18.sp,
                color: outline,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: borderSide,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: borderSide,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: BorderSide(color: primary, width: 1),
            ),
          ),
        ),
      ],
    );
  }
}
