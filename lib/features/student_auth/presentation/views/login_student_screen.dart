// ignore_for_file: deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/core/routing/routes.dart';
import 'package:mobile_app/core/services/UI/extensions.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';
import 'package:mobile_app/core/widgets/app_text_form_field.dart';
import 'package:mobile_app/core/widgets/custom_app_button.dart';
import 'package:mobile_app/features/student_auth/data/model/login_student_request_body.dart';
import 'package:mobile_app/features/student_auth/presentation/logic/student_auth_cubit.dart';
import 'package:mobile_app/features/student_auth/presentation/logic/student_auth_state.dart';

class LoginStudentScreen extends StatefulWidget {
  const LoginStudentScreen({super.key});

  @override
  State<LoginStudentScreen> createState() => _LoginStudentScreenState();
}

class _LoginStudentScreenState extends State<LoginStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  static const _fieldBg = Color(0xFFF5F5F5);
  static const _fieldBorder = Color(0xFFE0E0E0);
  static const _fieldIcon = Color(0xFFBDBDBD);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: AppColors.mainBackgroundWhiteColor,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(text: "Attendo", style: AppTextStyle.font18BlackBold),
            ],
          ),
        ),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.mainBackgroundDarkColor,
            size: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              verticalSpace(40),
              Text(
                'loginStudent.welcome_back'.tr(),
                style: AppTextStyle.font24BlackBold,
              ),
              verticalSpace(8),
              Text(
                'loginStudent.subtitle'.tr(),
                style: AppTextStyle.font14GreyRegular,
              ),
              verticalSpace(20),

              // ── Student Badge ─────────────────────────────────────────
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.mainBackgroundDarkColor.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: AppColors.mainBackgroundDarkColor.withOpacity(
                        0.12,
                      ),
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.all(6.r),
                        decoration: BoxDecoration(
                          color: AppColors.mainBackgroundDarkColor,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.school_rounded,
                          size: 16.sp,
                          color: AppColors.mainBackgroundWhiteColor,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'loginStudent.portal_badge'.tr(),
                            style: TextStyle(
                              color: AppColors.mainBackgroundDarkColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeightHelper.semiBold,
                            ),
                          ),
                          Text(
                            'loginStudent.portal_badge_sub'.tr(),
                            style: TextStyle(
                              color: AppColors.subTextGreyColor,
                              fontSize: 11.sp,
                              fontWeight: FontWeightHelper.regular,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              verticalSpace(36),

              // ── Email ─────────────────────────────────────────────
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  'loginStudent.email_label'.tr(),
                  style: AppTextStyle.font14GreyMedium,
                ),
              ),
              verticalSpace(8),
              AppTextFormField(
                controller: _emailController,
                hintText: 'loginStudent.email_hint'.tr(),
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
                  Icons.email_outlined,
                  color: _fieldIcon,
                  size: 20,
                ),
                validator: (val) => val == null || !val.contains('@')
                    ? 'validation.enter_valid_email'.tr()
                    : null,
              ),

              verticalSpace(16),

              // ── Password ──────────────────────────────────────────
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  'loginStudent.password_label'.tr(),
                  style: AppTextStyle.font14BlackMedium,
                ),
              ),
              verticalSpace(8),
              AppTextFormField(
                controller: _passwordController,
                hintText: '••••••••',
                borderRadius: 14.r,
                backgroundColor: _fieldBg,
                enabledBorderColor: _fieldBorder,
                focusedBorderColor: AppColors.mainBackgroundDarkColor,
                textStyle: TextStyle(
                  color: AppColors.mainBackgroundDarkColor,
                  fontSize: 14.sp,
                ),
                obscureText: _obscurePassword,
                label: const Icon(
                  Icons.lock_outline_rounded,
                  color: _fieldIcon,
                  size: 20,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: _fieldIcon,
                    size: 20,
                  ),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
                validator: (val) => val == null || val.length < 6
                    ? 'validation.password_min_chars'.tr()
                    : null,
              ),

              verticalSpace(8),

              // ── Forgot password ───────────────────────────────────
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton(
                  onPressed: () =>
                      context.pushNamed(Routes.forgotPasswordScreen),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'loginStudent.forgot_password'.tr(),
                    style: TextStyle(
                      color: AppColors.mainBackgroundDarkColor,
                      fontSize: 13.sp,
                      fontWeight: FontWeightHelper.semiBold,
                    ),
                  ),
                ),
              ),

              verticalSpace(28),

              // ── Login button ──────────────────────────────────────
              BlocConsumer<AuthStudentCubit, AuthStudentState>(
                listener: (context, state) {
                  if (state.status == AuthStudentStatus.loginSuccess) {
                    context.pushReplacmentNamed(Routes.mainNavigation);
                  }
                  if (state.status == AuthStudentStatus.failure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.errorMessage ?? ''),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  return CustomAppButton(
                    height: 56,
                    onPressed: state.status == AuthStudentStatus.loading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              context.read<AuthStudentCubit>().login(
                                LoginStudentRequestBody(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                ),
                              );
                            }
                          },
                    backgroundColor: AppColors.mainBackgroundDarkColor,
                    borderRadius: 16,
                    child: state.status == AuthStudentStatus.loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'loginStudent.log_in_button'.tr(),
                            style: TextStyle(
                              color: AppColors.mainBackgroundWhiteColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeightHelper.semiBold,
                            ),
                          ),
                  );
                },
              ),

              verticalSpace(24),

              // ── Sign up row ───────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'loginStudent.no_account'.tr(),
                    style: TextStyle(
                      color: AppColors.subTextDarkColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeightHelper.regular,
                    ),
                  ),
                  TextButton(
                    onPressed: () =>
                        context.pushNamed(Routes.registerStudentScreen),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'loginStudent.create_account'.tr(),
                      style: TextStyle(
                        color: AppColors.mainBackgroundDarkColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeightHelper.semiBold,
                      ),
                    ),
                  ),
                ],
              ),

              verticalSpace(16),
            ],
          ),
        ),
      ),
    );
  }
}
