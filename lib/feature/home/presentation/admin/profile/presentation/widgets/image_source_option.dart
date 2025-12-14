import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';

class ImageSourceOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const ImageSourceOption({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 30.w),
        decoration: BoxDecoration(
          color: AppColors.mainTextColorBlack.withOpacity(0.05),
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Column(
          children: [
            Icon(icon, size: 40.sp, color: AppColors.mainTextColorBlack),
            verticalSpace(8.h),
            Text(label, style: AppTextStyle.font14MediamGrey),
          ],
        ),
      ),
    );
  }
}