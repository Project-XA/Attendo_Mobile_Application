import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/themes/app_colors.dart';

class InfoBox extends StatelessWidget {
  const InfoBox({
    required this.message,
    super.key,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.buttonBlueBgDarkColor,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.2),
          width: 0.5,
        ),
      ),
      child: Text(
        message,
        style: TextStyle(
          fontSize: 12.sp,
          color: AppColors.buttonBlueTextDarkColor,
          height: 1.6,
        ),
      ),
    );
  }
}