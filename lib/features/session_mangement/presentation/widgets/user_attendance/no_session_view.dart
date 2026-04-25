import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';

class NoSessionView extends StatelessWidget {
  const NoSessionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_alt, size: 64.sp, color: Colors.grey.shade400),
          verticalSpace(16.h),
          Text('User Attendance', style: AppTextStyle.font18BlackBold),
          verticalSpace(8.h),
          Text('No active session', style: AppTextStyle.font14Grey600Medium),
          verticalSpace(4.h),
          Text(
            'Start a session to view attendance',
            style: AppTextStyle.font12Grey500Medium,
          ),
        ],
      ),
    );
  }
}