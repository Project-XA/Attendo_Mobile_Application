import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/features/attendance/domain/entities/attendency_state.dart';
import 'package:mobile_app/features/attendance/presentation/widgets/attendence_status_card.dart';

class StudentAttendanceSection extends StatelessWidget {
  final AttendanceStats? stats;
  final bool hasError;
  final VoidCallback onRetry;

  const StudentAttendanceSection({
    super.key,
    required this.stats,
    required this.hasError,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'attendance.my_attendance'.tr(),
          style: AppTextStyle.font18GreyBold,
        ),
        verticalSpace(12.h),
        AttendanceStatsCard(
          stats: stats,
          hasError: hasError,
          onRetry: onRetry,
        ),
      ],
    );
  }
}