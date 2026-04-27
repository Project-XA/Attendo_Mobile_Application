import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/routing/routes.dart';
import 'package:mobile_app/core/services/UI/extensions.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';
import 'package:mobile_app/core/widgets/custom_app_button.dart';
import 'package:mobile_app/features/student_auth/presentation/logic/student_auth_cubit.dart';
import 'package:mobile_app/features/student_auth/presentation/logic/student_auth_state.dart';

class LoginStudentFooter extends StatelessWidget {
  final VoidCallback onLoginPressed;

  const LoginStudentFooter({super.key, required this.onLoginPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Forgot Password
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: TextButton(
            onPressed: () => context.pushNamed(Routes.forgotPasswordScreen),
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

        SizedBox(height: 28.h),

        // Login Button
        BlocBuilder<AuthStudentCubit, AuthStudentState>(
          builder: (context, state) {
            return CustomAppButton(
              height: 56,
              onPressed: state.status == AuthStudentStatus.loading
                  ? null
                  : onLoginPressed,
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

        SizedBox(height: 24.h),

        // Sign Up Row
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

        SizedBox(height: 16.h),
      ],
    );
  }
}