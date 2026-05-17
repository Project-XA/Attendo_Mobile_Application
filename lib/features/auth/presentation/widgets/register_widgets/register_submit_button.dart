import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';
import 'package:mobile_app/core/widgets/custom_app_button.dart';

class RegisterSubmitButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;
  final String? text;
  final IconData icon;

  const RegisterSubmitButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
    this.text,
    this.icon = Icons.arrow_forward_rounded,
  });

 @override
Widget build(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;
  final label = text ?? 'auth.add_account'.tr();

  return CustomAppButton(
    onPressed: isLoading ? null : onPressed,
    backgroundColor: colorScheme.primary,
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
                label,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeightHelper.medium,
                  letterSpacing: 0.3,
                  color: colorScheme.onPrimary,
                ),
              ),
              horizontalSpace(8.w),
              Icon(
                icon,
                color: colorScheme.onPrimary,
                size: 20.sp,
              ),
            ],
          ),
  );
}
}
