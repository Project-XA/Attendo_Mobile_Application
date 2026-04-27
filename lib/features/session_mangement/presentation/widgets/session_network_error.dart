import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';

class SessionNetworkErrorBanner extends StatelessWidget {
  const SessionNetworkErrorBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.red.shade300, width: 2),
      ),
      child: Row(
        children: [
          Icon(Icons.wifi_off_rounded, color: Colors.red, size: 28.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'sessions.no_internet_title'.tr(),
                  style: AppTextStyle.font16Red900Bold,
                ),
                verticalSpace(4.h),
                Text(
                  'sessions.no_internet_body'.tr(),
                  style: AppTextStyle.font13Red700Medium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}