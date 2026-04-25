import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/widgets/custom_app_button.dart';
import 'package:mobile_app/features/attendance/domain/entities/nearby_session.dart';

class ActiveSessionCard extends StatelessWidget {
  final NearbySession session;
  final void Function(NearbySession) onCheckIn;

  const ActiveSessionCard({
    super.key,
    required this.session,
    required this.onCheckIn,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.mainSurfaceBlackColor,
            AppColors.mainSurfaceBlackColor.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          verticalSpace(16.h),
          _buildSessionInfo(),
          verticalSpace(16.h),
          _buildCheckInButton(context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: AppColors.onDarkForegroundWhiteColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            Icons.wifi,
            color: AppColors.onDarkForegroundWhiteColor,
            size: 24.sp,
          ),
        ),
        horizontalSpace(12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'attendance.active_session_title'.tr(),
                style: AppTextStyle.font18WhiteBold,
              ),
              verticalSpace(4.h),
              Row(
                children: [
                  Icon(Icons.circle, color: Colors.green, size: 8.sp),
                  horizontalSpace(6.w),
                  Text(
                    'attendance.live_now'.tr(),
                    style: AppTextStyle.font12WhiteMedium,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSessionInfo() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.onDarkForegroundWhiteColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          _buildInfoRow(
            Icons.event_note,
            'attendance.session_label'.tr(),
            session.name,
          ),
          verticalSpace(8.h),
          _buildInfoRow(
            Icons.location_on,
            'attendance.location_label'.tr(),
            session.location,
          ),
          verticalSpace(8.h),
          _buildInfoRow(
            Icons.access_time,
            'attendance.time_label'.tr(),
            '${DateFormat('hh:mm a').format(session.startTime)} - ${DateFormat('hh:mm a').format(session.endTime)}',
          ),
          verticalSpace(8.h),
          _buildInfoRow(
            Icons.people,
            'attendance.attendees_label'.tr(),
            'attendance.attendees_value'.tr(args: ['${session.attendeeCount}']),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.onDarkForegroundWhiteColor.withOpacity(0.7),
          size: 16.sp,
        ),
        horizontalSpace(8.w),
        Text(label, style: AppTextStyle.font12WhiteMedium),
        horizontalSpace(8.w),
        Expanded(
          child: Text(
            value,
            style: AppTextStyle.font13WhiteMedium,
            textAlign: TextAlign.end,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildCheckInButton(BuildContext context) {
    return CustomAppButton(
      onPressed: () => onCheckIn(session),
      backgroundColor: AppColors.mainBackgroundWhiteColor,
      borderRadius: 20.r,
      width: double.infinity,
      height: 50.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle,
            color: AppColors.mainTextBlackColor,
            size: 20.sp,
          ),
          horizontalSpace(8.w),
          Text(
            'attendance.check_in_now'.tr(),
            style: AppTextStyle.font16BlackBold,
          ),
        ],
      ),
    );
  }
}
