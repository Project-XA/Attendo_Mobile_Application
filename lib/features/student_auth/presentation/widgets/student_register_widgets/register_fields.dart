// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';
import 'package:mobile_app/core/widgets/app_text_form_field.dart';

class RegisterFields extends StatelessWidget {
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final VoidCallback onTogglePassword;
  final VoidCallback onToggleConfirmPassword;

  const RegisterFields({
    super.key,
    required this.fullNameController,
    required this.emailController,
    required this.passwordController,

    required this.obscurePassword,
    required this.onTogglePassword,
    required this.confirmPasswordController,
    required this.onToggleConfirmPassword,
    required this.obscureConfirmPassword,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("Full Name"),
        verticalSpace(8),
        AppTextFormField(
          controller: fullNameController,
          hintText: "John Doe",
          borderRadius: 14.r,
          enabledBorderColor: Theme.of(context).colorScheme.outline,
          focusedBorderColor: Theme.of(context).colorScheme.onSurface,
          labelStyle: AppTextStyle.font14GreyMedium,
          label: Icon(
            Icons.person_outline_rounded,
            color: AppColors.subTextGreyColor,
            size: 20.sp,
          ),
          validator: (val) =>
              val == null || val.isEmpty ? "Enter your full name" : null,
        ),
        verticalSpace(16),

        _buildLabel("Email Address"),
        verticalSpace(8),
        AppTextFormField(
          controller: emailController,
          hintText: "name@example.com",
          borderRadius: 14.r,
          enabledBorderColor: Theme.of(context).colorScheme.outline,
          focusedBorderColor: Theme.of(context).colorScheme.onSurface,
          textStyle: AppTextStyle.font14GreyMedium,
          keyboardType: TextInputType.emailAddress,
          label: Icon(
            Icons.email_outlined,
            color: AppColors.subTextGreyColor,
            size: 20.sp,
          ),
          validator: (val) =>
              val == null || !val.contains('@') ? "Enter a valid email" : null,
        ),
        verticalSpace(16),

        _buildLabel("Password"),
        verticalSpace(8),
        AppTextFormField(
          controller: passwordController,
          hintText: "••••••••",
          borderRadius: 14.r,
          focusedBorderColor: Theme.of(context).colorScheme.onSurface,
          enabledBorderColor: Theme.of(context).colorScheme.outline,
          textStyle:AppTextStyle.font14GreyMedium,
          obscureText: obscurePassword,
          label: Icon(
            Icons.lock_outline_rounded,
            color: AppColors.subTextDarkColor,
            size: 20.sp,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              obscurePassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppColors.subTextDarkColor,
              size: 20.sp,
            ),
            onPressed: onTogglePassword,
          ),
          validator: (val) => val == null || val.length < 6
              ? "Password must be at least 6 characters"
              : null,
        ),
        verticalSpace(8),

        _buildLabel("Confirm Password"),
        verticalSpace(8),

        AppTextFormField(
          controller: confirmPasswordController,
          hintText: "••••••••",
          borderRadius: 14.r,
          enabledBorderColor: Theme.of(context).colorScheme.outline,
          focusedBorderColor: Theme.of(context).colorScheme.onSurface,
          textStyle: AppTextStyle.font14GreyMedium,
          obscureText: obscureConfirmPassword,
          label: Icon(
            Icons.lock_outline_rounded,
            color: AppColors.subTextDarkColor,
            size: 20.sp,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              obscureConfirmPassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppColors.subTextDarkColor,
              size: 20.sp,
            ),
            onPressed: onToggleConfirmPassword,
          ),
          validator: (val) => val == null || val.length < 6
              ? "Password must be at least 6 characters"
              : null,
        ),
      ],
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        color: AppColors.mainBackgroundDarkColor,
        fontSize: 14.sp,
        fontWeight: FontWeightHelper.semiBold,
      ),
    );
  }
}
