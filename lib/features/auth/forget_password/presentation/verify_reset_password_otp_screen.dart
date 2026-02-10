import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/DI/get_it.dart';
import 'package:mobile_app/core/routing/routes.dart';
import 'package:mobile_app/core/services/UI/extensions.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/features/auth/forget_password/presentation/logic/forgot_password_cubit.dart';
import 'package:mobile_app/features/auth/forget_password/presentation/logic/forgot_password_state.dart';
import 'package:mobile_app/features/auth/register/presentation/widgets/custom_text_field.dart';
import 'package:mobile_app/features/auth/register/presentation/widgets/field_label.dart';
import 'package:mobile_app/features/auth/register/presentation/widgets/register_submit_button.dart';


class VerifyResetPasswordOtpScreen extends StatefulWidget {
  final String email;
  const VerifyResetPasswordOtpScreen({super.key, required this.email});

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

  void _onSubmit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    context.read<ForgotPasswordCubit>().verifyOtpAndResetPassword(
          email: widget.email.trim(),
          otp: _otpController.text.trim(),
          newPassword: _newPasswordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ForgotPasswordCubit>(),
      child: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
        listener: (context, state) {
          if (state is ForgotPasswordResetSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            context.pushReplacmentNamed(Routes.registerScreen);
          } else if (state is ForgotPasswordFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is ForgotPasswordVerifyLoadingState;

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
                        'Verify OTP',
                        style: AppTextStyle.font18BoldBlack.copyWith(
                          fontSize: 24.sp,
                        ),
                      ),
                      verticalSpace(8.h),
                      Text(
                        'We sent an OTP to ${widget.email}. Enter it below and choose a new password.',
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
                                  return 'OTP is required';
                                }
                                if (value.trim().length < 4) {
                                  return 'OTP is too short';
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
                              hintText: 'Enter new password',
                              obscureText: !_isPasswordVisible,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
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
                                  return 'New password is required';
                                }
                                if (value.length < 8) {
                                  return 'Password must be at least 8 characters';
                                }
                                return null;
                              },
                            ),
                            verticalSpace(24.h),
                            RegisterSubmitButton(
                              isLoading: isLoading,
                              onPressed: () => _onSubmit(context),
                              text: 'Reset Password',
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
      ),
    );
  }
}

