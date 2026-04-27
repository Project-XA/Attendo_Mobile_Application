import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';

class StudentInfoCard extends StatelessWidget {
  final String organizationName;
  final String rollNumber;
  final String email;

  const StudentInfoCard({
    super.key,
    required this.organizationName,
    required this.rollNumber,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.mainSurfaceBlackColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'attendance.welcome_title'.tr(),
            style: AppTextStyle.font18WhiteBold,
          ),
          verticalSpace(12.h),
          _buildInfoRow(
            icon: Icons.school_outlined,
            value: organizationName,
          ),
          verticalSpace(8.h),
          _buildInfoRow(
            icon: Icons.badge_outlined,
            value: rollNumber,
          ),
          verticalSpace(8.h),
          _buildInfoRow(
            icon: Icons.email_outlined,
            value: email,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({required IconData icon, required String value}) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16.sp,
          color: AppColors.onDarkForegroundWhiteColor.withOpacity(0.7),
        ),
        horizontalSpace(8.w),
        Expanded(
          child: Text(
            value,
            style: AppTextStyle.font13WhiteMedium,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}