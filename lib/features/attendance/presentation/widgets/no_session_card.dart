import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/widgets/custom_app_button.dart';

class NoSessionsCard extends StatelessWidget {
  final bool isIdle;
  final bool isDiscoveryActive;
  final VoidCallback onSearch;
  final VoidCallback onRefresh;

  const NoSessionsCard({
    super.key,
    required this.isIdle,
    required this.isDiscoveryActive,
    required this.onSearch,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.h, horizontal: 20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.surfaceContainerHighest,
            Theme.of(context).scaffoldBackgroundColor,
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildIcon(context),
          verticalSpace(20.h),
          _buildTitle(context),
          verticalSpace(12.h),
          _buildDescription(context),
          verticalSpace(18.h),
          _buildActionButton(context),
          if (isDiscoveryActive) ...[verticalSpace(16.h), _buildInfoBanner()],
        ],
      ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        shape: BoxShape.circle,
      ),
      child: Icon(
        isIdle ? Icons.search : Icons.wifi_off_rounded,
        size: 56.sp,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      isIdle
          ? 'attendance.no_sessions_title_idle'.tr()
          : 'attendance.no_sessions_title_empty'.tr(),
      style: AppTextStyle.font22BlackBold.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Text(
        isIdle
            ? 'attendance.no_sessions_desc_idle'.tr()
            : 'attendance.no_sessions_desc_empty'.tr(),
        textAlign: TextAlign.center,
        style: AppTextStyle.font14Grey600Medium.copyWith(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return CustomAppButton(
      onPressed: () => isIdle ? onSearch() : onRefresh(),
      backgroundColor: Theme.of(context).colorScheme.primary,
      borderRadius: 16.r,
      width: 200.w,
      height: 48.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isIdle ? Icons.search : Icons.refresh,
            color: Theme.of(context).colorScheme.onPrimary,
            size: 20.sp,
          ),
          horizontalSpace(10.w),
          Text(
            isIdle
                ? 'attendance.start_search'.tr()
                : 'attendance.search_again'.tr(),
            style: AppTextStyle.font15WhiteBold.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.info_outline, size: 16.sp, color: Colors.orange.shade700),
          horizontalSpace(8.w),
          Text(
            'attendance.venue_hint'.tr(),
            style: AppTextStyle.font12Orange700Medium,
          ),
        ],
      ),
    );
  }
}
