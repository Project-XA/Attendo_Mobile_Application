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
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        verticalSpace(5),
        TextField(
          controller: controller,
          obscureText: obscure,
          style: TextStyle(fontSize: 13.sp, color: colorScheme.onSurface),
          decoration: InputDecoration(
            hintText: 'privacy.password_placeholder'.tr(),
            hintStyle: TextStyle(
              fontSize: 13.sp,
              color: colorScheme.outline,
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
                color: colorScheme.outline,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: colorScheme.outline.withOpacity(0.5),
                width: 0.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: colorScheme.outline.withOpacity(0.5),
                width: 0.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(
                color: AppColors.buttonBlueColor,
                width: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}