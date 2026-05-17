import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/routing/routes.dart';
import 'package:mobile_app/core/services/UI/extensions.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/features/auth/presentation/widgets/register_widgets/custom_text_field.dart';
import 'package:mobile_app/features/auth/presentation/widgets/register_widgets/field_label.dart';
import 'package:mobile_app/features/auth/presentation/widgets/register_widgets/password_field.dart';
import 'package:mobile_app/features/auth/presentation/widgets/register_widgets/section_title.dart';

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
        SectionTitle(title: 'auth.account_information'.tr()),
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
        FieldLabel(
          label: 'auth.organization_id'.tr(),
          icon: Icons.business_rounded,
        ),
        verticalSpace(8.h),
        CustomTextField(
          controller: orgIdController,
          hintText: 'auth.hint_org_id'.tr(),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'auth.val_org_id_required'.tr();
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
        FieldLabel(label: 'auth.email_label'.tr(), icon: Icons.email_rounded),
        verticalSpace(8.h),
        CustomTextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          hintText: 'auth.hint_email'.tr(),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'auth.val_email_required'.tr();
            }
            if (!_isEmailValid(value)) {
              return 'auth.val_email_invalid'.tr();
            }
            return null;
          },
        ),
      ],
    );
  }
Widget _buildForgotPasswordButton(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;

  return Align(
    alignment: Alignment.centerRight,
    child: TextButton(
      onPressed: () => context.pushNamed(Routes.forgotPasswordScreen),
      child: Text(
        'auth.forgot_password_link'.tr(),
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w500,
          color: colorScheme.primary.withOpacity(0.8),
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
