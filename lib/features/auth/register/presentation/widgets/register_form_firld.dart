import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/routing/routes.dart';
import 'package:mobile_app/core/services/UI/extensions.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/features/auth/register/presentation/widgets/custom_text_field.dart';
import 'package:mobile_app/features/auth/register/presentation/widgets/field_label.dart';
import 'package:mobile_app/features/auth/register/presentation/widgets/password_field.dart';
import 'package:mobile_app/features/auth/register/presentation/widgets/section_title.dart';

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
        SectionTitle(title: 'account_information'.tr()),
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
        FieldLabel(label: 'org_id_label'.tr(), icon: Icons.business_rounded),
        verticalSpace(8.h),
        CustomTextField(
          controller: orgIdController,
          hintText: 'org_id_hint'.tr(),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'org_id_required'.tr();
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
        FieldLabel(label: 'email_label'.tr(), icon: Icons.email_rounded),
        verticalSpace(8.h),
        CustomTextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          hintText: 'email_hint'.tr(),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'email_required'.tr();
            }
            if (!_isEmailValid(value)) {
              return 'email_invalid'.tr();
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
          'forgot_password'.tr(),
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
