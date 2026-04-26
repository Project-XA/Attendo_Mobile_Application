import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';
import 'package:mobile_app/core/widgets/app_text_form_field.dart';

/// Page 1 of the student registration form.
/// Fields: organizationCode, fullname, email, confirmEmail.
class RegisterFieldsPage1 extends StatelessWidget {
  final TextEditingController organizationCodeController;
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController confirmEmailController;

  const RegisterFieldsPage1({
    super.key,
    required this.organizationCodeController,
    required this.fullNameController,
    required this.emailController,
    required this.confirmEmailController,
  });

  // ── shared field style constants ───────────────────────────────────────────
  static const _fieldBg = Color(0xFFF5F5F5);
  static const _fieldBorder = Color(0xFFE0E0E0);
  static const _fieldIcon = Color(0xFFBDBDBD);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Organization Code ────────────────────────────────────────────────
        _buildLabel('registerStudent.org_code_label'.tr()),
        verticalSpace(8),
        AppTextFormField(
          controller: organizationCodeController,
          hintText: 'registerStudent.org_code_hint'.tr(),
          borderRadius: 14.r,
          backgroundColor: _fieldBg,
          enabledBorderColor: _fieldBorder,
          focusedBorderColor: AppColors.mainBackgroundDarkColor,
          textStyle: TextStyle(
            color: AppColors.mainBackgroundDarkColor,
            fontSize: 14.sp,
          ),
          keyboardType: TextInputType.number,
          label: const Icon(
            Icons.business_outlined,
            color: _fieldIcon,
            size: 20,
          ),
          validator: (val) {
            if (val == null || val.isEmpty) {
              return 'validationRegisterStudent.enter_org_code'.tr();
            }
            if (int.tryParse(val) == null) {
              return 'validationRegisterStudent.organization_code_invalid'.tr();
            }
            return null;
          },
        ),
        verticalSpace(16),

        // ── Full Name ────────────────────────────────────────────────────────
        _buildLabel('registerStudent.full_name_label'.tr()),
        verticalSpace(8),
        AppTextFormField(
          controller: fullNameController,
          hintText: 'registerStudent.full_name_hint'.tr(),
          borderRadius: 14.r,
          backgroundColor: _fieldBg,
          enabledBorderColor: _fieldBorder,
          focusedBorderColor: AppColors.mainBackgroundDarkColor,
          textStyle: TextStyle(
            color: AppColors.mainBackgroundDarkColor,
            fontSize: 14.sp,
          ),
          label: const Icon(
            Icons.person_outline_rounded,
            color: _fieldIcon,
            size: 20,
          ),
          validator: (val) => val == null || val.isEmpty
              ? 'validationRegisterStudent.enter_full_name'.tr()
              : null,
        ),
        verticalSpace(16),

        // ── Email ────────────────────────────────────────────────────────────
        _buildLabel('registerStudent.email_label'.tr()),
        verticalSpace(8),
        AppTextFormField(
          controller: emailController,
          hintText: 'registerStudent.email_hint'.tr(),
          borderRadius: 14.r,
          backgroundColor: _fieldBg,
          enabledBorderColor: _fieldBorder,
          focusedBorderColor: AppColors.mainBackgroundDarkColor,
          textStyle: TextStyle(
            color: AppColors.mainBackgroundDarkColor,
            fontSize: 14.sp,
          ),
          keyboardType: TextInputType.emailAddress,
          label: const Icon(Icons.email_outlined, color: _fieldIcon, size: 20),
          validator: (val) => val == null || !val.contains('@')
              ? 'validationRegisterStudent.enter_valid_email'.tr()
              : null,
        ),
        verticalSpace(16),

        // ── Confirm Email ────────────────────────────────────────────────────
        _buildLabel('registerStudent.confirm_email_label'.tr()),
        verticalSpace(8),
        AppTextFormField(
          controller: confirmEmailController,
          hintText: 'registerStudent.confirm_email_hint'.tr(),
          borderRadius: 14.r,
          backgroundColor: _fieldBg,
          enabledBorderColor: _fieldBorder,
          focusedBorderColor: AppColors.mainBackgroundDarkColor,
          textStyle: TextStyle(
            color: AppColors.mainBackgroundDarkColor,
            fontSize: 14.sp,
          ),
          keyboardType: TextInputType.emailAddress,
          label: const Icon(
            Icons.mark_email_read_outlined,
            color: _fieldIcon,
            size: 20,
          ),
          validator: (val) {
            if (val == null || !val.contains('@')) {
              return 'validationRegisterStudent.enter_valid_email'.tr();
            }
            if (val != emailController.text) {
              return 'validationRegisterStudent.emails_no_match'.tr();
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: AppTextStyle.font14GreyMedium.copyWith(
        color: AppColors.mainBackgroundDarkColor,
        fontWeight: FontWeightHelper.semiBold,
      ),
    );
  }
}
