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

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthCubit>().sendResetOtp(
      email: _emailController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.otpSent) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message ?? '')),
          );
          context.pushNamed(Routes.verifyResetPasswordOtpScreen);
          // ✅ مش محتاج تبعت email — الـ cubit بيحتفظ بيه في state.email
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
                      'forgot_password_title'.tr(),
                      style: AppTextStyle.font18BoldBlack.copyWith(
                        fontSize: 24.sp,
                      ),
                    ),
                    verticalSpace(8.h),
                    Text(
                      'forgot_password_subtitle'.tr(),
                      style: AppTextStyle.font14MediamGrey,
                    ),
                    verticalSpace(24.h),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FieldLabel(
                            label: 'email_label'.tr(),
                            icon: Icons.email_rounded,
                          ),
                          verticalSpace(8.h),
                          CustomTextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            hintText: 'email_hint'.tr(),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'email_required'.tr();
                              }
                              final emailRegex = RegExp(
                                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                              );
                              if (!emailRegex.hasMatch(value)) {
                                return 'email_invalid'.tr();
                              }
                              return null;
                            },
                          ),
                          verticalSpace(24.h),
                          RegisterSubmitButton(
                            isLoading: isLoading,
                            onPressed: _onSubmit,
                            text: 'send_otp'.tr(),
                            icon: Icons.mail_outline_rounded,
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