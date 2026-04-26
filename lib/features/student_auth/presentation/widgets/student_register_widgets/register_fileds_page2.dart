import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';
import 'package:mobile_app/core/widgets/app_text_form_field.dart';
import 'package:mobile_app/features/student_auth/presentation/widgets/student_register_widgets/auth_password_field.dart';

/// Page 2 of the student registration form.
/// Fields: rollNumber, password, confirmPassword.
class RegisterFieldsPage2 extends StatelessWidget {
  final TextEditingController rollNumberController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const RegisterFieldsPage2({
    super.key,
    required this.rollNumberController,
    required this.passwordController,
    required this.confirmPasswordController,
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
        // ── Roll Number ──────────────────────────────────────────────────────
        _buildLabel('registerStudent.roll_number_label'.tr()),
        verticalSpace(8),
        AppTextFormField(
          controller: rollNumberController,
          hintText: 'registerStudent.roll_number_hint'.tr(),
          borderRadius: 14.r,
          backgroundColor: _fieldBg,
          enabledBorderColor: _fieldBorder,
          focusedBorderColor: AppColors.mainBackgroundDarkColor,
          textStyle: TextStyle(
            color: AppColors.mainBackgroundDarkColor,
            fontSize: 14.sp,
          ),
          keyboardType: TextInputType.text,
          label: const Icon(
            Icons.confirmation_number_outlined,
            color: _fieldIcon,
            size: 20,
          ),
          validator: (val) =>
              val == null || val.isEmpty ? 'validationRegisterStudent.enter_roll_number'.tr() : null,
        ),
        verticalSpace(16),

        // ── Password ─────────────────────────────────────────────────────────
        _buildLabel('registerStudent.password_label'.tr()),
        verticalSpace(8),
        AuthPasswordField(
          controller: passwordController,
          hintText: '••••••••',
          validator: (val) => val == null || val.length < 6
              ? 'validationRegisterStudent.password_min_chars'.tr()
              : null,
        ),
        verticalSpace(16),

        // ── Confirm Password ─────────────────────────────────────────────────
        _buildLabel('registerStudent.confirm_password_label'.tr()),
        verticalSpace(8),
        AuthPasswordField(
          controller: confirmPasswordController,
          hintText: '••••••••',
          validator: (val) {
            if (val == null || val.length < 6) {
              return 'validationRegisterStudent.password_min_chars'.tr();
            }
            if (val != passwordController.text) {
              return 'validationRegisterStudent.passwords_not_match'.tr();
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
