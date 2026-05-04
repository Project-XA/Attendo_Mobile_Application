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
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 24.w),
        padding: EdgeInsets.all(32.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
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
      mainAxisSize: MainAxisSize.min,
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
      mainAxisSize: MainAxisSize.min,
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(reason.icon, color: reason.color, size: 100.sp),
        verticalSpace(24.h),
        Text(
          reason.title,
          style: AppTextStyle.font14GreyMedium.copyWith(
            fontSize: 24.sp,
            fontWeight: FontWeightHelper.bold,
            color: reason.color,
          ),
        ),
        verticalSpace(12.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: reason.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: reason.color.withOpacity(0.3)),
          ),
          child: Text(
            reason.message,
            style: AppTextStyle.font14GreyMedium.copyWith(
              fontSize: 14.sp,
              color: reason.color,
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
