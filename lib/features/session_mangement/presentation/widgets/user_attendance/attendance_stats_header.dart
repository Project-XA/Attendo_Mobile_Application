import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';

class AttendanceStatsHeader extends StatelessWidget {
  final int totalCount;
  final bool isActive;

  const AttendanceStatsHeader({
    super.key,
    required this.totalCount,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colorScheme.outline.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    isActive ? Icons.people : Icons.check_circle,
                    size: 20.sp,
                    color: isActive ? Colors.green : Colors.blue,
                  ),
                  horizontalSpace(8.w),
                  Text(
                    'Total Attendance',
                    style: AppTextStyle.font14Grey600Medium,
                  ),
                ],
              ),
              verticalSpace(4.h),
              Text(
                '$totalCount',
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeightHelper.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),

          if (isActive)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(
                children: [
                  Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  horizontalSpace(6.w),
                  Text('Live', style: AppTextStyle.font12Green700Bold),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
