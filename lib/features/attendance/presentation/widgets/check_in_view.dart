import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';
import 'package:mobile_app/features/attendance/domain/entities/nearby_session.dart';
import 'package:mobile_app/features/attendance/presentation/logic/check_in/check_in_state.dart';

class CheckInView extends StatelessWidget {
  final CheckInState state;

  const CheckInView({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: switch (state) {
          CheckInLoading() => _buildLoadingState(),
          CheckInSuccess(:final session, :final checkInTime) =>
            _buildSuccessState(session, checkInTime),
          CheckInFailed(:final reason) => _buildFailedState(reason),
          CheckInIdle() => const SizedBox.shrink(),
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(),
        verticalSpace(24.h),
        Text(
          'attendance.check_in_loading_title'.tr(),
          style: AppTextStyle.font20GreyBold,
        ),
        verticalSpace(12.h),
        Text(
          'attendance.check_in_loading_subtitle'.tr(),
          style: AppTextStyle.font14Grey600Medium,
        ),
      ],
    );
  }

  Widget _buildSuccessState(NearbySession session, DateTime checkInTime) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.check_circle, color: Colors.green, size: 100.sp),
        verticalSpace(24.h),
        Text(
          'attendance.check_in_success_title'.tr(),
          style: AppTextStyle.font14GreyMedium.copyWith(
            fontSize: 24.sp,
            fontWeight: FontWeightHelper.bold,
            color: Colors.green,
          ),
        ),
        verticalSpace(12.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.green.shade200),
          ),
          child: Column(
            children: [
              _buildInfoRow(
                Icons.event,
                'attendance.check_in_row_session'.tr(),
                session.name,
                Colors.green.shade700,
              ),
              verticalSpace(8.h),
              _buildInfoRow(
                Icons.location_on,
                'attendance.check_in_row_location'.tr(),
                session.location,
                Colors.green.shade700,
              ),
              verticalSpace(8.h),
              _buildInfoRow(
                Icons.access_time,
                'attendance.check_in_row_time'.tr(),
                DateFormat('hh:mm a').format(checkInTime),
                Colors.green.shade700,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFailedState(CheckInFailureReason reason) {
    final color = switch (reason) {
      CheckInFailureReason.alreadyCheckedIn => Colors.orange,
      CheckInFailureReason.outsideZone => Colors.blue,
      _ => Colors.red,
    };

    final icon = switch (reason) {
      CheckInFailureReason.alreadyCheckedIn => Icons.info,
      CheckInFailureReason.outsideZone => Icons.location_off,
      _ => Icons.error,
    };

    final title = switch (reason) {
      CheckInFailureReason.alreadyCheckedIn =>
        'attendance.check_in_fail_already_title'.tr(),
      CheckInFailureReason.outsideZone =>
        'attendance.check_in_fail_zone_title'.tr(),
      _ => 'attendance.check_in_fail_generic_title'.tr(),
    };

    final message = switch (reason) {
      CheckInFailureReason.alreadyCheckedIn =>
        'attendance.check_in_fail_already_msg'.tr(),
      CheckInFailureReason.outsideZone =>
        'attendance.check_in_fail_zone_msg'.tr(),
      CheckInFailureReason.networkError =>
        'attendance.check_in_fail_network_msg'.tr(),
      CheckInFailureReason.unknown =>
        'attendance.check_in_fail_unknown_msg'.tr(),
    };

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 100.sp),
        verticalSpace(24.h),
        Text(
          title,
          style: AppTextStyle.font14GreyMedium.copyWith(
            fontSize: 24.sp,
            fontWeight: FontWeightHelper.bold,
            color: color,
          ),
        ),
        verticalSpace(12.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Text(
            message,
            style: AppTextStyle.font14GreyMedium.copyWith(
              fontSize: 14.sp,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value,
    Color iconColor,
  ) {
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: iconColor),
        horizontalSpace(8.w),
        Text('$label:', style: AppTextStyle.font13Grey700Medium),
        horizontalSpace(8.w),
        Expanded(
          child: Text(
            value,
            style: AppTextStyle.font13GreyMedium,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
