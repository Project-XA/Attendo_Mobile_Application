import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';
import 'package:mobile_app/features/attendance/domain/entities/attendency_state.dart';

class AttendanceStatsCard extends StatelessWidget {
  final AttendanceStats? stats;
  final bool hasError; 
  final VoidCallback? onRetry; 

  const AttendanceStatsCard({
    super.key,
    required this.stats,
    this.hasError = false,
    this.onRetry, 
  });

  @override
  Widget build(BuildContext context) {
    if (hasError) {
      return _buildErrorState(context);
    }

    if (stats == null) {
      return _buildLoadingState();
    }

    return _buildSuccessState();
  }

  Widget _buildErrorState(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 40.sp,
          ),
          verticalSpace(8.h),
          Text(
            'Failed to load stats',
            style: AppTextStyle.font14MediamGrey.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeightHelper.medium,
              color: Colors.red.shade700,
            ),
          ),
          verticalSpace(12.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildSuccessState() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              'Total',
              '${stats!.totalSessions}',
              Icons.event,
              Colors.blue,
            ),
          ),
          Container(width: 1, height: 50.h, color: Colors.grey.shade200),
          Expanded(
            child: _buildStatItem(
              'Attended',
              '${stats!.attendedSessions}',
              Icons.check_circle,
              Colors.green,
            ),
          ),
          Container(width: 1, height: 50.h, color: Colors.grey.shade200),
          Expanded(
            child: _buildStatItem(
              'Rate',
              '${stats!.attendancePercentage.toStringAsFixed(0)}%',
              Icons.percent,
              Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24.sp),
        verticalSpace(8.h),
        Text(
          value,
          style: AppTextStyle.font14MediamGrey.copyWith(
            fontSize: 20.sp,
            fontWeight: FontWeightHelper.bold,
          ),
        ),
        verticalSpace(4.h),
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyle.font14MediamGrey.copyWith(
            fontSize: 11.sp,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}