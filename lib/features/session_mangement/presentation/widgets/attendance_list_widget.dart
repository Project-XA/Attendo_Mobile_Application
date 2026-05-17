import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/features/session_mangement/data/models/attendency_record.dart';

class AttendanceListWidget extends StatelessWidget {
  final List<AttendanceRecord> attendanceList;
  final String? emptyMessage;
  final bool showStats;

  const AttendanceListWidget({
    super.key,
    required this.attendanceList,
    this.emptyMessage,
    this.showStats = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        if (showStats) ...[
          SliverToBoxAdapter(child: verticalSpace(20.h)),
          SliverToBoxAdapter(child: _buildAttendanceStats(context)),
          SliverToBoxAdapter(child: verticalSpace(20.h)),
        ],
        _buildAttendanceSliver(),
        SliverToBoxAdapter(child: verticalSpace(20.h)),
      ],
    );
  }

  Widget _buildAttendanceStats(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colorScheme.primary, colorScheme.primary.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            context,
            'Total Attendance',
            attendanceList.length.toString(),
            Icons.check_circle_outline,
          ),
          Container(
            width: 1,
            height: 40.h,
            color: colorScheme.onPrimary.withOpacity(0.3),
          ),
          _buildStatItem(
            context,
            'Unique Users',
            _getUniqueUsersCount().toString(),
            Icons.people,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Icon(icon, color: colorScheme.onPrimary, size: 28.sp),
        verticalSpace(8.h),
        Text(value, style: AppTextStyle.font24WhiteBold),
        verticalSpace(4.h),
        Text(label, style: AppTextStyle.font12WhiteMedium),
      ],
    );
  }

  Widget _buildAttendanceSliver() {
    if (attendanceList.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.pending_actions,
                size: 64.sp,
                color: Colors.grey.shade400,
              ),
              verticalSpace(16.h),
              Text(
                emptyMessage ?? 'No attendance records yet',
                style: AppTextStyle.font16Grey600Medium,
              ),
            ],
          ),
        ),
      );
    }

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final record = attendanceList[index];
          return Column(
            children: [
              _buildAttendanceItem(context, record, index + 1),
              if (index < attendanceList.length - 1)
                Divider(
                  height: 1.h,
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                ),
            ],
          );
        }, childCount: attendanceList.length),
      ),
    );
  }

  Widget _buildAttendanceItem(
    BuildContext context,
    AttendanceRecord record,
    int number,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          // Number badge
          Container(
            width: 32.w,
            height: 32.h,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text('$number', style: AppTextStyle.font12WhiteBold),
            ),
          ),
          horizontalSpace(12.w),

          // User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(record.userName, style: AppTextStyle.font14GreyBold),
                verticalSpace(4.h),
                Text(
                  'ID: ${record.userId}',
                  style: AppTextStyle.font12Grey600Medium,
                ),
              ],
            ),
          ),

          // Time and location
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                DateFormat('hh:mm a').format(record.checkInTime),
                style: AppTextStyle.font13GreyMedium,
              ),
              if (record.location != null) ...[
                verticalSpace(4.h),
                Text(record.location!, style: AppTextStyle.font11Grey600Medium),
              ],
            ],
          ),
        ],
      ),
    );
  }

  int _getUniqueUsersCount() {
    final uniqueUserIds = attendanceList.map((r) => r.userId).toSet();
    return uniqueUserIds.length;
  }
}
