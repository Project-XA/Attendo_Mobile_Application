import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
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
    return AppTextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      suffixIcon: suffixIcon,
      contentPadding: EdgeInsets.symmetric(
        vertical: 18.h,
        horizontal: 20.w,
      ),
      borderRadius: 16.r,
      focusedBorderColor: AppColors.mainTextColorBlack,
      enabledBorderColor: Colors.grey.shade300,
      hintText: hintText,
      labelStyle: TextStyle(
        fontSize: 14.sp,
        color: Colors.grey.shade400,
        fontWeight: FontWeightHelper.regular,
      ),
      textStyle: AppTextStyle.font18BoldBlack.copyWith(
        fontSize: 14.sp,
        fontWeight: FontWeightHelper.medium,
      ),
      validator: validator,
    );
  }
}