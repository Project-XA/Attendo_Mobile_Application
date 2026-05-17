import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/widgets/app_text_form_field.dart';

class LoginStudentFormFields extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController organizationCodeController;

  const LoginStudentFormFields({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.organizationCodeController,
  });

  @override
  State<LoginStudentFormFields> createState() => _LoginStudentFormFieldsState();
}

class _LoginStudentFormFieldsState extends State<LoginStudentFormFields> {
  bool _obscurePassword = true;

  

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final fieldBg = colorScheme.surfaceContainerHighest;
    final fieldBorder = colorScheme.outline;
    final fieldIcon = colorScheme.outline;
    final fieldText = colorScheme.onSurface;
    final focusBorderColor = colorScheme.primary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            'loginStudent.org_code'.tr(),
            style: AppTextStyle.font14GreyMedium,
          ),
        ),
        verticalSpace(8.h),
        AppTextFormField(
          controller: widget.organizationCodeController,
          hintText: 'loginStudent.org_code_hint'.tr(),
          borderRadius: 14.r,
          backgroundColor: fieldBg,
          enabledBorderColor: fieldBorder,
          focusedBorderColor: focusBorderColor,
          textStyle: TextStyle(
            color: fieldText,
            fontSize: 14.sp,
          ),
          label: Icon(
            Icons.apartment_outlined,
            color: fieldIcon,
            size: 20,
          ),
          validator: (val) => val == null || val.isEmpty
              ? 'validation.enter_org_code'.tr()
              : null,
        ),
        // Email
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            'loginStudent.email_label'.tr(),
            style: AppTextStyle.font14GreyMedium,
          ),
        ),
        SizedBox(height: 8.h),
        AppTextFormField(
          controller: widget.emailController,
          hintText: 'loginStudent.email_hint'.tr(),
          borderRadius: 14.r,
          backgroundColor: fieldBg,
          enabledBorderColor: fieldBorder,
          focusedBorderColor: focusBorderColor,
          textStyle: TextStyle(
            color: fieldText,
            fontSize: 14.sp,
          ),
          keyboardType: TextInputType.emailAddress,
          label:  Icon(Icons.email_outlined, color: fieldIcon, size: 20),
          validator: (val) => val == null || !val.contains('@')
              ? 'validation.enter_valid_email'.tr()
              : null,
        ),

        SizedBox(height: 16.h),

        // Password
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            'loginStudent.password_label'.tr(),
            style: AppTextStyle.font14BlackMedium,
          ),
        ),
        SizedBox(height: 8.h),
        AppTextFormField(
          controller: widget.passwordController,
          hintText: '••••••••',
          borderRadius: 14.r,
          backgroundColor: fieldBg,
          enabledBorderColor: fieldBorder,
          focusedBorderColor: focusBorderColor,
          textStyle: TextStyle(
            color: fieldText,
            fontSize: 14.sp,
          ),
          obscureText: _obscurePassword,
          label:  Icon(
            Icons.lock_outline_rounded,
            color: fieldIcon,
            size: 20,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: fieldIcon,
              size: 20,
            ),
            onPressed: () =>
                setState(() => _obscurePassword = !_obscurePassword),
          ),
          validator: (val) => val == null || val.length < 6
              ? 'validation.password_min_chars'.tr()
              : null,
        ),
      ],
    );
  }
}
