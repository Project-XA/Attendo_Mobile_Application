import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';
import 'package:mobile_app/core/widgets/app_text_form_field.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final bool obscureText;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.validator,
    this.keyboardType,
    this.suffixIcon,
    this.obscureText = false,
  });
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppTextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      suffixIcon: suffixIcon,
      contentPadding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 20.w),
      borderRadius: 16.r,
      focusedBorderColor: colorScheme.primary,
      enabledBorderColor: colorScheme.outline.withOpacity(0.4),
      hintText: hintText,
      labelStyle: TextStyle(
        fontSize: 14.sp,
        color: colorScheme.outline,
        fontWeight: FontWeightHelper.regular,
      ),
      textStyle: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeightHelper.medium,
        color: colorScheme.onSurface,
      ),
      validator: validator,
    );
  }
}
