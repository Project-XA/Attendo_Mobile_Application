import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';

class StudentBadge extends StatelessWidget {
  const StudentBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColors.mainBackgroundDarkColor.withOpacity(0.06),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: AppColors.mainBackgroundDarkColor.withOpacity(0.12),
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
    );
  }
}