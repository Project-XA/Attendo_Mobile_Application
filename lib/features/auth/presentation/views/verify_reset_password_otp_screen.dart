import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/routing/routes.dart';
import 'package:mobile_app/core/services/UI/extensions.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/features/auth/presentation/logic/auth_cubit.dart';
import 'package:mobile_app/features/auth/presentation/logic/auth_state.dart';
import 'package:mobile_app/features/auth/presentation/widgets/register_widgets/custom_text_field.dart';
import 'package:mobile_app/features/auth/presentation/widgets/register_widgets/field_label.dart';
import 'package:mobile_app/features/auth/presentation/widgets/register_widgets/register_submit_button.dart';

class VerifyResetPasswordOtpScreen extends StatefulWidget {
  const VerifyResetPasswordOtpScreen({super.key});

  @override
  State<VerifyResetPasswordOtpScreen> createState() =>
      _VerifyResetPasswordOtpScreenState();
}

class _VerifyResetPasswordOtpScreenState
    extends State<VerifyResetPasswordOtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _otpController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthCubit>().verifyOtpAndResetPassword(
      otp: _otpController.text.trim(),
      newPassword: _newPasswordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    // ✅ جيب الـ email من الـ state مباشرة
    final email = context.read<AuthCubit>().state.email ?? '';

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.resetPasswordSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message ?? '')),
          );
          context.pushReplacmentNamed(Routes.registerScreen);
        } else if (state.status == AuthStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error?.message ?? ''),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == AuthStatus.loading;

        return Scaffold(
          backgroundColor: AppColors.backGroundColorWhite,
          appBar: AppBar(
            backgroundColor: AppColors.backGroundColorWhite,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              color: AppColors.mainTextColorBlack,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    verticalSpace(16.h),
                    Text(
                      'verify_otp_title'.tr(),
                      style: AppTextStyle.font18BoldBlack.copyWith(
                        fontSize: 24.sp,
                      ),
                    ),
                    verticalSpace(8.h),
                    Text(
                      'verify_otp_subtitle'.tr(args: [email]),
                      style: AppTextStyle.font14MediamGrey,
                    ),
                    verticalSpace(24.h),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const FieldLabel(
                            label: 'OTP',
                            icon: Icons.verified_rounded,
                          ),
                          verticalSpace(8.h),
                          CustomTextField(
                            controller: _otpController,
                            keyboardType: TextInputType.number,
                            hintText: '123456',
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'otp_required'.tr();
                              }
                              if (value.trim().length < 4) {
                                return 'otp_too_short'.tr();
                              }
                              return null;
                            },
                          ),
                          verticalSpace(16.h),
                          const FieldLabel(
                            label: 'New Password',
                            icon: Icons.lock_reset_rounded,
                          ),
                          verticalSpace(8.h),
                          CustomTextField(
                            controller: _newPasswordController,
                            hintText: 'new_password_hint'.tr(),
                            obscureText: !_isPasswordVisible,
                            suffixIcon: IconButton(
                              onPressed: () => setState(
                                () => _isPasswordVisible = !_isPasswordVisible,
                              ),
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility_rounded
                                    : Icons.visibility_off_rounded,
                                color: Colors.grey.shade500,
                                size: 22.sp,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'password_required'.tr();
                              }
                              if (value.length < 8) {
                                return 'password_too_short'.tr();
                              }
                              return null;
                            },
                          ),
                          verticalSpace(24.h),
                          RegisterSubmitButton(
                            isLoading: isLoading,
                            onPressed: _onSubmit,
                            text: 'reset_password'.tr(),
                            icon: Icons.lock_reset_rounded,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}