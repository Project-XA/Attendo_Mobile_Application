import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/DI/get_it.dart';
import 'package:mobile_app/core/routing/routes.dart';
import 'package:mobile_app/core/services/UI/extensions.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/features/auth/presentation/logic/forgot_password_cubit.dart';
import 'package:mobile_app/features/auth/presentation/logic/forgot_password_state.dart';
import 'package:mobile_app/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:mobile_app/features/auth/presentation/widgets/field_label.dart';
import 'package:mobile_app/features/auth/presentation/widgets/register_submit_button.dart';

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

  void _onSubmit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    context.read<ForgotPasswordCubit>().sendResetOtp(
          email: _emailController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ForgotPasswordCubit>(),
      child: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
        listener: (context, state) {
          if (state is ForgotPasswordOtpSentState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            context.pushNamed(
              Routes.verifyResetPasswordOtpScreen,
              arguments: _emailController.text.trim(),
            );
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
          final isLoading = state is ForgotPasswordSendOtpLoadingState;

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
                        'Forgot Password',
                        style: AppTextStyle.font18BoldBlack.copyWith(
                          fontSize: 24.sp,
                        ),
                      ),
                      verticalSpace(8.h),
                      Text(
                        'Enter your registered email address and we will send you an OTP.',
                        style: AppTextStyle.font14MediamGrey,
                      ),
                      verticalSpace(24.h),
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const FieldLabel(
                              label: 'Email Address',
                              icon: Icons.email_rounded,
                            ),
                            verticalSpace(8.h),
                            CustomTextField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              hintText: 'example@email.com',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Email is required';
                                }
                                final emailRegex = RegExp(
                                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                                );
                                if (!emailRegex.hasMatch(value)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            verticalSpace(24.h),
                            RegisterSubmitButton(
                              isLoading: isLoading,
                              onPressed: () => _onSubmit(context),
                              text: 'Send OTP',
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
      ),
    );
  }
}

