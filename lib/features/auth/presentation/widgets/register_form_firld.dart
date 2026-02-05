import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/routing/routes.dart';
import 'package:mobile_app/core/services/UI/extensions.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:mobile_app/features/auth/presentation/widgets/field_label.dart';
import 'package:mobile_app/features/auth/presentation/widgets/password_field.dart';
import 'package:mobile_app/features/auth/presentation/widgets/section_title.dart';

class RegisterFormFields extends StatelessWidget {
  final TextEditingController orgIdController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const RegisterFormFields({
    super.key,
    required this.orgIdController,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: 'Account Information'),
        verticalSpace(15.h),
        _buildOrgIdField(),
        verticalSpace(15.h),
        _buildEmailField(),
        verticalSpace(15.h),
        PasswordField(controller: passwordController),
        verticalSpace(8.h),
        _buildForgotPasswordButton(context),
      ],
    );
  }

  Widget _buildOrgIdField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FieldLabel(
          label: 'Organization ID',
          icon: Icons.business_rounded,
        ),
        verticalSpace(8.h),
        CustomTextField(
          controller: orgIdController,
          hintText: 'Enter your organization ID',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Organization ID is required';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FieldLabel(
          label: 'Email Address',
          icon: Icons.email_rounded,
        ),
        verticalSpace(8.h),
        CustomTextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          hintText: 'example@email.com',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Email is required';
            }
            if (!_isEmailValid(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildForgotPasswordButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          context.pushNamed(Routes.forgotPasswordScreen);
        },
        child: Text(
          'Forgot Password?',
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.mainTextColorBlack.withOpacity(0.7),
          ),
        ),
      ),
    );
  }

  bool _isEmailValid(String email) {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(email);
  }
}