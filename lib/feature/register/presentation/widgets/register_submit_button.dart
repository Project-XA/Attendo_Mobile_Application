// widgets/register_submit_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';
import 'package:mobile_app/core/widgets/custom_app_button.dart';

class RegisterSubmitButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const RegisterSubmitButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CustomAppButton(
      onPressed: isLoading ? null : onPressed,
      backgroundColor: AppColors.mainTextColorBlack,
      borderRadius: 16.r,
      width: double.infinity,
      height: 46.h,
      child: isLoading
          ? SizedBox(
              height: 24.h,
              width: 24.w,
              child: const CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Add Account',
                  style: AppTextStyle.font14MediamGrey.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeightHelper.semiBold,
                    fontSize: 16.sp,
                    letterSpacing: 0.3,
                  ),
                ),
                horizontalSpace(8.w),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 20.sp,
                ),
              ],
            ),
    );
  }
}