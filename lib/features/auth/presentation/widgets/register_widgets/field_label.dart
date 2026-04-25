import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';

class FieldLabel extends StatelessWidget {
  final String label;
  final IconData icon;

  const FieldLabel({
    super.key,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18.sp,
          // ignore: deprecated_member_use
          color: AppColors.mainTextBlackColor.withOpacity(0.7),
        ),
        horizontalSpace(6.w),
        Text(
          label,
          style: AppTextStyle.font14BlackMedium.copyWith(
            fontWeight: FontWeightHelper.semiBold,
          ),
        ),
      ],
    );
  }
}