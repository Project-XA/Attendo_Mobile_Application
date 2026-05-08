import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/widgets/custom_app_button.dart';
import 'package:mobile_app/features/attendance/domain/entities/nearby_session.dart';
import 'package:mobile_app/features/attendance/presentation/logic/check_in/check_in_state.dart';
import 'package:mobile_app/features/attendance/presentation/widgets/button_state_content.dart';
import 'package:mobile_app/features/attendance/presentation/widgets/session_info_tile.dart';

class ActiveSessionCard extends StatelessWidget {
  final NearbySession session;
  final void Function(NearbySession) onCheckIn;
  final CheckInState checkInState;

  const ActiveSessionCard({
    super.key,
    required this.session,
    required this.onCheckIn,
    this.checkInState = const CheckInIdle(),
  });

  // ─── Button helpers ───────────────────────────────────────────────

  Color get _buttonBgColor => switch (checkInState) {
    CheckInSuccess() => Colors.green.shade100,
    CheckInFailed(:final reason) => reason.color.withOpacity(0.15),
    _ => AppColors.mainBackgroundWhiteColor,
  };

  Widget get _buttonChild => switch (checkInState) {
    CheckInLoading() => SizedBox(
      key: const ValueKey('loading'),
      width: 22.sp,
      height: 22.sp,
      child: const CircularProgressIndicator(
        strokeWidth: 2.5,
        color: AppColors.mainTextBlackColor,
      ),
    ),
    CheckInSuccess() => ButtonStatusContent(
      key: const ValueKey('success'),
      icon: Icons.check_circle,
      color: Colors.green.shade700,
      label: 'attendance.check_in_success_title'.tr(),
    ),
    CheckInFailed(:final reason) => ButtonStatusContent(
      key: const ValueKey('failed'),
      icon: reason.icon,
      color: reason.color,
      label: reason.title,
    ),
    _ => ButtonStatusContent(
      key: const ValueKey('idle'),
      icon: Icons.check_circle,
      color: AppColors.mainTextBlackColor,
      label: 'attendance.check_in_now'.tr(),
    ),
  };

  // ─── Build ────────────────────────────────────────────────────────

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
          _buildCheckInButton(),
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
          SessionInfoTile(
            icon: Icons.event_note,
            label: 'attendance.session_label'.tr(),
            value: session.name,
          ),
          verticalSpace(8.h),
          SessionInfoTile(
            icon: Icons.location_on,
            label: 'attendance.location_label'.tr(),
            value: session.location,
          ),
          verticalSpace(8.h),
          SessionInfoTile(
            icon: Icons.access_time,
            label: 'attendance.time_label'.tr(),
            value:
                '${DateFormat('hh:mm a').format(session.startTime)} - ${DateFormat('hh:mm a').format(session.endTime)}',
          ),
          verticalSpace(8.h),
          SessionInfoTile(
            icon: Icons.people,
            label: 'attendance.attendees_label'.tr(),
            value: 'attendance.attendees_value'.tr(
              args: ['${session.attendeeCount}'],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckInButton() {
    final isDisabled =
        checkInState is CheckInLoading || checkInState is CheckInSuccess;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: _buttonBgColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: CustomAppButton(
        onPressed: isDisabled ? null : () => onCheckIn(session),
        backgroundColor: Colors.transparent,
        borderRadius: 20.r,
        width: double.infinity,
        height: 50.h,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeOut,
          child: _buttonChild,
        ),
      ),
    );
  }
}
